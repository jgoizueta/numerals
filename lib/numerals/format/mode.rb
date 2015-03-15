module Numerals

  class Format
  end

  # Formatting mode
  class Format::Mode

    DEFAULT_MODE = :general
    DEFAULT_SCI_INT_DIGITS = 1
    DEFAULT_MAX_LEADING = 6
    DEFAULT_MAX_TRAILING = 0
    DEFAULT_BASE_SCALE = 1

    def initialize(*args)
      @mode = :general
      @sci_int_digits = DEFAULT_SCI_INT_DIGITS
      @max_leading = DEFAULT_MAX_LEADING
      @max_trailing = DEFAULT_MAX_TRAILING
      @base_scale = DEFAULT_BASE_SCALE
      set! *args
    end

    attr_reader :mode, :sci_int_digits, :max_leading, :max_trailing, :base_scale

    include ModalSupport::StateEquivalent

    def [](*args)
      set *args
    end

    def self.[](*args)
      Format::Mode.new *args
    end

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

    def set(*args)
      dup.set! *args
    end

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

    def parameters
      p = { mode: @mode }
      if engineering?
        p[:mode] = :engineering
      elsif scientific?
        p[:sci_int_digits] = @sci_int_digits unless @sci_int_digits == DEFAULT_SCI_INT_DIGITS
      end
      p[:base_scale] = @base_scale unless @base_scale == DEFAULT_BASE_SCALE
      p[:max_leading] = @max_leading unless @max_leading == DEFAULT_MAX_LEADING
      p[:max_trailing] = @max_trailing unless @max_trailing == DEFAULT_MAX_TRAILING
      p
    end

    def to_s
      "Mode[#{parameters.inspect.unwrap('{}')}]"
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
