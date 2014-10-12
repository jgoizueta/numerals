
module Numerals

    # Repeating decimal configuration options
    class Options
      include ModalSupport::StateEquivalent
      include ModalSupport::BracketConstructor

      def initialize(options={})
        options = {
          #  default options
            delim: ['<', '>'],
            suffix:  '...',
            sep:   '.',
            grouping:   [',', []], # [...,[3]] for thousands separators
            special:   ['NaN', 'Infinity'],
            digits:    nil,
            signs: ['+', '-'],
            maximum_number_of_digits: Numeral.maximum_number_of_digits
          }.merge(options)

        set_delim *Array(options[:delim])
        set_suffix options[:suffix]
        set_sep options[:sep]
        set_grouping *Array(options[:grouping])
        set_special *Array(options[:special])
        set_digits *Array(options[:digits])
        set_signs *Array(options[:signs])
        @maximum_number_of_digits = options[:maximum_number_of_digits]
      end

      attr_accessor :begin_rep, :end_rep, :auto_rep, :dec_sep, :grp_sep, :grp, :maximum_number_of_digits
      attr_accessor :nan_txt, :inf_txt, :plus_sign, :minus_sign

      def set_delim(begin_d, end_d='')
        @begin_rep = begin_d
        @end_rep = end_d
        return self
      end

      def set_suffix(a)
        @auto_rep = a
        return self
      end

      def set_sep(d)
        @dec_sep = d
        return self
      end

      def set_grouping(sep, g=[])
        @grp_sep = sep
        @grp = g
        return self
      end

      def set_special(nan_txt, inf_txt)
        @nan_txt = nan_txt
        @inf_txt = inf_txt
        return self
      end

      def set_digits(*args)
        @digits_defined = !args.empty?
        @digits = DigitsDefinition[*args]
        self
      end

      def set_signs(plus, minus)
        @plus_sign = plus
        @minus_sign = minus
      end

      attr_accessor :digits

      def digits_defined?
        @digits_defined
      end

    end

    DEFAULT_OPTIONS = Options[]

end
