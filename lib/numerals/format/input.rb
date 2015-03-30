module Numerals

  # Formatted input implementation
  module Format::Input

    def read(text, options={})
      # TODO: base-scale

      # obtain destination type

      # Alt.1 use Conversion...
      selector = options[:context] || options[:type]
      conversion = Conversions[selector, options[:type_options]]
      raise "Invalid type #{selector.inspect}" unless conversion
      type = conversion.type
      if conversion.is_a?(ContextConversion)
        context = conversion.context
      end

      # Alt.2 require :type arguent
      # type = options[:type]


      input_rounding = @input_rounding || @rounding

      # 1. dissassemble (parse notation): text notation => text parts
      text_parts = Format.disassemble(@notation, self, text)

      if text_parts.special?

        nan = /
                #{@symbols.regexp(:nan, case_sensitivity: true)}
              /x
        inf = /
                #{@symbols.regexp(:plus, :minus, case_sensitivity: true)}?
                \s*
                #{@symbols.regexp(:infinity, case_sensitivity: true)}
              /x
        minus = /#{@symbols.regexp(:minus, case_sensitivity: true)}/
        if nan.match(text_parts.special)
          numeral = Numeral[:nan]
        elsif match = inf.match(text_parts.special)
          if match[1] && match[1] =~ minus
            sign = -1
          else
            sign = +1
          end
          numeral = Numeral[:infinity, sign: sign]
        else
          raise "Invalid number"
        end

      else

        # 2. parse and convert text parts to digit values / other values (sign, exponent...)
        #    @symbols.repeat_suffix found => detect_repeat
        if !@symbols.repeating && (text_parts.repeat || text_parts.detect_repeat)
          raise Format::InvalidRepeatingNumeral, "Invalid format: unexpected repeating numeral"
        end

        minus = /#{@symbols.regexp(:minus, case_sensitivity: true)}/
        if text_parts.sign? && text_parts.sign =~ minus
          sign = -1
        else
          sign = +1
        end

        integer_digits = []
        if text_parts.integer?
          integer_digits = @symbols.digits_values(text_parts.integer, base: @rounding.base)
        end

        fractional_digits = []
        if text_parts.fractional?
          fractional_digits = @symbols.digits_values(text_parts.fractional, base: @rounding.base)
        end

        exponent_value = 0
        if text_parts.exponent?
          exponent_value = text_parts.exponent.to_i
        end

        point = integer_digits.size + exponent_value

        # 3. generate numeral
        if text_parts.detect_repeat? # repeat_suffix found
          digits = integer_digits + fractional_digits
          digits, repeat = RepeatDetector.detect(digits, @symbols.repeat_count - 1)
        elsif text_parts.repeat?
          repeat_digits = @symbols.digits_values(text_parts.repeat, base: @rounding.base)
          digits = integer_digits + fractional_digits
          repeat = digits.size
          digits += repeat_digits
        else
          digits = integer_digits + fractional_digits
          repeat = nil
        end

        if repeat || @exact_input
          normalization = :exact
        else
          normalization = :approximate
        end

        numeral = Numeral[digits, sign: sign, point: point, repeat: repeat, normalize: normalization]
      end

      # 4. Convert to requested type:
      if type == Numeral
        return numeral
      else
        # Alternatives:
        #
        # convert numeral to number with
        # Conversions
        options = {
          exact: numeral.exact?, # @exact_input,
          simplify: @rounding.simplifying?,
          type_options: {
            input_rounding: @input_rounding || @rounding,
          },
          type: options[:type],
          context: options[:context]
        }

        # or, if admitting type_options
        options = options.merge(
          exact: numeral.exact?, # @exact_input,
          simplify: @rounding.simplifying?,
        )
        type_options = { input_rounding: @input_rounding || @rounding }
        if options[:type_options]
          options[:type_options] = options[:type_options].merge(type_options)
        else
          options[:type_options] = type_options
        end

        Conversions.read(numeral, options)
      end

    end

  end

end
