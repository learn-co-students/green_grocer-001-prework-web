def consolidate_cart(cart:[])
  consolidated_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item, attributes|
      if !consolidated_cart.has_key?(item)
        consolidated_cart[item] = attributes
        consolidated_cart[item][:count] = 1
      else
        consolidated_cart[item][:count] += 1
      end
    end
  end
  consolidated_cart
end


def apply_coupons(cart:[], coupons:[])
  cart_with_coupons = {}
  coupons.each do |coupon|
    cart.each do |item, attributes|
      if coupon[:item] == item && coupon[:num] <= attributes[:count] && cart_with_coupons["#{item} W/COUPON"] == nil
        cart_with_coupons["#{item} W/COUPON"] =
        {
          :price => coupon[:cost],
          :clearance => attributes[:clearance],
          :count => 1
        }
        attributes[:count] -= coupon[:num]
      elsif coupon[:item] == item && coupon[:num] <= attributes[:count] && cart_with_coupons["#{item} W/COUPON"] != nil
        cart_with_coupons["#{item} W/COUPON"][:count] += 1
        attributes[:count] -= coupon[:num]
      end
    end
  end
  cart_with_coupons.merge(cart)
end


def apply_clearance(cart:[])
  cart.each_value do |attributes|
    attributes[:price] = attributes[:price] * 8 /10 if attributes[:clearance] == true
  end
  cart
end


def checkout(cart:[], coupons:[])
  c_cart = consolidate_cart(cart: cart)
  coupon_cart = apply_coupons(cart: c_cart, coupons: coupons)
  final_cart = apply_clearance(cart: coupon_cart)
  total = 0
  final_cart.each_value do |attributes|
    total += attributes[:price] * attributes[:count]
  end
  total = total * 9 / 10 if total > 100
  total
end