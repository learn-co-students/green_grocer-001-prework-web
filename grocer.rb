def consolidate_cart(cart:[])

consolidated={}

  cart.each do |line_item|
    line_item.each do|name, data_hash|
      (consolidated[name] ||=data_hash.merge({count:0})) [:count]+=1
    end
  end 
  consolidated
end




def apply_coupons(cart:[], coupons:[])

 couponed_hash={}

  cart.each do |item, item_data|
    couponed_hash[item]=item_data.clone
    coupons.each do |coupon|
      if coupon[:item]==item
        couponed_hash[item][:count]= item_data[:count]%coupon[:num]
        couponed_hash[item+" W/COUPON"]=item_data.clone
        couponed_hash[item+" W/COUPON"][:count]= item_data[:count]/coupon[:num]
        couponed_hash[item+" W/COUPON"][:price]= coupon[:cost]
      end
    end   
  end
  couponed_hash
end



def apply_clearance(cart:[])

cart.each do |item, item_data|
  if item_data[:clearance]
    item_data[:price]=(item_data[:price]*0.8).round(1)
  end
end

cart
   
end



def checkout(cart: [], coupons: [])

out_cart=apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))

sum=0
out_cart.each do |item, item_data|
  sum=sum+item_data[:price]*item_data[:count]
end

return sum if sum<=100 else return (sum*0.9).round(1)
end

