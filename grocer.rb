require 'pry'

def consolidate_cart(cart:[])
  consolidated_cart = {}
  cart.each do |cart_item|
    item_count = 0
    cart_item.each do |product,attributes|
      if consolidated_cart.include?(product) == false
        item_count = 1
        attributes[:count] = item_count
        consolidated_cart[product] = attributes
      else
        consolidated_cart[product][:count] += 1
      end
    end
  end
  consolidated_cart
end


#consolidate_cart(cart:[      
# {"AVOCADO" => {:price => 3.00, :clearance => true}},
#  {"AVOCADO" => {:price => 3.00, :clearance => true}},
#  {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},])

def apply_coupons(cart:[], coupons:[])
  cart_hash = cart
  coupons.each do |coupon|
    if cart_hash.include?(coupon[:item] + " W/COUPON") == false
      if cart_hash.include?(coupon[:item])
        if cart_hash[coupon[:item]][:count] - coupon[:num] > -1
          cart_hash[coupon[:item]][:count] -= coupon[:num]
          cart_hash[coupon[:item] + " W/COUPON"] = {:price => coupon[:cost], :clearance => cart_hash[coupon[:item]][:clearance], :count => 1}
        end
      
  #      if cart_hash[coupon[:item]][:count] == 0
  #        cart_hash.delete(coupon[:item])
  #      end
      end
    else
      if cart_hash[coupon[:item]][:count] - coupon[:num] > -1
        cart_hash[coupon[:item]][:count] -= coupon[:num]
        cart_hash[coupon[:item] + " W/COUPON"][:count] += 1
      end
    end
  end
  cart_hash
end

#apply_coupons(cart: {
#  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
#  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
#  }], coupons: [{:item => "AVOCADO", :num => 2, :cost => 5.0})

def apply_clearance(cart:[])
  cart_hash = cart
  cart_hash.each do |product, attributes|
    if attributes[:clearance] == true
      attributes[:price] = (attributes[:price] * 0.80).round(2)
    end
  end
  cart_hash
end

#apply_clearance(cart: [{
#  "PEANUTBUTTER" => {:price => 3.00, :clearance => true,  :count => 2},
#  "KALE"         => {:price => 3.00, :clearance => false, :count => 3},
#  "SOY MILK"     => {:price => 4.50, :clearance => true,  :count => 1}
#}])

def checkout(cart: [], coupons: [])
  cart_hash = consolidate_cart(cart: cart)
  apply_coupons(cart: cart_hash, coupons: coupons)
  apply_clearance(cart: cart_hash)
  cart_total = 0.00
  cart_hash.each do |product, attributes|
    cart_total += (attributes[:price] * attributes[:count])
  end
  if cart_total > 100
    cart_total = (cart_total * 0.90).round(2)
  end
  cart_total
end

#checkout(cart: [{
#  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
#  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
#  }], coupons: [{:item => "AVOCADO", :num => 2, :cost => 5.0}])







