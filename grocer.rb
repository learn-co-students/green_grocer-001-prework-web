require 'pry'
require 'bigdecimal'
def consolidate_cart(cart:[])
  # code here

  cart_data = Hash.new {|hash, key| hash[key] = Hash.new(0)}
  cart.each do |item|
  	item.each do |key, value|
  			cart_data[key][:count] += 1
  			cart_data[key][:price] =item[key][:price]
  			cart_data[key][:clearance] = item[key][:clearance]
  	end
  end
  cart_data
end

def apply_coupons(cart:[], coupons:[])
  # code here
  # coupon = array
  #if cart_data.each  has_key clearance and value?(true)
  #check the coupon array each
  # if cart item_name each and counter >= coupon_num 
  #add cart_data []
  #add item "item_name + W/COUPON" 
  cart_apply_after_coupon = {}
  cart.each do |cart_value|
  	#binding.pry
  	if coupons.size == 0
  		cart_apply_after_coupon[cart_value[0]] = cart_value[1]
  	else
	  	coupons.each do |coupons_value|
	  		if coupons_value.has_value?(cart_value[0]) && cart_value[1][:count] >= coupons_value[:num]
	  			if cart_apply_after_coupon.has_key?("#{cart_value[0]} W\/COUPON")
	  				# binding.pry
	  			else
		  			cart_apply_after_coupon["#{cart_value[0]} W\/COUPON"] = {}
		  			cart_apply_after_coupon["#{cart_value[0]} W\/COUPON"][:clearance] = cart_value[1][:clearance] #count -
		  			cart_apply_after_coupon["#{cart_value[0]} W\/COUPON"][:price] = coupons_value[:cost] #count -1
		  			cart_apply_after_coupon["#{cart_value[0]} W\/COUPON"][:count] = 0
		  		end
	  			#
	  			#binding.pry
	  			cart_apply_after_coupon[cart_value[0]] = cart_value[1]
	  			# binding.pry
	  			#次にやること：couponを適用した後のクーポン対象データのカウント操作[previous/coupon count]
	  			#coupon適用できない数字になるまで、元データのカウントを減らす、クーポン適用のcount を１ずつ
	  			coupon_count = coupons_value[:num]
	  			cart_count = cart_value[1][:count]
	  			# binding.pry
		  		cart_apply_after_coupon["#{cart_value[0]} W\/COUPON"][:count] += 1
	  			# binding.pry
	  			cart_apply_after_coupon[cart_value[0]][:count] -= coupons_value[:num]
	  			# binding.pry
		  			#additional if :count after applying discount is less than or equal to 0 ,delete cart_value 
		  			#binding.pry	
	  			#binding.pry
	  		else
	  			#binding.pry
	  			cart_apply_after_coupon[cart_value[0]] = cart_value[1]
	  		end
	  		# binding.pry
	  	end
	end

  end
  cart_apply_after_coupon
end

def apply_clearance(cart:[])
	after_apply_cart_item = []
	decimal_price = ""
	decimal_discount = ""
	discount_percentage = 0.2
	check = []
	cart.each do |value|
		if value[1][:clearance] == true #switcher == false #複数対象があった場合に割り引きされない
			#binding.pry

			decimal_price = value[1][:price].to_s
			decimal_discount = (1 - 0.2).to_s
			# value[:price] = BigDecimal(value[:price].to_i).truncate(2).to_s() * BigDecimal(1-0.2)
			value[1][:price] = BigDecimal(decimal_price) * BigDecimal(decimal_discount)
			switcher = true
		end
		after_apply_cart_item << value
	end

  # code here
  # binding.pry
  #1.take cart to hash 
  #2.check each hash key clearance
  #3.if clearance is true change price(first_define)
  #4.return value
end

def checkout(cart: [], coupons: [])
  # code here
  	total = 0
 	# binding.pry
 	consolidate = consolidate_cart(cart: cart)
	# binding.pry
 	coupon_apply = apply_coupons(cart: consolidate,coupons: coupons)
	# binding.pry
 	data = apply_clearance(cart: coupon_apply)
	# binding.pry
	 data.each do |value|
	 	# binding.pry
	 	if value[1][:count] > 0

	 		total += value[1][:price] * value[1][:count]
	 		# binding.pry
	 	end
	 	# binding.pry
	 end
	 if total > 100
	 	total *= 0.9
	 end
 total

end