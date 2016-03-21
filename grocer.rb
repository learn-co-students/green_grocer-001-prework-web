require 'pry'

def consolidate_cart(cart:[])
  consolidated_cart = {}
  while cart.to_a.length > 0
  	item = cart.to_a.pop
  	item.each do |key, value|
  		if consolidated_cart.has_key?(key)
  			consolidated_cart[key][:count] += 1
  		else
  			consolidated_cart[key] = value
  			consolidated_cart[key][:count] = 1
  		end
  	end
  end
  consolidated_cart
end

def apply_coupons(cart:[], coupons:[])
	if coupons == []
		return cart
	end
	new_cart = {}
	cart.each do |item, traits|
		coupons.each do |coupon|
			if coupon[:item] == item && traits[:count] >= coupon[:num]
				traits[:count] -= coupon[:num]
				if new_cart.has_key?("#{item} W/COUPON")
					new_cart["#{item} W/COUPON"][:count] += 1
				else
					new_cart["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => traits[:clearance], :count => 1}
				end
			end
		end
		new_cart[item] = traits
	end
	new_cart
end

def apply_clearance(cart:[])
  cart.each do |key, value|
  	value[:price] -= (0.2 * value[:price]) if value[:clearance]  
  end
  cart
end

def checkout(cart: [], coupons: [])
  #step 1: consolidate items
  	cart = consolidate_cart(cart: cart)
  #step 2: apply coupons
  	cart = apply_coupons(cart: cart, coupons: coupons)
  #step 3: apply clearance
  	cart = apply_clearance(cart: cart)
  #step 4: if total is over $100, apply 10% discount
  total = 0.0
  cart.each do |item, traits|
  	total += (traits[:price] * traits[:count])
  end
  if total > 100.0
  	return total * 0.9
  else
  	return total
  end
end

one = {"AVOCADO" => {:price => 3.00, :clearance => true, :count => 3}}
coups = [{:item => "AVOCADO", :num => 2, :cost => 5.00}]

apply_coupons(cart: one, coupons: coups)