def consolidate_cart(cart: [])
  # code here
  array_groceries = []
  hash_keys = []
  new_hash = {}
  cart.each { |hash|
    hash.each { |item, item_data|
      array_groceries << item
      }
    count = {}
    count.default = 0
    array_groceries.each { |item_name|
      count[item_name] += 1
      }
    hash_keys = array_groceries.uniq
    idx = 0
    hash.each { |item, item_data|
    while idx < array_groceries.size
      if array_groceries[idx] == item
        new_hash[item] = item_data
        new_hash[item][:count] = count[item]
      end
      idx += 1
    end
      }
    }
  new_hash
end

def apply_coupons(cart: {}, coupons: [])
  # code here
  new_hash = {}
  new_hash.default = 0
  coupon_num = {}
  coupon_num.default = 0
  coupons.each { |coupon|
    cart.collect { |item, item_data|
        if item == coupon[:item]
          if item_data[:count] >= coupon[:num]
            coupon_num[item] += 1
            new_hash[item + " W/COUPON"] = {:price => coupon[:cost], :clearance => item_data[:clearance], :count => coupon_num[item]}
            item_data[:count] = item_data[:count] - coupon[:num]
          end
        end
        }
    }
  cart.merge!(new_hash)
end

def apply_clearance(cart: {})
  # code here
  cart.collect { |item, item_data|
    if item_data[:clearance] == true
      item_data[:price] = (item_data[:price] * 0.8).round(2)
    end
    }
  cart
end

def checkout(cart: [], coupons: [])
  # code here
  new_hash = {}
  new_hash.default = 0
  new_hash = apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))
  total = 0
  new_hash.each { |item, item_data|
    if item_data[:count] > 0
      total += (item_data[:price] * item_data[:count])
    end
      }
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end