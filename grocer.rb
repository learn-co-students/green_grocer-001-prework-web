def consolidate_cart(cart:[])
  result = {}
  cart.each do |item|
    name, data = item.first
    if result.include?(name)
      result[name][:count] += 1
    else
      result[name] = data
      result[name][:count] = 1
    end
  end
  result
end

def apply_coupons(cart:[], coupons:[])
  result = cart
  coupons.each do |coupon|
    if cart.include?(coupon[:item])
      data = result[coupon[:item]]
      if data[:count] >= coupon[:num]
        k = "#{coupon[:item]} W/COUPON"
        if result.include?(k)
          result[k][:count] += 1
        else
          result[k] = {price: coupon[:cost], clearance: data[:clearance], count: 1}
        end
        result[coupon[:item]][:count] = data[:count] - coupon[:num]
      end
    end
  end
  result
end

def apply_clearance(cart:[])
  result = cart
  cart.each do |grocery, info|
    if info[:clearance]
      discount = info[:price] * 0.8
      result[grocery][:price] = discount.round(2)
    end
  end
  result
end

def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart)
  apply_coupons(cart: consolidated, coupons: coupons)
  apply_clearance(cart: consolidated)
  total_price = 0
  consolidated.each do |grocery, info|
    total_price += (info[:price] * info[:count])
  end
  if total_price > 100
    total_price *= 0.9
  end
  total_price
end