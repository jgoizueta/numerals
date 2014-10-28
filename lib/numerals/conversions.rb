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

    def number_to_numeral(number, options={})
      self[number.class].number_to_numeral(number, options)
    end

    def numeral_to_number(numeral, type, options={})
      self[type].numeral_to_number(numeral, options)
    end
  end

end
