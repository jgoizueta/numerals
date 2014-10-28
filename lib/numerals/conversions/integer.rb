require 'numerals/conversions'

class Numerals::IntegerConversion

  def order_of_magnitude(value, options={})
    base = options[:base] || 10
    if base == 2 && value.respond_to?(:bit_length)
      value.bit_length
    else
      value.to_s(base).size
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

def Integer.numerals_conversion
  Numerals::IntegerConversion.new
end
