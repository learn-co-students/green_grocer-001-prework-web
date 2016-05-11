def consolidate_cart(cart:[])
  # code here
consolidated = {}
cart.each do |item|
  item.each do |key, value|
    if consolidated.has_key?(key)
      consolidated[key][:count] += 1
    else
      consolidated[key] = value
      consolidated[key][:count] = 1
    end
  end
end
consolidated
end

def apply_coupons(cart:[], coupons:[])
  # code here
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      item_withcoupon = coupon[:item] + " W/COUPON"
      if cart.has_key?(item_withcoupon)
        cart[item_withcoupon][:count] += 1
      else
        cart[item_withcoupon] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: 1}
      end
      cart[coupon[:item]][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart:[])
  # code here
  cart.each do |item, properties|
    if properties[:clearance] == true
      properties[:price] = (properties[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  # code here
  cart_consolidated = consolidate_cart(cart:cart)
  cart_couponsapplied = apply_coupons(cart:cart_consolidated, coupons: coupons)
  cart_clearanceapplied = apply_clearance(cart: cart_couponsapplied)
  cart_total = 0
  cart_clearanceapplied.each do |item, properties|
    cart_total += properties[:price] * properties[:count]
  end
  if cart_total > 100
    cart_total = (cart_total * 0.9).round(2)
  end
  cart_total
end
