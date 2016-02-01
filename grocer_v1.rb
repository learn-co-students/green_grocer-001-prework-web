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
  consolidated_cart = cart
  discounts = Hash.new(0)
  left_over_items = Hash.new(0)
  
  
  coupons.each do |coupon_name|
    consolidated_cart.each do |item, properties|
        
      remainder_count = properties[:count]%coupon_name[:num]
      coupon_count = properties[:count].divmod(coupon_name[:num])[0]
      coupon_cost = coupon_name[:cost]
      original_price = properties[:price]
      
      if coupon_name[:item] == item
          
          discounts["#{item} W/COUPON"] = {}
          discounts["#{item} W/COUPON"][:price] = coupon_cost
          discounts["#{item} W/COUPON"][:clearance] = properties[:clearance]
          discounts["#{item} W/COUPON"][:count] = coupon_count
          properties[:count] = remainder_count
        end
      end
    end

    
  all_items_and_discounts = discounts.merge(consolidated_cart)
  all_items_and_discounts.delete_if {|key, value| value[:count] <= 0 }
end

end


def apply_clearance(cart:[])
  # code here
end

def checkout(cart: [], coupons: [])
  # code here
end