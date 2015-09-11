require 'pry'

def consolidate_cart(cart:[])
  new_hash = {}
  cart.each do |item|
    item.each do |food, item|
      item[:count] ||= 0
      item[:count] += 1
      new_hash[food] = item
    end
  end
    new_hash
end

def apply_coupons(cart:[], coupons:[])
  cart.keys.each do |item|
    coupons.each do |coupon|
      if item == coupon[:item] && cart[item][:count] >= coupon[:num]
        cart[item][:count] -= coupon[:num]
        if cart["#{coupon[:item]} W/COUPON"]
          cart["#{coupon[:item]} W/COUPON"][:count] += 1
        else
          cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item][:clearance], :count => 1}
        end
      end   
    end  
  end
  cart
end

def apply_clearance(cart:[])
  cart.values.each do |item|
    if item[:clearance] == true
      item[:price] = (item[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  total = 0
  consolidated = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consolidated, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  clearance_applied.each do |item|
    total += item[1][:price] * item[1][:count]
  end
  if total > 100
    total = total * 0.9
  else
    total
  end
  total  
end
