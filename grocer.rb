

require 'pry'
def consolidate_cart(cart:[])
  # code 
  new_hash = {}
  cart.each do |hash|
    hash.each do |food, info|
      new_hash[food] = info
        new_hash[food][:count] ||= 0
        #binding.pry
        if new_hash.has_key?(food)
          new_hash[food][:count] += 1
        end      
    end
  end  
  new_hash     
end


def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |food, info|
    if info[:clearance] == true
      new_price = info[:price] * 0.80 
      info[:price] = new_price.round(2)    
    end
  end
  cart          
end

def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart)
  with_coupons = apply_coupons(cart: consolidated, coupons: coupons)
  with_clearance = apply_clearance(cart: with_coupons)
 
  total = 0
 
   with_clearance.values.each do |data|
    total += (data[:price] * data[:count])
   end
 
   total > 100 ? (total * 0.90) : total
 
end


