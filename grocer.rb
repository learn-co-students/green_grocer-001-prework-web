require 'pry'
def consolidate_cart(cart:[])
  
  new_hash = {}
  count_hash = Hash.new(0)

  cart.each do |item_hash|
    item_hash.each do |key, value|
      count_hash[key] += 1
      value[:count] = count_hash[key]
      new_hash[key] = value
    end
  end
new_hash
end
    

def apply_coupons(cart:[], coupons:[])
  new_hash = {}
  coupons.each do |coupon|
    if cart[coupon[:item]] != nil
      if cart[coupon[:item]][:count] >= coupon[:num] 
      cart[coupon[:item]][:count] -= coupon[:num] 
      if cart["#{coupon[:item]} W/COUPON"] == nil
        cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1 }
      else cart["#{coupon[:item]} W/COUPON"][:count] += 1
      end
    end
    end
  end
  cart
end


def apply_clearance(cart:[])
    cart.each do |key, value|
      if value[:clearance] == true
        value[:price] = (0.80 * value[:price]).round(2)
      end
  end
cart
end


def checkout(cart: [], coupons: [])
  
  new_cart = consolidate_cart(cart: cart)
  new_cart = apply_coupons(cart: new_cart, coupons:coupons)
  new_cart = apply_clearance(cart: new_cart)

  sum = 0.00
  new_cart.each do |k,v|
    sum += v[:price] * v[:count]
  end

  if sum > 100.00
    sum = sum * 0.90
    sum.round(2)
  else
    sum.round(2)
  end
end





