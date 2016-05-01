def consolidate_cart(cart:[])
  # code here
  result = {}

  cart.each do |item|
    item_name, item_details = item.first
    if result.has_key?(item_name)
      result[item_name][:count] += 1
    else
      result[item_name] = item_details
      result[item_name][:count] = 1
    end
  end

  result
end

def apply_coupons(cart:[], coupons:[])
  # code here
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]

      # update coupon key
      coupon_key = coupon[:item] + " W/COUPON"
      if cart.has_key?(coupon_key)
        cart[coupon_key][:count] += 1
      else
        cart[coupon_key] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: 1}
      end

      #update item key
      cart[coupon[:item]][:count] -= coupon[:num]
    end
  end

  cart
end

def apply_clearance(cart:[])
  # code here
  cart.each do |k,v|
    if v[:clearance]
      v[:price] = (v[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  # code here
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart:cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  
  total = 0
  cart.each { |k,v| total += v[:price] * v[:count] }
  total > 100 ? (total * 0.9).round(2) : total
end