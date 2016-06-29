require "pry"

def consolidate_cart(cart:[])
  consolidated_cart = {}

  #iterate over each item in the cart
  cart.each do |item|
    item.each do |name, attributes|
      #add the item count to each item
      count = cart.count(item)
      attributes[:count] = count
    end
    #add the changed items to the cart
    consolidated_cart.merge!(item)
  end
  
  consolidated_cart
end


def apply_coupons(cart:[], coupons:[])

  cart_with_coupons = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc) }

  cart.each do |item, attributes|
    coupons.uniq.each do |item_coupon|

      #if there is a coupon for the item
      if item_coupon[:item] == item 

        #adds couponed item to updated cart
        cart_with_coupons["#{item} W/COUPON"][:price] = item_coupon[:cost]
        cart_with_coupons["#{item} W/COUPON"][:clearance] = attributes[:clearance]

        #calculates number of items in coupons
        number_of_coupons = coupons.count(item_coupon)
        items_in_coupons = number_of_coupons * item_coupon[:num]
        
        #if all coupons can be applied
        if attributes[:count] >= items_in_coupons
          attributes[:count] = attributes[:count] - items_in_coupons
          cart_with_coupons["#{item} W/COUPON"][:count] = number_of_coupons
        
        #if there are more coupons than can be applied
        else
          #checks how many items can be discounted and updates hash with discounted items
          allowed_coupons = (items_in_coupons/ attributes[:count]).to_i
          cart_with_coupons["#{item} W/COUPON"][:count] = allowed_coupons

          #removes discounted items
          allowed_coupon_items = allowed_coupons * item_coupon[:num]
          attributes[:count] = attributes[:count] - allowed_coupon_items

        end
      end
    end
  end

  #combines original cart with cart of couponed items
  cart_with_coupons = cart.merge(cart_with_coupons)

end


def apply_clearance(cart:[])
  #gives a 20% discount if the item is on clearance
  cart.each do |item, attributes|
    if attributes[:clearance] == true
      attributes[:price] = (attributes[:price] * 80) / 100
    end
  end
end

def checkout(cart: [], coupons: [])

  consolidated_cart = consolidate_cart(cart: cart)

  couponed_cart = apply_coupons(cart: consolidated_cart, coupons: coupons)

  final_cart = apply_clearance(cart: couponed_cart)

  total_cost = 0.0

  final_cart.each do |item, attributes|
    total_cost += attributes[:price] * attributes[:count]
  end

  if total_cost > 100
    total_cost = total_cost * 90/100
  end

  return total_cost
end


