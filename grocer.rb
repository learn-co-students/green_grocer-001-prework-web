def consolidate_cart(cart:[])
  # code here
   consolidated = {}
 
   cart.each do |item|
     item.each do |k, v|
       if consolidated.include?(k)
         consolidated[k][:count] += 1
       else
         consolidated[k] = v
         consolidated[k][:count] = 1
       end
     end
   end
   consolidated
end

def apply_coupons(cart:[], coupons:[])
  # reiterate through coupons 1 by 1
   coupons.each do |coupon,data|
   #Let's jot down the current item
    item = coupon[:item]
  #Check if we have an item in the cart 
  #that matches a coupon
  if cart.has_key?(item)
    #Coupons are for a specific quanity 
    #so see if we have the right #
  if cart[item][:count] >= coupon[:num]
#If coupon qualifies we need to adjust the cart
#Will have two cases one where # of items is exact
#in this case the old item is deleted and item with coupon
#is added in other case we have more items than is on the coupon
#and we have to add new item and reduce quantity of old
 new_item = item + " W/COUPON"
  if cart.has_key?(new_item)
  cart[new_item][:count] += 1
  else
 cart[new_item] = {:price => coupon[:cost],
  :clearance => cart[item][:clearance],
  :count => 1}
end 
cart[item][:count] -= coupon[:num]
end 
end
end 
cart
end
def apply_clearance(cart:[])
  # code here
  cart.each do |item,data|
     if(data[:clearance] == true)
       data[:price] = (data[:price]*0.80).round(2)
     end
   end
end

def checkout(cart: [], coupons: [])
  # code here
first = consolidate_cart(cart:cart)
 subtotal = 0
 total = 0
second = apply_coupons(cart:first, coupons:coupons)
third = apply_clearance(cart:second)
third.each do |item, stats|
total += (stats[:price] * stats[:count])
   end
   if total > 100
     total = total * 0.9
   end
   total
 end










