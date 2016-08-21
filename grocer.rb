

def consolidate_cart(cart:[])

  new_hash = {}
  cart.each do |elem_hash|
    elem_hash.each do |fruit_key, value_hash|
    
      new_hash[fruit_key] ||= {} 
      new_hash[fruit_key][:count]||=0
      new_hash[fruit_key][:count]+=1
        value_hash.each do |k,v|
          new_hash[fruit_key][k] = v
        end
    end
  end
new_hash
end
###############- best one so far below

# def apply_coupons(cart:[], coupons:[])
#   value = 0
#  coupons.each do |coup_hash|
#     fruit = coup_hash[:item]

#   if cart[fruit] #&& cart[fruit][:count] >= coup_hash[:num ]#&& coup_hash[:num] < cart[fruit][:count] #if cart[fruit] exists.. or the key "fruit" is included in cart,then coupon is applicable
#     cart[fruit][:count] -= coup_hash[:num] #correct the:count
#     cart["#{fruit} W/COUPON"] ||= {}
#     cart["#{fruit} W/COUPON"] = {:price => coup_hash[:cost], :clearance => cart[fruit][:clearance]}


#     if cart[fruit][:count] >= coup_hash[:num]
#       value +=1
#       cart["#{fruit} W/COUPON"][:count] ||= value
      
#     else
#       cart["#{fruit} W/COUPON"][:count] = 1
#     end

#     cart["#{fruit} W/COUPON"][:count] ||=0



#   end  
#  end
# cart
# end

#----------------------------------------------------#############################################

# def apply_coupon(cart, coupons)
#   new_key_coupon = ""
#   new_hash = {}

#   cart.each do |fruit_key, hash_value| ##"AVOCADO,"KALE"|| {:price => 3.0, :clearance => true. :count =>3}
#     new_hash[fruit_key] = hash_value

    
#     if fruit_key == coupons[:item]
    
#         new_hash[fruit_key][:count] -= coupons[:num] #change in count

#           new_key_coupon = fruit_key.to_s + " " + "W/COUPON"  #"AVOCADO W/ COUPON"
          
#           new_hash[new_key_coupon] ||= {}
#           new_hash[new_key_coupon][:price] = coupons[:cost]
#           new_hash[new_key_coupon][:clearance] = cart[fruit_key][:clearance]
#           new_hash[new_key_coupon][:count] = 1  #count will always be 1
#     end
#   end
#   new_hash
# end
#-----------works when 2 arguments aren simple hashes and not "cart:[], coupons: []". ---------------#

def apply_coupons(cart:[], coupons:[])
  value = 0
  coupons.each do |coup_hash|
  fruit = coup_hash[:item]

  if cart[fruit] && cart[fruit][:count] >= coup_hash[:num]

    coupons_used = cart[fruit][:count] / coup_hash[:num]
    uncouponed_fruits = cart[fruit][:count] % coup_hash[:num]
    
    cart["#{fruit} W/COUPON"] ||= {}
    cart["#{fruit} W/COUPON"] = {:price => coup_hash[:cost], :clearance => cart[fruit][:clearance], :count => coupons_used}
    cart[fruit][:count] = uncouponed_fruits #correct the:count (remove the applicable numbr of fruits by the coupon)
  end 
 end
cart
end



def apply_clearance(cart:[])
 cart.map do |food, hash|
  if hash[:clearance] == true
  hash.map do |category, value|
    if category == :price
      cart[food][category] = ((value * 0.8)*100).round/100.00
    end
  end
 end
end
 p cart
end

def checkout(cart: [], coupons: [])
  
  total = 0
  con_cart = consolidate_cart(cart: cart)
  coup_cart = apply_coupons(cart: con_cart,coupons: coupons) 
  cleared_cart = apply_clearance(cart: coup_cart)

  cleared_cart.each do |food, hash|
      cost = hash[:count] * hash[:price]
      total += cost
  end


  if total > 100
    total = (total * 0.9).round(2)
  else
    total
  end
total

end