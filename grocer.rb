def consolidate_cart(cart:[])
  consolidated = {}

  cart.each do |item|
    item.each do |food, data|
      if consolidated.include?(food)
        consolidated[food][:count] += 1
      else
        consolidated[food] = data
        consolidated[food][:count] = 1
      end
    end
  end
  consolidated
end

def apply_coupons(cart:[], coupons:[])
  new_hash = {}
  cart.each do |food, data|
    coupons.each do |coupon|
      if food == coupon[:item] && data[:count] >= coupon[:num]
        data[:count] = data[:count] - coupon[:num]
        if new_hash["#{food} W/COUPON"]
          new_hash["#{food} W/COUPON"][:count] += 1
        else new_hash["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => data[:clearance], :count => 1}
        end
      end
    end
    new_hash[food] = data
  end
  new_hash
end

def apply_clearance(cart:[])
  cart.each do |item, data|
    if data[:clearance] == true
      data[:price] = (data[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  total = 0
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  cart.each do |food, data|
    total += data[:price] * data[:count]
  end

  if total >= 100
    total = total *0.9
  end
  total
end