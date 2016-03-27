def consolidate_cart(cart:[])
  abc={}
  cart.each do |i|
    i.each do |j,k|
      if abc.has_key?(j)
        abc[j][:count]+=1
      else
        abc[j]=k
        abc[j][:count]=1
      end
    end
  end
  return abc
end

def apply_coupons(cart:[], coupons:[])
  abc={}
  coupons.each do |i|
    i.each do |j,k|
      if cart.has_key?(k)
        abc[k]=abc[k].to_i+1
        cart["#{k} W/COUPON"] = {:price => i[:cost], :clearance => cart[k][:clearance], :count => abc[k]}
          if cart[k][:count]>=i[:num]
            cart[k][:count]=cart[k][:count]-i[:num]
          end
        end
      end
    end
  return cart
end

def apply_clearance(cart:[])
  xyz={}
  cart.each do |x,y|
    if cart[x][:clearance]==true
      cart[x][:price]=(cart[x][:price]*0.8).round(2)
    end
    xyz[x]=cart[x]
  end
  return xyz
end

def checkout(cart: [], coupons: [])
  if coupons.size==0
    xyz=apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: []))
    sum=0
    xyz.each do |i,j|
      sum+=j[:price]*j[:count]
    end
    sum>100 ? (return sum*0.9):(return sum)
  else
    sum=0
    xyz=apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))
    xyz.each do |g,l|
      dic=0.8 if xyz[g][:clearance]==true
      if xyz.has_key?("#{g} W/COUPON")
        sum+=(xyz[g][:price]*xyz[g][:count]*dic)
      else
        q=1
        q=xyz[g][:count] if g.include?("W/COUPON")==false
        sum+=(xyz[g][:price]*q)
      end
    end
  end
  sum>100 ? (return sum*0.9):(return sum)
end