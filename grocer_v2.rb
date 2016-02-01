  consolidated_cart = consolidate_cart(cart)
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