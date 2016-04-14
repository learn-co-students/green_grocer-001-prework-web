def consolidate_cart(cart:[])
  new_hash = {}
  cart.each do |x|
    x.each do |produce, info|
      if new_hash.include?(produce) == false
        new_hash.store(produce, info)
        new_hash[produce].store(:count, 1)
      else
        new_hash[produce][:count] += 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |hash|
    hash.each do |category, info|
      if category == :item && cart.include?(info) == true && cart[info][:count] >= hash[:num]
        cart[info][:count] -= hash[:num]
        with_coupon_hash = {:price => hash[:cost], :clearance => cart[info][:clearance], :count => 1}
        if cart.include?("#{info} W/COUPON") == true
          cart["#{info} W/COUPON"][:count] += 1
        else
          cart.store("#{info} W/COUPON", with_coupon_hash)
        end
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |item, hash|
    if hash[:clearance] == true
      hash[:price] *= 0.8
      hash[:price] = hash[:price].round(3)
    end
  end
  cart
end

def checkout(cart:[], coupons:[])
  first = consolidate_cart(cart:cart)
  subtotal = 0
  total = 0
  second = apply_coupons(cart:first, coupons:coupons)
  third = apply_clearance(cart:second)
  third.each do |item, stats|
    total += (stats[:price] * stats[:count])
  end
  if total > 100
    total = total * 0.9
  end
  total
end

=begin
one item
consolidate before total
apply coupons after consolidate
apply clearnace after coupons
multiple items
clearance after coupons
=end

