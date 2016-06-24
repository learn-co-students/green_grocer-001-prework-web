def consolidate_cart(cart:[])
  # code here
  final = {}
  temp = []
    cart.each do |x|
        x.each do |k, v|
            temp << k
            if final.has_key?(k)
                final[k][:count] = temp.count(k)
            else
                v[:count] = 1
                final[k] = v
            end
        end
    end
    final
end

def apply_coupons(cart:[], coupons:[])
  # code here
  final = cart.clone
  temp = ""
  cart.each do |k,v|
      coupons.each do |c|
           if c[:item] == k && v[:count] >= c[:num]
            temp = "#{k} W/COUPON"
            number = (v[:count]/c[:num])
            final[k][:count] = (v[:count]%c[:num])
            final[temp] = {:price => c[:cost], :clearance => v[:clearance], :count => number}
                # if final[k][:count] == 0
                #     final.delete(k)
                # end
           end
      end
  end
return final
end

def apply_clearance(cart:[])
  # code here
  final = {}
    cart.each do |k,v|
      final[k]= v
      if v[:clearance] == true
        final[k][:price] = (final[k][:price] * 0.8).round(2)
      end
    end
  final
end

def checkout(cart:[], coupons: [])
  # code here
  puts cart
  apply_clearance(cart:apply_coupons(cart:consolidate_cart(cart:cart), coupons:coupons))
  puts cart.inspect
  cost = 0.00
  # cart.each do |x|
  #   x.each do |k,v|
  #     cost += (v[:price]*v[:count]).round(2)
  #   end
  # end
  # if cost >= 100.00
  #   cost = cost *0.9
  # end
  # cost
end

cart =   [{"AVOCADO" => {:price => 3.00, :clearance => true}},{"ALMONDS" => {:price => 9.00, :clearance => false}}]
coupons = [
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "BEER", :num => 2, :cost => 20.00},
      {:item => "CHEESE", :num => 3, :cost => 15.00}
    ]
checkout(cart: cart, coupons:coupons)
