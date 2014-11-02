require 'numerals/conversions'
require 'singleton'

class Numerals::RationalConversion

  include Singleton

  def order_of_magnitude(value, options={})
    base = options[:base] || 10
    if base == 10
      Math.log10(value.abs).floor + 1
    else
      (Math.log(value.abs)/Math.log(base)).floor + 1
    end
  end

  def number_to_numeral(number, mode, rounding)
    q = [number.numerator, number.denominator]
    numeral = Numeral.from_quotient(q)
    numeral = rounding.round(numeral) unless rounding.exact?
    numeral
  end

  def numeral_to_number(numeral, mode)
    Rational(*numeral.to_quotient)
  end

end

def Rational.numerals_conversion
  Numerals::RationalConversion.instance
end
