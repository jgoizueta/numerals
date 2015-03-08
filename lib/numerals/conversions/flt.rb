require 'numerals/conversions'
require 'flt'

class Numerals::FltConversion

  def initialize(context_or_type)
    if Class === context_or_type && context_or_type < Flt::Num
      @type = context_or_type
      @context = @type.context
    elsif Flt::Num::ContextBase === context_or_type
      @context = context_or_type
      @type = @context.num_class
    else
      raise "Invalid FltConversion definition"
    end
    # @rounding_mode is used for :free numeral to number conversion
    # and should be the implied rounding mode of the invers conversion
    # (number to numeral);
    # TODO: it should be possible to assign it for higher level
    # formatting handling.
    @rounding_mode = @context.rounding
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

  # mode is either :exact or :approximate
  def number_to_numeral(number, mode, rounding)
    if number.special? # @context.special?(number)
      special_num_to_numeral(number)
    else
      if mode == :exact
        exact_num_to_numeral number, rounding
      else # mode == :approximate
        approximate_num_to_numeral(number, rounding)
      end
    end
  end

  def numeral_to_number(numeral, mode)
    if numeral.special?
      special_numeral_to_num numeral
    elsif mode == :fixed
      fixed_numeral_to_num numeral
    else # mode == :free
      free_numeral_to_num numeral
    end
  end

  def write(number, exact_input, output_rounding)
    output_base = output_rounding.base
    input_base = @context.radix

    if number.special? # @context.special?(number)
      special_num_to_numeral number
    elsif exact_input
      if output_base == input_base
        # akin to number.format(base: output_base, simplified: true)
        if true
          # ALT.1 just like approximate :simplify
          general_num_to_numeral number, output_rounding, false
        else
          # ALT.2 just like different bases
          exact_num_to_numeral number, output_rounding
        end
      else
        # akin to number.format(base: output_base, exact: true)
        exact_num_to_numeral number, output_rounding
      end
    else
      if output_base == input_base && output_rounding.preserving?
        # akin to number.format(base: output_base)
        Numeral.from_coefficient_scale number.sign*number.coefficient, number.integral_exponent, approximate: true
      elsif output_rounding.simplifying?
        # akin to number.forma(base: output_base, simplify: true)
        general_num_to_numeral number, output_rounding, false
      else
        # akin to number.forma(base: output_base, all_digits: true)
        general_num_to_numeral number, output_rounding, true
      end
    end
  end

  def read(numeral, exact_input, approximate_simplified)
    if numeral.special?
      special_numeral_to_num numeral
    elsif numeral.approximate? && !exact_input
      if approximate_simplified
        # akin to @context.Num(numeral_text, :short)
        short_numeral_to_num numeral
      else
        # akin to @context.Num(numeral_text, :free)
        free_numeral_to_num numeral
      end
    else
      # akin to @context.Num(numeral_text, :fixed)
      fixed_numeral_to_num numeral
    end
  end

  private

  def special_num_to_numeral(x)
    if x.nan?
      Numeral.nan
    elsif x.infinite?
      Numeral.infinity @context.sign(x)
    end
  end

  def exact_num_to_numeral(number, rounding)
    quotient = number.to_r
    numeral = Numerals::Numeral.from_quotient(quotient, base: rounding.base)
    unless rounding.exact?
      numeral = rounding.round(numeral)
    end
    numeral
  end

  def approximate_num_to_numeral(number, rounding)
    all_digits = !rounding.exact?
    general_num_to_numeral(number, rounding, all_digits)
  end

  def general_num_to_numeral(x, rounding, all_digits)
    sign, coefficient, exponent = x.split # @context.split(x)
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
    numeral = Numerals::Numeral[digits, sign: sign, point: dec_pos, rep_pos: formatter.repeat, base: output_base]
    if all_digits
      numeral = rounding.round(numeral, round_up: formatter.round_up)
    end
    numeral
  end

  def special_numeral_to_num(numeral)
    case numeral.special
    when :nan
      @context.nan
    when :inf
      @context.infinity numeral.sign
    end
  end

  def fixed_numeral_to_num(numeral)
    # consider:
    # return exact_numeral_to_num(numeral) if numeral.exact?
    if numeral.base == @context.radix
      numeral = numeral.approximate(@context.precision) unless @context.exact?
      same_base_numeral_to_num numeral
    else
      general_numeral_to_num numeral, :fixed
    end
  end

  def same_base_numeral_to_num(numeral)
    sign, coefficient, scale = numeral.split
    @context.Num sign, coefficient, scale
  end

  def exact_numeral_to_num(numeral)
    @context.Num Rational(*numeral.to_quotient), :fixed
  end

  def free_numeral_to_num(numeral)
    general_numeral_to_num numeral, :free
  end

  def short_numeral_to_num(numeral)
    general_numeral_to_num numeral, :short
  end

  def general_numeral_to_num(numeral, mode)
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

def (Flt::Num).numerals_conversion
  Numerals::FltConversion.new(self)
end

class Flt::Num::ContextBase
  def numerals_conversion
    Numerals::FltConversion.new(self)
  end
end
