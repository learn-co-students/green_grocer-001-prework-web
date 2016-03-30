require 'pry'

# RUNNER METHOD

def checkout(cart:[], coupons:[])
  sorted_cart = consolidate_cart(cart:cart)
  apply_coupons(cart:sorted_cart, coupons:coupons)
  apply_clearance(cart:sorted_cart)
  big_spender_discount(cart:sorted_cart)
end

# SORTING THE CART

# runner method
def consolidate_cart(cart:[])
  add_item_counts(cart:cart)
  remove_duplicates(cart:cart)
  cart.inject({}) { |hash, cart_item| hash.merge(cart_item) }
end

# add counts to all items
def add_item_counts(cart:[])
  cart.each do |item|
    item.map { |food_item, info| info[:count] = count_item(food_item, cart) }
  end
end

#a add counts to single item
def count_item(food_item, cart)
  cart.select { |groceries| groceries.has_key?(food_item) }.count
end

# delete duplicate items after adding counts
def remove_duplicates(cart:[])
  cart.uniq
end

# APPLYING DISCOUNTS

# runner method
def apply_coupons(cart:[], coupons:[])
  coupons.each { |coupon| apply_coupon(coupon, cart) if valid_coupon?(coupon, cart) }
  cart
end

# check if coupon applies
def valid_coupon?(coupon, cart)
  cart.has_key?(coupon[:item]) && cart[coupon[:item]].fetch(:count) >= coupon[:num]
end

# add coupon to cart, decrease item count accordingly
def apply_coupon(coupon, cart)
  item = coupon.fetch(:item)
  if !cart.has_key?("#{item} W/COUPON")
    cart["#{item} W/COUPON"] = { price: coupon[:cost], clearance: cart[item][:clearance], count: 1 }
  else
    cart["#{item} W/COUPON"][:count] += 1
  end
  cart[item][:count] -= coupon[:num]
end

# apply clearance discounts
def apply_clearance(cart:[])
  cart.each { |item, info| info[:price] -= info[:price] * 0.2 if info[:clearance] }
end

# apply discount for spending $100+
def big_spender_discount(cart:[])
  cart_total = cart.reduce(0.0) { |total, (item, info)| total += info[:price] * info[:count] }
  cart_total > 100 ? cart_total -= cart_total * 0.1 : cart_total
end











# def consolidate_cart(cart:[])
#   sorted_cart = {}
#   cart.each do |item|
#     item.each do |name, data|
#       sorted_cart.has_key?(name) ? sorted_cart[name][:count] += 1 : sorted_cart[name] = {:count => 1}
#       data.each { |attrb, info| sorted_cart[name][attrb] = info }
#     end
#   end
#   sorted_cart
# end
#
# def apply_coupons(cart:[], coupons:[])
#   coupons.each do |coupon|
#     name = coupon[:item]
#     if cart.has_key?(name) && cart[name][:count] >= coupon[:num]
#       cart[name][:count] -= coupon[:num]
#       if cart.has_key?("#{name} W/COUPON") == false
#         cart["#{name} W/COUPON"] = {
#           :price => coupon[:cost],
#           :clearance => cart[name][:clearance],
#           :count => 1
#         }
#       else
#         cart["#{name} W/COUPON"][:count] += 1
#       end
#     end
#   end
#   cart
# end
#
# def apply_clearance(cart:[])
#   cart.keys.each do |item|
#     cart[item][:price] -= cart[item][:price] * 0.2 if cart[item][:clearance]
#   end
#   cart
# end
#
# def checkout(cart: [], coupons: [])
#   sorted_cart = consolidate_cart(cart: cart)
#   apply_coupons(cart: sorted_cart, coupons: coupons)
#   apply_clearance(cart: sorted_cart)
#   cart_total = 0.0
#   sorted_cart.keys.each do |item|
#     cart_total += sorted_cart[item][:price] * sorted_cart[item][:count]
#   end
#   if cart_total > 100
#     cart_total -= cart_total * 0.1
#   end
#   cart_total
# end
#
