z = {
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
}

uz = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]

def consolidate_cart(cart:[])
  consolidated = Hash.new(0)
  cart.uniq.each do |items|
    items.each do |item, info|
      consolidated[item] = info
      consolidated[item][:count] = cart.count(items)
    end
  end
  consolidated
end

def apply_coupons(cart:[], coupons:[])
  new_hash = {}
  cart.each do |food, data|
    coupons.each do |coupon|
      if food == coupon[:item] && data[:count] >= coupon[:num]
        data[:count] = data[:count] - coupon[:num]
        new_hash["#{food} W/COUPON"] ? new_hash["#{food} W/COUPON"][:count] += 1 : new_hash["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => data[:clearance], :count => 1}
      end
    end
    new_hash[food] = data
  end
  new_hash
end


def apply_clearance(cart:[])
  cart.each do |item, info|
    info[:price] = (info[:price] * 0.8).round(2)  if info[:clearance] == true
  end
  cart
end


def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  total = 0
  cart.each do |food, data|
    total += data[:price] * data[:count]
  end
  total > 100 ? total * 0.9 : total
end
