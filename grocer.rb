require 'pry'

def consolidate_cart(cart:[])
  # take in cart array that is then assigned to cart
  consolidated = {}
  # if item exits in cart, increment it's count object
  cart.each do |hash|
    hash.each do |item, data|
      if consolidated.include?(item)
        consolidated[item][:count] += 1
  # else push item into new hash with count object
      else
        consolidated.merge!(item => data.merge!(count: 1))
      end
    end
  end
  consolidated
end




def apply_coupons(cart:[], coupons:[])
  return cart if coupons == []
  new_cart = {}
  coupons.each do |coupon|
    cart.each do |item, data|
      if item == coupon[:item] && data[:count] >= coupon[:num]
        new_cart.merge!("#{item} W/COUPON" => {:price => coupon[:cost], :clearance => data[:clearance], :count => 0})     
        while data[:count] >= coupon[:num]
          data[:count] -= coupon[:num]
          new_cart["#{item} W/COUPON"][:count] += 1        
        end
      end
      new_cart.merge!(item => data) 
    end
  end 
  new_cart
end

def apply_clearance(cart:[])
  cart.each do |item, data|
    cart[item][:price] = (data[:price] * 0.8).round(2) if data[:clearance] == true
  end
  cart
end

def checkout(cart: [], coupons: [])
  total = 0
  final_cart = apply_clearance(cart:apply_coupons(cart:consolidate_cart(cart:cart), coupons:coupons))
  final_cart.each do |item, data|
    data[:count].times do 
      total += data[:price]
    end
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end