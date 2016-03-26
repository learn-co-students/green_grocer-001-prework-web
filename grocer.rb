require 'pry'
def consolidate_cart(cart:[])
  # code here
newCart={}
cart.each do |p|
   p.each do |product,values|
    if !(newCart.has_key?(product))
         newCart[product]=values
         newCart[product][:count]=1
    elsif newCart.has_key?(product)
        newCart[product][:count]+=1
    end
  end
end
  newCart
end

def apply_coupons(cart:[], coupons:[])
newHash={}
cart.each do |product,details|
 newHash[product]=details
   coupons.each do |coupon|
    if coupon[:item]==product && details[:count] >= coupon[:num]
      newHash[product][:count]=details[:count]-coupon[:num]
    if newHash.keys.include?("#{product} W/COUPON")
           newHash["#{product} W/COUPON"][:count] += 1
    else
           newHash["#{product} W/COUPON"]={:price=>(coupon[:cost]),:clearance=>details[:clearance],:count=>1}
    end
   end
  end
end
newHash
end

def apply_clearance(cart:[])
newHash={}
    cart.each do |product,details|
        newHash[product]=details
       if details[:clearance]==true
          newHash[product][:price]=(details[:price]-(details[:price]*0.2))
       end
    end
    newHash
end

def checkout(cart: [], coupons: [])
  checkOutCart =consolidate_cart(cart: cart)
  checkOutCart =apply_coupons(cart: checkOutCart, coupons:coupons)
  checkOutCart =apply_clearance(cart:checkOutCart )

  #If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount
  cartTotal=[]
  checkOutCart.each do |item,value|
    cartTotal<<value[:price]*value[:count]
  end
  cartTotal=cartTotal.reduce(0, :+)
  if cartTotal>100
    cartTotal=cartTotal*0.9
  end
  cartTotal

end