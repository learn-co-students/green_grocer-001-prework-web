def consolidate_cart(cart:[])
  # code here
   # code here
  conso_cart = {}
  
  cart.each do |item|
    item.each do |k,v|
      if conso_cart.keys.include?(k) == false
        conso_cart[k] = v
        conso_cart[k][:count] = 1
      else 
        counter = conso_cart[k][:count] + 1
        conso_cart[k][:count] = counter 
      end
    end
  end
  conso_cart
end

def apply_coupons(cart:[], coupons:[])
   # code here
   app_coupon = {}
   cart.each do |item, attributes|
     coupons.each do |coupon|
       if coupon[:item] == item && attributes[:count] >= coupon[:num]
         if !app_coupon.has_key?("#{item} W/COUPON")
           app_coupon["#{item} W/COUPON"] = {
             price: coupon[:cost],
             clearance: attributes[:clearance],
             count: 0}
         end
         app_coupon["#{item} W/COUPON"][:count] += 1
         attributes[:count] -= coupon[:num]
       end
     end
   end
   cart.merge!(app_coupon)
  end


def apply_clearance(cart:[])
   # code here
  app_clear = {}
  cart.each do |item_name, value|
     app_clear[item_name] = value
      if value[:clearance] == true
        value[:price] = (value[:price] * 0.8).round(2)
      end
  end
  app_clear
end


def checkout(cart: [], coupons: [])
  # code here
  total = 0 
  cart = apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), 
                         coupons: coupons))
  cart.each do |item_name, value|
     total += value[:price] * value[:count]
  end
 
  total = (total * 0.9).round(2) if total >= 100
  total
end 