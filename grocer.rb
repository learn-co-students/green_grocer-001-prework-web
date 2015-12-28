require 'pry'

def consolidate_cart(cart:[])
  # code here
  hash = {}
  cart.each do |item|
    item.each do |name, info|
      if(hash.keys.include?(name))
        hash[name][:count] += 1
      else
        hash[name] = info
        hash[name][:count] = 1
      end
    end
  end
  hash
end

def apply_coupons(cart:[], coupons:[])
  # code here
  hash = Hash.new(cart)
  cart.each do |item, info|
    hash[item] = info
    coupons.each do |coupon|
      if(item == coupon[:item] && coupon[:num] <= hash[item][:count] && !hash.keys.include?("#{item} W/COUPON"))
        hash[item][:count] -= coupon[:num]
        hash["#{item} W/COUPON"] = {price: coupon[:cost], clearance: info[:clearance],count: 1}
      elsif(item == coupon[:item] && coupon[:num] <= hash[item][:count] && hash.keys.include?("#{item} W/COUPON"))
        hash[item][:count] -= coupon[:num]
        hash["#{item} W/COUPON"][:count] += 1
      end
    end
  end
  hash
end

def apply_clearance(cart:{})
  # code here
  cart.each do |item, info|
    if(info[:clearance] == true)
      cart[item][:price] = (cart[item][:price] * 0.80 * 100).round/100.0
    end
  end
  cart
end

def checkout(cart:[], coupons:[])
  # code here
  total = 0
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart:cart, coupons:coupons)
  cart = apply_clearance(cart: cart)
  cart.each do |item, info|
    total += info[:price] * info[:count]
  end
  total = (total * 0.9) if total > 100
  total
end