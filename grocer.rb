def consolidate_cart(cart:[])
  new_hash = {}
  cart.each do |row|
    row.each do |food, data|
      if new_hash[food]
        new_hash[food][:count] += 1
      else
        new_hash[food] = data
        new_hash[food][:count] = 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart:[], coupons:[])
  new_hash = {}
  cart.each do |food, data|
    coupons.each do |coupon|
      if food == coupon[:item] && data[:count] >= coupon[:num]
        data[:count] = data[:count] - coupon[:num]
        new_hash["#{food} W/COUPON"] ? new_hash["#{food} W/COUPON"][:count] += 1 : new_hash["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => data[:clearance], :count => 1}
      end
    end
    new_hash[food] = data
  end
  new_hash
end

def apply_clearance(cart:[])
  cart.each do |food, data|
    data[:price] = (data[:price] * 0.8).round(2) if data[:clearance]
  end
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  total = 0
  cart.each do |food, data|
    total += data[:price] * data[:count]
  end
  total > 100 ? total * 0.9 : total
end