module Numerals

  module Conversions

    class <<self
      def [](type, options = nil)
        if type.respond_to?(:numerals_conversion)
          type.numerals_conversion(options || {})
        end
      end

      def order_of_magnitude(number, options={})
        self[number.class, options[:type_options]].order_of_magnitude(number, options)
      end

      def number_of_digits(number, options={})
        self[number.class, options[:type_options]].number_of_digits(number, options)
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
        conversions = self[selector, options[:type_options]]
        conversions.read(numeral, exact_input, approximate_simplified)
      end

      # Convert Number to Numeral
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
      # Summary
      #
      # In result there are 5 basically diferent conversion modes.
      # Three of them apply only to approximate values, so they are
      # not available for all input types:
      #
      # * 'Short' mode, which produces an exact Numeral. Used when
      #   input is not exact and rounding precision is :short.
      # * 'Free' mode, which produces an approximate Numeral. Used
      #   when input is not exact and rounding precision is :short.
      # * 'Fixed' mode, which produces an approximate Numeral. Used when
      #   input isnot exact and rounding precision is limited.
      #
      # The other two modes are applied to exact input, so they're
      # available for all input types (since all can be taken as exact with
      # the :exact option):
      #
      # * 'All' mode, which produces an exact Numeral. Used when
      #   input is exact and rounding precision is :free (or :short).
      # * 'Rounded' mode, which produces an approximate Numeral. Used
      #   when input is exact and rounding precision is limited.
      #
      def write(number, options = {})
        output_rounding = Rounding[options[:rounding] || Rounding[]]
        conversion = self[number.class, options[:type_options]]
        exact_input = conversion.exact?(number, options)
        conversion.write(number, exact_input, output_rounding)
      end

      def exact?(number, options = {})
        self[number.class, options[:type_options]].exact?(number, options)
      end

      # Convert an number to a different numeric type.
      # Conversion is done by first converting the number to a Numeral,
      # then converting the Numeral to de destination type.
      #
      # Options:
      #
      # * :exact_input Consider the number an exact quantity.
      #   Otherwise, for approximate types, insignificant digits
      #   will not be converted.
      # * :rounding Rounding to be applied during the conversion.
      # * :type or :context can be used to define the destination
      #   type.
      # * :output_mode can have the values :free, :short or :fixed
      #   and is used to define how the result is generated.
      #
      def convert(number, options = {})
        if options[:exact]
          options = options.merge(exact_input: true, ouput_mode: :free)
        end

        exact_input = options[:exact_input] || false
        rounding = Rounding[options[:rounding] || Rounding[]]
        output_mode = options[:output_mode] || :free # :short :free :fixed
        type_options =  options[:type_options]
        selector = options[:context] || options[:type]
        output_conversions = self[selector, type_options]
        if output_conversions && output_conversions.respond_to?(:context)
          output_base = output_conversions.context.radix
          if rounding.base != output_base && rounding.free?
            rounding = rounding[base: output_base]
          end
        end

        if number.is_a?(Numeral)
          numeral = number
        else
          input_options = {
            exact: exact_input,
            rounding: rounding,
            type_options: type_options
          }
          numeral = write(number, input_options)
        end

        output_options = {
          type: options[:type], context: options[:context]
        }
        case output_mode
        when :short
          output_options.merge!(
            exact: false,
            simplify: true
          )
        when :free
          output_options.merge!(
            exact: false,
            simplify: false
          )
        when :fixed
          output_options.merge!(
            exact: true,
            simplify: false
          )
        end
        if !output_options[:exact] && numeral.exact?
          numeral.approximate!
        end
        read(numeral, output_options)
      end

      private

      def extract_mode_from_args!(args)
        if [:fixed, :free, :exact, :approximate].include?(args.first)
          args.shift
        end
      end
    end

  end

end
