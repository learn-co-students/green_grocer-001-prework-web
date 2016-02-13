require 'pry'

def consolidate_cart(cart:[])
cart_hash = Hash.new

  cart.each do |hash|
    hash.each do |item, stats|
      cart_hash[item] = stats
      cart_hash[item][:count] = 0
    end
  end

  cart.each do |hash|
    hash.each do |item, stats|
      cart_hash[item][:count] += 1
    end
  end

  cart_hash
end

def apply_coupons(cart:[], coupons:[])

  coupons.each do |coupon|
    if cart[coupon[:item]] != nil && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] -= coupon[:num]
      if cart["#{coupon[:item]} W/COUPON"] == nil
        cart["#{coupon[:item]} W/COUPON"] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: 1}
      else
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      end
    end
  end
  
  cart
end

def apply_clearance(cart:[])
  cart.each do |item, stats|
    if cart[item][:clearance] == true
      price = cart[item][:price]
      price_string = '%.2f' % [price * 0.80]
      cart[item][:price] = price_string.to_f
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  prices = []
  cart.each do |item, stats|
    prices << cart[item][:price] * cart[item][:count]
  end

  total = prices.inject {|sum, el| sum + el}
  if total > 100
    total_string = '%.2f' % [total * 0.90]
    return total_string.to_f
  else
    return total
  end

end