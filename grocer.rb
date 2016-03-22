require 'pry'


def consolidate_cart(cart:[])
  cartHash = {}

  cart.each do |item|
  #binding.pry
    item.each do |itemName, itemHash|
    #binding.pry

      if !(cartHash.include?(itemName))
        cartHash[itemName] = itemHash         
        cartHash[itemName][:count] = 1      
      
      elsif cartHash.include?(itemName)               
        cartHash[itemName][:count] += 1
      end

    end
  end

  cartHash
end

####

def apply_coupons(cart:[], coupons:[])
  newHash = {}

  cart.each do |item, info|
    coupons.each do |coupon|
      if item == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] = info[:count] - coupon[:num]
        if newHash.keys.include?("#{item} W/COUPON")
          newHash["#{item} W/COUPON"][:count] += 1
        else
          newHash["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
        #binding.pry
      end 
    end
    newHash[item] = info
    #add original item w/ modified count to new hash
  end

  newHash
end

####

def apply_clearance(cart:[])
  cart.each do |item, info|
    #binding.pry
    if info[:clearance] == true then info[:price] = (info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  total = 0
  #keeps track of our total dollar value

  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  cart.each do |item, info|
    total += info[:price] * info[:count]
    #iterate over each item. total = each item total (price * count)
  end

  if total > 100
    total = total * 0.9
  end
  #apply discount to totals > $100
  total
end