def consolidate_cart(cart:[])
  new_hash = {}

  cart.each do |items|

    items.each do |item_name, attributes|
      if new_hash[item_name].nil?

        items[item_name][:count] = 0
        new_hash.merge!(items)

      end

      new_hash[item_name][:count] += 1
    end

  end

  new_hash
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    item_name = coupon[:item]
    coupon_name = "#{item_name} W/COUPON"

    if cart.keys.include?(item_name) && cart[item_name][:count] >= coupon[:num]
      unless cart.keys.include?(coupon_name)
        item_data = { cart: cart, coupon: coupon, coupon_name: coupon_name, 
                      item_name: item_name }

        cart[coupon_name] = construct_coupon(item_data: item_data) 

        cart[item_name][:count] = update_item_count(item_data: item_data)
      end
    end
  end

  cart
end

def construct_coupon(item_data:{})
  cart, coupon, item_name = item_data[:cart], item_data[:coupon], item_data[:item_name]
  new_coupon = {}

  new_coupon[:clearance] = cart[item_name][:clearance]

  new_coupon[:price] = coupon[:cost]

  coupon_count = cart[item_name][:count] / coupon[:num]
  new_coupon[:count] = coupon_count

  new_coupon
end

def update_item_count(item_data:{})
  cart, coupon, coupon_name = item_data[:cart], item_data[:coupon], item_data[:coupon_name]

  cart[coupon[:item]][:count] - coupon[:num] * cart[coupon_name][:count]
end

def apply_clearance(cart:[])
  cart.each do |item_name, attributes|
    if attributes[:clearance] == true

      attributes[:price] = (attributes[:price] * 0.80).round(1)

    end
  end
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  sub_total = 0

  cart.values.each do |attributes|
    sub_total += (attributes[:price] * attributes[:count].to_f)
  end

  if sub_total > 100
    sub_total = sub_total*0.9
  end

  sub_total
end