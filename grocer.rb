def consolidate_cart(cart:[])
  sorted_cart = {}
  cart.each do |item|
    item.each do |name, data|
      sorted_cart.has_key?(name) ? sorted_cart[name][:count] += 1 : sorted_cart[name] = {:count => 1}
      data.each { |attrb, info| sorted_cart[name][attrb] = info }
    end
  end
  sorted_cart
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart.has_key?(name) && cart[name][:count] >= coupon[:num]
      cart[name][:count] -= coupon[:num]
      if cart.has_key?("#{name} W/COUPON") == false
        cart["#{name} W/COUPON"] = {
          :price => coupon[:cost],
          :clearance => cart[name][:clearance],
          :count => 1 
        }
      else
        cart["#{name} W/COUPON"][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.keys.each do |item|
    cart[item][:price] -= cart[item][:price] * 0.2 if cart[item][:clearance]  
  end
  cart
end

def checkout(cart: [], coupons: [])
  sorted_cart = consolidate_cart(cart: cart)
  apply_coupons(cart: sorted_cart, coupons: coupons)
  apply_clearance(cart: sorted_cart)
  cart_total = 0.0
  sorted_cart.keys.each do |item|
    cart_total += sorted_cart[item][:price] * sorted_cart[item][:count]
  end
  if cart_total > 100
    cart_total -= cart_total * 0.1
  end
  cart_total
end

