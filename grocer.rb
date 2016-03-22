def consolidate_cart(cart:[])
  consolidated = {}

  cart.each do |food|
    food.each do |info, value|
      if consolidated.keys.include?(info)
        consolidated[info][:count] += 1
       else
        consolidated[info] = {:price => value[:price], :clearance => value[:clearance], :count => 1}
      end
    end
  end
  consolidated
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    food = coupon[:item]
    if cart.keys.include?(food) && cart[food][:count] >= coupon[:num]
    number_items = cart[food][:count] - coupon[:num]
    cart[food][:count] = number_items
      if cart.include?("#{food} W/COUPON")
      cart["#{food} W/COUPON"][:count] += 1
      else
      cart["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[food][:clearance], :count => 1}
     end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |food, info|
    if cart[food][:clearance] == true
        cart[food][:price] = (cart[food][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  consolidate = consolidate_cart(cart: cart)
  coupons_cart = apply_coupons(cart: consolidate, coupons: coupons)
  clearance_cart = apply_clearance(cart: coupons_cart)

  total = 0

  clearance_cart.each do |food, info|
    total += info[:price] * info[:count]
  end

  if total > 100
    total = (total * 0.9).to_f
  end

  total
end