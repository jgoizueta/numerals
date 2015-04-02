module Numerals

  # Padding a number to a given width
  class Format::Symbols::Padding < FormattingAspect

    # Parameters:
    #
    # * :width field width (0 for no padding)
    # * :fill filling symbol; nil for no padding;
    #   0 to use the digit zero; otherwise should be a String
    # * :adjust adjust mode: :left, :right, :integer, :center
    #
    def initialize(*args)
      @width = 0
      @fill = nil
      @adjust = :right
      set! *args
    end

    include ModalSupport::StateEquivalent

    set do |*args|
      options = extract_options(*args)
      options.each do |option, value|
        send :"#{option}=", value
      end
    end

    attr_accessor :width, :fill, :adjust

    def leading_zeros=(width)
      @width = width
      @fill = 0
      @adjust = :internal
    end

    def padded?
      @width > 0 && @fill && @fill != ''
    end

    def parameters
      { width: width, fill: fill, adjust: adjust }
    end

    def to_s
      params = []
      if fill == 0 && adjust == :internal
        params << "leading_zeros: #{width}"
      else
        if width != 0
          params << "width: #{width}"
        end
        if fill
          params << "fill: #{fill.inspect}"
        end
        if adjust != :right || !params.empty?
          params << "adjust: #{adjust.inspect}"
        end
      end
      "Padding[#{params.join(', ')}]"
    end

    def inspect
      "Format::Symbols::#{to_s}"
    end

    # Returns size (characters of left, internal and right padding)
    # for a number of given width (without padding)
    def padding_sizes(number_size)
      left_padding_size = internal_padding_size = right_padding_size = 0
      padding_size = width - number_size
      if padding_size > 0 && padding?
        case format.symbols.padding.adjust
        when :left
          left_padding_size = padding_size
        when :right
          right_padding_size = padding_size
        when :internal
          internal_padding_size = padding_size
        when :center
          left_padding_size = (padding_size + 1) / 2
          right_padding_size = padding_size - left_padding_size
        end
      end
      [left_padding_size, internal_padding_size, right_padding_size]
    end

    private

    def extract_options(*args)
      options = {}
      args = args.first if args.size == 1 && args.first.kind_of?(Array)
      args.each do |arg|
        case arg
        when Integer
          options.merge! width: arg
        when String
          options.merge! fill: arg
        when :left, :right, :internal, :center
          options.merge! adjust: arg
        when Hash
          options.merge! arg
        when Format::Symbols::Padding
          options.merge! arg.parameters
        end
      end
      options
    end

  end

end
