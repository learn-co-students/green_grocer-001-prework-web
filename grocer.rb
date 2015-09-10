require 'pry'

def consolidate_cart(cart:[])
  # code here
  consolidated_cart = {}
  cart.each do |item_with_info|
    item_with_info.each do |item, info|
      if consolidated_cart.has_key?(item) == false
        consolidated_cart[item]= info
        consolidated_cart[item][:count]= 1
      else
        consolidated_cart[item][:count]+= 1
      end
    end
  end
  consolidated_cart
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    if cart.has_key?((coupon[:item] + " W/COUPON")) && cart[coupon[:item]][:count] >= coupon[:num]
      cart[(coupon[:item] + " W/COUPON")][:count]+= 1
      cart[coupon[:item]][:count]-= coupon[:num]
    else
      if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
        coupon_name = coupon[:item] + " W/COUPON"
        cart[coupon_name]= {:price=>coupon[:cost], :clearance=>cart[coupon[:item]][:clearance], :count=>1}
        cart[coupon[:item]][:count]-= coupon[:num]
        #if cart[coupon[:item]][:count] == 0
        #  cart.delete(coupon[:item])
        #end
      end
    end
  end
  cart
end


def apply_clearance(cart:[])
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price]-= (info[:price] * 0.20)
    end
  end
  cart
end


def checkout(cart:[], coupons:[])
  consolidated_cart = consolidate_cart(cart: cart)
  coupon_cart = apply_coupons(cart: consolidated_cart, coupons: coupons)
  clearance_cart = apply_clearance(cart: coupon_cart)
  total = 0
  clearance_cart.each do |item, info|
    total += (info[:price] * info[:count])
  end
  if total > 100
    total -= (total * 0.10)
  end
  total

end

