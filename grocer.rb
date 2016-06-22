require 'pry'

def consolidate_cart(cart:[])
  # code here
  {}.tap do |consolidated_cart|
    cart.each do |item|
      item.each do |grocery_name,attributes|
        if !consolidated_cart.key?(grocery_name)
          consolidated_cart[grocery_name] = attributes
          consolidated_cart[grocery_name][:count] = 1
        else
          consolidated_cart[grocery_name][:count] += 1
        end
      end
    end    
  end
end

def apply_coupons(cart:[], coupons:[])
  # code here
  {}.tap do |coupons_applied_cart|
    cart.each do |grocery_name,grocery_attributes|
      coupons.each do |coupon|
        if grocery_name == coupon[:item]
          num_of_coupons = grocery_attributes[:count]/coupon[:num]
          if num_of_coupons >= 1
            coupons_applied_cart[grocery_name] = {}
            coupons_applied_cart[grocery_name][:price] = grocery_attributes[:price]
            coupons_applied_cart[grocery_name][:clearance] = grocery_attributes[:clearance]
            coupons_applied_cart[grocery_name][:count] = grocery_attributes[:count] - (coupon[:num]*num_of_coupons)
            coupons_applied_cart["#{grocery_name} W/COUPON"] = {}
            coupons_applied_cart["#{grocery_name} W/COUPON"][:price] = coupon[:cost]
            coupons_applied_cart["#{grocery_name} W/COUPON"][:clearance] = grocery_attributes[:clearance]
            coupons_applied_cart["#{grocery_name} W/COUPON"][:count] = num_of_coupons
          else
            coupons_applied_cart[grocery_name] = grocery_attributes
          end
        elsif !coupons_applied_cart.key?(grocery_name)
          coupons_applied_cart[grocery_name] = grocery_attributes
        end
      end
      if !coupons_applied_cart.key?(grocery_name)
        coupons_applied_cart[grocery_name]= grocery_attributes
      end
    end
  end
end

def apply_clearance(cart:[])
  # code here
  cart.each_value do |grocery_attributes|
    if grocery_attributes[:clearance] == true
      grocery_attributes[:price] -= grocery_attributes[:price]/5
    end
  end
end

def checkout(cart: [], coupons: [])
  # code here
  total = 0
  final_cart = consolidate_cart(cart: cart)
  final_cart = apply_coupons(cart: final_cart, coupons: coupons)
  final_cart = apply_clearance(cart: final_cart)
  final_cart.each_value do |item_info|
    total += item_info[:price]*item_info[:count]
  end
  total > 100 ? total -= total/10 : total
end