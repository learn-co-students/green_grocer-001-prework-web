def list
  [
    { 'product' => 1, 'x' => 200, 'y' => 100},
    { 'product' => 1, 'x' => 200, 'y' => 100},
    { 'product' => 1, 'x' => 300, 'y' => 100},
    { 'product' => 2, 'x' => 300, 'y' => 100},
    { 'product' => 2, 'x' => 100, 'y' => 100},
    { 'product' => 3, 'x' => 100, 'y' => 100}
  ]
end

def consolidate(items)
# hash to count the number of unique products.
cart = Hash.new 0

# Add each product to the hash count.
items.each do |item_detail|
  cart[item_detail] += 1
end

cart.keys.each do |k|
  # since each key is a product hash, we can add count to it
  k[:count] = cart[k]
  end


puts "cart.keys: #{cart.keys}"
puts "\ncart.values: #{cart.values}"







  puts "\nthis is cart: #{cart}"
end
consolidate(list)

