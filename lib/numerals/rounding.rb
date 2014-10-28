# Rounding of Numerals
class Rounding

  # Rounding is defined by the rounding mode and the precision,
  # and is used to stablish the desired accuracy of a Numeral result.
  #
  # The rounding mode may be any of the valid Flt rounding modes
  # (:half_even, :half_down, :half_up, :floor, :ceiling, :down, :up or :up05)
  # or :exact for no rounding at all (to represent the situation where
  # we want to get an exact numeral result.
  #
  # The precision may be defined either as a relative :precision value
  # (number of significant digits of the result numeral) or as an :absolute
  # :places that indicate the number of digits to the right of the fractional
  # point. Negative values of :places will round to digits in integral positions.
  #
  # The base of the numerals to be rounded must also be defined (10 by default)
  #
  def initialize(*args)
    if Hash === args.last
      options = args.pop
    else
      options = {}
    end
    args.each do |arg|
      if Symbol === arg
        options[:mode] = arg
      elsif Integer === arg
        options[:precision] = arg
      else
        raise "Invalid Rounding definition"
      end
    end
    @mode = options[:mode] || :half_even
    if @mode == :exact
      @precision = @places = 0
    end
    @precision = options[:precision]
    @places = options[:places]
    @base = options[:base] || 10
    if @precision == 0
      @mode = :exact
    end
  end

  include ModalSupport::BracketConstructor
  include ModalSupport::StateEquivalent

  def parameters
    if exact?
      { mode: :exact }
    elsif relative?
      { mode: @mode, precision: @precision }
    elsif absolute?
      { mode: @mode, places: @places }
    end
  end

  def to_s
    if exact?
      "Rounding[:exact]"
    elsif relative?
      "Rounding[#{@mode.inspect}, precision: #{@precision}]"
    elsif absolute?
      "Rounding[#{@mode.inspect}, places: #{@places}]"
    end
  end

  def inspect
    to_s
  end

  def exact?
    @mode == :exact
  end

  def absolute?
    !exact? && !@precision
  end

  def relative?
    !exact? && !absolute?
  end

  # Number of significant digits for a given numerical/numeral value
  def precision(value)
    if relative? || exact?
      @precision
    else
      @places + num_integral_digits(value)
    end
  end

  # Number of fractional placesfor a given numerical/numeral value
  def places(value)
    if absolute? || exact?
      @places
    else
      @precision - num_integral_digits(value)
    end
  end

  # Round a numeral. If the numeral has been truncated
  # the :round_up option must be used to pass the information
  # about the discarded digits:
  # * nil if all discarded digits where 0 (the truncated value is exact)
  # * :lo if there where non-zero discarded digits, but the first discarded digit
  #   is below half the base.
  # * :tie if the first discarded was half the base and there where no more nonzero digits,
  #   i.e. the original value was a 'tie', exactly halfway between the truncated value
  #   and the next value with the same number of digits.
  # * :hi if the original value was above the tie value.
  def round(numeral, options={})
    round_up = options[:round_up]
    numeral, round_up = truncate(numeral, round_up)
    adjust(numeral, round_up)
  end

  private

  def check_base(numeral)
    if numeral.base != @base
      raise "Invalid Numeral (base #{numeral.base}) for a base #{@base} Rounding"
    end
  end

  # Truncate a numeral and return also a round_up value with information about
  # the digits beyond the truncation point that can be used to round the truncated
  # numeral. If the numeral has already been truncated, the round_up result of
  # that truncation should be passed as the second argument.
  def truncate(numeral, round_up=nil)
    check_base numeral
    if exact?
      round_up = nil
    else
      n = precision(numeral)
      unless n==numeral.digits.size && numeral.approximate?
        if n < numeral.digits.size - 1
          rest_digits = numeral.digits[n+1..-1]
        else
          rest_digits = []
        end
        if numeral.repeating? && numeral.repeat < numeral.digits.size && n >= numeral.repeat
          rest_digits += numeral.digits[numeral.repeat..-1]
        end
        digits = numeral.digits[0, n]
        if digits.size < n
          digits += (digits.size...n).map{|i| numeral.digit_value_at(i)}
        end
        if numeral.base % 2 == 0
          tie_digit = numeral.base / 2
          max_lo = tie_digit - 1
        else
          max_lo = numeral.base / 2
        end
        next_digit = numeral.digit_value_at(n)
        if next_digit == 0
          unless round_up.nil? && rest_digits.all?{|d| d == 0}
            round_up = :lo
          end
        elsif next_digit <= max_lo # next_digit < tie_digit
          round_up = :lo
        elsif next_digit == tie_digit
          if round_up || rest_digits.any?{|d| d != 0}
            round_up = :hi
          else
            round_up = :tie
          end
        else # next_digit > tie_digit
          round_up = :hi
        end
        numeral = Numeral[digits, point: numeral.point, sign: numeral.sign, normalize: :approximate]
      end
    end
    [numeral, round_up]
  end

  # Adjust a truncated numeral using the round-up information
  def adjust(numeral, round_up)
    check_base numeral
    point, digits = Flt::Support.adjust_digits(
      numeral.point, numeral.digits.digits_array,
      round_mode: @mode,
      negative: numeral.sign == -1,
      round_up: round_up,
      base: numeral.base
    )
    Numeral[digits, point: point, base: numeral.base, sign: numeral.sign, normalize: :approximate]
  end

  ZERO_DIGITS = 0 # 1?

  # Number of digits in the integer part of the value (excluding leading zeros).
  def num_integral_digits(value)
    case value
    when 0
      ZERO_DIGITS
    when Numeral
      if value.zero?
        ZERO_DIGITS
      else
        if @base != value.base
          value = value.to_base(@base)
        end
        value.normalized(remove_trailing_zeros: true).point
      end
    else
      Conversions.order_of_magnitude(value, base: @base)
    end
  end

end
