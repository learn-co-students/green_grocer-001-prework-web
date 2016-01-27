def consolidate_cart(cart:[])
# hash to count items and hash to hold consolidated cart
old_cart = Hash.new 0
consolidated_cart = Hash.new 0

  # count every item and add to hash
  cart.each { |item_detail| old_cart[item_detail] += 1 }

  # add the count to the item specs
  old_cart.keys.each do |key|
    key.each do |food, specs|
    specs[:count] = old_cart[key]

    # add food and specs to new consolidated cart
    consolidated_cart[food] = specs
    end
  end
  consolidated_cart
end


def apply_coupons(cart:[], coupons:[])
  couponed_cart = {}

  cart.each do |grocery, grocery_i|
    coupons.each do |coupon|
      if coupon[:item] == grocery
        coupon_count = coupon[:num]
        item_count = grocery_i[:count]
        regular_count = grocery_i[:count]
        bundle_count = 0
        while item_count > 0 && item_count >= coupon[:num]
          couponed_cart["#{grocery} W/COUPON"] = {:price=>coupon[:cost], :clearance=>grocery_i[:clearance], :count=>bundle_count += 1}
          regular_count = grocery_i[:count] - (coupon[:num] * bundle_count)
          item_count -= coupon_count
        end
        if regular_count >= 0
          couponed_cart["#{grocery}"] = {:price=>grocery_i[:price], :clearance=>grocery_i[:clearance], :count=>regular_count}
        end
      end
    end
    if !couponed_cart["#{grocery}"] && !couponed_cart["#{grocery} W/COUPON"]
      couponed_cart["#{grocery}"] = grocery_i
    end
  end
  couponed_cart
end


def apply_clearance(cart:[])
  cart.each do |key, value|
    # if item is on clearance, apply discount
    if value[:clearance]
      value[:price] -= (value[:price] * 0.2)
    end
  end
  cart
end


def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart)
  couponed = apply_coupons(cart: consolidated, coupons: coupons)
  clearanced = apply_clearance(cart: couponed)
  total = 0
  clearanced.each do |item, data|
    total += data[:price] * data[:count]
  end

  if total > 100
    total -= (total * 0.1)
  end
  total
end
