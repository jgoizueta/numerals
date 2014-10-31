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
