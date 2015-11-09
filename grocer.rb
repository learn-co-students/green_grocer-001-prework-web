def consolidate_cart(cart:[])
  # code here
  con_hash = {}
  cart.each do |item|
    item.each do |name, attribute|
      if con_hash.has_key?(name)
        con_hash[name][:count] += 1        
      else 
        con_hash = con_hash.merge({name => attribute.merge({count: 1})})
      end
    end
  end
  return con_hash
end

def apply_coupons(cart:[], coupons:[])
  # code here
  # cart_cons = consolidate_cart(cart: cart)
  cart_cons = cart
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart_cons.keys.include?(item_name)
      cart_count = cart_cons[item_name][:count]
      if cart_count >= coupon[:num]
        item_coup = {"#{item_name} W/COUPON" => {price: coupon[:cost], clearance: cart_cons[item_name][:clearance], count: cart_count/coupon[:num]}}
        cart_cons[item_name][:count] %= coupon[:num]
        cart_cons = cart_cons.merge(item_coup)
      end
    end
  end
  return cart_cons
end

def apply_clearance(cart:[])
  # code here
  # cart_cons = consolidate_cart(cart: cart)
  cart.each do |item, attribute|
    if attribute[:clearance] == true
      attribute[:price] = (attribute[:price]*0.8).round(2)
    end
  end
  return cart
end

def checkout(cart: [], coupons: [])
  # code here
  cart_cons = consolidate_cart(cart: cart)
  cart_coup = apply_coupons(cart:cart_cons, coupons:coupons)
  cart_check = apply_clearance(cart: cart_coup)
  total = 0
  cart_check.each do |item, attribute|
    total += attribute[:count] * attribute[:price]
  end
  return total = total > 100 ? (total*0.9).round(2) : total
end