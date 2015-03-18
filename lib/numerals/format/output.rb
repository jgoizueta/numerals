require 'stringio'

module Numerals

  class Format
  end

  # Formatted output implementation
  module Format::Output

    def write(number, options={})
      numeral = conversion_out(number)
      num_parts = partition_out(numeral)
      text_parts = symbolize_out(num_parts)
      output = options[:output] || StringIO.new
      assemble_out(output, text_parts)
      options[:output] ? output : output.string
    end

    private

    def digits_text(part, base)
      @symbols.digits_text(part, base: base)
    end

    def grouped_digits_text(part, base)
      @symbols.digits_text(part, base: base, with_grouping: true)
    end

    def conversion_out(number) # => Numeral
      conversion_options = { exact: exact_input, rounding: rounding }
      Conversions.write(number, conversion_options)
    end

    def partition_out(numeral) # => num_parts (ExpSetting/BaseScaler)
      num_parts = Format::ExpSetter[numeral]
      return num_parts if numeral.special?
      mode = @mode.mode
      if mode == :general
        mode = :fixed
        if @mode.max_leading == :all
          if numeral.repeating?
            max_leading = 0
          else
            max_leading = @rounding.precision(numeral) - numeral.digits.size
          end
        else
          max_leading = @mode.max_leading
        end
        if num_parts.leading_size > max_leading || num_parts.trailing_size > @mode.max_trailing
          mode = :scientific
        end
      end

      case mode
      when :fixed
        num_parts.exponent = 0
      when :scientific
        if @mode.sci_int_digits == :eng
          num_parts.integer_part_size = 1
          num_parts.integer_part_size += 1 while (num_parts.exponent % 3) != 0
        elsif @mode.sci_int_digits == :all
          raise "Cannot represent number with integral significand" if numeral.repeating?
          num_parts.integer_part_size = numeral.digits.size
        else
          num_parts.integer_part_size = @mode.sci_int_digits
        end
      end
      if @mode.base_scale > 1 && !num_parts.special?
        num_parts = BaseScale[num_parts, @mode.base_scale]
      end

      num_parts
    end

    def symbolize_out(num_parts) # => text_parts Hash
      text_parts = TextParts.new
      if num_parts.special?
        case num_parts.special
        when :nan
          text_parts.special = @symbols.nan
        when :infinity
          if num_parts.sign == -1
            text_parts.special = @symbols.negative_infinity
          else
            text_parts.special = @symbols.positive_infinity
          end
        end
      else
        if num_parts.sign == -1
          text_part.sign = @symbols.minus
        elsif @symbols.show_plus
          text_parts.sign = @symbols.plus
        end
        if num_parts.integer_part.empty?
          if @symbols.show_zero || (num_parts.fractional_part.empty? && !num_parts.repeat_part.empty?)
            text_parts.integer = @symbols.zero
          end
          text_parts.integer_value = 0
        else
          text_parts.integer = grouped_digits_text(num_parts.integer_part, num_parts.base)
          text_parts.integer_value = Numerals::Digits[num_parts.integer_part, base: num_parts.base].value
        end
        text_parts.fractional = digits_text(num_parts.fractional_part, num_parts.base)
        if num_parts.repeating?
          text_parts.repeat = digits_text(num_parts.repeat_part, num_parts.base)
        end
        text_parts.exponent_value = num_parts.exponent
        # if num_parts.exponent != 0 || @mode.mode == :scientific
          text_parts.exponent = num_parts.exponent.to_s(10) # use digits_definition ?
        # end
        text_parts.exponent_base = num_parts.exponent_base.to_s(10) # use digits_definition ?
        text_parts.exponent_base_value = num_parts.exponent_base
      end
      # TODO: justification
      # TODO: base indicator for significand? significand_bas?
      text_parts
    end

    def assemble_out(output, text_parts)
      Format.assemble(@assembler, output, self, text_parts)
    end

  end

end
