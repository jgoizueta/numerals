require 'numerals/conversions'
require 'flt/float'

class Numerals::FloatConversion

  def initialize(options={})
    @type = Float
    @context = @type.context
    options = { use_native_float: true }.merge(options)
    @use_native_float = options[:use_native_float]
    # @rounding_mode if used for :free numeral to number conversion
    # and should be the implied rounding mode of the invers conversion
    # (number to numeral);
    # TODO: it should be possible to assign it for higher level
    # formatting handling.
    @rounding_mode = @context.rounding
    @honor_rounding = true
  end

  def order_of_magnitude(value, options={})
    base = options[:base] || 10 # @contex.radix
    if base == 10
      Math.log10(value.abs).floor + 1
    else
      (Math.log(value.abs)/Math.log(base)).floor + 1
    end
  end

  # mode is either :exact or :approximate
  def number_to_numeral(number, mode, rounding)
    if @context.special?(number)
      special_float_to_numeral(number)
    else
      if mode == :exact
        exact_float_to_numeral number, rounding
      else # mode == :approximate
        approximate_float_to_numeral(number, rounding)
      end
    end
  end

  def numeral_to_number(numeral, mode)
    if numeral.special?
      special_numeral_to_float numeral
    elsif mode == :fixed
      fixed_numeral_to_float numeral
    else # mode == :free
      free_numeral_to_float numeral
    end
  end

  private

  def special_float_to_numeral(x)
    if x.nan?
      Numeral.nan
    elsif x.infinite?
      Numeral.infinity @context.sign(x)
    end
  end

  def exact_float_to_numeral(number, rounding)
    quotient = number.to_r
    numeral = Numeral.from_quotient(quotient, base: rounding.base)
    unless rounding.exact?
      numeral = rounding.round(numeral)
    end
    numeral
  end

  def approximate_float_to_numeral(number, rounding)
    all_digits = !rounding.exact?
    general_float_to_numeral(number, rounding, all_digits)
  end

  # def fixed_float_to_numeral(number, rounding)
  #   # adjust to rounding.precision
  #   if rounding.exact?
  #     # if simplify
  #     #   number = @context.rationalize(simplify)
  #     # end
  #     exact_float_to_numeral number, rounding.base
  #   else
  #     if rounding.base == 10 && @use_native_float
  #       native_float_to_numeral number, rounding
  #     else
  #       general_float_to_numeral number, rounding, true
  #     end
  #   end
  # end

  # def free_float_to_numeral(number, rounding)
  #   # free mode ignores output precision (rounding) and
  #   # produces the result based only on the number precision
  #   rounding = Rounding[:exact, base: rounding.base]
  #   general_float_to_numeral number, rounding, false
  # end

  def native_float_to_numeral(number, rounding)
    need_to_round = (rounding.mode != @context.rounding)
    n = need_to_round ? Float::DECIMAL_DIG : rounding.precision
    txt = format("%.*e", n-1, x)
    numeral = text_to_numeral(txt, normalize: :approximate) # C-Locale text to numeral...
    numeral = rounding.round(numeral) if need_to_round
    numeral
  end

  def general_float_to_numeral(x, rounding, all_digits)
    sign, coefficient, exponent = x.split
    precision = x.number_of_digits
    output_base = rounding.base

    # here rounding_mode should be not the output rounding mode, but the rounding mode used for input
    # we'll assume rounding.mode will be used for input unless it is exact
    rounding_mode = rounding.exact? ? @context.rounding : rounding.mode
    formatter = Flt::Support::Formatter.new(
      @context.radix, @context.etiny, output_base, raise_on_repeat: false
    )
    formatter.format(
      x, coefficient, exponent, rounding_mode, precision, all_digits
    )

    dec_pos, digits = formatter.digits
    rep_pos = formatter.repeat
    numeral = Numeral[digits, sign: sign, point: dec_pos, rep_pos: formatter.repeat, base: output_base]
    if all_digits
      numeral = rounding.round(numeral, formatter.round_up)
    end
    numeral
  end

  def special_numeral_to_float(numeral)
    case numeral.special
    when :nan
      @context.nan
    when :inf
      @context.infinity numeral.sign
    end
  end

  def fixed_numeral_to_float(numeral)
    # consider:
    # return exact_numeral_to_float(numeral) if numeral.exact?
    if numeral.base == @context.radix
      same_base_numeral_to_float numeral
    else
      # representable_digits: number of numeral.base digits that can always be converted to Float and back
      # to a numeral preserving its value.
      representable_digits = @context.representable_digits(numeral.base)
      k = numeral.scale
      if !@honor_rounding && numeral.digits.size <= representable_digits && k.abs <= representable_digits
        representable_numeral_to_float numeral
      elsif !@honor_rounding && (k>0 && numeral.point < 2*representable_digits)
        near_representable_numeral_to_float numeral
      elsif numeral.base.modulo(@context.radix)==0
        conmensurable_base_numeral_to_float numeral
      else
        general_numeral_to_float numeral, :fixed
      end
    end
  end

  def exact_numeral_to_float(numeral)
    Rational(*numeral.to_quotient).to_f
  end

  def free_numeral_to_float(numeral)
    # raise "Invalid Conversion" # Float does not support free (arbitrary precision)
    # fixed_numeral_to_float numeral
    # consider:
    # return general_numeral_to_float(numeral, :short) if numeral.exact?
    general_numeral_to_float numeral, :free
  end

  def same_base_numeral_to_float(numeral)
    sign, coefficient, scale = numeral.split
    @context.Num(sign, coefficient, scale)
  end

  def representable_numeral_to_float(numeral)
    value, scale = numeral.to_value_scale
    x = value.to_f
    if scale<0
      x /= Float(numeral.base**-scale)
    else
      x *= Float(numeral.base**scale)
    end
    x
  end

  def near_representable_numeral_to_float(numeral)
    value, scale = numeral.to_value_scale
    j = scale-numeral.digits.size
    x = value.to_f * Float(numeral.base**(j))
    x *= Float(numeral.base**(scale-j))
    x
  end

  def conmensurable_base_numeral_to_float(numeral)
    general_numeral_to_float numeral, :float
  end

  def general_numeral_to_float(numeral, mode)
    sign, coefficient, scale = numeral.split
    reader = Flt::Support::Reader.new(mode: mode)
    if mode == :fixed
      rounding_mode = @context.rounding
    else
      rounding_mode = @rounding_mode
    end
    reader.read(@context, rounding_mode, sign, coefficient, scale, numeral.base).tap do
      # @exact = reader.exact?
    end
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
