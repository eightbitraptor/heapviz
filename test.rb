def popcount(n)
  x = 0
  while n > 1
    x += 1
    n >>= 1
    p n.to_s(2)
  end
  x
end


p popcount 0b111000 
p popcount 0b111111

