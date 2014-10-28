require 'numerals/conversions'

class Numerals::FltConversion

  def initialize(context_or_type)
    if Flt::Num === context_or_type
      @type = context_or_type
      @context = @type.context
    else
      @context = context_or_type
      @type = context.num_class
    end
  end

  attr_reader :context, :type

  def order_of_magnitude(value, options={})
    base = options[:base] || 10 # value.num_class.radix
    if value.class.radix == base
      value.adjusted_exponent + 1
    else
      value.abs.log(base).floor + 1
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

def (Flt::Num).numerals_conversion
  Numerals::FltConversion.new(self)
end

class Flt::Num::ContextBase
  def numerals_conversion
    Numerals::FltConversion.new(self)
  end
end
