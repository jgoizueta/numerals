require 'numerals/conversions'
require 'singleton'

class Numerals::IntegerConversion

  include Singleton

  class InvalidConversion < RuntimeError
  end

  def type
    Integer
  end

  def order_of_magnitude(value, options={})
    base = options[:base] || 10
    if base == 2 && value.respond_to?(:bit_length)
      value.bit_length
    else
      value.to_s(base).size
    end
  end

  def number_of_digits(value, options={})
    # order_of_magnitude(value, options)
    0 # this is needed only for non-exact values
  end

  def exact?(value, options={})
    true
  end

  def number_to_numeral(number, mode, rounding)
    # Rational.numerals_conversion Rational(number), mode, rounding
    numeral = Numerals::Numeral.from_quotient(number, 1)
    numeral = rounding.round(numeral) # unless rounding.free?
    numeral
  end

  def numeral_to_number(numeral, mode)
    rational = Rational.numerals_conversion.numeral_to_number numeral, mode
    if rational.denominator != 1
      raise InvalidConversion, "Invalid numeral to rational conversion"
    end
    rational.numerator
  end

  def write(number, exact_input, output_rounding)
    output_base = output_rounding.base
    numeral = Numerals::Numeral.from_quotient(number, 1, base: output_base)
    numeral = output_rounding.round(numeral) # unless output_rounding.free?
    numeral
  end

  def read(numeral, exact_input, approximate_simplified)
    rational = Rational.numerals_conversion.read numeral, exact_input, approximate_simplified
    if rational.denominator != 1
      raise InvalidConversion, "Invalid numeral to rational conversion"
    end
    rational.numerator
  end


end

def Integer.numerals_conversion(options = {})
  Numerals::IntegerConversion.instance
end
