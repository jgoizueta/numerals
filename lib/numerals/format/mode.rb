module Numerals

  class Format
  end

  # Formatting mode
  #
  # * :scientific use scientific notation.
  # * :fixed used fixed notation.
  # * :general (the default) uses :fixed notation unless
  #   it would produce trailing zeros in the integer part
  #   or too many leading zeros in the fractional part.
  #   The intent is to produced the simplest or more natural
  #   output and it's regulated by the :max_leading and
  #  :max_trailing parameters.
  #
  # The special value :engineering can be used as a shortcut
  # for :scientific mode with :engineering :sci_int_digits.
  #
  # The modes can be abbreviated as :sci, :fix, :gen and :end.
  #
  # * :sci_int_digits numbe of digits to the left of the point
  #   in scientific notation. By default 1. The special value
  #   :engineering can be used for engineering notation, i.e.
  #   the number of digits will be between one and 3 so that the
  #   exponent is a multiple of 3.
  #   The special value :all is used to make the significand an
  #   integer value.
  #
  # * :max_leading (maximum number of leading zeros) determines
  #   when :scientific is chosen instead of :fixed when the mode is
  #   :general.
  #   The default value, 5 is that of the General Decimal Arithmetic
  #   'to-scientific-string' number to text conversion, and also used
  #   by the .NET General ("G") format specifier. To reproduce the
  #   behaviour of the C %g format specifier the value should be 3.
  #   The special value :all can be used to reproduce the behaviour
  #   of some calculators, where scientific notation is used when
  #   more digits than the specified precision would be needed.
  #
  class Format::Mode < Format::Aspect

    DEFAULTS = {
      mode: :general,
      sci_int_digits: 1,
      max_leading: 5,
      max_trailing: 0,
      base_scale: 1
    }

    def initialize(*args)
      DEFAULTS.each do |param, value|
        instance_variable_set "@#{param}", value
      end
      set! *args
    end

    attr_reader :mode, :sci_int_digits, :max_leading, :max_trailing, :base_scale

    include ModalSupport::StateEquivalent

    def set!(*args)
      options = extract_options(*args)
      options.each do |option, value|
        send :"#{option}=", value
      end
      normalize!
    end

    MODE_SHORTCUTS = {
      gen: :general,
      sci: :scientific,
      fix: :fixed,
      eng: :engineering
    }

    def mode=(mode)
      @mode = MODE_SHORTCUTS[mode] || mode
      if @mode == :engineering
        @mode = :scientific
        @sci_int_digits = :engineering
      end
    end

    def sci_int_digits=(v)
      @sci_int_digits = v
      if @sci_int_digits == :eng
        @sci_int_digits = :engineering
      end
    end

    attr_writer :max_leading, :max_trailing, :base_scale

    def engineering?
      @mode == :scientific && @sci_int_digits == :engineering
    end

    def scientific?
      @mode == :scientific
    end

    def fixed?
      @mode == :fixed
    end

    def general?
      @mode == :general
    end

    def parameters(abbreviated=false)
      params = {}
      DEFAULTS.each do |param, default|
        value = instance_variable_get("@#{param}")
        if !abbreviated || value != default
          params[param] = value
        end
      end
      if abbreviated && engineering?
        params[:mode] = :engineering
        params.delete :sci_int_digits
      end
      params
    end

    def to_s
      "Mode[#{parameters(true).inspect.unwrap('{}')}]"
    end

    def inspect
      "Format::#{self}"
    end

    # Note: since Mode has no mutable attributes, default dup is OK
    # otherwise we'd need to redefine it:
    # def dup
    #   Mode[parameters]
    # end

    private

    def extract_options(*args)
      options = {}
      args = args.first if args.size == 1 && args.first.kind_of?(Array)
      args.each do |arg|
        case arg
        when Hash
          options.merge! arg
        when Symbol
          options[:mode] = arg
        when Format::Mode
          options.merge! arg.parameters
        else
          raise "Invalid Mode definition"
        end
      end
      options
    end

    def normalize!
      self
    end

  end

end
