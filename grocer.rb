def consolidate_cart(cart:[])
  cart.collect do |cart_items|
    cart_items.collect do |items, attribute_hash|
      if attribute_hash.include?(:count)
      else
        cart_items[items][:count] = 1
      end
    end
  end
  cart = cart.reduce{|acc, h| acc.merge(h){|key, old_val, new_val|
    old_val[:count] += 1
    new_val 
    }}
  cart
end

def apply_coupons(cart:[], coupons:[])
  coupon_items = []
  coupons.each {|array| coupon_items << array[:item]}
  cart_items = []
  cart.each {|item, hash| cart_items << item}
  if coupons == []
    cart
  elsif cart_items.any?{ |i| coupon_items.include?(i) }
    coupons.each do |array|
      item = "#{array[:item]} W/COUPON"
      cart[item] = {:price => array[:cost], :clearance => cart[array[:item]][:clearance], :count => 1}
      if coupon_items.count(array[:item]) > 1
        cart[item][:count] = coupon_items.count(array[:item])
      end
    end
    cart.collect do |item, item_prop|
      coupons.collect do |array|
        if item == array[:item]
          if item_prop[:count] - array[:num] < 0
            cart["#{item} W/COUPON"][:count] = cart["#{item} W/COUPON"][:count] - 1
          else
            cart[item][:count] = item_prop[:count] - array[:num]
          end
        end
      end
    end
  else
    cart
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |item, hash|
    if hash[:clearance] == true
      cart[item][:price] = cart[item][:price] - (cart[item][:price] * 1/5)
    end
  end
end

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(cart: cart)
  couponed_cart = apply_coupons(cart: consolidated_cart, coupons: coupons)
  clearanced_cart = apply_clearance(cart: couponed_cart)
  total_array = []
  clearanced_cart.each do |item, hash|
    if hash[:count] > 0
      total_array << hash[:price] * hash[:count]
    end
  end
  total = total_array.inject(0){ |sum,i| sum + i }
  if total > 100
    total = total - (total * 1/10)
  end
  total
end