module Numerals

  # A Format object holds formatting options and performs
  # formatted input/output operations on numbers.
  #
  # Formatting options are grouped into aspects:
  #
  # * Exact input
  # * Rounding
  # * Format::Mode
  # * Format::Symbols
  #
  # Some aspects (Rounding, ...) are handled with aspect-definining classes.
  #
  class Format

    def initialize(*args)
      @exact_input = false
      @rounding = Rounding[]
      @mode = Mode[]
      @symbols = Symbols[]
      @assembler = :text
      set! *args
    end

    attr_reader :rounding, :exact_input, :mode, :symbols, :assembler

    def base
      @rounding.base
    end

    include ModalSupport::StateEquivalent

    def [](*args)
      set *args
    end

    def self.[](*args)
      Format.new *args
    end

    def set!(*args)
      options = extract_options(*args)
      @exact_input = options[:exact_input] if options.has_key?(:exact_input)
      @rounding.set! base: options[:base] if options[:base]
      @rounding.set! options[:rounding] if options[:rounding]
      @mode.set! options[:mode] if options[:mode] # :format ?
      @symbols.set! digits: options[:digits] if options[:digits]
      @symbols.set! options[:symbols] if options[:symbols]
      @assembler = options[:assembler] if options[:assembler]
      normalize!
    end

    def set(*args)
      dup.set! *args
    end

    def parameters
      {
        rounding: @rounding,
        exact_input: @exact_input,
        mode: @mode,
        symbols: @symbols,
        assembler: @assembler
      }
    end

    def to_s
      args = []
      args << "exact_input: true" if @exact_input
      args << "rounding: #{@rounding}"
      args << "mode: #{@mode}"
      args << "symbols: #{@symbols}"
      args << "assembler: #{@assembler.inspect}" if @assembler != :text
      "Format[#{args.join(', ')}]"
    end

    def inspect
      to_s
    end

    def set_rounding(*args)
      dup.set_rounding!(*args)
    end

    def set_rounding!(*args)
      set! rounding: args
    end

    def set_base!(base)
      set! base: base
    end

    def set_base(base)
      dup.set_base(base)
    end

    def set_exact_input!(value)
      @exact_input = value
      normalize!
    end

    def set_exact_input(value)
      dup.set_exact_input!(value)
    end

    def set_mode(*args)
      dup.set_mode!(*args)
    end

    def set_mode!(*args)
      set! mode: args
    end

    def set_symbols(*args)
      dup.set_symbols!(*args)
    end

    def set_symbols!(*args)
      set! symbols: args
    end

    def set_assembler!(assembler)
      set! assembler: assembler
    end

    def set_assembler(assembler)
      dup.set_assembler(assembler)
    end

    def set_digits!(digits)
      set! digits: digits
    end

    def set_digits(digits)
      dup.set_digits(digits)
    end

    def dup
      # we need deep copy
      Format[parameters]
    end

    include Output
    include Input

    private

    def extract_options(*args)
      options = {}
      args = args.first if args.size == 1 && args.first.kind_of?(Array)
      args.each do |arg|
        case arg
        when Hash
          options.merge! arg
        when Rounding
          options[:rounding] = arg
        when Mode
          options[:mode] = arg
        when Symbols
          options[:symbols] = arg
        when Symbols::Digits
          options[:digits] = arg
        when Format
          options.merge arg.parameters
        when :exact_input
          options[:exact_input] = true
        when :hexbin
          options.merge!(
            base: 2,
            mode: {
              base_scale: 4,
              mode: :scientific,
              sci_int_digits: 1
            },
            symbols: {
              exponent: 'p'
            }
          )
        when Symbol
          options[:assembler] = arg
        when Integer
          options[:base] = arg
        else
          raise "Invalid Format definition"
        end
      end
      options
    end

    def normalize!
      self
    end

  end

end
