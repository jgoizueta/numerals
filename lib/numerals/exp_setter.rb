# Adjust exponent to be used in a Numeral expression;
# break up the numeral into integer, fractional and repeating parts.
#
#   setter = ExpSetter[numeral]
#   # To use 'fixed' format:
#   setter.exponent = 0
#   # To use scientific notation:
#   setter.integer_part_size = 1
#   # To adjust scientific notation to engineering mode:
#   setter.integer_part_size += 1 (while setter.exponent % 3) != 0
#   # To automatically choose between fixed/scientific format:
#   setter.exponent = 0 # fixed
#   if setter.leading_size > 6 || setter.trailing_size > 0
#     setter.integer_part_size = 1 # scientific
#   end
#
#   # To access the numeric parts for formatting:
#   setter.sign
#   setter.integer_part # digits before radix point
#   setter.fractional_part # digits after radix point, before repetition
#   setter.repeating_part  # repeated digits
#   setter.base            # base for exponent
#   setter.exponent        # exponent
#
class ExpSetter

  def initialize(numeral)
    @numeral = numeral
    @integer_part_size = @numeral.point
    @digits = @numeral.digits
    @exponent = 0
    @repeat_size = @numeral.repeating? ? @digits.size - @numeral.repeat : 0
    adjust
  end

  attr_reader :numeral

  include ModalSupport::BracketConstructor
  attr_reader :integer_part_size, :exponent
  attr_reader :trailing_size, :leading_size

  def base
    @numeral.base
  end

  def special?
    @numeral.special?
  end

  def special
    @numeral.special
  end

  def sign
    @numeral.sign
  end

  def exponent=(v)
    if @exponent != v
      @integer_part_size -= (v - @exponent)
      @exponent = v
      adjust
    end
  end

  def integer_part_size=(v)
    if @integer_part_size != v
      @exponent -= (v - @integer_part_size)
      @integer_part_size = v
      adjust
    end
  end

  def repeat_part
    if @numeral.repeating?
      if @repeat_phase != 0
        start = @numeral.repeat + @repeat_phase
        (start...start+repeat_part_size).map{|i| @numeral.digit_value_at(i)}
      else
        @digits[@numeral.repeat..-1]
      end
    else
      []
    end
  end

  def repeat_part_size
    if @numeral.repeating?
      @digits.size - @numeral.repeat
    else
      0
    end
  end

  def fractional_part
    leading + @digits[@fractional_start...@fractional_end]
  end

  def integer_part
    @digits[@integer_start...@integer_end] + trailing
  end

  def fractional_part_size
    @fractional_end - @fractional_start + @leading_size
  end

  private

  def trailing
    if @trailing_size > 0
      (@digits.size...@digits.size+@trailing_size).map{|i| @numeral.digit_value_at(i)}
    else
      []
    end
  end

  def leading
    if @leading_size > 0
      [0]*@leading_size
    else
      []
    end
  end

  def adjust
    if @integer_part_size <= 0
      @leading_size = -@integer_part_size
      @trailing_size = 0
      # integer_part == []
      @integer_start = @integer_end = @digits.size
      @fractional_start = 0
      @fractional_end   = @numeral.repeat || @digits.size
      @repeat_phase = 0
    elsif @integer_part_size >= @digits.size
      @trailing_size = @integer_part_size - @digits.size
      @leading_size = 0
      @integer_start = 0
      @integer_end = @digits.size
      if @numeral.repeating?
        @repeat_phase = @trailing_size % repeat_part_size
        @fractional_start = @fractional_end = @digits.size
      else
        @repeat_phase = 0
        @fractional_start = @fractional_end = @digits.size
      end
    else
      @trailing_size = @leading_size = 0
      @integer_start = 0
      @integer_end   = @integer_part_size
      if @numeral.repeating? && @numeral.repeat < @integer_part_size
        @repeat_phase = (@integer_end - @numeral.repeat) % repeat_part_size
        @fractional_start = @fractional_end = @digits.size
      else
        @repeat_phase = 0
        @fractional_start = @integer_part_size
        @fractional_end   = @numeral.repeat || @digits.size
      end

    end
  end

end
