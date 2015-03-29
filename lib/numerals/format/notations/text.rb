module Numerals

  class Format

    class TextNotation < Notation

      def assemble(output, text_parts)
        if text_parts.special?
          output << text_parts.special
        else
          output << text_parts.sign
          output << text_parts.integer # or decide here if empty integer part is show as 0?
          unless !text_parts.fractional? &&
                 !text_parts.repeat? &&
                 !format.symbols.show_point
            output << format.symbols.point
          end
          output << text_parts.fractional
          if text_parts.repeat?
            if format.symbols.repeat_delimited
              output << format.symbols.repeat_begin
              output << text_parts.repeat
              output << format.symbols.repeat_end
            else
              n = RepeatDetector.min_repeat_count(
                    text_parts.numeral.digits.digits_array,
                    text_parts.numeral.repeat,
                    format.symbols.repeat_count - 1
                  )
              n.times do
                output << text_parts.repeat
              end
              output << format.symbols.repeat_suffix
            end
          end
          if text_parts.exponent_value != 0 || format.mode.mode == :scientific
            output << format.symbols.exponent
            output << text_parts.exponent
          end
        end
      end

      def disassemble(input, text)
        text_parts = TextParts.new
        s = format.symbols
        special = /#{s.regexp(:plus, :minus)}?\s*#{s.regexp(:nan, :infinity)}/i
        if match = special.match(text)
          text_parts.special = "#{match[1]}#{match[2]}"
        else
          valid = true
          # TODO: the i (ignore case) option conflicts with the case handling of digits...
          # TODO: replace numbered groups by named variables ?<var>
          regular = /
            #{s.regexp(:plus, :minus)}?
            \s*
            (#{s.regexp(:grouped_digits, base: format.base, no_capture: true)})*
            #{s.regexp(:point)}?
            #{s.regexp(:digits, base: format.base)}?
            (?:#{s.regexp(:repeat_begin)}#{s.regexp(:digits, base: format.base)}#{s.regexp(:repeat_end)})?
            #{s.regexp(:repeat_suffix)}?
            (?:#{s.regexp(:exponent)}#{s.regexp(:plus, :minus)}\d+)
          /xi
          match = regular.match(text)

          if match.nil?
            valid = false
          else
            sign = match[1]
            integer_part = match[2]
            point = match[3]
            fractional_part = match[4]
            repeat_begin = match[5]
            repeat_part = match[6]
            repeat_end = match[7]
            repeat_suffix = match[8]
            exponent = match[9]
            exponent_sign = match[10]
            exponent_value = match[11]

            text_parts.sign = sign
            text_parts.integer = integer_part
            text_parts.fractional = fractional_part

            if repeat_begin
              if !repeat_part || !repeat_end || repeat_suffix
                valid = false
              end
              text_parts.repeat = repeat_part
            else
              if repeat_part || repeat_end
                valid = false
              end
              if repeat_suffix
                text_parts.detect_repeat = true
              end
            end

            if exponent
              if !exponent_value
                valid = false
              end
              text_parts.exponent = "#{exponent_sign}#{exponent}"
              text_parts.exponent_value = text_parts.exponent.to_i
            else
              if exponen_sign || exponent_value
                valid = false
              end
            end
          end
        end
        raise "Invalid text numeral" unless valid
        text_parts
      end

    end

    define_notation :text, TextNotation

  end

end
