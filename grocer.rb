require 'pry'

def consolidate_cart(cart:[])
  uniq_items = {}
  item_basket = []
  cart.each do |item|
      uniq_items.merge!(item)
      item_basket << item.keys
  end
  uniq_items.each do |name, details|
    details[:count] = 0
  end
  item_basket.flatten!
  item_basket.each do |item|
    if uniq_items.keys.include?(item)
      uniq_items[item][:count] += 1
    end
  end
  uniq_items
end



def apply_coupons(cart:[], coupons:[])
  cart.keys.each do |key|
    coupons.each do |item|
      if key == item[:item]
        cart["#{key} W/COUPON"] = Hash.new(0)
      end
    end
  end
  cart.each do |names, details|
    if names.include? ("W/COUPON")
      item_name = names.split[0]
      coupons.each do |coupon_item| 
        if coupon_item[:item] == item_name
          #set :cost
          cost = coupon_item[:cost]
          details[:price] = cost
          #set :clearance
          clearance = cart[item_name][:clearance]
          details[:clearance] = clearance
          #set :count. The if statement avoids duplication for multiple coupons
          if cart[item_name][:count] - coupon_item[:num] >= 0
            details[:count] += 1
          # set original cart item count
            cart[item_name][:count] -= coupon_item[:num]
          end
        end
      end
    end
  end
  cart
end

=begin
def apply_coupons(cart:[], coupons:[])
  cart.keys.each do |key|
    coupons.each do |item|
      if key == item[:item]
        cart["#{key} W/COUPON"] = {}
      end
    end
  end
  cart.each do |names, details|
    if names.include? ("W/COUPON")
      item_name = names.split[0]
      coupons.each do |coupon_item| 
        if coupon_item[:item] == item_name
          #set :cost
          cost = coupon_item[:cost]
          details[:price] = cost
          #set :clearance
          clearance = cart[item_name][:clearance]
          details[:clearance] = clearance
          #set :count. The if statement avoids duplication for multiple coupons
          if details.key?(:count) == false
            count = (cart[item_name][:count] / coupon_item[:num]).round
            details[:count] = count
          # set original cart item count
            cart[item_name][:count] -= (count * coupon_item[:num])
          end
        end
      end
    end
  end
  cart
end
=end




def apply_clearance(cart:[])
  cart.each do |name, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(1)
    end
  end
end



def checkout(cart: [], coupons: [])
  consolidate = consolidate_cart(cart: cart)
  cart_with_coupons = apply_coupons(cart: consolidate, coupons: coupons)
  cart_with_clearance = apply_clearance(cart: cart_with_coupons)
  total = []
  cart_with_clearance.each do |item, info|
    total << info[:price] * info[:count]
  end
  total = total.inject {|num, n| num + n}
  if total > 100
    return (total * 0.9).round
  else
    return total
  end
end



=begin
def checkout(cart: [], coupons: [])
  #first do consolidate_cart
  uniq_items = {}
  item_basket = []
  cart.each do |item|
      uniq_items.merge!(item)
      item_basket << item.keys
  end
  uniq_items.each do |name, details|
    details[:count] = 0
  end
  item_basket.flatten!
  item_basket.each do |item|
    if uniq_items.keys.include?(item)
      uniq_items[item][:count] += 1
    end
  end
  cart = uniq_items
    cart.keys.each do |key|
    coupons.each do |item|
      if key == item[:item]
        cart["#{key} W/COUPON"] = {}
      end
    end
  end
  #now do coupons
  cart.each do |names, details|
    if names.include? ("W/COUPON")
      item_name = names.split[0]
      coupons.each do |coupon_item| 
        if coupon_item[:item] == item_name
          #set :cost
          cost = coupon_item[:cost]
          details[:price] = cost
          #set :clearance
          clearance = cart[item_name][:clearance]
          details[:clearance] = clearance
          #set :count. The if statement avoids duplication for multiple coupons
          if details.key?(:count) == false
            count = (cart[item_name][:count] / coupon_item[:num]).round
            details[:count] = count
          # set original cart item count
            cart[item_name][:count] -= (count * coupon_item[:num])
          end
        end
      end
    end
  end
  cart.each do |name, info|
    info.each do |category, detail|
      if category == :clearance
        if detail == true
          info[:price] = (info[:price] * 0.8).round(1)
        end
      end
    end
  end
  total = []
  cart.each do |item, info|
    total << info[:price] * info[:count]
  end
  total = total.join.to_f
  if total > 100
    return (total * 0.9).round
  else
    return total
  end
end
=end



