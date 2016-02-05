require 'pry'
##### Core Methods #####

def consolidate_cart(cart:[])
  uniq_cart = uniq_cart(cart)
  item_w_count = get_counts(cart)
  item_w_count.keys.each_with_object({}) do |item_name, consolidated|
    consolidated[item_name] = uniq_cart.fetch(item_name).merge(count: item_w_count[item_name])
  end
end

def apply_coupons(cart:[], coupons:[])
  coupons.each_with_object(cart) do |coupon, cart_w_coupons|
    cart_w_coupons = apply_coupon(coupon, cart_w_coupons) if cart_w_coupons.keys.include?(coupon.fetch(:item))
  end
end

def apply_clearance(cart:[])
  cart.each do |item, info|
    cart[item][:price] = calc_clearance(info) if info[:clearance] == true
  end
  cart
end

def checkout(cart:[], coupons:[])
  cart = consolidate_cart(cart: cart)
  apply_coupons(cart:cart, coupons:coupons)
  apply_clearance(cart: cart)
  calc_total(cart)
end

##### Helper Methods #####

###consolidate_cart helpers###
def uniq_cart(cart)
  cart.each_with_object({}) do |item, uniq_hash|
    uniq_hash[item.keys.first] = item.values.first
  end
end

def get_counts(cart)
  cart.each_with_object({}) do |item, item_counts|
    item_counts.has_key?(item.flatten[0]) ? item_counts[item.flatten[0]] += 1 : item_counts[item.flatten[0]]=1
  end
end

###apply_coupons helpers###
def apply_coupon(coupon, cart)
  return cart if !can_apply_coupon?(coupon,cart)
  has_item_w_coupon?(coupon,cart) ? increment_coupon_count(coupon, cart) : add_item_w_coupon(coupon, cart)
end

def can_apply_coupon?(coupon, cart)
  cart.fetch(coupon.fetch(:item)).fetch(:count) >= coupon.fetch(:num)
end

def has_item_w_coupon?(coupon, cart)
  cart.key?("#{coupon.fetch(:item)} W/COUPON")
end

def increment_coupon_count (coupon, cart)
  cart[coupon.fetch(:item)][:count] -= coupon.fetch(:num)
  cart["#{coupon.fetch(:item)} W/COUPON"][:count] += 1
  cart
end

def add_item_w_coupon(coupon, cart)
  cart["#{coupon.fetch(:item)} W/COUPON"] = cart.fetch(coupon.fetch(:item)).clone
  cart[coupon.fetch(:item)][:count] -= coupon.fetch(:num)
  cart["#{coupon.fetch(:item)} W/COUPON"][:count] = 1
  cart["#{coupon.fetch(:item)} W/COUPON"][:price] = coupon.fetch(:cost)
  cart
end

###apply_clearance helper###
def calc_clearance(info)
  (info[:price] * 0.80 * 100).round/100.0
end

###checkout helper###
def calc_total(cart)
  total = 0
  cart.each do |item, info|
    total += info[:price] * info[:count]
  end
  total > 100 ? (total * 0.9) : total
end