require 'pry'

# Used the solution from Learn Github to get this passing. will come back and work on commented code later

# def consolidate_cart(cart:[])
#   item_count = Hash.new(0)
#   consolidated_cart = Hash.new(0)

#   cart.each do |item|
#     item_count[item] += 1
#   end
  
#   count_adder = item_count.each do |k, v|
#       k.each do |k2, v2|
#         k.each do |k3,v3|
#           v3[:count] = v
#         consolidated_cart[k2] = v3
#         end
#       end
#   end
  
#   consolidated_cart
# end

def consolidate_cart(cart:[])
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        result[type] = attributes
      end
    end
  end
end
  

# def apply_coupons(cart:[], coupons:[])
#   discounts = Hash.new(0)
  
#   coupons.each do |coupon|
#     cart.each do |item, properties|
        
#       remainder_count = properties[:count]%coupon[:num]
#       coupon_count = properties[:count].divmod(coupon[:num])[0]
#       coupon_cost = coupon[:cost]
#       original_price = properties[:price]

#       if coupon[:item] == item
#           discounts["#{item} W/COUPON"] = {price: coupon_cost, clearance: properties[:clearance], count: coupon_count}
#           properties[:count] = remainder_count  
#       end  
#     end
#   end  
#   discounts.merge(cart).delete_if {|key, value| value[:count] <= 0 }
# end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart:[])
  cart.each do |item, properties|
    if properties[:clearance]
      properties[:price] = (properties[:price] * 0.80).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(cart: cart)
  couponed_cart = apply_coupons(cart: consolidated_cart, coupons: coupons)
  final_cart = apply_clearance(cart: couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end