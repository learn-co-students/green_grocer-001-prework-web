require 'pry'
def consolidate_cart(cart:[])
  new_cart = {}
  cart.each do |hash|
    hash.each do |food, info|
      new_cart[food] = info
      new_cart[food][:count] ||= 0
      new_cart[food][:count] += 1
    end  
  end     
  new_cart       
end


def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1

    else # if more items than coupon allows
      cart["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => true, :count => 1}
      cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
    end
  cart[name][:count] -= coupon[:num]
  end 
end
  cart    
end

def apply_clearance(cart:[])
  cart.each do |food, info|
    if cart[food][:clearance] == true
      new_price = info[:price] * 0.80
      info[:price] = new_price.round(2)
    end  
  end  
  cart     
end

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(cart: cart) 
  coupons_applied = apply_coupons(cart: consolidated_cart, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  total = 0
  
  clearance_applied.each do |food, info|
    total += info[:price]*info[:count]
  end
  if total > 100
    total*0.90
  else
    total  
  end    

end


