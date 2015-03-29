module Numerals

  class Format

    class LatexNotation < Notation

      def assemble(output, text_parts)
        # 1.23\overline{456}\times10^{9}
        if text_parts.special?
          output << text_parts.special
        else
          output << text_parts.sign
          output << text_parts.integer # or decide here if empty integer part is shown as 0?
          unless !text_parts.fractional? &&
                 !text_parts.repeat? &&
                 !format.symbols.show_point
            output << format.symbols.point
          end
          output << text_parts.fractional
          if text_parts.repeat?
            output << "\\overline{#{text_parts.repeat}}"
          end
          if text_parts.exponent_value != 0 || format.mode.mode == :scientific
            output << "\\times"
            output << text_parts.exponent_base
            output << "^"
            output << "{#{text_parts.exponent}}"
          end
        end
      end

      private

      def escape(text)
        text.gsub('\\', '\\\\')
      end

      def unescape(text)
        text.gsub('\\\\', '\\')
      end

    end

    define_notation :latex, LatexNotation

  end

end
