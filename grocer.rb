def consolidate_cart(cart:[])
 cart.each_with_object({}) do |item, consol|
    item_name = item.keys.first
    if consol[item_name]
        consol[item_name][:count] += 1
    else
      consol[item_name] = 
        {price: item[item_name][:price],
        clearance: item[item_name][:clearance],
        count: 1}
    end 
  end
end

def apply_coupons(cart:[], coupons:[])
  # code here

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
  # code here
      cart.each do |item, properties|
        if properties[:clearance] 
          new_price = properties[:price] * 0.80
          properties[:price] = new_price.round(2)
        end
     end

end

def checkout(cart: [], coupons: [])
  puts cart.inspect
  call_later = cart
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  final = apply_clearance(cart: cart)

  total = 0 
  final.each do |name, properties|
    total += properties[:price] * properties[:count]
  end 

  total = total * 0.9 if total > 100

total 

end