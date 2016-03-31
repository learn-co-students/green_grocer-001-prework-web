def consolidate_cart(cart:[])
  # code here
  final_cart = {}

  cart.each do |scan|
    scan.each do |item, info|
      if final_cart.keys.include?(item) == false
        final_cart[item] = info
        final_cart[item][:count] = 1
      else
        count = final_cart[item][:count] + 1
        final_cart[item][:count] = count
      end
    end
  end
  # puts "DEBUG consolidate_cart: #{final_cart}"
  final_cart
end

def apply_coupons(cart:[], coupons:[])
  # code here
  final_cart = cart.clone
  coupon_list = []

  # DEBUG
  # if final_cart.keys.include?("AVOCADO")
  #   puts "DEBUG avocado count before: #{final_cart["AVOCADO"][:count]}"
  #   puts "DEBUG cart: #{cart}"
  #   puts "DEBUG coupons: #{coupons}"
  # end

  # cycle through the items in the cart
  cart.each do |cart_key, cart_value |
    # cycle through the coupons
    coupons.each do |coupon_hash|
      # check to see if the coupon applies to the item in the cart
      if coupon_hash[:item] == cart_key
        # check the count
        ## if coupon amount is less than what's in the cart
        if (coupon_hash[:num] <= cart_value[:count])
          # create key w/coupon w/info from item in cart
          item = coupon_hash[:item].dup
          item << " W/COUPON"
          if final_cart.keys.include?(item)
            final_cart[item][:count] += 1
          else
            final_cart[item] = cart_value.dup
            final_cart[item][:price] = coupon_hash[:cost]
            final_cart[item][:count] = 1
          end
          # subtract the amount from the original item
          final_cart[cart_key][:count] = cart_value[:count] - coupon_hash[:num]
        end
      end
    end
  end
  # DEBUG
  # puts "DEBUG contents of final hash: #{final_cart}"
  # if final_cart.keys.include?("AVOCADO")
  #   puts "DEBUG avocado count after: #{final_cart["AVOCADO"][:count]}"
  #   puts "DEBUG final cart: #{final_cart}"
  # end
  final_cart
end

def apply_clearance(cart:[])
  # code here
  # puts "DEBUG: cart input: #{cart}"
  cart.each do |item, values|
    if values[:clearance]
      base_price = values[:price]
      values[:price] = base_price * 8 / 10.0
    end
  end
end

def checkout(cart: [], coupons: [])
  # code here
  # DEBUG
  # puts "DEBUG cart: #{cart}"
  # puts "DEBUG coupons: #{coupons}"
  con_cart = consolidate_cart(cart:cart)
  coup_cart = apply_coupons(cart:con_cart, coupons:coupons)
  final_cart = apply_clearance(cart:coup_cart)

  # puts "DEBUG checkout: #{final_cart}"
  total = 0
  final_cart.each do |key, value|
    total += (value[:price] * value[:count])
  end
  if total > 100
    total = total * 9 / 10.0
  end
  total
end


