def consolidate_cart(cart: [])
consolidated_hash = {}

cart.each {|item_hash|
  consolidated_hash.merge!(item_hash)}

consolidated_hash.each {|name, info|
    info.merge!(count: 0)}

consolidated_hash.each {|name, info|
  info.each {|key, value|
    if key == :count
      cart.each {|item_hash|
        item_hash.each {|old_name, old_info|
          if old_name == name
            info[key] += 1
          end}}
        end}}
consolidated_hash
end

def apply_coupons(cart:[], coupons:[])
discounts_applied = Hash.new 
discounts_applied.merge!(cart)

#creates new temp hash for coupons
valid_coupon_hash = Hash.new
discounts_applied.each {|item_name, item_hash|
  coupons.each {|coupon|
        coupon.each {|coupon_key, coupon_value|
          if coupon_key == :item && coupon_value == item_name
             valid_coupon_hash[coupon_value] = {}
          end}}}

#adds price status to coupon eligible items
valid_coupon_hash.each {|new_item_name, new_item_hash|
coupons.each {|coupon|
coupon.each {|coupon_key, coupon_value|
  if coupon_key == :item && coupon_value == new_item_name
      coupon.each {|coupon_key, coupon_value| 
    if coupon_key == :cost
      discount_cost = coupon[coupon_key]
          new_item_hash[:price] = discount_cost
      end}
  end}}}

#adds clearance status to coupon eligible items
valid_coupon_hash.each {|new_item_name, new_item_hash|
  discounts_applied.each {|item_name, item_hash|
    if new_item_name == item_name
      item_hash.each {|key, value|
        if key == :clearance && value == true
          new_item_hash[:clearance] = true
        elsif key == :clearance && value == false
          new_item_hash[:clearance] = false
    end}
  end}}

#adds quantity to coupon eligible items - 1) moves quantity to new hash 2) adjusts quantity in the new hash
coupons.each {|coupon|
    coupon.each {|coupon_key, coupon_value|
        valid_coupon_hash.each {|new_item_name, new_item_hash| 
            if coupon_key == :item && coupon_value == new_item_name
            num = coupon[:num]
            new_item_hash[:count] = num
          end}}}

valid_coupon_hash.each {|new_item_name, new_item_hash|
  discounts_applied.each {|item_name, item_hash|
    if item_name == new_item_name && item_hash[:count] >= new_item_hash[:count]
        new_num = (item_hash[:count]/new_item_hash[:count]).to_f.to_i
        new_item_hash[:count] = new_num
          end}}

#adjusts item count quanitity for regularly priced items
discounts_applied.each {|item_name, item_hash|
  coupons.each {|coupon|
      if item_name == coupon[:item] && item_hash[:count] >= coupon[:num]
      num = coupon[:num]
      new_num = item_hash[:count] % num 
        item_hash[:count] = new_num
          end}}

#merges regularly priced items with coupon priced items 
valid_coupon_hash.each {|new_item_name, new_item_hash|
  discounts_applied.merge!("#{new_item_name} W/COUPON" => new_item_hash)}

discounts_applied
end

def apply_clearance(cart: [])
  clearance_applied = Hash.new
  clearance_applied.merge!(cart)
  
  clearance_applied.each {|item_name, item_hash|
    new_value = ""
    if item_hash[:clearance] == true
      adjusted = (item_hash[:price]*0.8).to_s
      num = 0
      while num < adjusted.length
        new_value << adjusted[num]
        if adjusted[num - 1] == "."
          break
        end
        num += 1
      end
      item_hash[:price] = new_value.to_f.round(1)
    end}
clearance_applied
end



def checkout(cart: [], coupons: [])
consolidated_cart = consolidate_cart(cart: cart)
applied_coupons = apply_coupons(cart: consolidated_cart, coupons: coupons)
applied_clearance = apply_clearance(cart: applied_coupons)

total = 0

prices = Array.new
applied_clearance.each {|item, item_hash|
  prices << item_hash[:price]*item_hash[:count]}

item_price = 0
while item_price < prices.length
  total += prices[item_price] 
  item_price += 1
end

if total >= 100
  total *= 0.9
end

total

end
