require 'pry'

def consolidate_cart(cart:[])
  # code here
  new_cart = {}
  cart.uniq.each do |item_hash|
    item_hash.each do |name, info_hash|
      new_cart[name] = info_hash
      new_cart[name][:count] = cart.count(item_hash)
    end
  end
  new_cart
end

def apply_coupons(cart:[], coupons:[])
  # code here
  return cart if coupons == []
  new_cart = cart
  coupons.each do |coupon_hash|
    if cart.has_key?(coupon_hash[:item]) && new_cart[coupon_hash[:item]][:count] >= coupon_hash[:num] 
      if new_cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
        num_to_discount = coupon_hash[:num]
      else
        num_to_discount = new_cart[coupon_hash[:item]][:count]
      end
      new_cart[coupon_hash[:item]][:count] -= num_to_discount
      if new_cart["#{coupon_hash[:item]} W/COUPON"] == nil
        new_cart["#{coupon_hash[:item]} W/COUPON"] = {
          price: coupon_hash[:cost],
          clearance: cart[coupon_hash[:item]][:clearance],
          count: 1
          }
      else
        new_cart["#{coupon_hash[:item]} W/COUPON"][:count] += 1
      end
    end

  end
  #new_cart.delete_if { |name,data| data[:count] < 1 }
  new_cart
end

def apply_clearance(cart:[])
  # code here
  new_cart = cart
  cart.each do |name, info_hash|
    if info_hash[:clearance]
      new_cart[name][:price] = (cart[name][:price] * 0.8).round(2)
    end
  end
  new_cart
end

def checkout(cart: [], coupons: [])
  # code here
  #binding.pry

  new_cart = consolidate_cart(cart: cart)
  new_cart = apply_coupons(cart: new_cart, coupons: coupons)
  new_cart = apply_clearance(cart: new_cart)
  total = 0
  new_cart.each do |item, info_hash|
    total += (info_hash[:price] * info_hash[:count]).round(2)
  end
  (total *= 0.9).round(2) if total > 100
  total
end