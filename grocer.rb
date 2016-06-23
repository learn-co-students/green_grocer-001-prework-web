require 'pry'

def consolidate_cart(cart:[])
  consolidated_cart = {}
  cart.each do |item|
    item.each do |item_name, attributes|
      if !consolidated_cart.has_key? item_name
        consolidated_cart[item_name] = attributes
        consolidated_cart[item_name][:count] = 0
      end
      consolidated_cart[item_name][:count] += 1
    end
  end
  consolidated_cart
end

def apply_coupons(cart:[], coupons:[])
  coupon_cart = {}
  cart.each do |item, attributes|
    coupons.each do |coupon|
      if coupon[:item] == item && attributes[:count] >= coupon[:num]
        if !coupon_cart.has_key?("#{item} W/COUPON")
          coupon_cart["#{item} W/COUPON"] = {
            price: coupon[:cost],
            clearance: attributes[:clearance],
            count: 0}
        end
        coupon_cart["#{item} W/COUPON"][:count] += 1
        attributes[:count] -= coupon[:num]
      end
    end
  end
  cart.merge!(coupon_cart)
end

def apply_clearance(cart:[])
  cart.each do |item, attributes|
    attributes[:price] = (attributes[:price] * 0.8).round(2) if attributes[:clearance]
  end
end

def checkout(cart: [], coupons: [])
  cart = apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))
  total = 0

  cart.each do |item, attributes|
    total += attributes[:price] * attributes[:count]
  end

  total = (total * 0.9).round(2) if total >= 100
  total
end