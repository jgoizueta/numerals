require 'numerals/digits'
require 'numerals/support'

module Numerals

  class NumeralError < StandardError
  end

  # A Numeral represents a numeric value as a sequence of digits
  # (possibly repeating) in some numeric base.
  #
  # A numeral can have a special value (infinity or not-a-number).
  #
  # A non-special numeral is defined by:
  #
  # * radix (the base)
  # * digits (a Digits object)
  # * sign (+1/-1)
  # * point: the position of the fractional point; 0 would place it
  #   before the first digit, 1 before the second, etc.
  # * repeat: the digits starting at this position repeat indefinitely
  #
  # A Numeral is equivalent to a Rational number; a quotient of integers
  # can be converted to a Numeral in any base and back to a quotient without
  # altering its value (although the fraction might be simplified).
  #
  # By default a Numeral represents an exact quantity (rational number).
  # A numeral can also represent an approximate value with a specific
  # precision: the number of significant digits (numeral.digits.size),
  # which can include significant trailing zeros. Approximate numerals
  # are never repeating.
  #
  # Exact numerals are always repeating, but, when the repeating digits are
  # just zeros, the repeating? method returns false.
  #
  class Numeral
    include ModalSupport::StateEquivalent
    include ModalSupport::BracketConstructor

    @maximum_number_of_digits = 5000

    # Change the maximum number of digits that Numeral objects
    # can handle.
    def self.maximum_number_of_digits=(n)
      @maximum_number_of_digits = [n, 2048].max
    end

    # Return the maximum number of digits that Numeral objects
    # can handle.
    def self.maximum_number_of_digits
      @maximum_number_of_digits
    end

    # Special numerals may be constructed with the symbols :nan, :infinity,
    # :negative_infinity, :positive_infinity (or with :infinity and the
    # :sign option which should be either +1 or -1)
    #
    # Examples:
    #
    #   Numeral[:nan]
    #   Numeral[:infinity, sign: -1]
    #
    # For non-special numerals, the first argument may be a Digits object or
    # an Array of digits, and the remaining parameters (:base, :sign, :point
    # and :repeat) are passed as options.
    #
    # Examples:
    #
    #   Numeral[1,2,3, base: 10, point: 1] # 1.23
    #   Numeral[1,2,3,4, point: 1, repeat: 2] # 1.234343434...
    #
    # The :normalize option can be used to specify the kind of normalization
    # to be applied to the numeral:
    #
    # * :exact, the default, produces a normalized :exact number
    #   where no trailing zeros are kept and there is always a repeat point
    #   (which may just repeat trailing zeros)
    # * :approximate produces a non-repeating numeral with a fixed number of
    #   digits (where trailing zeros are significant)
    # * false or nil will not normalize the result, mantaining the digits
    #   and repeat values passed.
    #
    def initialize(*args)
      if Hash === args.last
        options = args.pop
      else
        options = {}
      end
      options = { normalize: :exact }.merge(options)
      normalize = options.delete(:normalize)
      @point  = nil
      @repeat = nil
      @sign   = nil
      @radix  = options[:base] || options[:radix] || 10
      if args.size == 1 && Symbol === args.first
        @special = args.first
        case @special
        when :positive_infinity
          @special = :inf
          @sign = +1
        when :negative_infinity
          @special = :inf
          @sign = -1
        when :infinity
          @special = :inf
        end
      elsif args.size == 1 && Digits === args.first
        @digits = args.first
        @radix = @digits.radix || @radix
      elsif args.size == 1 && Array === args.first
        @digits = Digits[args.first, base: @radix]
      else
        if args.any? { |v| Symbol === v }
          @digits = Digits[base: @radix]
          args.each do |v|
            case v
            when :point
              @point = @digits.size
            when :repeat
              @repeat = @digits.size
            else # when Integer
              @digits.push v
            end
          end
        elsif args.size > 0
          @digits = Digits[args, base: @radix]
        end
      end
      if options[:value]
        @digits = Digits[value: options[:value], base: @radix]
      end
      @sign    ||= options[:sign] || +1
      @special ||= options[:special]
      unless @special
        @point   ||= options[:point]  || @digits.size
        @repeat  ||= options[:repeat] || @digits.size
      end
      case normalize
      when :exact
        normalize! Numeral.exact_normalization
      when :approximate
        normalize! Numeral.approximate_normalization
      when Hash
        normalize! normalize
      end
    end

    attr_accessor :sign, :digits, :point, :repeat, :special, :radix

    def base
      @radix
    end

    def base=(b)
      @radix = b
    end

    def scale
      @point - @digits.size
    end

    def special?
      !!@special
    end

    def nan?
      @special == :nan
    end

    def indeterminate?
      nan?
    end

    def infinite?
      @special == :inf
    end

    def positive_infinite?
      @special == :inf && @sign == +1
    end

    def negative_infinite?
      @special == :inf && @sign == -1
    end

    def zero?
      !special? && @digits.zero?
    end

    # unlike the repeat attribute, this is nevel nil
    def repeating_position
      @repeat || @digits.size
    end

    def repeating?
      !special? && @repeat && @repeat < @digits.size
    end

    def nonrepeating?
      !special && !repeating?
    end

    def scale=(s)
      @point = s + @digits.size
    end

    def digit_value_at(i)
      if i < 0
        0
      elsif i < @digits.size
        @digits[i]
      elsif @repeat.nil? || @repeat >= @digits.size
        0
      else
        repeated_length = @digits.size - @repeat
        i = (i - @repeat) % repeated_length
        @digits[i + @repeat]
      end
    end

    def self.approximate_normalization
      { remove_extra_reps: false, remove_trailing_zeros: false, remove_leading_zeros: true, force_repeat: false }
    end

    def self.exact_normalization
      { remove_extra_reps: true, remove_trailing_zeros: true, remove_leading_zeros: true, force_repeat: true }
    end

    def normalize!(options = {})
      if @special
        if @special == :nan
          @sign = nil
        end
        @point = @repeat = nil
      else

        defaults = { remove_extra_reps: true, remove_trailing_zeros: true }
        options = defaults.merge(options)
        remove_trailing_zeros = options[:remove_trailing_zeros]
        remove_extra_reps = options[:remove_extra_reps]
        remove_leading_zeros = options[:remove_extra_reps]
        force_repeat = options[:force_repeat]

        # Remove unneeded repetitions
        if @repeat && remove_extra_reps
          rep_length = @digits.size - @repeat
          if rep_length > 0 && @digits.size >= 2*rep_length
            while @repeat > rep_length && @digits[@repeat, rep_length] == @digits[@repeat-rep_length, rep_length]
              @repeat -= rep_length
              @digits.replace @digits[0...-rep_length]
            end
          end
        end

        # Replace 'nines' repetition 0.999... -> 1
        if @repeat && @repeat == @digits.size-1 && @digits[@repeat] == (@radix-1)
          @digits.pop
          @repeat = nil

          i = @digits.size - 1
          carry = 1
          while carry > 0 && i >= 0
            @digits[i] += carry
            carry = 0
            if @digits[i] > @radix
              carry = 1
              @digits[i] = 0
              @digits.pop if i == @digits.size
            end
            i -= 1
          end
          if carry > 0
            digits.unshift carry
            @point += 1
          end
        end

        # Remove zeros repetitions
        if remove_trailing_zeros
          if @repeat && @repeat >= @digits.size
            @repeat = @digits.size
          end
          if @repeat && @repeat >= 0
            unless @digits[@repeat..-1].any? { |x| x != 0 }
              @digits.replace @digits[0...@repeat]
              @repeat = nil
            end
          end
        end

        if force_repeat
          @repeat ||= @digits.size
        else
          @repeat = nil if @repeat && @repeat >= @digits.size
        end

        # Remove leading zeros
        if remove_leading_zeros
          # if all digits are zero, we consider all to be trailing zeros
          unless !remove_trailing_zeros && @digits.zero?
            while @digits.first == 0
              @digits.shift
              @repeat -= 1 if @repeat
              @point -= 1
            end
          end
        end

        # Remove trailing zeros
        if remove_trailing_zeros && !repeating?
          while @digits.last == 0
            @digits.pop
            @repeat -= 1 if @repeat
          end
        end
      end

      self
    end

    # Deep copy
    def dup
      duped = super
      duped.digits = duped.digits.dup
      duped
    end

    def negate!
      @sign = -@sign
      self
    end

    def negated
      dup.negate!
    end

    def -@
      negated
    end

    def normalized(options={})
      dup.normalize! options
    end

    def self.zero(options={})
      integer 0, options
    end

    def self.positive_infinity
      Numeral[:inf, sign: +1]
    end

    def self.negative_infinity
      Numeral[:inf, sign: -1]
    end

    def self.infinity(sign=+1)
      Numeral[:inf, sign: sign]
    end

    def self.nan
      Numeral[:nan]
    end

    def self.indeterminate
      nan
    end

    def self.integer(x, options={})
      base = options[:base] || options[:radix] || 10
      if x == 0
        # we also could conventionally keep 0 either as Digits[[], ...]
        digits = Digits[0, base: base]
        sign = +1
      else
        if x < 0
          sign = -1
          x = -x
        else
          sign = +1
        end
        digits = Digits[value: x, base: base]
      end
      Numeral[digits, sign: sign]
    end

    # Create a Numeral from a quotient (Rational number).
    # The quotient can be passed as an Array [numerator, denomnator];
    # to allow fractions with a zero denominator
    # (representing indefinite or infinite numbers).
    def self.from_quotient(*args)
      r = args.shift
      if Integer === args.first
        r = [r, args.shift]
      end
      options = args.shift || {}
      raise "Invalid number of arguments" unless args.empty?
      max_d = options.delete(:maximum_number_of_digits) || Numeral.maximum_number_of_digits
      if Rational === r
        x, y = r.numerator, r.denominator
      else
        x, y = r
      end
      return integer(x, options) if (x == 0 && y != 0) || y == 1

      radix = options[:base] || options[:radix] || 10

      xy_sign = x == 0 ? 0 : x < 0 ? -1 : +1
      xy_sign = -xy_sign if y < 0
      x = x.abs
      y = y.abs

      digits = Digits[base: radix]
      repeat = nil
      special = nil

      if y == 0
        if x == 0
          special = :nan
        else
          special = :inf
        end
      end

      return Numeral[special, sign: xy_sign] if special

      point = 1
      k = {}
      i = 0

      while (z = y*radix) < x
        y = z
        point += 1
      end

      while x > 0 && (max_d <= 0 || i < max_d)
        break if repeat = k[x]
        k[x] = i
        d, x = x.divmod(y)
        x *= radix
        digits.push d
        i += 1
      end

      while digits.size > 1 && digits.first == 0
        digits.shift
        repeat -= 1 if repeat
        point -= 1
      end

      Numeral[digits, sign: xy_sign, repeat: repeat, point: point]
    end

    # Return a quotient (Rational) that represents the exact value of the numeral.
    # The quotient is returned as an Array, so that fractions with a zero denominator
    # can be handled (representing indefinite or infinite numbers).
    def to_quotient
      if @special
        y = 0
        case @special
        when :nan
          x = 0
        when :inf
          x = @sign
        end
        return [x, y]
      end

      n = @digits.size
      a = 0
      b = a

      repeat = @repeat
      repeat = nil if repeat && repeat >= n

      for i in 0...n
        a *= @radix
        a += @digits[i]
        if repeat && i < repeat
          b *= @radix
          b += @digits[i]
        end
      end

      x = a
      x -= b if repeat

      y = @radix**(n - @point)
      y -= @radix**(repeat - @point) if repeat

      d = Numerals.gcd(x, y)
      x /= d
      y /= d

      x = -x if @sign < 0

      [x.to_i, y.to_i]
    end

    def self.from_coefficient_scale(coefficient, scale, options={})
      radix = options[:base] || options[:radix] || 10
      if coefficient < 0
        sign = -1
        coefficient = -coefficient
      else
        sign = +1
      end
      digits = Digits[radix]
      digits.value = coefficient
      point = scale + digits.size
      normalization = options[:normalize] || :exact
      normalization = :approximate if options[:approximate]
      Numeral[digits, base: radix, point: point, sign: sign, normalize: normalization]
    end

    def split
      if @special || (@repeat && @repeat < @digits.size)
        raise NumeralError, "Numeral cannot be represented as sign, coefficient, scale"
      end
      [@sign, @digits.value, scale]
    end

    def to_value_scale
      if @special || (@repeat && @repeat < @digits.size)
        raise NumeralError, "Numeral cannot be represented as value, scale"
      end
      [@digits.value*@sign, scale]
    end

    # Convert a Numeral to a different base
    def to_base(other_base)
      if other_base == @radix
        dup
      else
        normalization = exact? ? :exact : :approximate
        Numeral.from_quotient to_quotient, base: other_base, normalize: normalization
      end
    end

    def parameters
      if special?
        params = { special: @special }
        params.merge! sign: @sign if @special == :inf
      else
        params = {
          digits: @digits,
          sign:   @sign,
          point:  @point
        }
        params.merge! repeat: @repeat if @repeat
        if approximate?
          params.merge! normalize: :approximate
        end
      end
      params
    end

    def to_s
      case @special
      when :nan
        'Numeral[:nan]'
      when :inf
        if @sign < 0
          'Numeral[:inf, sign: -1]'
        else
          'Numeral[:inf]'
        end
      else
        if @digits.size > 0
          args = @digits.digits_array.to_s.unwrap('[]')
          args << ', '
        end
        params = parameters
        params.delete :digits
        params.merge! base: @radix
        args << params.to_s.unwrap('{}')
        "Numeral[#{args}]"
      end
    end

    def inspect
      to_s
    end

    # An exact Numeral represents exactly a rational number.
    # It always has a repeat position, although the repeated digits
    # may all be zero.
    def exact?
      !!@repeat
    end

    # An approximate Numeral has limited precision (number of significant digits).
    # In an approximate Numeral, trailing zeros are significant.
    def approximate?
      !exact?
    end

    # Make sure the numeral has at least the given number of digits;
    # This may denormalize the number.
    def expand!(minimum_number_of_digits)
      if @repeat
        while @digits.size < minimum_number_of_digits
          @digits.push @digits[@repeat] || 0
          @repeat += 1
        end
      else
        @digits.push 0 while @digits.size < minimum_number_of_digits
      end
      self
    end

    def expand(minimum_number_of_digits)
      dup.expand! minimum_number_of_digits
    end

    # Expand to the specified number of digits,
    # then truncate and remove repetitions.
    def approximate!(number_of_digits)
      expand! number_of_digits
      @digits.truncate! number_of_digits
      @repeat = nil
      self
    end

    def approximate(number_of_digits)
      dup.approximate! number_of_digits
    end

    def exact!
      normalize! Numeral.exact_normalization
    end

    def exact
      dup.exact!
    end

    private

    def test_equal(other)
      return false if other.nil? || !other.is_a?(Numeral)
      if self.special? || other.special?
        self.special == other.special && self.sign == other.sign
      else
        this = self.normalized
        that = other.normalized
        this.sign == that.sign && this.point == that.point && this.repeat == that.repeat && this.digits == that.digits
      end
    end

  end

end
