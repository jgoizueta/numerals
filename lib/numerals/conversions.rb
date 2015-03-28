module Numerals::Conversions

  # This constant is used to experiment with two alternatives for
  # the default input_rounding used in output:
  DEFAULT_INPUT_ROUNDING_IS_CONTEXT = false

  class <<self
    def [](type)
      if type.respond_to?(:numerals_conversion)
        type.numerals_conversion
      end
    end

    def order_of_magnitude(number, options={})
      self[number.class].order_of_magnitude(number, options)
    end

    def number_of_digits(number, options={})
      self[number.class].number_of_digits(number, options)
    end

    # Convert Numeral to Number
    #
    #   read numeral, options={}
    #
    # If the input numeral is approximate and the destination type
    # allows for arbitrary precision, then the destination context
    # precision will be ignored and the precision of the input will be
    # preserved. The :simplify option affects this case by generating
    # only the mininimun number of digits needed.
    #
    # The :exact option will prevent this behaviour and always treat
    # input as exact.
    #
    # Valid output options:
    #
    # * :type class of the output number
    # * :context context (in the case of Flt::Num, Float) for the output
    # * :simplify (for approximate input numeral/arbitrary precision type only)
    # * :exact treat input numeral as if exact
    #
    def read(numeral, options={})
      selector = options[:context] || options[:type]
      exact_input = options[:exact]
      approximate_simplified = options[:simplify]
      if options[:input_rounding] || options[:rounding]
        input_rounding = Rounding[options[:input_rounding] || options[:rounding]].mode
      end
      self[selector].read(numeral, exact_input, approximate_simplified, input_rounding)
    end

    # Convert Number to Numeral
    #
    #   write number, options={}
    #
    # Valid options:
    #
    # * :rounding (a Rounding) (which defines output base as well)
    # * :exact (exact input indicator)
    # * :input_rounding (optional, a non-exact Rounding or rounding mode)
    #   which is used when input is approximate as the assumed rounding
    #   mode which would be used so that the result numeral rounds back
    #   to the input number
    #
    # Approximate mode:
    #
    # If the input is treated as an approximation
    # (which is the case for types such as Flt::Num, Float,...
    # unless the :exact option is true) then no 'spurious' digits
    # will be shown (digits that can take any value and the numeral
    # still would convert to the original number if rounded to the same precision)
    #
    # In approximate mode, if rounding is simplifying? (:short), the shortest representation
    # which rounds back to the origina number with the same precision is used.
    # If rounding is :free and the output base is the same as the number
    # internal radix, the exact precision (trailing zeros) of the number
    # is represented.
    #
    # Exact mode:
    #
    # Is used for 'exact' types (such as Integer, Rational) or when the :exact
    # option is defined to be true.
    #
    # The number is treated as an exact value, and converted according to
    # Rounding. (in this case the :free and :short precision roundings are
    # equivalent)
    #
    def write(number, options = {})
      output_rounding = Rounding[options[:rounding] || Rounding[]]
      if options[:input_rounding]
        input_rounding = Rounding[options[:input_rounding]].mode
      end
      conversion = self[number.class]
      exact_input = conversion.exact?(number, options)
      conversion.write(number, exact_input, output_rounding, input_rounding)
    end

    def exact?(number, options = {})
      self[number.class].exact?(number, options)
    end

    private

    def extract_mode_from_args!(args)
      if [:fixed, :free, :exact, :approximate].include?(args.first)
        args.shift
      end
    end
  end

end
