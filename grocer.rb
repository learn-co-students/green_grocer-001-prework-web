require 'pry'

def consolidate_cart(cart:[])
  item_quantity = []
  consolidate_cart = {}

  cart.map! do |item|
    item.each do |name, details|
      item[name][:count] = cart.count(item)
    end
  end

  cart.uniq.each do |item|
    item.each do |name, details|
      consolidate_cart[name] = details
    end
  end

  consolidate_cart
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count]/coupon[:num] > 0
      cart["#{coupon[:item]} W/COUPON"] = {}
      cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
      cart["#{coupon[:item]} W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
      cart["#{coupon[:item]} W/COUPON"][:count] = cart[coupon[:item]][:count]/coupon[:num]

      #if cart[coupon[:item]][:count]%coupon[:num] == 0
        #cart.delete(coupon[:item])
      #else
        cart[coupon[:item]][:count] = cart[coupon[:item]][:count]%coupon[:num]
      #end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |name, details|
    if cart[name][:clearance]
      cart[name][:price] = (cart[name][:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  total = 0

  apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons)).each do |item, details|
    total += (details[:price]*details[:count])
  end

  if total > 100
    total *= 0.9
  end

  total
end