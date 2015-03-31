require 'stringio'

module Numerals

  # Formatted output implementation
  module Format::Output

    def write(number, options={})
      # 1. Convert number to numeral
      numeral = conversion_out(number)
      if numeral.approximate? && !@rounding.free?
        insignificant_digits = @rounding.precision(numeral) - numeral.digits.size
        if insignificant_digits > 0
          numeral.expand! @rounding.precision(numeral)
        end
      end
      return numeral if options[:output] == :numeral
      # 2. Break numeral into parts (digits, etc.)
      num_parts = partition_out(numeral, insignificant_digits: insignificant_digits)
      if !@symbols.repeating && num_parts.repeating?
        raise Format::InvalidRepeatingNumeral, "Invalid format: cannot represent exact value"
      end
      # 3. Represent parts as text
      text_parts = symbolize_out(num_parts)
      # 4. Assemble text parts into output notation
      output = options[:output] || StringIO.new
      assemble_out(output, text_parts)
      options[:output] ? output : output.string
    end

    private

    def digits_text(part, options = {})
      @symbols.digits_text(part, options)
    end

    def grouped_digits_text(part, options = {})
      @symbols.digits_text(part, options.merge(with_grouping: true))
    end

    def conversion_out(number) # => Numeral
      return number if number.kind_of?(Numeral) # @exact_input is ignored
      conversion_options = {
        exact: exact_input,
        rounding: rounding,
        type_options: {
          input_rounding: input_rounding_mode
        }
      }
      Conversions.write(number, conversion_options)
    end

    def partition_out(numeral, options={}) # => num_parts (ExpSetting/BaseScaler)
      num_parts = Format::ExpSetter[numeral, options]
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
        check_trailing = !numeral.repeating?
        if num_parts.leading_size > max_leading ||
           check_trailing && (num_parts.trailing_size > @mode.max_trailing)
          mode = :scientific
        end
      end

      case mode
      when :fixed
        num_parts.exponent = 0
      when :scientific
        if @mode.sci_int_digits == :engineering
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
        num_parts = Format::BaseScaler[num_parts, @mode.base_scale]
      end

      num_parts
    end

    def symbolize_out(num_parts) # => text_parts Hash
      text_parts = TextParts.new(num_parts.numeral)
      if num_parts.special?
        case num_parts.special
        when :nan
          text_parts.special = @symbols.nan
        when :inf
          if num_parts.sign == -1
            text_parts.special = @symbols.negative_infinity
          else
            text_parts.special = @symbols.positive_infinity
          end
        end
      else
        if num_parts.sign == -1
          text_parts.sign = @symbols.minus
        elsif @symbols.show_plus
          text_parts.sign = @symbols.plus
        end
        if num_parts.integer_part.empty?
          if @symbols.show_zero || (num_parts.fractional_part.empty? && !num_parts.repeat_part.empty?)
            text_parts.integer = @symbols.zero
          end
          text_parts.integer_value = 0
        else
          if @symbols.insignificant_digit.nil?
            # we can't just omit integer part symbols
            integer_insignificant_digits = 0
          else
            integer_insignificant_digits = num_parts.integer_insignificant_size
          end
          text_parts.integer = grouped_digits_text(
                                 num_parts.integer_part,
                                 insignificant_digits: integer_insignificant_digits,
                                 base: num_parts.base
                               )
          text_parts.integer_value = Numerals::Digits[num_parts.integer_part, base: num_parts.base].value
        end
        text_parts.fractional = digits_text(
                                  num_parts.fractional_part,
                                  insignificant_digits: num_parts.fractional_insignificant_size,
                                  baseL: num_parts.base
                                )
        if num_parts.repeating?
          text_parts.repeat = digits_text(
                                num_parts.repeat_part,
                                insignificant_digits: num_parts.repeat_insignificant_size,
                                base: num_parts.base
                              )
        end
        text_parts.exponent_value = num_parts.exponent
        # if num_parts.exponent != 0 || @mode.mode == :scientific
          text_parts.exponent = num_parts.exponent.to_s(10) # use digits_definition ?
          if @symbols.show_exponent_plus && num_parts.exponent >= 0
            text_parts.exponent = @symbols.plus + text_parts.exponent
          end
        # end
        text_parts.exponent_base = num_parts.exponent_base.to_s(10) # use digits_definition ?
        text_parts.exponent_base_value = num_parts.exponent_base
      end
      # TODO: justification
      # TODO: base indicator for significand? significand_bas?
      text_parts
    end

    def assemble_out(output, text_parts)
      Format.assemble(@notation, output, self, text_parts)
    end

  end

end
