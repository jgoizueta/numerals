module Numerals


  class Format

    @assemblers = {}

    def self.output_assembler(id, &blk)
      @assemblers[id] = blk
    end

    def self.assemble(id, output, format, text_parts)
      assembler = @assemblers[id]
      if assembler
        assembler[output, format, text_parts]
      else
        raise "Unknown output assembler #{id.inspect}"
      end
    end

  end

end

# TODO: in separate files format/assemblers/text.rb etc

Numerals::Format.output_assembler :text do |output, format, text_parts|
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

Numerals::Format.output_assembler :latex do |output, format, text_parts|
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

Numerals::Format.output_assembler :html do |output, format, text_parts|
  # 1.23<span style="text-decoration: overline">456</span> &times;10<sup>9</sup>
  # Or alternative: use classes
  # <span class=”numerals-num”>1.23<span class="numerals-rep">456</span> &times;10<span class="numerals-sup">9</span></span>
  # .numerals-rep { text-decoration: overline; }
  # .numerals-sup { vertical-align: super; }
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
    if text_parts.repeat
      output << %(<span style="text-decoration: overline">#{text_parts.repeat}</span>)
    end
    if text_parts.exponent_value != 0 || format.mode.mode == :scientific
      output << "&times;"
      output << text_parts.exponent_base
      output << "<sup>#{text_parts.exponent}</sup>"
    end
  end
end
