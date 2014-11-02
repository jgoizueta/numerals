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

    # explicit: number_to_numeral x, mode, rounding
    # but for :free mode rounding is ignored except for the base
    # so if no rounding/rounding options are passed except for the base, the default mode should be :free
    # otherwise, the default mode should be :fixed...

    # number_to_numeral(x, precision: 3) = number_to_numeral(x, :fixed, Rounding[precision: 3])
    # number_to_numeral(x, precision: 3, base: 2) = number_to_numeral(x, :fixed, Rounding[precision: 3, base: 2])
    # number_to_numeral(x, :exact, base: 2) = number_to_numeral(x, :free, Rounding[:exact, base: 2])

    # Two ways of defining the conversion mode:
    # 1. fixed or free:
    # * :fixed means: adjust the number precision to the output rounding
    # * :free means: forget about the rounding, preserve the input number precision
    # But :free cheats: if rounding is not exact it really honors it by
    # converting the number to an exact numeral an then rounding it.
    # 2. exact or approximate
    # * :exact means: consider the number an exact quantity
    # * :approximate means: consider the number approximate; show only non-spurious digits.
    def number_to_numeral(number, *args)
      mode = extract_mode_from_args!(args)
      rounding = Rounding[*args]
      # mode ||= rounding.exact? ? :free : :fixed
      mode ||= :approximate
      if [:fixed, :free].include?(mode)
        mode = (mode == :fixed) == (rounding.exact?) ? :exact : :approximate
      end
      self[number.class].number_to_numeral(number, mode, rounding)
    end

    # conversion mode:
    # * :fixed interprets the input as an exact quantity and represents it
    #   with the destitation type/context precision.
    # * :free interprets the input as an approximate quantity with given
    #   precision (trailing zeros being considered); the destination
    #   type precision is ignored when possible and generates number with
    #   equivalent (no less) to that of the input. The destination rounding
    #   mode is not used to round the number but taken into consideration
    #   so that if the result is converted back with that rounding mode
    #   to the input precision and base, the same input is obtained.
    #   It is meaningless for destination types with fixed precision
    #   (e.g. Float).
    # TODO: either add :short mode or some other way to trigger that option;
    # In the :short case, which is a variant of :free, the output doesn't have
    # precision equivalent to the input, but just the least possible
    # precision value that can produce back the input as described above.
    def numeral_to_number(numeral, type, *args)
      mode = extract_mode_from_args!(args) || :fixed
      self[type].numeral_to_number(numeral, mode, *args)
    end

    private

    def extract_mode_from_args!(args)
      if [:fixed, :free, :exact, :approximate].include?(args.first)
        args.shift
      end
    end
  end

end
