require 'pry'

def consolidate_cart(cart:[])
  # code here
  cart.each_with_object({}) do |i, hash|
    i.each do |key, value|
      # count items in cart
      count = cart.count({key => value})
      # add consolidated hash (with count)
      if !hash.has_key?(key)
        hash[key] = value
        hash[key][:count] = count
      end
    end
  end
end

def apply_coupons(cart:[], coupons:[])
  # code here
  # new_hash to temp store coupon_applied items
  new_hash = {}
  # iterate over cart items + check for coupons
  cart.each do |item, attributes|
    coupons.each do |coupon|
      # if matching coupon
      if coupon.has_value?(item)
        count = 0
        # apply coupons while reducing count by coupon :num
        # store coupon_applied items into new_hash
        while cart[item][:count] >= coupon[:num]
          cart[item][:count] -= coupon[:num]
          count += 1
          new_hash["#{item} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => cart[item][:clearance],
            :count => count
          }
        end
      end
    end
  end
  cart.merge(new_hash)
end

def apply_clearance(cart:[])
  # code here
  cart.each do |item, attributes|
    if cart[item][:clearance] == true
      cart[item][:price] -= cart[item][:price] * 0.20
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  # code here
  cart_total = 0
  consolidated = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consolidated, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  clearance_applied.each do |item, attributes|
    cart_total += clearance_applied[item][:price] * clearance_applied[item][:count]
  end
  if cart_total > 100
    cart_total -= cart_total * 0.10
  end
  cart_total
end