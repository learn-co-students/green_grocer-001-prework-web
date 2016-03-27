abc = [
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}}
    ]
def consolidate_cart(cart:[])
  # code here
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


xyz=consolidate_cart(:cart => [      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}}])



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
    puts "cart-#{cart}"
    end
    puts "cart---#{cart}"
  end
  puts "cart-----#{cart}"
  puts "i-----#{coupons[i]}"
end

#consolidate_cart(cart:[])
#apply_coupons(cart: consolidate_cart (cart: [{"BEER" => {:price => 13.00, :clearance => false}},{"BEER" => {:price => 13.00, :clearance => false}},{"BEE#R" => {:price => 13.00, :clearance => false}} ]),coupons: [{:item => "AVOCADO", :num => 2, :cost => 5.00}, {:item => "BEER", :num => 2, :cost => 20.00}, #{:item => "CHEESE", :num => 3, :cost => 15.00}])

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

#apply_clearance(cart:[xyz])



def checkout(cart: [], coupons: [])
  if coupons.size==0
    xyz=apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: []))
    sum=0
    xyz.each do |i,j|
      sum+=j[:price]*j[:count]
    end
   return sum
  else
    sum=0
    xyz=apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons))
    #coupons.each do |i|
     # i.each do |x,y|
        xyz.each do |g,l|
         dic=1
          dic=0.8 if xyz[g][:clearance]==true
          if xyz.has_key?("#{g} W/COUPON")  #or xyz.has_key?("#{g.gsub!(' ','_')} W/COUPON")
 #puts"-------1"
            sum+=(xyz[g][:price]*xyz[g][:count]*dic)


           #*xyz["#{g} W/COUPON"][:count]+xyz["#{g} W/COUPON"][:price]
         else
           # puts"-------2"
              q=1
            q=xyz[g][:count] if g.include?("W/COUPON")==false
            sum+=(xyz[g][:price]*q)
      #    puts "#{xyz[g]} and  #{xyz[g][:count]}"
       #   puts  "#{ xyz[g][:price]}----"
        #    puts "#{sum}"
      #      puts xyz
          end
          #puts

      end

  end

puts sum
end








=begin
checkout(cart: [{"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
        {"SOY MILK" => {:price => 4.50, :clearance => true}}],coupons: [{:item => "AVOCADO", :num => 2, :cost => 5.00}, {:item => "BEER", :num => 2, :cost => 20.00}, {:item => "CHEESE", :num => 3, :cost => 15.00}])
=end
#=begin
checkout(cart: [{"BEER" => {:price => 13.00, :clearance => false}},{"BEER" => {:price => 13.00, :clearance => false}},{"BEER" => {:price => 13.00, :clearance => false}}],coupons: [{:item => "AVOCADO", :num => 2, :cost => 5.00}, {:item => "BEER", :num => 2, :cost => 20.00}, {:item => "CHEESE", :num => 3, :cost => 15.00}])

#=end
=begin
checkout(cart: [ {"CHEESE" => {:price => 6.50, :clearance => false}}, {"CHEESE" => {:price => 6.50, :clearance => false}}, {"CHEESE" => {:price => 6.50, :clearance => false}},{"SOY MILK" => {:price => 4.50, :clearance => true}},{"AVOCADO" => {:price => 3.00, :clearance => true}},{"AVOCADO" => {:price => 3.00, :clearance => true}}],coupons: [{:item => "AVOCADO", :num => 2, :cost => 5.00}, {:item => "BEER", :num => 2, :cost => 20.00}, {:item => "CHEESE", :num => 3, :cost => 15.00}])
=end




