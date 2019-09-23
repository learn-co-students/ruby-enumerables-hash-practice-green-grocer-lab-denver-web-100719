require 'pry'
def consolidate_cart(cart)
  final_cart = {}
  cart.each do |element|
      element_name = element.keys[0]
      element_values = element.values[0]
      
      if final_cart.has_key?(element_name)
        final_cart[element_name][:count] += 1
      else
        final_cart[element_name] = {
          count:  1,
          price: element_values[:price],
          clearance: element_values[:clearance]
        } 
      end
    end
    final_cart
end

def apply_coupons(cart, coupons)
    coupons.each do |coupon|
      item = coupon[:item]
      coupon_name = "#{item} W/COUPON"
      if cart.has_key?(item) 
        if cart[item][:count] >= coupon[:num]
          if !cart.has_key?(coupon_name)
          cart[coupon_name] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        else 
        cart[coupon_name][:count] += coupon[:num]
    end
        cart[item][:count] -= coupon[:num]
    end
   end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product, stats|
    if stats[:clearance]
      stats[:price] -= stats[:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  final_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(final_cart, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  total = applied_clearance.reduce(0) {|acc, (key,value)| acc += value[:price]*value[:count]}
  total > 100 ? total * 0.9: total
end
