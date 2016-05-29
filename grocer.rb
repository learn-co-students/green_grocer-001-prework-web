
def consolidate_cart(cart:[])
  countcart={}
  cart.each {|item|
    item.each {|ingred, properties|
      if (countcart.key?(ingred)==false) 
          countcart[ingred] = properties
          countcart[ingred][:count]=1
      else 
          countcart[ingred][:count]+=1
      end
    }
  }
  countcart
end



def apply_coupons(cart:[], coupons:[])
  # code here
  coupons.each do |coupon|
    if cart.key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      bundle = coupon[:item] + " W/COUPON"
      cart[coupon[:item]][:count] -= coupon[:num]
      if (cart.key?(bundle)==false)
        cart[bundle] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: 1}
      else
         cart[bundle][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each {|item, properties|
    if properties[:clearance] == true
      properties[:price] = (properties[:price] * 0.8).round(2)
    end
  }
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  total = 0
  cart.each {|item, properties|
    total += properties[:price] * properties[:count]
  }
  if (total > 100)
    total=total*0.9
  end
  total
end












