require 'pry'

def consolidate_cart(cart:[])

  object = cart.each_with_object({}) do |item, consolidated_cart|
    food_item = item.keys[0]
    consolidated_cart[food_item]  = item.values[0]
    if consolidated_cart[food_item][:count]
      consolidated_cart[food_item][:count] += 1
    else
      consolidated_cart[food_item][:count] = 1
    end
#  binding.pry
  end
  object # => hash

end

def apply_coupons(cart:[], coupons:[])

  coupons.each do |coupon|
    food_item = coupon[:item]
    if cart[food_item] && cart[food_item][:count] >=coupon[:num]
      couponed = cart[food_item][:count] / coupon[:num].floor
      left_over_wo_coupon = cart[food_item][:count] % coupon[:num]
      food_item_w_coupon = "#{food_item} W/COUPON"
      cart[food_item_w_coupon] = {
        price: coupon[:cost],
        clearance: cart[food_item][:clearance],
        count: couponed
      }
      cart[food_item][:count] = left_over_wo_coupon

    end
  end
  cart # => hash
end

def apply_clearance(cart:[])
  cart.each do |item, info|
    if info[:clearance]
      info[:price] = (0.8 * info[:price]).round(6)
    end
  end
end

def checkout(cart: [], coupons: [])

  grand_total = 0
#  consolidated_cart = consolidate_cart(cart: cart)
#  cart_with_coupons = apply_coupons(cart: consolidated_cart, coupons: coupons)
#  discounted_cart = apply_clearance(cart: cart_with_coupons)
  discounted_cart = apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))
  discounted_cart.values.each {|pricing| grand_total += pricing[:price]*pricing[:count]}
  grand_total > 100 ? (grand_total*0.9).round(6) : grand_total
end
