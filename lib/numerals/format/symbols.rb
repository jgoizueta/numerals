module Numerals

  #
  # * insignificant_digit : symbol to represent insignificant digits;
  #   use nil (the default) to omit insignificant digits and 0
  #   for a zero digit. Insignificant digits are digits which, in an
  #   approximate value, are not determined: they could change to any
  #   other digit and the approximated value would be the same.
  #
  class Format::Symbols


    class Digits

      DEFAULT_DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

      def initialize(*args)
        @digits = DEFAULT_DIGITS
        @downcase_digits = @digits.downcase
        @max_base = @digits.size
        @case_sensitive = false
        @uppercase = false
        @lowercase = false
        set! *args
      end

      include ModalSupport::StateEquivalent

      def [](*args)
        set *args
      end

      def self.[](*args)
        Format::Symbols::Digits.new *args
      end

      def set!(*args)
        options = extract_options(*args)
        options.each do |option, value|
          send :"#{option}=", value
        end
        normalize!
      end

      attr_reader :digits, :max_base, :case_sensitive, :uppercase, :lowercase
      attr_writer :case_sensitive

      def set(*args)
        dup.set! *args
      end

      def digits=(digits)
        @digits = digits
        @max_base = @digits.size
        @lowercase = (@digits.downcase == @digits)
        @uppercase = (@digits.upcase == @digits)
        @downcase_digits = @digits.downcase
        if @digits.each_char.to_a.uniq.size != @max_base
          raise "Inconsistent digits"
        end
      end

      def uppercase=(v)
        @uppercase = v
        self.digits = @digits.upcase
      end

      def lowercase=(v)
        @lowercase = v
        self.digits = @digits.downcase
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
        params[:digits] = @digits if @digits != DEFAULT_DIGITS
        params[:case_sensitive] = true if @case_sensitive
        params[:uppercase] = true if @uppercase
        params[:lowercase] = true if @lowercase
        params
      end

      def to_s
        "Digits[#{parameters.inspect.unwrap('{}')}]"
      end

      def inspect
        "Format::Symbols::#{self}"
      end

      def regexp(base = nil)
        base ||= @max_base
        if case_sensitive
          "[#{Regexp.escape(@digits[0,@max_base])}]"
        else
          "[#{Regexp.escape(@downcase_digits[0,@max_base])}#{Regexp.escape(@digits[0,@max_base].upcase)}]"
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
          when String
            options[:digits] = arg
          when Format::Symbols::Digits
            options.merge! arg.parameters
          else
            raise "Invalid Symbols::Digits definition"
          end
        end
        options
      end

      def normalize!
        self
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
      insignificant_digit: nil
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
    attr_reader :grouping, :repeat_count

    attr_writer :uppercase, :lowercase, :nan, :infinity, :plus,
                :minus, :exponent, :point, :group_separator, :zero,
                :repeat_begin, :repeat_end, :repeat_suffix,
                :show_plus, :show_exponent_plus, :show_zero, :show_point,
                :repeat_delimited, :repeat_count, :grouping,
                :insignificant_digit

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

    # def set_signs(...)

    def [](*args)
      set *args
    end

    def self.[](*args)
      Format::Symbols.new *args
    end

    def set!(*args)
      options = extract_options(*args)
      options.each do |option, value|
        if option == :digits
          @digits.set! value
        else
          send :"#{option}=", value
        end
      end
      normalize!
    end

    attr_writer :digits, :nan, :infinity,
                :plus, :minus, :exponent, :point, :group_separator, :zero,
                :repeat_begin, :repeat_end, :repeat_suffix, :show_plus,
                :show_exponent_plus, :uppercase, :show_zero, :show_point,
                :grouping, :repeat_count

    def set(*args)
      dup.set! *args
    end

    def set_repeat(*args)
      # TODO accept hash :begin, :end, :suffix, ...
    end

    def set_grouping(*args)
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

    def set_group_thousands(sep = nil)
      @group_separator = sep if sep
      @grouping = [3]
    end

    def set_signs(plus, minus)
      @plus = plus
      @minus = minus
    end

    def set_locale(locale)
      # ...
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
      Mode[parameters]
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

    def normalize!
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
        @exponent = @exponent.upcae
        @point = @point.downcase
        @group_separator = @group_separator.downcase
        @zero = @zero.downcase if @zero
        @repeat_begin = @repeat_begin.downcase
        @repeat_end   = @repeat_end.downcase
        @repeat_suffix = @repeat_suffix.downcase
        @digits = @digits[lowercase: true]
      end
      self
    end

    def cased(symbol)
      @uppercase ? symbol.upcase : @lowercase ? symbol.downcase : symbol
    end

  end

end
