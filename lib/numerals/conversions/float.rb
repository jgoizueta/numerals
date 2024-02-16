require 'numerals/conversions/context_conversion'

class Numerals::FloatConversion < Numerals::ContextConversion

  # Options:
  #
  # * :input_rounding (optional, a non-exact Rounding or rounding mode)
  #   which is used when input is approximate as the assumed rounding
  #   mode which would be used so that the result numeral rounds back
  #   to the input number
  #
  def initialize(options={})
    super Float, options
  end

  def order_of_magnitude(value, options={})
    base = options[:base] || 10 # @contex.radix
    if base == 10
      Math.log10(value.abs).floor + 1
    else
      (Math.log(value.abs)/Math.log(base)).floor + 1
    end
  end

  def number_of_digits(value, options={})
    base = options[:base] || 10
    if base == @context.radix
      @context.precision
    else
      @context.necessary_digits(base)
    end
  end

  def exact?(value, options={})
    options[:exact]
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

  def write(number, exact_input, output_rounding)
    output_base = output_rounding.base
    input_base = @context.radix

    if @context.special?(number)
      special_float_to_numeral number
    elsif exact_input
      if output_base == input_base && output_rounding.free?
        # akin to number.format(base: output_base, simplified: true)
        general_float_to_numeral number, output_rounding, false
      else
        # akin to number.format(base: output_base, exact: true)
        exact_float_to_numeral number, output_rounding
      end
    else
      if output_base == input_base && output_rounding.preserving?
        # akin to number.format(base: output_base)
        sign, coefficient, exp = @context.split(number)
        Numerals::Numeral.from_coefficient_scale(
          sign*coefficient, exp,
          approximate: true, base: output_base
        )
      elsif output_rounding.simplifying?
        # akin to number.forma(base: output_base, simplify: true)
        general_float_to_numeral number, output_rounding, false
      else
        # akin to number.forma(base: output_base, all_digits: true)
        general_float_to_numeral number, output_rounding, true
      end
    end
  end

  def read(numeral, exact_input, approximate_simplified)
    if numeral.special?
      special_numeral_to_float numeral
    # elsif numeral.approximate? && !exact_input
    #   if approximate_simplified
    #     # akin to @context.Num(numeral_text, :short)
    #     short_numeral_to_float numeral
    #   else
    #     # akin to @context.Num(numeral_text, :free)
    #     free_numeral_to_float numeral
    #   end
    else
      # akin to @context.Num(numeral_text, :fixed)
      fixed_numeral_to_float numeral
    end
  end

  private

  def special_float_to_numeral(x)
    if x.nan?
      Numerals::Numeral.nan
    elsif x.infinite?
      Numerals::Numeral.infinity @context.sign(x)
    end
  end

  def exact_float_to_numeral(number, rounding)
    quotient = number.to_r
    numeral = Numerals::Numeral.from_quotient(quotient, base: rounding.base)
    unless rounding.free?
      numeral = rounding.round(numeral)
    end
    numeral
  end

  def approximate_float_to_numeral(number, rounding)
    all_digits = !rounding.free?
    general_float_to_numeral(number, rounding, all_digits)
  end

  def general_float_to_numeral(x, rounding, all_digits)
    sign, coefficient, exponent = @context.split(x)
    precision = @context.precision
    output_base = rounding.base

    # here rounding_mode is not the output rounding mode, but the rounding mode used for input
    rounding_mode = (@input_rounding || rounding).mode

    formatter = Flt::Support::Formatter.new(
      @context.radix, @context.etiny, output_base, raise_on_repeat: false
    )
    formatter.format(
      x, coefficient, exponent, rounding_mode, precision, all_digits
    )

    dec_pos, digits = formatter.digits
    rep_pos = formatter.repeat

    normalization = :approximate

    numeral = Numerals::Numeral[digits, sign: sign, point: dec_pos, rep_pos: rep_pos, base: output_base,
                                normalize: normalization]

    numeral = rounding.round(numeral, round_up: formatter.round_up)

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
    return exact_numeral_to_float(numeral) if numeral.exact?
    if numeral.base == @context.radix
      same_base_numeral_to_float numeral
    else
      # representable_digits: number of numeral.base digits that can always be converted to Float and back
      # to a numeral preserving its value.
      representable_digits = @context.representable_digits(numeral.base)
      k = numeral.scale
      if !@input_rounding && numeral.digits.size <= representable_digits && k.abs <= representable_digits
        representable_numeral_to_float numeral
      elsif !@input_rounding && (k > 0 && numeral.point < 2*representable_digits)
        near_representable_numeral_to_float numeral
      elsif numeral.base.modulo(@context.radix) == 0
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

  def short_numeral_to_float(numeral)
    # raise "Invalid Conversion" # Float does not support short (arbitrary precision)
    # fixed_numeral_to_float numeral
    general_numeral_to_float numeral, :short
  end

  def same_base_numeral_to_float(numeral)
    sign, coefficient, scale = numeral.split
    @context.Num(sign, coefficient, scale)
  end

  def representable_numeral_to_float(numeral)
    value, scale = numeral.to_value_scale
    x = value.to_f
    if scale < 0
      x /= Float(numeral.base**-scale)
    else
      x *= Float(numeral.base**scale)
    end
    x
  end

  def near_representable_numeral_to_float(numeral)
    value, scale = numeral.to_value_scale
    j = scale - numeral.digits.size
    x = value.to_f * Float(numeral.base**(j))
    x *= Float(numeral.base**(scale - j))
    x
  end

  def conmensurable_base_numeral_to_float(numeral)
    general_numeral_to_float numeral, :fixed
  end

  def general_numeral_to_float(numeral, mode)
    sign, coefficient, scale = numeral.split
    reader = Flt::Support::Reader.new(mode: mode)
    if @input_rounding
      rounding_mode = @input_rounding.mode
    else
      rounding_mode = @context.rounding
    end
    reader.read(@context, rounding_mode, sign, coefficient, scale, numeral.base).tap do
      # @exact = reader.exact?
    end
  end

end

def Float.numerals_conversion(options = {})
  Numerals::FloatConversion.new(options)
end

class <<Float.context
  def numerals_conversion(options = {})
    Numerals::FloatConversion.new(options)
  end
end
