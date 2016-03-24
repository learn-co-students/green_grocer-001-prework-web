require 'byebug'
def consolidate_cart(cart:[])
  consolidated = {}

  cart.each do |item_hash|
    item_hash.each do |name, attr_hash|
      if consolidated.empty? || consolidated[name].nil?
        consolidated.merge!(item_hash)
        consolidated[name][:count] = 1
      else
        consolidated[name][:count] += 1
      end
    end
  end

  consolidated
end

def apply_coupons(cart:[], coupons:[])
  new_hash = {}

  coupons.each do |coupon_hash|
    coupon_hash.each do |attribute, value|
      if attribute == :item && cart.include?(value)
        item_count = cart[value][:count]
        coupon_num = coupon_hash[:num]

        num_coupons = item_count / coupon_num
        num_of_items = item_count % coupon_num

        old_item_attributes = cart[value]
        ## Add old item and update to correct count
        new_hash.merge!({ value => old_item_attributes.dup })
        new_hash[value][:count] = num_of_items

        ### Add item w/ coupon and update count
        new_hash.merge!({ "#{value} W/COUPON" => old_item_attributes.dup })
        new_hash["#{value} W/COUPON"][:count] = num_coupons
        new_hash["#{value} W/COUPON"][:price] = coupon_hash[:cost]
        break
      end
    end
  end

  cart.merge!(new_hash)

  cart
end

def apply_clearance(cart:[])
  current_price = nil

  cart.each do |item, attr_hash|
    attr_hash.each do |attribute, value|
      current_price = value if attribute == :price
      if attribute == :clearance && value == true
        cart[item][:price] = (current_price - (current_price.to_f * 0.2))
      end
    end
  end

  cart
end

def checkout(cart: [], coupons: [])
  new_cart = consolidate_cart(cart: cart)
  new_cart = apply_coupons(cart: new_cart, coupons: coupons)
  new_cart = apply_clearance(cart: new_cart)

  price = 0

  new_cart.each do |item, attributes_hash|
    unless attributes_hash[:count] == 0
      count = attributes_hash[:count]
      price += (count * attributes_hash[:price])
    end
  end

  price = price - (price * 0.10) if price > 100

  price
end
