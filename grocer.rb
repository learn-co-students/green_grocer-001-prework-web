def consolidate_cart(cart:[])
  count = {}
  cart.each do |item|
    item.each do |name, data|
      count[name] = data if count[name].nil?
      count[name][:count] = count[name][:count].nil? ? 1 : count[name][:count] + 1
    end
  end
  count
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart.include?(name)
      if cart[name][:count] >= coupon[:num]
        num_cart = cart[name][:count] % coupon[:num]
        num_coupons = cart[name][:count] / coupon[:num]
        cart["#{name} W/COUPON"] = {price: coupon[:cost], clearance: cart[name][:clearance], count: num_coupons}
        cart[name][:count] = num_cart
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |item, data|
    data[:price] = (data[:price] * 0.8).round(2) if data[:clearance]
  end
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  total_cost = cart.inject(0) {|total, (item, data)| total += (data[:price] * data[:count])}
  total_cost = (total_cost * 0.9).round(2) if total_cost > 100
  total_cost
end


