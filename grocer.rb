require 'pry'

def consolidate_cart(cart:[])
  consolidated = {}
  holding_cart = []

  cart.collect do |item_hash|
    item_hash.collect do |item_name, item_data|
      holding_cart << item_name  #add the items to the shopping cart to be counted later

      item_data.each do |attribute, attribute_value|
        consolidated[item_name] = {:price => nil, :clearance => nil, :count => nil}
        # New Hash Structure established
      end

      item_data.each do |attribute, attribute_value|
        if attribute == :price
          consolidated[item_name][:price] = attribute_value
        end
        if attribute == :clearance
          consolidated[item_name][:clearance] = attribute_value
        end
        holding_cart.collect do |item|
          consolidated[item][:count] = holding_cart.count(item)
        end
      end
    end
  end
  consolidated
  #binding.pry
end


def apply_coupons(cart:[], coupons:[])
  coupon_book = []
  coupons.each do |coupon|
    coupon.each do |item_category, item_data|
      coupon_book << item_data   #add the coupon name to be counted later
      if item_category == :item && cart.include?(item_data)
        #binding.pry
        cart["#{item_data} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item_data][:clearance], :count => coupon_book.count(item_data)}
        if coupon[:num] <= cart[item_data][:count]
          cart[item_data][:count] = cart[item_data][:count] - coupon[:num]
        end
      else
        cart
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  # code here
  cart.collect do |item_name, item_data|
    if cart[item_name][:clearance] == true
      cart[item_name][:price] = (cart[item_name][:price] * 0.8).round(1)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart)

  coupons_applied = apply_coupons(cart: consolidated, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  final_price_array = []
  final_price = nil

  clearance_applied.each do |item, data|
    if data[:count] > 0 
      if item.include?("W/COUPON")
        final_price_array << data[:price]
      else
        final_price_array << data[:price] * data[:count]
      end
    end
    #binding.pry
  end

  final_price = final_price_array.inject(:+)
  if final_price > 100
    final_price = final_price * 0.9
  end
  final_price
  #binding.pry
end





