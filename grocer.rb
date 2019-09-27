def consolidate_cart(cart)
 cart_hash = {}
  cart.each do |items| 
    items.each do |item, attributes|
 if cart_hash[item] 
   cart_hash[item][:count] += 1
 else cart_hash[item] = attributes
   cart_hash[item][:count] = 1
 end
 end
 end
 cart_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
  if cart[item]
    if cart[item][:count] >= coupon[:num] && !cart["#{item} W/COUPON"]
       cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num] }
       cart[item][:count] -= coupon[:num]
    elsif cart[item][:count] >= coupon[:num] && cart["#{item} W/COUPON"]
       cart["#{item} W/COUPON"][:count] += coupon[:num]
       cart[item][:count] -= coupon[:num]
  end
 end
 end
 cart
end

def apply_clearance(cart)
  cart.each do |item, stats|
    if stats[:clearance] 
      stats[:price] -= stats[:price] * 0.2
    end
  end
cart
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_clearence = apply_clearance(applied_coupons)
  total = applied_clearence.reduce(0) { |acc, (key, value)| acc += value[:price] * value[:count]}
  total > 100 ? total * 0.9 : total
end
