module Numerals

  class Format::Symbols::Digits < FormattingAspect

    DEFAULT_DIGITS = %w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

    def initialize(*args)
      @digits = DEFAULT_DIGITS
      @downcase_digits = @digits.map(&:downcase)
      @max_base = @digits.size
      @case_sensitive = false
      @uppercase = false
      @lowercase = false
      set!(*args)
    end

    include ModalSupport::StateEquivalent

    set do |*args|
      options = extract_options(*args)
      options.each do |option, value|
        send :"#{option}=", value
      end
    end

    attr_reader :digits_string, :max_base, :case_sensitive, :uppercase, :lowercase
    attr_writer :case_sensitive

    def digits(options = {})
      base = options[:base] || @max_base
      if base >= @max_base
        @digits
      else
        @digits[0, base]
      end
    end

    def digits=(digits)
      if digits.is_a?(String)
        @digits = digits.each_char.to_a
      else
        @digits = digits
      end
      @max_base = @digits.size
      @lowercase = @digits.all? { |d| d.downcase == d }
      @uppercase = @digits.all? { |d| d.upcase == d }
      @downcase_digits = @digits.map(&:downcase)
      if @digits.uniq.size != @max_base
        raise "Inconsistent digits"
      end
    end

    def uppercase=(v)
      @uppercase = v
      self.digits = @digits.map(&:upcase) if v
    end

    def lowercase=(v)
      @lowercase = v
      self.digits = @digits.map(&:downcase) if v
    end

    def case_sensitive?
      case_sensitive
    end

    def is_digit?(digit_symbol, options={})
      base = options[:base] || @max_base
      raise "Invalid base" if base > @max_base
      v = digit_value(digit_symbol)
      v && v < base
    end

    def digit_value(digit)
      if @case_sensitive
        @digits.index(digit)
      else
        @downcase_digits.index(digit.downcase)
      end
    end

    def digit_symbol(v, options={})
      base = options[:base] || @max_base
      raise "Invalid base" if base > @max_base
      v >= 0 && v < base ? @digits[v] : nil
    end

    # Convert sequence of digits to its text representation.
    # The nil value can be used in the digits sequence to
    # represent the group separator.
    def digits_text(digit_values, options={})
      insignificant_digits = options[:insignificant_digits] || 0
      num_digits = digit_values.reduce(0) { |num, digit|
        digit.nil? ? num : num + 1
      }
      num_digits -= insignificant_digits
      digit_values.map { |d|
        if d.nil?
          options[:separator]
        else
          num_digits -= 1
          if num_digits >= 0
            digit_symbol(d, options)
          else
            options[:insignificant_symbol]
          end
        end
      }.join
    end

    def parameters
      params = {}
      params[:digits] = @digits
      params[:case_sensitive] = @case_sensitive
      params[:uppercase] = @uppercase
      params[:lowercase] = @lowercase
      params
    end

    def to_s
      # TODO: show only non-defaults
      args = []
      if @digits != DEFAULT_DIGITS
        args << @digits.to_s
      end
      if @max_base != @digits.size
        args << "max_base: #{@max_base}"
      end
      if @case_sensitive
        args << "case_sensitive: #{case_sensitive.inspect}"
      end
      if @uppercase
        args << "uppercase: #{uppercase.inspect}"
      end
      if @lowercase
        args << "lowercase: #{lowercase.inspect}"
      end
      "Digits[#{args.join(', ')}]"
    end

    def inspect
      "Format::Symbols::#{self}"
    end

    def dup
      Format::Symbols::Digits[parameters]
    end

    private

    def extract_options(*args)
      options = {}
      args = args.first if args.size == 1 && args.first.kind_of?(Array)
      args.each do |arg|
        case arg
        when Hash
          options.merge! arg
        when String, Array
          options[:digits] = arg
        when Format::Symbols::Digits
          options.merge! arg.parameters
        when :uppercase, :downcase
          send :"#{arg}=", true
        else
          raise "Invalid Symbols::Digits definition"
        end
      end
      options
    end

  end

end
