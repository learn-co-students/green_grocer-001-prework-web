require 'pry'

def consolidate_cart(cart:[])
  # code here
  consolidated = {}
  cart.each do |items|
    items.each do |item, details|
      consolidated[item] ||= {}
      consolidated[item][:count] ||= 0
      consolidated[item][:count] += 1 
      details.each{|k, v| consolidated[item][k] = v}
    end
  end
  consolidated
end

def apply_coupons(cart:[], coupons:[])
  return cart if coupons.length == 0 
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      old_item = coupon[:item]
      if cart[old_item][:count] >= coupon[:num]
        new_item = "#{old_item} W/COUPON"
        cart[new_item] ||= {}
        if cart[new_item][:count]
          cart[new_item][:count] += 1
        else
          cart[new_item][:count] = 1
        end
        cart[new_item][:price] = coupon[:cost]
        cart[new_item][:clearance] = cart[old_item][:clearance]
        cart[old_item][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  new_cart = {}
  cart.each do |item, values|
    new_cart[item] ||= {}
    if values[:clearance]
      new_cart[item][:count] = values[:count]
      new_cart[item][:price] = (values[:price] * 0.8).round(2)
      new_cart[item][:clearance] = values[:clearance]
    else
      new_cart[item][:count] = values[:count]
      new_cart[item][:price] = values[:price]
      new_cart[item][:clearance] = values[:clearance]
    end
  end
  new_cart
end


def checkout(cart: [], coupons: [])

  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  total = 0
  cart.each do |key, value|
    total += (value[:count] * value[:price])
  end

  total = (total * 0.9) if total > 100

  total
end
