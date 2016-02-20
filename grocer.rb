require 'pry'
def consolidate_cart(cart:[])
  consolidated_cart = Hash.new { |hash, key| hash[key] = Hash.new(0)}
  cart.each do |line_item|
  	line_item.each do |item, attributes|
  		consolidated_cart[item][:count] += 1
  		consolidated_cart[item][:price] = line_item[item][:price] 
	  	consolidated_cart[item][:clearance] = line_item[item][:clearance]
	  end
  end
  consolidated_cart
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
  	discounted_item = coupon[:item]
  	if cart.keys.include?(discounted_item) && cart[discounted_item][:count] >= coupon[:num]
  		cart[discounted_item][:count] -= coupon[:num]
	  	cart[discounted_item + " W/COUPON"][:price] = coupon[:cost]
  		cart[discounted_item + " W/COUPON"][:clearance] = cart[discounted_item][:clearance]
  		cart[discounted_item + " W/COUPON"][:count] += 1
  	end
  end
  cart
end

def apply_clearance(cart:[])
	
  cart.each do |item, attributes|
  	if attributes[:clearance] == true
  		cart[item][:price] = (cart[item][:price]*0.8).round(2)
  	end
  end
  cart
end

def checkout(cart: [], coupons: [])
 	consolidated_cart = consolidate_cart(cart:cart)
  coupon_cart = apply_coupons(cart:consolidated_cart, coupons:coupons)
  final_cart = apply_clearance(cart:coupon_cart)

  total = 0
  final_cart.each do |item, attributes|
  	total += attributes[:price] * attributes[:count]
  end

  if total > 100
  	total *= 0.9
  end

  total
end