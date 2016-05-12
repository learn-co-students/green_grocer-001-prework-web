require "pry"
def consolidate_cart(cart:[])
  consolidated_cart = {}
  cart.each do |item|
    item.each do |key, value_hash|
      if consolidated_cart.has_key?(key)
        consolidated_cart[key][:count] += 1
      else
        consolidated_cart[key] = value_hash
        consolidated_cart[key][:count] = 1
      end
    end
  end
consolidated_cart
end


def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      if cart.has_key?("#{coupon[:item]} W/COUPON")
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      else
        cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}
      end
      cart[coupon[:item]][:count] -= coupon[:num]
    end
  end
cart
end



def apply_clearance(cart:[])
  cart.each do |item, info_hash|
    if info_hash[:clearance] == true
      info_hash[:price] = (info_hash[:price] * 0.8).round(2) 
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(cart: cart)
  applied_coupons = apply_coupons(cart: consolidated_cart, coupons: coupons)
  applied_clearance = apply_clearance(cart: applied_coupons)
  total = 0
  applied_clearance.each do |item, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end
  if total >= 100
    total = (total * 0.9).round(2)
  end
  total
end












