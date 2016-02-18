require 'pry'
=begin
def consolidate_cart(cart:[])
  # code here
  h = {}
  cart.each do |hashs|
  	hashs.each do |hash, values|
  		if  h.has_key?(hash) && h[hash].has_key?(:count)
  			count_add = h[hash][:count] +1
  			h[hash][:count] = count_add
  		else
  			h[hash] = values
  			h[hash][:count] = 1
  		end
  	end
  end
  h
end

def apply_coupons(cart:[], coupons:[])
  h = {}
  cart_hashes = cart#consolidate_cart(cart)


  coupons.each do |coup_hash|
  	coup_hash.each do |coup_item, coup_value|
  		if coup_item == :item
  			cart_hashes.each do |cart_hash, cart_key|
  				if coup_value == cart_hash && cart_key[:count] >= coup_hash[:num]
  					cart_key[:count] = cart_key[:count] - coup_hash[:num]
            if h.has_key?("#{cart_hash} W/COUPON")
              h["#{cart_hash} W/COUPON"][:count] += 1
            else
  					  h["#{cart_hash} W/COUPON"] = {:price => coup_hash[:cost], :clearance => cart_key[:clearance], :count => 1}
            end
  				end
  			end
  		end
  	end
  end
  h_comp = cart_hashes.merge(h)
  h_comp
  #binding.pry
end

def apply_clearance(cart:[])


  cart.collect do |hash, key|
    if key[:clearance] == true
      key[:price] = (key[:price]*0.8).round(2)
      #binding.pry
    end
  end
  cart
  #binding.pry
end

def checkout(cart: [], coupons: [])
  # code here
  x = cart
  binding.pry
  consolidate_cart(x)
  binding.pry
  if coupons.empty? == false
    binding.pry
    cart = apply_coupons(cart,coupons)
    binding.pry
  end
  cart = apply_clearance
  binding.pry


end
=end


def consolidate_cart(cart:[])
  # code here
  h = {}
  cart.each do |hashs|
  	hashs.each do |hash, values|
  		if  h.has_key?(hash) && h[hash].has_key?(:count)
  			count_add = h[hash][:count] +1
  			h[hash][:count] = count_add
  		else
  			h[hash] = values
  			h[hash][:count] = 1
  		end
  	end
  end
  h
end

def apply_coupons(cart:[], coupons:[])
  # code here
  h = {}

  cart_hashes = cart


  coupons.each do |coup_hash|
  	coup_hash.each do |coup_item, coup_value|
  		if coup_item == :item
  			cart_hashes.each do |cart_hash, cart_key|
  				if coup_value == cart_hash && cart_key[:count] >= coup_hash[:num]
  					cart_key[:count] = cart_key[:count] - coup_hash[:num]
            if h.has_key?("#{cart_hash} W/COUPON")
              h["#{cart_hash} W/COUPON"][:count] += 1
            else
  					  h["#{cart_hash} W/COUPON"] = {:price => coup_hash[:cost], :clearance => cart_key[:clearance], :count => 1}
            end
  				end
  			end
  		end
  	end
  end
  h_comp = cart_hashes.merge(h)
  h_comp
end

def apply_clearance(cart:[], coupons:[])


  cart.collect do |hash, key|
    if key[:clearance] == true
      key[:price] = (key[:price]*0.8).round(2)
      #binding.pry
    end
  end
  cart

end

def checkout(cart:[], coupons:[])
  x = cart
  #binding.pry
  x = consolidate_cart(cart:x)
  #binding.pry

  if coupons.empty? == false
    #binding.pry
    x = apply_coupons(cart:x,coupons:coupons)
    #binding.pry
  else
    x = apply_coupons(cart:x,coupons:[])
    #binding.pry
  end
  x = apply_clearance(cart:x)
  #binding.pry
  total = 0
  x.each do |hash, key|
    if key[:clearance] == true
      total = total + (key[:price]*key[:count])
    else
      total = total + (key[:price]*key[:count])
    end
  end
  #binding.pry
  if total >= 100
    total *= 0.9
    total.round(2)
  end
  total
  #binding.pry
end
