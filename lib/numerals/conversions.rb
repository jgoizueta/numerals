module Numerals::Conversions

  class <<self
    def [](type)
      if type.respond_to?(:numerals_conversion)
        type.numerals_conversion
      end
    end

    def order_of_magnitude(number, options={})
      self[number.class].order_of_magnitude(number, options)
    end

    # Convert a numeric value to a Numeral.
    #
    #  number_to_numeral x, mode, rounding
    #
    # There's two ways of defining the conversion mode:
    #
    # 1. fixed or free:
    #
    # * :fixed means: adjust the number precision to the output rounding
    # * :free means: forget about the rounding (except for the base);
    #   preserve the input number precision
    #
    # But :free cheats: if rounding is not exact it really honors it by
    # converting the number to an exact numeral an then rounding it.
    #
    # 2. exact or approximate:
    #
    # * :exact means: consider the number an exact quantity
    # * :approximate means: consider the number approximate;
    #   show only non-spurious digits.
    #
    def number_to_numeral(number, *args)
      # TODO: default mode value:
      # if no rounding/rounding options are passed except for the base,
      # the default mode should be :free; otherwise, the default mode should be
      # :fixed
      #
      # number_to_numeral(x, precision: 3)
      # == number_to_numeral(x, :fixed, Rounding[precision: 3])
      # number_to_numeral(x, precision: 3, base: 2)
      # == number_to_numeral(x, :fixed, Rounding[precision: 3, base: 2])
      # number_to_numeral(x, :exact, base: 2)
      # === number_to_numeral(x, :free, Rounding[:exact, base: 2])
      mode = extract_mode_from_args!(args)
      rounding = Rounding[*args]
      # mode ||= rounding.exact? ? :free : :fixed
      mode ||= :approximate
      if [:fixed, :free].include?(mode)
        mode = (mode == :fixed) == (rounding.exact?) ? :exact : :approximate
      end
      self[number.class].number_to_numeral(number, mode, rounding)
    end

    # Convert a Numeral to a numeric value of class type:
    #
    #   numeral_to_number numeral, type, mode, rounding
    #
    # The conversion mode can be:
    #
    # * :fixed: interprets the input as an exact quantity and represents it
    #   with the destination type/context precision.
    # * :free: interprets the input as an approximate quantity with given
    #   precision (trailing zeros being considered); the destination
    #   type precision is ignored when possible and generates number with
    #   equivalent (no less) precision to that of the input.
    #   The destination rounding mode is not used to round the number
    #   but taken into consideration so that if the result is converted back
    #   with that rounding mode to the input precision and base, the same input
    #   is obtained.
    #   The :free mode is meaningless for destination types with fixed
    #   precision such as Float.
    def numeral_to_number(numeral, type, *args)
      # TODO: either add :short mode or some other way to trigger that option;
      # In the :short case, which is a variant of :free, the output doesn't have
      # precision equivalent to the input, but just the least possible
      # precision value that can produce back the input as described above.
      mode = extract_mode_from_args!(args) || :fixed
      self[type].numeral_to_number(numeral, mode, *args)
    end

    # Convert Numeral to Number, new interface
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
      self[selector].read(numeral, exact_input, approximate_simplified)
    end

    # Convert Number to Numeral, new interface
    #
    #   write number, options={}
    #
    # Valid options:
    #
    # * :rounding (a Rounding) (which defines output base as well)
    # * :exact (exact input indicator)
    #
    # Approximate mode:
    #
    # If the input is treated as an approximation
    # (which is the case for types such as Flt::Num, Float,...
    # unless the :exact option is true) then no 'spurious' digits
    # will be shown (digits that can take any value and the numeral
    # still would convert to the original number if rounded to the same precision)
    #
    # In approximate mode, if rounding is :simplify, the shortest representation
    # which rounds back to the origina number with the same precision is used.
    # If rounding is :preserve and the output base is the same as the number
    # internal radix, the exact precision (trailing zeros) of the number
    # is represented.
    #
    # Exact mode:
    #
    # Is used for 'exact' types (such as Integer, Rational) or when the :exact
    # option is defined to be true.
    #
    # The number is treated as an exact value, and converted according to
    # Rounding. (in this case the :simplify and :preserve roundings are
    # equivalent to :exact)
    #
    def write(number, options = {})
      output_rounding = Rounding[options[:rounding] || Rounding[:exact]]
      exact_input = options[:exact]
      self[number.class].write(number, exact_input, output_rounding)
    end

    private

    def extract_mode_from_args!(args)
      if [:fixed, :free, :exact, :approximate].include?(args.first)
        args.shift
      end
    end
  end

end
