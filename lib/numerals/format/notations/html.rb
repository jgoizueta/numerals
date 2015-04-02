require 'cgi'

module Numerals

  class Format

    class HtmlNotation < Notation

      def assemble(output, text_parts)
        # 1.23<span style="text-decoration: overline">456</span> &times;10<sup>9</sup>
        # Or alternative: use classes
        # <span class=”numerals-num”>1.23<span class="numerals-rep">456</span> &times;10<span class="numerals-sup">9</span></span>
        # .numerals-rep { text-decoration: overline; }
        # .numerals-sup { vertical-align: super; }
        # TODO: padding
        if text_parts.special?
          output << escape(text_parts.special)
        else
          output << escape(text_parts.sign)
          if format.symbols.base_prefix
            output << format.symbols.base_prefix
          end
          output << escape(text_parts.integer) # or decide here if empty integer part is show as 0?
          if text_parts.show_point?(format)
            output << escape(format.symbols.point)
          end
          output << escape(text_parts.fractional)
          if text_parts.repeat
            output << %(<span style="text-decoration: overline">#{escape(text_parts.repeat)}</span>)
          end
          if format.symbols.base_suffix || format.base != 10
            if format.symbols.base_prefix
              output << format.symbols.base_suffix
            else
              # show base suffix as a subscript
              subscript = format.symbols.base_suffix || base.to_s
º             output << "<sub>#{subscript}</sub>"
            end
          end
          if text_parts.exponent_value != 0 || format.mode.mode == :scientific
            output << "&times;"
            output << escape(text_parts.exponent_base)
            output << "<sup>#{escape(text_parts.exponent)}</sup>"
          end
        end
      end

      private

      def escape(text)
        CGI.escapeHTML(text)
      end

      def unescape(text)
        CGI.unescapeHTML(text)
      end

    end

    define_notation :html, HtmlNotation

  end

end
