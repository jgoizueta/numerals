module Numerals

  def self.gcd(a,b)
    while b!=0 do
      a,b = b, a.modulo(b)
    end
    return a.abs
  end

end
