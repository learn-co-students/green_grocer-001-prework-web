def consolidate_cart(cart: [])
  new_cart = {}

  cart.each do |hash|
    hash.each do |item, attributes|
      unless new_cart.include?(item)
        new_cart[item] = attributes
        new_cart[item][:count] = 1
      else
        new_cart[item][:count] += 1
      end
    end
  end

  new_cart
end


def apply_coupons(cart:[], coupons:[])
  coupon_hash = {}

  cart.each do |item, attributes|
    coupons.each do |coupon|
      if coupon[:item] == item && attributes[:count] % coupon[:num] >= 0
        coup_item = "#{item} W/COUPON"
        iterations = attributes[:count] / coupon[:num]

        iterations.times do
          unless coupon_hash.include?(coup_item)
            coupon_hash[coup_item] = attributes.dup
            coupon_hash[coup_item][:price] = coupon[:cost]
            coupon_hash[coup_item][:count] = 1
          else
            coupon_hash[coup_item][:count] += 1
          end
          attributes[:count] -= coupon[:num]
        end

      end
    end
  end

  cart.merge(coupon_hash)
end


def apply_clearance(cart:[])
  cart.each do |item, attributes|
    if attributes[:clearance] == true
      attributes[:price] = (attributes[:price]*0.8).round(2)
    end
  end
end


def checkout(cart: [], coupons: [])
  cart_a = consolidate_cart(cart: cart)
  cart_b = apply_coupons(cart: cart_a, coupons: coupons)
  cart_c = apply_clearance(cart: cart_b)

  total = 0

  cart_c.each do |item, attributes|
    total += (attributes[:price] * attributes[:count])
  end

  total *= 0.9 if total > 100
  total
end




