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

    DEFAULTS = {
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
      repeating: true,
      base_prefix: nil,
      base_suffix: nil
    }

    def initialize(*args)
      DEFAULTS.each do |param, value|
        instance_variable_set "@#{param}", value
      end

      # @digits is a mutable Object, so we don't want
      # to set it from DEFAULTS (which would share the
      # default Digits among all Symbols)
      @digits = Format::Symbols::Digits[]

      # same with @padding
      @padding = Format::Symbols::Padding[]

      set! *args
    end

    attr_reader :digits, :nan, :infinity, :plus, :minus, :exponent, :point,
                :group_separator, :zero, :insignificant_digit, :padding,
                :repeat_begin, :repeat_end, :repeat_suffix, :repeat_delimited,
                :show_plus, :show_exponent_plus, :uppercase, :lowercase,
                :show_zero, :show_point,
                :grouping, :repeat_count, :repeating,
                :base_prefix, :base_suffix

    attr_writer :digits, :uppercase, :lowercase, :nan, :infinity, :plus,
                :minus, :exponent, :point, :group_separator, :zero,
                :repeat_begin, :repeat_end, :repeat_suffix,
                :show_plus, :show_exponent_plus, :show_zero, :show_point,
                :repeat_delimited, :repeat_count, :grouping,
                :insignificant_digit, :repeating,
                :base_prefix, :base_suffix

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

    def padded?
      @padding.padded?
    end

    def fill
      fill = @padding.fill
      if fill.is_a?(Integer)
        @digits.digit_symbol(fill)
      else
        fill
      end
    end

    set do |*args|
      options = extract_options(*args)
      options.each do |option, value|
        if option == :digits
          @digits.set! value
        elsif option == :padding
          @padding.set! value
        else
          send :"#{option}=", value
        end
      end
      apply_case!
    end

    aspect :repeat do |*args|
      args.each do |arg|
        case arg
        when true, false
          @repeating = arg
        when Integer
          @repeat_count = arg
        when :delimited
          @repeat_delimited = true
        when :suffixed
          @repeat_delimited = false
        when Hash
          arg.each do |key, value|
            case key
            when :delimiters
              @repeat_begin, @repeat_end = Array(value)
            when :begin
              @repeat_begin = value
            when :end
              @repeat_end = value
            when :suffix
              @repeat_suffix = value
            when :delimited
              @repeat_delimited = value
            when :count
              @repeat_count = value
            else
              send "#{key}=", value
            end
          end
        end
      end
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

    def case_sensitive
      @digits.case_sensitive
    end

    def case_sensitive?
      @digits.case_sensitive
    end

    def case_sensitive=(v)
      @digits.set! case_sensitive: v
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

    aspect :padding do |*args|
      @padding.set! *args
    end

    aspect :leading_zeros do |width|
      @padding.leading_zeros = width
    end

    def parameters(abbreviated=false)
      params = {}
      DEFAULTS.each do |param, default|
        value = instance_variable_get("@#{param}")
        if !abbreviated || value != default
          params[param] = value
        end
      end
      if !abbreviated || @digits != Format::Symbols::Digits[]
        params[:digits] = @digits
      end
      if !abbreviated || @padding != Format::Symbols::Padding[]
        params[:padding] = @padding
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

    # Generate a regular expression to match any of the passed symbols.
    #
    #   symbols.regexp(:nan, :plus, :minus) #=> "(NaN|+|-)"
    #
    # The special symbol :digits can also be passed to generate all the digits,
    # in which case the :base option can be used to generate digits
    # only for some base smaller than the maximum defined for digits.
    #
    #   symbols.regexp(:digits, :point, base: 10) # => "(0|1|...|9)"
    #
    # The option :no_capture can be used to avoid generating a capturing
    # group; otherwise the result is captured group (surrounded by parenthesis)
    #
    #   symbols.regexp(:digits, no_capture: true) # => "(?:...)"
    #
    # The :case_sensitivity option is used to generate a regular expression
    # that matches the case of the text as defined by ghe case_sensitive
    # attribute of the Symbols. If this option is used the result should not be
    # used in a case-insensitive regular expression (/.../i).
    #
    #   /#{symbols.regexp(:digits, case_sensitivity: true)}/
    #
    # If the options is not used, than the regular expression should be
    # be made case-insensitive according to the Symbols:
    #
    #  if symbols.case_sensitive?
    #    /#{symbols.regexp(:digits)}/
    # else
    #    /#{symbols.regexp(:digits)}/i
    #
    def regexp(*args)
      options = args.pop if args.last.is_a?(Hash)
      options ||= {}
      symbols = args
      digits = symbols.delete(:digits)
      grouped_digits = symbols.delete(:grouped_digits)
      symbols = symbols.map { |s|
        s.is_a?(Symbol) ? send(s)  : s
      }
      if grouped_digits
        symbols += [group_separator, insignificant_digit]
      elsif digits
        symbols += [insignificant_digit]
      end
      if digits || grouped_digits
        symbols += @digits.digits(options)
      end
      regexp_group(symbols, options)
    end

    def digits_values(digits_text, options = {})
      digit_pattern = Regexp.new(
        regexp(
          :grouped_digits,
          options.merge(no_capture: true)
        ),
        !case_sensitive? ? Regexp::IGNORECASE : 0
      )
      digits_text.scan(digit_pattern).map { |digit|
        case digit
        when /\A#{regexp(:insignificant_digit, case_sensitivity: true)}\Z/
          0
        when /\A#{regexp(:group_separator, case_sensitivity: true)}\Z/
          nil
        else
          @digits.digit_value(digit)
        end
      }.compact
    end

    # Returns left, internal and right padding for a number
    # of given size (number of characters)
    def paddings(number_size)
      left_padding = internal_padding = right_padding = ''
      if padded?
        left_padding_size, internal_padding_size, right_padding_size = padding.padding_sizes(number_size)
        right_padding_size = right_padding_size/fill.size
        right_padding = fill*right_padding_size
        d = right_padding_size - right_padding.size
        left_padding_size = (left_padding_size + d)/fill.size
        left_padding = fill*left_padding_size
        internal_padding_size = internal_padding_size/fill.size
        internal_padding = fill*internal_padding_size
      end
      [left_padding, internal_padding, right_padding ]
    end

    private

    def regexp_char(c, options = {})
      c_upcase = c.upcase
      c_downcase = c.downcase
      if c_downcase != c_upcase && !case_sensitive? && options[:case_sensitivity]
        "(?:#{Regexp.escape(c_upcase)}|#{Regexp.escape(c_downcase)})"
      else
        Regexp.escape(c)
      end
    end

    def regexp_symbol(symbol, options = {})
      symbol.each_char.map { |c| regexp_char(c, options) }.join
    end

    def regexp_group(symbols, options = {})
      capture = !options[:no_capture]
      symbols = Array(symbols).compact.select { |s| !s.empty? }
                              .map{ |d| regexp_symbol(d, options) }.join('|')
      if capture
        symbols = "(#{symbols})"
      else
        if symbols != ''
          symbols = "(?:#{symbols})"
          if options[:optional]
            if options[:multiple]
              symbols = "#{symbols}*"
            else
              symbols = "#{symbols}?"
            end
          elsif options[:multiple]
            symbols = "#{symbols}+"
          end
        end
      end
      symbols
    end

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
        when :case_sensitive
          options[:case_sensitive] = true
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
        @digits.set! uppercase: true
        @padding.fill = @padding.fill.upcase if @padding.fill.is_a?(String)
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
        @digits.set! lowercase: true
        @padding.fill = @padding.fill.downcase if @padding.filll.is_a?(String)
      end
    end

    def cased(symbol)
      @uppercase ? symbol.upcase : @lowercase ? symbol.downcase : symbol
    end

  end

end

require 'numerals/format/symbols/digits'
require 'numerals/format/symbols/padding'
