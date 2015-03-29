module Numerals

  #
  # * insignificant_digit : symbol to represent insignificant digits;
  #   use nil (the default) to omit insignificant digits and 0
  #   for a zero digit. Insignificant digits are digits which, in an
  #   approximate value, are not determined: they could change to any
  #   other digit and the approximated value would be the same.
  #
  # * repeating : (boolean) support repeating decimals?
  #
  class Format::Symbols < FormattingAspect

    def self.regexp_group(symbols, options={})
      capture = !options[:no_capture]
      symbols = "#{Array(symbols).map{|d| Regexp.escape(d)}.join('|')}"
      if capture
        "(#{symbols})"
      else
        "(?:#{symbols})"
      end
    end

    class Digits < FormattingAspect

      DEFAULT_DIGITS = %w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

      def initialize(*args)
        @digits = DEFAULT_DIGITS
        @downcase_digits = @digits.map(&:downcase)
        @max_base = @digits.size
        @case_sensitive = false
        @uppercase = false
        @lowercase = false
        set! *args
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
        "Digits[#{parameters.inspect.unwrap('{}')}]"
      end

      def inspect
        "Format::Symbols::#{self}"
      end

      def regexp(options = {})
        base = options[:base] || @max_base
        additional_symbols = Array(options[:symbols])
        if case_sensitive
          symbols = @digits[0, @max_base]
        else
          symbols = @downcase_digits[0, @max_base] + @digits[0, @max_base].map(&:upcase)
        end
        symbols += additional_symbols
        Symbols.regexp_group(symbols, options)
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
          else
            raise "Invalid Symbols::Digits definition"
          end
        end
        options
      end

    end

    DEFAULTS = {
      digits: Format::Symbols::Digits[],
      nan: 'NaN',
      infinity: 'Infinity',
      plus: '+',
      minus: '-',
      exponent: 'e',
      point: '.',
      group_separator: ',',
      zero: nil,
      repeat_begin: '<',
      repeat_end: '>',
      repeat_suffix: '...',
      #repeat_detect: false,
      show_plus: false,
      show_exponent_plus: false,
      uppercase: false,
      lowercase: false,
      show_zero: true,
      show_point: false,
      repeat_delimited: false,
      repeat_count: 3,
      grouping: [],
      insignificant_digit: nil,
      repeating: true
    }

    def initialize(*args)
      DEFAULTS.each do |param, value|
        instance_variable_set "@#{param}", value
      end

      # TODO: justification/padding
      # width, adjust_mode (left, right, internal), fill_symbol

      # TODO: base_suffixes, base_preffixes, show_base

      set! *args
    end

    # TODO: transmit uppercase/lowercase to digits

    attr_reader :digits, :nan, :infinity, :plus, :minus, :exponent, :point,
                :group_separator, :zero, :insignificant_digit
    attr_reader :repeat_begin, :repeat_end, :repeat_suffix, :repeat_delimited
    attr_reader :show_plus, :show_exponent_plus, :uppercase, :lowercase,
                :show_zero, :show_point
    attr_reader :grouping, :repeat_count, :repeating

    attr_writer :uppercase, :lowercase, :nan, :infinity, :plus,
                :minus, :exponent, :point, :group_separator, :zero,
                :repeat_begin, :repeat_end, :repeat_suffix,
                :show_plus, :show_exponent_plus, :show_zero, :show_point,
                :repeat_delimited, :repeat_count, :grouping,
                :insignificant_digit, :repeating

    include ModalSupport::StateEquivalent

    def positive_infinity
      txt = ""
      txt << @plus if @show_plus
      txt << @infinity
      txt
    end

    def negative_infinity
      txt = ""
      txt << @minus
      txt << @infinity
      txt
    end

    def zero
      if @zero
        @zero
      else
        @digits.digit_symbol(0)
      end
    end

    def grouping?
      !@grouping.empty? && @group_separator && !@group_separator.empty?
    end

    set do |*args|
      options = extract_options(*args)
      options.each do |option, value|
        if option == :digits
          @digits.set! value
        else
          send :"#{option}=", value
        end
      end
      apply_case!
    end

    attr_writer :digits, :nan, :infinity,
                :plus, :minus, :exponent, :point, :group_separator, :zero,
                :repeat_begin, :repeat_end, :repeat_suffix, :show_plus,
                :show_exponent_plus, :uppercase, :show_zero, :show_point,
                :grouping, :repeat_count

    aspect :repeat do |*args|
      # TODO accept hash :begin, :end, :suffix, ...
    end

    aspect :grouping do |*args|
      args.each do |arg|
        case arg
        when Symbol
          if arg == :thousands
            @groups = [3]
          end
        when String
          @group_separator = arg
        when Array
          @groups = groups
        end
      end
    end

    aspect :group_thousands do |sep = nil|
      @group_separator = sep if sep
      @grouping = [3]
    end

    aspect :signs do |plus, minus|
      @plus = plus
      @minus = minus
    end

    aspect :plus do |plus, which = nil|
      case plus
      when nil, false
        case which
        when :exponent, :exp
          @show_exponent_plus = false
        when :both, :all
          @show_plus = @show_exponent_plus = false
        else
          @show_plus = false
        end
      when true
        case which
        when :exponent, :exp
          @show_exponent_plus = true
        when :both, :all
          @show_plus = @show_exponent_plus = true
        else
          @show_plus = true
        end
      when :both, :all
        @show_plus = @show_exponent_plus = true
      when :exponent, :exp
        @show_exponent_plus = true
      else
        @plus = plus
        case which
        when :exponent, :exp
          @show_exponent_plus = true
        when :both, :all
          @show_plus = @show_exponent_plus = true
        else
          @show_plus = true
        end
      end
    end

    aspect :minus do |minus|
      @minus = minus
    end

    def parameters(abbreviated=false)
      params = {}
      DEFAULTS.each do |param, default|
        value = instance_variable_get("@#{param}")
        if !abbreviated || value != default
          params[param] = value
        end
      end
      params
    end

    def to_s
      "Digits[#{parameters(true).inspect.unwrap('{}')}]"
    end

    def inspect
      "Format::Symbols::#{self}"
    end

    def dup
      Format::Symbols[parameters]
    end

    # Group digits (inserting nil values as separators)
    def group_digits(digits)
      if grouping?
        grouped = []
        i = 0
        while digits.size > 0
          l = @grouping[i]
          l = digits.size if l > digits.size
          grouped = [nil] + grouped if grouped.size > 0
          grouped = digits[-l, l] + grouped
          digits = digits[0, digits.length - l]
          i += 1 if i < @grouping.size - 1
        end
        grouped
      else
        digits
      end
    end

    def digits_text(digit_values, options={})
      if options[:with_grouping]
        digit_values = group_digits(digit_values)
      end
      insignificant_symbol = @insignificant_digit
      insignificant_symbol = zero if insignificant_symbol == 0
      @digits.digits_text(
        digit_values,
        options.merge(
          separator: @group_separator,
          insignificant_symbol: insignificant_symbol
        )
      )
    end

    def regexp(symbols, options = {})
      symbols = Array(symbols)
      if symbols.delete(:digits)
        @digits.regexp(options.merge(symbols: symbols))
      elsif symbol.delete(:grouped_digits)
        @digits.regexp(options.merge(symbols: symbols+[group_separator]))
      else
        Symbols.regexp_group(symbols, options)
      end
    end

    private

    def extract_options(*args)
      options = {}
      args = args.first if args.size == 1 && args.first.kind_of?(Array)
      args.each do |arg|
        case arg
        when Hash
          options.merge! arg
        when Format::Symbols::Digits
          options[:digits] = arg
        when Format::Symbols
          options.merge! arg.parameters
        when :group_thousands
          options[:grouping] = [3]
        else
          raise "Invalid Symbols definition"
        end
      end
      options
    end

    def apply_case!
      if @uppercase
        @nan = @nan.upcase
        @infinity = @infinity.upcase
        @plus = @plus.upcase
        @exponent = @exponent.upcase
        @point = @point.upcase
        @group_separator = @group_separator.upcase
        @zero = @zero.upcase if @zero
        @repeat_begin = @repeat_begin.upcase
        @repeat_end   = @repeat_end.upcase
        @repeat_suffix = @repeat_suffix.upcase
        @digits = @digits[uppercase: true]
      elsif @lowercase
        @nan = @nan.downcase
        @infinity = @infinity.downcase
        @plus = @plus.downcase
        @exponent = @exponent.downcase
        @point = @point.downcase
        @group_separator = @group_separator.downcase
        @zero = @zero.downcase if @zero
        @repeat_begin = @repeat_begin.downcase
        @repeat_end   = @repeat_end.downcase
        @repeat_suffix = @repeat_suffix.downcase
        @digits = @digits[lowercase: true]
      end
    end

    def cased(symbol)
      @uppercase ? symbol.upcase : @lowercase ? symbol.downcase : symbol
    end

  end

end
