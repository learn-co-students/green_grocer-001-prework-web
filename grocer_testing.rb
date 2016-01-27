def items
  [
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      #{"AVOCADO" => {:price => 3.00, :clearance => true}},
      #{"KALE" => {:price => 3.00, :clearance => false}},
      #{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      #{"ALMONDS" => {:price => 9.00, :clearance => false}},
      #{"TEMPEH" => {:price => 3.00, :clearance => true}},
      #{"TEMPEH" => {:price => 3.00, :clearance => true}},
      #{"CHEESE" => {:price => 6.50, :clearance => false}},
      #{"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}}
  ]
end


#
# Translate it into a hash that includes the counts for each item
#   [
#      {"AVOCADO" => {:price => 3.0, :clearance => true }},
#      {"AVOCADO" => {:price => 3.0, :clearance => true }},
#      {"KALE"    => {:price => 3.0, :clearance => false}}
#   ]
#   {
#      "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
#      "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
#   }
#

def consolidate(items_arr)
  cart = Hash.new 0
  item_count = 0

  items_arr.each do |items|
    # puts "items: #{items}"                #  items (hash):     {"AVOCADO"=>{:price=>3.0, :clearance=>true}}
    cart[items] += 1

    items.each do |item, options|
      #puts "item: #{item}"                #  item (string):    AVOCADO
      #puts "options: #{options}"          #  options (hash):   {:price=>3.0, :clearance=>true}

      #item_count = cart[items] += 1
      # cart[item] = { count: item_count  }

      options.each do | status, value |
        # puts "status: #{status}"       #  status (symbol):  price
        # puts "value: #{value}"         #  value (float):    3.0
      end
    end

    cart.values.each do |v|
      cart.keys.each do |k|
        puts "cart.keys: #{k}"
        k[:count] = item_count
      end
    end
  end

  puts "this is cart: #{cart}"
end
consolidate(items)



def consolidate_cart(cart:[])

  # code here
end

def apply_coupons(cart:[], coupons:[])
  # code here
end

def apply_clearance(cart:[])
  # code here
end

def checkout(cart: [], coupons: [])
  # code here
end