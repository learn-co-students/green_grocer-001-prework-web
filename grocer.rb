def consolidate_cart(cart:[])
	tmp_h = {}
	cart.each do |item|
		item.each do |name, properties|
			if tmp_h[name].nil?
				tmp_h[name] = properties
				tmp_h[name][:count] = 1
			else
				tmp_h[name][:count] += 1
			end
		end
	end
	tmp_h
end

def apply_coupons(cart:[], coupons:[])
	hash = {}
	cart.each do |item, properties|
		coupons.each do |coupon|
			if coupon[:item] == item && properties[:count] >= coupon[:num]
				if hash["#{item} W/COUPON"]
					hash["#{item} W/COUPON"][:count] += 1
				else
				  hash["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => properties[:clearance], :count =>1}
				end
				properties[:count] -= coupon[:num]
			end
		end
		hash[item] = properties
	end
	hash
end

def apply_clearance(cart:[])
  # code here
	cart.each do |item, properties|
		if properties[:clearance] == true
			properties[:price] -= properties[:price] * 0.20
		end
	end
	cart
end

def checkout(cart: [], coupons: [])
  # code here
	fin_cart = consolidate_cart(cart: cart)
	fin_cart = apply_coupons(cart: fin_cart, coupons: coupons)
	fin_cart = apply_clearance(cart: fin_cart)
	total = 0
	fin_cart.each do |item,properties|	
		total += properties[:price] * properties[:count]
	end
	if total > 100
		total = total * 0.90
	end
	total
end
