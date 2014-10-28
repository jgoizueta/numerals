require 'numerals/conversions'

class Numerals::BigDecimalConversion

  def order_of_magnitude(value, options={})
    base = options[:base] || 10
    if base == 10
      value.exponent
    else
      Conversions.order_of_magnitude(Flt::DecNum(value.to_s), options)
    end
  end

  def number_to_numeral(number, options={})
    mode = options[:mode] || :fixed
    base = options[:base] || 10
    rounding = options[:rounding] || Rounding[:exact]

  end

  def numeral_to_number(numeral, options={})
    mode = options[:mode] || :fixed

  end

end

def BigDecimal.numerals_conversion
  Numerals::BigDecimalConversion.new
end
