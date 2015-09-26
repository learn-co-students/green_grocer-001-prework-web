def consolidate_cart(cart:[])
  output = {}
  cart.each do |fruit_hash|
    fruit_hash.each do |fruit, price_hash|
      if output[fruit]
        price_hash[:count] += 1
      else
        price_hash[:count] = 1
        output[fruit] = price_hash
      end
    end
  end
output
end


{
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
}

[{:item => "AVOCADO", :num => 2, :cost => 5.0}]

{
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
  "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},
}


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
  cart.each do |name, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (0.8 * price_hash[:price]).round(1)
    end
  end
end

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(:cart => cart)
  consolidated_cart_coupons = apply_coupons(:cart => consolidated_cart,:coupons => coupons)
  consolidated_cart_clearance = apply_clearance(:cart => consolidated_cart_coupons)
  total = 0
  consolidated_cart_clearance.each do |name,price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  if total > 100
    total = total * 0.9
  end
    total
end









