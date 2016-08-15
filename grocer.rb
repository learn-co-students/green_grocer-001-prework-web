require 'pry'

def consolidate_cart(cart:[])
  # code here
  cart.each {|item| item.values[0][:count] = 1}
  output_hash = Hash.new
  cart.each {|item| output_hash.merge!(item){|key,ov,nv| ov.merge(nv){|key2,ov2,nv2| key2 == :count ? ov2 + nv2 : ov2}}}
  cart = output_hash
end

def apply_coupons(cart:[], coupons:[])
  # code here
  coupons.each do |coupon|
    if cart[coupon[:item]] == nil
      next
	  elsif cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
    else next
    end
	  cart.merge!({"#{coupon[:item]} W/COUPON" => {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}}){|key,ov,nv| ov.merge(nv){|key2,ov2,nv2| key2 == :count ? ov2 + nv2 : ov2}}
  end
  cart
end

def apply_clearance(cart:[])
  # code here
  cart.each {|k,v| v[:clearance] == true ? v[:price] = (v[:price]*0.80).round(2) : v[:price]}
end

def checkout(cart: [], coupons: [])
  # code here
  checkout_cart = consolidate_cart(cart: cart)
  checkout_cart = apply_coupons(cart: checkout_cart, coupons: coupons)
  checkout_cart = apply_clearance(cart: checkout_cart)
  checkout_cart_total = checkout_cart.collect {|k,v| v[:price]*v[:count]}.inject(0){|sum,x| sum + x}.round(2)
  if checkout_cart_total > 100.00
    checkout_cart_total = checkout_cart_total*0.90
  else checkout_cart_total
  end
end
