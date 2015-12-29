def consolidate_cart(cart:[])

  cons = {}
  cart.each { |item| item.each { |k, v| v[:count] = 1 } }
  
  cart.each do |item|
    item.each { |k, v| cons[k] == nil ? cons[k] = v : cons[k][:count] += 1 }
  end
  
  cons
end


def apply_coupons(cart:[], coupons:[])

  coupon_holder = []
  coupons.each do |coupon|
    item = coupon[:item]

    if cart.keys.include?(item)
      if cart[item][:count] >= coupon[:num]
        if cart["#{item} W/COUPON"] == nil
          cart["#{item} W/COUPON"] = {}
          cart["#{item} W/COUPON"][:price] = coupon[:cost]
        end
        
        if coupon_holder.include?(coupon)
         cart["#{item} W/COUPON"][:count] += 1
        else
         cart["#{item} W/COUPON"][:count] = 1
         coupon_holder << coupon
        end
        
        cart[item][:count] -= coupon[:num]
        cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
      end
    end
  end
  
  cart
end


def apply_clearance(cart:[])
  
  cart.each { |k, v| v[:price] -= (v[:price] * 0.2) if v[:clearance] == true }
  
end


def checkout(cart:[], coupons:[])

  start_cart       = {}
  cart_and_coupons = {}
  clearance_cart   = {}
  
  start_cart[:cart]          = cart
  cart_and_coupons[:cart]    = consolidate_cart(start_cart)
  cart_and_coupons[:coupons] = coupons
  clearance_cart[:cart]      = apply_coupons(cart_and_coupons)
  checkout_cart              = apply_clearance(clearance_cart)

  prices = checkout_cart.collect { |k, v| v[:price] * v[:count]}
  total = prices.inject { |sum, item| sum + item }
  
  total -= (total * 0.1) if total > 100
  total
  
end
