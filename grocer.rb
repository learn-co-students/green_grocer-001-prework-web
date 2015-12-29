def consolidate_cart(cart:[])
  updated_cart = {}
  cart.each do |item|
    item.each do |k, v|
      if !updated_cart[k]
        updated_cart[k] = v
        updated_cart[k][:count] = 1
      else
        updated_cart[k][:count] += 1
      end
    end
  end
  updated_cart
end

def apply_coupons(cart:[], coupons:[])
    new_hash = {}
    cart.each do |vegetable, properties|
      if !new_hash[vegetable]
        new_hash[vegetable] = properties
      end
      coupons.each do |hash|
        hash.each do |coupon_key, coupon_value|
          if coupon_value == vegetable
            if !new_hash["#{vegetable} W/COUPON"]
              new_hash["#{vegetable} W/COUPON"] = {:price => hash[:cost], :clearance => cart[vegetable][:clearance], :count => 0}
            end
            if !(new_hash[vegetable][:count] < hash[:num])
              new_hash[vegetable][:count] -= hash[:num]
              new_hash["#{vegetable} W/COUPON"][:count] += 1
            end
          end
        end
      end
    end
    new_hash
end

def apply_clearance(cart:[])
  new_hash = {}
  cart.each do |item, properties|
    if properties[:clearance] == true
      price = properties[:price] - properties[:price] * 0.20
      new_hash[item] = {:price => price, :clearance => properties[:clearance], :count => properties[:count]}
    else
      new_hash[item] = properties
    end
  end
  new_hash
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart:cart)
  cart = apply_coupons(cart:cart, coupons:coupons)
  cart = apply_clearance(cart:cart)
  
  total = 0
  cart.each do |item, properties|
    total += properties[:price] * properties[:count]
  end

  total > 100 ? total -= total * 0.1 : nil

  total
end