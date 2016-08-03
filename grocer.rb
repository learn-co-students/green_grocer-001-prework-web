def consolidate_cart(cart:[])
  hash = {}
  cart.each do |item|
    item.each do |key, value|
      value[:count] = cart.count(item)
      hash[key] = value
    end
  end
  hash
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    x = coupon[:item]
    if cart[x] && cart[x][:count] >= coupon[:num]
      if cart["#{x} W/COUPON"]
        cart["#{x} W/COUPON"][:count] += 1
      else
        cart["#{x} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{x} W/COUPON"][:clearance] = cart[x][:clearance]
      end
      cart[x][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |item, value|
    if value[:clearance]
      value[:price] -= value[:price] * 0.2
    end
  end
  cart
end

def checkout(cart: [], coupons: [])

  combined_cart = consolidate_cart(cart: cart)
  marked_down_cart = apply_coupons(cart: combined_cart, coupons: coupons)
  complete_cart = apply_clearance(cart: marked_down_cart)
  total = 0
  complete_cart.each do |name, value|
    total += value[:price] * value[:count]


end
  if total > 100
    total -= total * 0.1

end
total
end
