def consolidate_cart(cart:[])
  consolidated = {}

  cart.each do |grocery_item_hash|
    item_name = grocery_item_hash.keys[0]

    if consolidated[item_name]
      consolidated[item_name][:count] += 1
    else
      consolidated[item_name] = grocery_item_hash[item_name]
      consolidated[item_name][:count] = 1
    end

  end

  consolidated
end

def apply_coupons(cart:{}, coupons:[])
  coupons.each do |coupon_hash|
    item_name = coupon_hash[:item]

    #Only apply coupon if we have enough of the item in our cart
    if cart[item_name] && cart[item_name][:count] >= coupon_hash[:num]

      #Add the couponed item(s) to the cart
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += 1
      else
        cart["#{item_name} W/COUPON"] = {price: coupon_hash[:cost],
                                          clearance: cart[item_name][:clearance],
                                          #count: cart[item_name][:count]/coupon_hash[:num]
                                          count: 1
                                         }
      end

      #Update original item's count
      num_uncouponed = cart[item_name][:count] - coupon_hash[:num]
      cart[item_name][:count] = num_uncouponed

    end
  end

  cart
end

def apply_clearance(cart:{})
  cart.collect do |item_name, item_data|
    if item_data[:clearance]
      item_data[:price] = (item_data[:price] * 80)/100
    end
  end

  cart
end

def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart)
  with_coupons = apply_coupons(cart: consolidated, coupons: coupons)
  with_coupons_and_clearance = apply_clearance(cart: with_coupons)

  total_cost = 0

  with_coupons_and_clearance.values.each do |item_data|
    total_cost += (item_data[:price] * item_data[:count])
  end

  total_cost > 100 ? (total_cost * 90)/100 : total_cost
end
