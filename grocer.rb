# The cart starts as an array of individual items.
# Translate into a hash that includes counts for each item w/ the consolidate_cart method.
def consolidate_cart(cart:[])
  count_hash = {}
  count_updated = false

  cart.each do |item|
  count_updated = false
    item.each do |food_str, value_hash|
    	if count_hash.empty?
    		new_hash = value_hash.merge(count: 1)
    		count_hash[food_str] = new_hash
    	else
	    	if count_hash.has_key?(food_str)
	    		count_hash[food_str][:count] += 1
	    		count_updated = true
	    	else
	    		if count_updated == false
		    		new_hash = value_hash.merge(count: 1)
		    		count_hash[food_str] = new_hash
		    	end
		    end
    	end
    end
  end
  return count_hash
end


def apply_coupons(cart:[], coupons:[])
  couponed_cart = {}

  cart.each do |vegetable_str, attributes_hash|
    coupon_key_array = []

    coupons.each do |new_key_to_add|
      coupon_key_array << new_key_to_add[:item]
    end

    if coupon_key_array.include?(vegetable_str)
      coupon_count ||= 0

      coupons.each do |coupon_item|

        # this if statement checks if the vegetable in cart has a coupon associated with it
        if vegetable_str == coupon_item[:item]

          # the case below is if the count in cart is greater or equal to coupon count

          if cart[vegetable_str][:count] >= coupon_item[:num]

            cart[vegetable_str][:count] = cart[vegetable_str][:count] - coupon_item[:num]

            temp_hash = { vegetable_str + " W/COUPON" => {:price => coupon_item[:cost],
              :clearance => cart[vegetable_str][:clearance],
              :count => coupon_count += 1}
            }
            couponed_cart.merge!(temp_hash)

            if cart[vegetable_str][:count] >= 0
              temp_hash = { vegetable_str => {:price => cart[vegetable_str][:price],
                :clearance => cart[vegetable_str][:clearance],
                :count => cart[vegetable_str][:count]}
              }
              couponed_cart.merge!(temp_hash)
            end
          end
        end
      end
    else
      temp_hash = {vegetable_str => {:price => cart[vegetable_str][:price],
        :clearance => cart[vegetable_str][:clearance],
        :count => cart[vegetable_str][:count]}
      }
      couponed_cart.merge!(temp_hash)
    end
  end
  return couponed_cart
end

def apply_clearance(cart:[])
  cart.each do |vegetable_str, veg_hash|
    if cart[vegetable_str][:clearance]
      cart[vegetable_str][:price] = (cart[vegetable_str][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])

  final_cart = {}

  cart = consolidate_cart(cart: cart)

  cart = apply_coupons(cart: cart, coupons: coupons)

  cart = apply_clearance(cart: cart)

  total = 0

  cart.each do |vegetable_str, veg_hash|
    total = total + (cart[vegetable_str][:price] * cart[vegetable_str][:count])
  end

  if total > 100
    total = (total * 0.9).round(2)
  end

  return total
end
