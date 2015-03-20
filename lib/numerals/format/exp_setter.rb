module Numerals

  class Format
  end

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
  class Format::ExpSetter

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

    def exponent_base
      base
    end

    def special?
      @numeral.special?
    end

    def special
      @numeral.special
    end

    def repeating?
      @numeral.repeating?
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
        if @repeat_phase != 0 || @numeral.repeat < 0
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
      n = @leading_size
      if @fractional_end < @fractional_start
        n += @fractional_end - @fractional_start
      end
      if n > 0
        [0]*n
      else
        []
      end
    end

    def adjust
      if special?
        @leading_size = @trailing_size = 0
        @integer_start = @integer_end = 0
        @fractional_start = @fractional_end = 0
        @repeat_phase = 0
      elsif @integer_part_size <= 0
        @trailing_size = 0
        # integer_part == []
        @integer_start = @integer_end = @digits.size
        if !@numeral.repeating? || @numeral.repeat >= 0 || @integer_part_size >= @numeral.repeat
          @leading_size = -@integer_part_size
          @fractional_start = 0
          if @numeral.repeat
            if @numeral.repeat >= 0
              @fractional_end  = @numeral.repeat
            else
              @fractional_end = @digits.size
            end
          else
            @fractional_end = @digits.size
          end
          @repeat_phase = 0
        else
          @leading_size = @numeral.repeat - @integer_part_size
          @trailing_size = 0
          @fractional_start = @fractional_end = @digits.size
          @repeat_phase = 0
        end
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

end
