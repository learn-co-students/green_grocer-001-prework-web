require 'pry'
def consolidate_cart(cart:[])
  return_hash = {}
  cart.each do |item|
    item.each do |key, value|
      value[:count] = cart.count(item) 
      return_hash[key] = value
    end
  end
 # binding.pry
  return_hash
end

def apply_coupons(cart:[], coupons:[])
  return_hash = {}
  if coupons != []
    cart.each do |key, value|
      coupons.each do |coupon|
        if key == coupon[:item] && value[:count] >= coupon[:num]
          value[:count] -= coupon[:num]
          return_hash[key] = value
          if !return_hash.has_key?(key + " W/COUPON")
            return_hash[key + " W/COUPON"] = {:price => coupon[:cost], :clearance => value[:clearance], :count => 1}
          else
            return_hash[key + " W/COUPON"][:count] += 1
          end
        else
          return_hash[key] = value
        end
      end
    end
  return_hash
else
  cart
  end
end

def apply_clearance(cart:[])
  return_hash = {}
  cart.each do |key, value|

    if value[:clearance] == true
      value[:price] = (value[:price] * 0.8).round(1)
      #binding.pry
    end
    return_hash[key] = value
  end
  return_hash
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  total = cart.inject(0) {|amount, (item, data)| amount += (data[:price] * data[:count])} 
  #binding.pry
  if total > 100
    total = total * 0.9
  end
  total


end