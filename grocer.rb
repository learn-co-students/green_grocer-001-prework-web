require 'pry'

def items
  [
    {"AVOCADO" => {:price => 3.00, :clearance => true}},
    {"KALE" => {:price => 3.00, :clearance => false}},
    {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
    {"ALMONDS" => {:price => 9.00, :clearance => false}},
    {"TEMPEH" => {:price => 3.00, :clearance => true}},
    {"CHEESE" => {:price => 6.50, :clearance => false}},
    {"BEER" => {:price => 13.00, :clearance => false}},
    {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
    {"BEETS" => {:price => 2.50, :clearance => false}}
  ]
end

def consolidate_cart(cart:[])
  cart.each_with_object({}) do |product, consolidate| #consolidate is the new hash using each_with_object
    product.each do |key, value|
      if consolidate.has_key?(key)
      consolidate[key][:count] +=1 #increase count if theres duplicates?.. 
      else
        consolidate[key] = value
        consolidate[key][:count] = 1
       end
    end
  end
end


def apply_coupons(cart:[], coupons:[])
      coupons.each do |coupon|
          coupon_name = coupon[:item] + " W/COUPON"
          if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
            cart[coupon[:item]][:count]-= coupon[:num]
          if cart[coupon_name]
            cart[coupon_name][:count] += 1
          else 
            cart[coupon_name] = {}
            cart[coupon_name][:price] = coupon[:cost]
            cart[coupon_name][:clearance] = cart[coupon[:item]][:clearance]
            cart[coupon_name][:count] = 1
           end
         end
      end
    cart
end

def apply_clearance(cart:[])
    cart.each do |product, info|
      if cart[product][:clearance] == true
        cart[product][:price] = ((cart[product][:price])*0.8).round(1)
      end
    end
end

def checkout(cart: [], coupons: [])
  shop = consolidate_cart(cart: cart)
  coup = apply_coupons(cart: shop, coupons: coupons)
  clear = apply_clearance(cart: coup)

  total = 0

  clear.each do |product, info|
    total += clear[product][:price] * clear[product][:count]
  end

  if total > 100
      total = total * 0.9
  end
  
total

end
