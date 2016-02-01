require 'pry'

def consolidate_cart(cart:[])
  item_count = Hash.new(0)
  consolidated_cart = Hash.new(0)

  cart.each do |item|
    item_count[item] += 1
  end
  
  count_adder = item_count.each do |k, v|
      k.each do |k2, v2|
        k.each do |k3,v3|
          v3[:count] = v
        consolidated_cart[k2] = v3
        end
      end
  end
  
  consolidated_cart
end
  

def apply_coupons(cart:[], coupons:[])
  discounts = Hash.new(0)

  
  coupons.each do |coupon|
    item = coupon[:item]
    # cart.each do |item, properties|
        
      remainder_count = cart[item][:count]%coupon[:num]
      coupon_count = cart[item][:count].divmod(coupon[:num])[0]
      coupon_cost = coupon[:cost]
      original_price = cart[item][:price]

      if coupon[:item] == cart[item]
          cart["#{item} W/COUPON"] = {price: coupon_cost, clearance: cart[item][:clearance], count: coupon_count}
          cart[item][:count] = remainder_count  
      end  
    # end
  end  
  discounts.merge(cart).delete_if {|key, value| value[:count] <= 0 }
end


def apply_clearance(cart:[])
  # code here
end

def checkout(cart: [], coupons: [])
  # code here
end