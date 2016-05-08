require 'pry'
def consolidate_cart(cart:[])
  # code here
  new_cart = {}
  cart.each { |item|
    if new_cart.keys.include?(item.keys[0])
      new_cart[item.keys[0]][:count] += 1
    else
      item.values[0][:count] = 1
      new_cart[item.keys[0]] = item.values[0]
    end
  }
  new_cart
end

def apply_coupons(cart:[], coupons:[])
  # code here
  new_items = {}
  coupons.each { |coupon|
    cart.collect { |k, v|
      if k == coupon[:item] && v[:count] >= 2
        v[:count] -= coupon[:num]

        coupon_item = "#{k} W/COUPON"
        if new_items.keys.include?(coupon_item)
          new_items[coupon_item][:count] += 1
        else
          new_items[coupon_item] = {
            :price => coupon[:cost],
            :clearance => v[:clearance],
            :count => 1
          }
        end
      end
    }
  }
  cart.merge(new_items)
end

def apply_clearance(cart:[])
  # code here
  cart.collect { |k, v|
    v[:price] = (v[:price] * 0.80).round(2) if v[:clearance] == true
  }
  cart
end

def checkout(cart: [], coupons: [])
  # code here
  # binding.pry
  new_cart = consolidate_cart(cart:cart)
  check_out = apply_coupons(cart: new_cart, coupons: coupons)
  check_out = apply_clearance(cart: check_out)

  total = 0
  check_out.each { |k, v|
    total += v[:price] * v[:count]
  }

  total > 100 ? total = total * 0.90 : total

end
