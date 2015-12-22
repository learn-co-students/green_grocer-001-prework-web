#cart = [
#  {"AVOCADO" => {:price => 3.0, :clearance => true }},
#  {"AVOCADO" => {:price => 3.0, :clearance => true }},
#  {"KALE"    => {:price => 3.0, :clearance => false}}
#]
#coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]

def consolidate_cart(cart:[])
  consolidate_cart = Hash.new 
  cart.each do |item|
    item.each do |name, property|
        if consolidate_cart.has_key?(name) 
        consolidate_cart[name][:count] += 1
        else
        property[:count] = 1
        consolidate_cart[name] = property
        end
    end
  end
  consolidate_cart
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart.has_key?(name) && cart[name][:count] >= coupon[:num]
      cart[name][:count] -= coupon[:num]
      if !cart.has_key?("#{name} W/COUPON")
        cart["#{name} W/COUPON"] = {
        price: coupon[:cost],
        clearance: cart[name][:clearance],
        count: 1
        }
      else
        cart["#{name} W/COUPON"][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |name, property|
    if property[:clearance] == true 
      property[:price] = (property[:price] * 0.8).round(1)
    end
  cart
  end
end

def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart)
  applied_coupons = apply_coupons(cart: consolidated, coupons: coupons)
  final_cart = apply_clearance(cart: applied_coupons)
  total_cost = 0
  final_cart.each do |name, property|
    total_cost += property[:price] * property[:count]
  end
  if total_cost > 100
    total_cost = total_cost * 0.9
  end 
  total_cost
end