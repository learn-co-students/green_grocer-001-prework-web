require 'pry'

def consolidate_cart(cart:[])
  new_cart = {}
  cart.each do |item|
    item.each do |k, v|
      if new_cart.include?(k)
        new_cart[k][:count] += 1
      else
        new_cart[k] = v
        new_cart[k][:count] = 1
      end
    end
  end
  cart = new_cart
end

def apply_coupons(cart:[], coupons:[])
  if cart.class == Array
    cart = cart[0]
  end
  new_cart = cart
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        if new_cart["#{coupon[:item]} W/COUPON"] != nil
          new_cart["#{coupon[:item]} W/COUPON"][:count] += 1
        else
          new_cart["#{coupon[:item]} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => cart[coupon[:item]][:clearance],
            :count => 1
          }
        end
        new_cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart = new_cart
  if cart.class == Array
    cart = cart[0]
  end
  cart
end

def apply_clearance(cart:[])
  if cart.class == Array
    cart = cart[0]
  end
  cart.each do |item, atts|
    if atts[:clearance] == true
      atts[:price] *= 0.8
      atts[:price] = atts[:price].round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  if cart.class == Array
    cart = cart[0]
  end
  apply_coupons(cart: cart, coupons: coupons)
  apply_clearance(cart: cart)
  cart_total = 0
  cart.each do |item, atts|
    cart_total += atts[:price] * atts[:count]
  end
  if cart_total > 100.0
    cart_total *= 0.9
  end
  cart_total
end