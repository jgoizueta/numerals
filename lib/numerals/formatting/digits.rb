module Numerals

  # Digits definition (symbols used as digits)
  class DigitsDefinition
    include ModalSupport::StateEquivalent
    include ModalSupport::BracketConstructor

    DEFAULT_DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    DEFAULT_BASE   = 10

    def initialize(*args)
      if String === args.first
        digits = args.shift
      end
      options = args.shift || {}
      raise NumeralError, "Invalid DigitsDefinition" unless args.empty? && Hash === options
      digits ||= options[:digits]
      base = options[:base]
      if base
        if digits
          raise NumeralError, "Inconsistent DigitsDefinition" unless digits.size == base
        end
      elsif digits
        base = digits.size
      else
        base = DEFAULT_BASE
      end
      digits ||= DEFAULT_DIGITS[0, base]

      @radix = base
      @digits = digits
      @case_sensitive = options[:case_sensitive]
      @downcase = options[:downcase] || (@digits.downcase == @digits)
      @digits = @digits.downcase if @downcase
    end

    def is_digit?(digit)
      digit = set_case(digit)
      @digits.include?(digit)
    end

    def digit_value(digit)
      digit = set_case(digit)
      @digits.index(digit)
    end

    def digit_char(v)
      v >= 0 && v < @radix ? @digits[v] : nil
    end

    def radix
      @radix
    end

    def valid?
      @digits.none?{|x| x.nil? || x<0 || x>=@radix}
    end

    private

    def set_case(digit_char)
      if digit_char
        unless @case_sensitive
          if @downcase
            digit_char = digit_char.downcase
          else
            digit_char = digit_char.upcase
          end
        end
      end
      digit_char
    end
  end

end
