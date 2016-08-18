def consolidate_cart(cart:[])
  consolidate_hash = {}
  cart.each do |item|
    item.each do |key, value|
      value[:count] = cart.count(item)
      consolidate_hash[key] = value
    end
  end
  consolidate_hash
end

def apply_coupons(cart:[], coupons:[])
  coupon_hash = {}
  cart.each do |key, value|
    coupon_hash[key] = value.clone
    coupons.each do |coupon|
      if coupon[:item] == key
        coupon_hash[key][:count] = value[:count]%coupon[:num]
        coupon_hash[key + " W/COUPON"] = value.clone
        coupon_hash[key + " W/COUPON"][:count] = value[:count] / coupon[:num]
        coupon_hash[key + " W/COUPON"][:price] = coupon[:cost]
      end
    end
  end
  coupon_hash
end

def apply_clearance(cart:[])
  cart.each do |item, item_info|
    if item_info[:clearance]
      item_info[:price] = (item_info[:price] * 0.8).round(1)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  checkout_cart = apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))
  total = 0
  checkout_cart.each do |item, value|
    total = total + value[:price] * value[:count]
end
return total if total <= 100
else
  return (total * 0.9).round(1)
end
