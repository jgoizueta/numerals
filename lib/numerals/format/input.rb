module Numerals

  # Formatted input implementation
  module Format::Input

    def read(text, options={})
      # TODO: implement
      return nil

      # obtain destination type

      # Alt.1 use Conversion...
      selector = options[:context] || options[:type]
      conversion = Conversions[selector, options[:type_options]]
      type = conversion.type
      if conversion.is_a?(ContextConversion)
        context = conversion.context
      end

      # Alt.2 require :type arguent
      type = options[:type]


      input_rounding = @input_rounding || @rounding

      # 1. dissassemble (parse notation): text notation => text parts
      text_parts = Format.disassemble(@notation, self, text)

      # 2. parse and convert text parts to digit values / other values (sign, exponent...)
      #    @symbols.repeat_suffix found => detect_repeat
      if !@symbols.repeating && text_parts.repeat || text_parts.detect_repeat
        raise Format::InvalidRepeatingNumeral, "Invalid format: unexpected repeating numeral"
      end

      # 3. generate numeral
      if text_parts.detect_repeat # repeat_suffix found
        # 3A) convert to digit sequence or numeral, then detect repeats with RepeatDetector, generate numeral
      elsif text_parts.repeat
        # 3B) explicit repeat => convert parts to numeral with repeat set
      else
        # 3C) generate nonrepeating numeral
      end
      # based on @exact_input (and repetition presence?), the generated
      # numeral should be either exact or approximate

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
