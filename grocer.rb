require 'pry'

def consolidate_cart(cart:[])
  items = []
  cart_hash = {}

  #makes cart_hash:

  cart.each do |i|
    i.each do |item, data|
      items << i.keys
      if !cart_hash.has_key?(item)
      cart_hash[item] = data
      end
    end
  end

  items.flatten!

  #counts:
  already_counted = []
  items.each do |i|
    if !already_counted.include?(i)
      count = items.count(i)
      already_counted << i
        cart_hash.each do |item, data|
          if item == i
            cart_hash[item][:count] = count
          end
        end
    end
  end

  cart_hash
end


def apply_coupons(cart:[], coupons:[])
  coupon_hash = {}

  num = 1
  coupons.each do |i|
      coupon_hash[num] = i
      num += 1
  end

  coupon_hash.each do |num, coupon|
    coupon.each do |a, b|
      if cart.has_key?(b) && cart[b][:count] >= coupon_hash[num][:num] && !cart.has_key?("#{b} W/COUPON")
        cart["#{b} W/COUPON"] = {}

        cart["#{b} W/COUPON"][:price] = coupon_hash[num][:cost]

        cart["#{b} W/COUPON"][:count] = coupon_hash[num][:num]

        cart["#{b} W/COUPON"][:clearance] = cart[b][:clearance]

        cart["#{b} W/COUPON"][:count] = 1

        cart[b][:count] = (cart[b][:count]) - (coupon_hash[num][:num])
      elsif cart.has_key?("#{b} W/COUPON") && cart[b][:count] >= coupon_hash[num][:num]

        cart["#{b} W/COUPON"][:count] += 1
        cart[b][:count] = (cart[b][:count]) - (coupon_hash[num][:num])
      end
    end
  end

  cart
end


def apply_clearance(cart:[])

  cart.each do |item, data|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(1)
    end
  end

  cart
end

def checkout(cart: [], coupons: [])
  con_cart = consolidate_cart(cart: cart)

  con_cart = apply_coupons(cart: con_cart, coupons: coupons)

  con_cart = apply_clearance(cart: con_cart)

  total = 0
  con_cart.each do |i, j|
    total = total + (con_cart[i][:price] * con_cart[i][:count])
  end

  if total >= 100
    total = total * 0.9
  end

  total
end

