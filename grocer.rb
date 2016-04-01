def cart
  	[{"AVOCADO" => {:price => 3.00, :clearance => true}},
    {"AVOCADO" => {:price => 3.00, :clearance => true}},
    {"AVOCADO" => {:price => 3.00, :clearance => true}},
    {"AVOCADO" => {:price => 3.00, :clearance => true}},
    {"BEER" => {:price => 13.00, :clearance => false}},
    {"BEER" => {:price => 13.00, :clearance => false}},
    {"CHEESE" => {:price => 6.50, :clearance => false}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}}]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

#{
#  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
#  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
#}

def apply_coupons(cart:[], coupons:[])
  # reiterate through coupons 1 by 1
  coupons.each do |coupon,data|
    #Let's jot down the current item
    item = coupon[:item]
    #Check if we have an item in the cart that matches a coupon
    if cart.has_key?(item)
      #Coupons are for a specific quanity so see if we have the right #
      if cart[item][:count] >= coupon[:num]
        #If coupon qualifies we need to adjust the cart
        #Will have two cases one where # of items is exact
        #in this case the old item is deleted and item with coupon
        #is added in other case we have more items than is on the coupon
        #and we have to add new item and reduce quantity of old
        new_item = item + " W/COUPON"
        if cart.has_key?(new_item)
          cart[new_item][:count] += 1
        else
          cart[new_item] = {:price => coupon[:cost],
                            :clearance => cart[item][:clearance],
                            :count => 1}
        end
        cart[item][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def consolidate_cart(cart:[])
  # code here
  new_cart = {}
  cart.each do |item|
    item.each do |key,data|
      if !new_cart.has_key?(key)
        new_cart[key] = data
        new_cart[key][:count] = 1
      else
        new_cart[key][:count] += 1
      end
    end
  end
  new_cart
end



def apply_clearance(cart:[])
  # code here
  cart.each do |item,data|
    if(data[:clearance] == true)
      data[:price] = (data[:price]*0.80).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  # code here
  consol_cart = consolidate_cart(cart: cart)
  apply_coupons(cart:consol_cart,coupons: coupons)
  apply_clearance(cart:consol_cart)

  count = total_cart(cart:consol_cart)
  if  count > 100.00
    count = (count*0.90)
  end
  count.round(2)
end

def total_cart(cart: [])
  count = 0
  cart.each do |item,data|
    count += data[:price] * data[:count]
  end
  count
end
checkout(cart: cart,coupons: coupons)