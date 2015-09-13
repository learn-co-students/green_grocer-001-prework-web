def consolidate_cart(cart:[])
  new_hash ={}
  cart = cart.group_by { |item| item}
    for i in 0..cart.length - 1
        new_hash[cart.keys[i].keys[0]] = cart.keys[i].values[0]
    new_hash[new_hash.keys[i]][:count] = cart.values[i].length
  end
  new_hash
end

def apply_coupons(cart:[], coupons:[])
  for i in 0..coupons.length - 1
    for j in 0..cart.length - 1
      if coupons[i][:item] == cart.keys[j]
        if cart.values[j][:count] >= coupons[i][:num]
          cart["#{cart.keys[j]} W/COUPON"] = {:price => coupons[i][:cost], :clearance => cart.values[j][:clearance], :count => cart.values[j][:count] / coupons[i][:num]}
          cart.values[j][:count] = cart.values[j][:count] % coupons[i][:num]
        end
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  for i in 0..cart.length - 1
    if cart.values[i][:clearance] == true
      cart.values[i][:price] = cart.values[i][:price] - (cart.values[i][:price] * 0.20)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart:cart)
  apply_coupons(cart:cart, coupons:coupons)
  apply_clearance(cart:cart)
  total = 0
  for i in 0..cart.length - 1
    total += cart.values[i][:count] * cart.values[i][:price]
    if total > 100
      total = total - (total * 0.10)
    end
  end
  total
end