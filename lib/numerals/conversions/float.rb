require 'numerals/conversions'
require 'flt/float'

class Numerals::FloatConversion

  def initialize(options={})
    options = { use_native_float: true }.merge(options)
    @use_native_float = options[:use_native_float]
  end

  def order_of_magnitude(value, options={})
    base = options[:base] || 10 # Float::RADIX
    if base == 10
      Math.log10(value.abs).floor + 1
    else
      (Math.log(value.abs)/Math.log(base)).floor + 1
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

def Float.numerals_conversion
  Numerals::FloatConversion.new
end

class <<Float.context
  def numerals_conversion
    Numerals::FloatConversion.new
  end
end
