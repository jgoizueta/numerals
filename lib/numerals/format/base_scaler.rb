require 'forwardable'

module Numerals

  # This converts the number representation contained in an ExpSetter
  # scaling the base of the significand.
  #
  # This is typically used when the ExpSetter base is 2 to render the number
  # in C99 '%A' format, i.e., in hexadecimal base. Only the significand is
  # shown in base 16; the exponent is still a power of two, and represented
  # in base 10.
  #
  # This is a generalization of the %A format where any base which is a
  # power of the original base can be used for the significand.
  #
  # The number exponent is previously adjusted in the ExpSetter and that
  # doesn't change, only the significand parts are converted from the
  # original base `base` to the new base `base**base_scale`.
  #
  # This will require adjusting the repeating digits position and length,
  # and adding leading 0s (in the original base) to the signficant
  # and/or trailing digits may be required.
  #
  class Format::BaseScaler

    def initialize(exp_setter, base_scale)
      @setter = exp_setter
      @numeral = @setter.numeral
      @base_scale = base_scale
      @scaled_base = @setter.base**@base_scale
      adjust
    end

    include ModalSupport::BracketConstructor

    attr_reader :base_scale, :scaled_base, :numeral

    extend Forwardable
    def_delegators :@setter,
                   :exponent_base, :exponent, :special?, :special,
                   :repeating?, :sign

    def base
      scaled_base
    end

    def fractional_part
      ungrouped = @setter.fractional_part + (0...@scaling_trailing_size).map{|i| repeat_digit(i)}
      grouped_digits ungrouped
    end

    def fractional_part_size
      (@setter.fractional_part_size + @scaling_trailing_size)/@base_scale
    end

    def fractional_insignificant_size
      if @setter.numeral.approximate?
        (@setter.fractional_insignificant_size + @scaling_trailing_size)/@base_scale
      else
        0
      end
    end

    def integer_part
      ungrouped = [0]*@scaling_leading_size + @setter.integer_part
      grouped_digits ungrouped
    end

    def integer_part_size
      (@setter.integer_part_size + @scaling_leading_size)/@base_scale
    end

    def integer_insignificant_size
      if @setter.numeral.approximate?
        (@setter.integer_insignificant_size + @scaling_leading_size)/@base_scale
      else
        0
      end
    end

    def repeat_size_size
      @repeat_length/@base_scale
    end

    def repeat_insignificant_size
      0
    end

    def repeat_part
      ungrouped = (@scaling_trailing_size...@scaling_trailing_size+@repeat_length).map{|i| repeat_digit(i)}
      grouped_digits ungrouped
    end

    private

    # Return the `scaled_base` digit corresponding to a group of `base_scale` `exponent_base` digits
    def scaled_digit(group)
      unless group.size == @base_scale
        raise "Invalid digits group size for scaled_digit (is #{group.size}; should be #{@base_scale})"
      end
      v = 0
      group.each do |digit|
        v *= @setter.base
        v += digit
      end
      v
    end

    # Convert base `exponent_base` digits to base `scaled_base` digits
    # the number of digits must be a multiple of base_scale
    def grouped_digits(digits)
      unless (digits.size % @base_scale) == 0
        raise "Invalid number of digits for group_digits (#{digits.size} is not a multiple of #{@base_scale})"
      end
      digits.each_slice(@base_scale).map{|group| scaled_digit(group)}
    end

    # Number of digits (base `exponent_base`) to be added to make the number
    # of digits a multiple of `base_scale`.
    def padding_size(digits_size)
      (@base_scale - digits_size) % @base_scale
    end

    def adjust
      return if special?
      @setter_repeat_part = @setter.repeat_part
      @setter_repeat_part_size = @setter.repeat_part_size

      @scaling_trailing_size =  padding_size(@setter.fractional_part_size)
      @scaling_leading_size = padding_size(@setter.integer_part_size)

      @repeat_length = @setter.repeat_part_size
      while (@repeat_length % @base_scale) != 0
        @repeat_length += @setter.repeat_part_size
      end
    end

    def repeat_digit(i)
      if @setter_repeat_part_size > 0
        @setter_repeat_part[i % @setter_repeat_part_size]
      else
        0
      end
    end

    # Convert base digits to scaled base digits
    def self.ugrouped_digits(digits, base, base_scale)
      digits.flat_map { |d|
        group = Numeral::Digits[base: base]
        group.value = d
        ungrouped = group.digits_array
        if ungrouped.size < base_scale
          ungrouped = [0]*(base_scale - ungrouped.size) + ungrouped
        end
        ungrouped
      }
    end
  end

end
