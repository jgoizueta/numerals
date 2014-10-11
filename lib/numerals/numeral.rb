require 'forwardable'

module Numerals

  class NumeralError <StandardError
  end

  # Digits definition (symbols used as digits)
  class DigitsDefinition
    include ModalSupport::StateEquivalent
    include ModalSupport::BracketConstructor

    DEFAULT_DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    DEFAULT_BASE   = 10

    def initialize(*args)
      if String === args.first
        digits = args.shift
      end
      options = args.shift || {}
      raise NumeralError, "Invalid DigitsDefinition" unless args.empty? && Hash === options
      digits ||= options[:digits]
      base = options[:base]
      if base
        if digits
          raise NumeralError, "Inconsistent DigitsDefinition" unless digits.size == base
        end
      elsif digits
        base = digits.size
      else
        base = DEFAULT_BASE
      end
      digits ||= DEFAULT_DIGITS[0, base]

      @radix = base
      @digits = digits
      @case_sensitive = options[:case_sensitive]
      @downcase = options[:downcase] || (@digits.downcase == @digits)
      @digits = @digits.downcase if @downcase
    end

    def is_digit?(digit)
      digit = set_case(digit)
      @digits.include?(digit)
    end

    def digit_value(digit)
      digit = set_case(digit)
      @digits.index(digit)
    end

    def digit_char(v)
      v >= 0 && v < @radix ? @digits[v] : nil
    end

    def radix
      @radix
    end

    private

    def set_case(digit_char)
      if digit_char
        unless @case_sensitive
          if @downcase
            digit_char = digit_char.downcase
          else
            digit_char = digit_char.upcase
          end
        end
      end
      digit_char
    end
  end

  # Sequence of digit values type, with an Array-compatible interface
  # Having this encapsulated here allow to change the implementation
  # e.g. to an Integer or packed in a String, ...
  class Digits
    def initialize(radix, *digits)
      @radix
      @digits_array = digits
    end

    include ModalSupport::BracketConstructor

    attr_reader :digits_array, :radix

    # delegate :replace, :size, :map, :pop, :push, :shift, :unshift,
    #          :empty?, :first, :last,
    #          to: :digits_array

    extend Forwardable
    def_delegators :@digits_array,
                   :size, :map, :pop, :push, :shift, :unshift,
                   :empty?, :first, :last, :any?, :all?, :[]=

    # The [] with a Range argument or two arguments (index, length)
    # returns a Regular Array.
    def_delegators :@digits_array, :[], :replace
    include ModalSupport::StateEquivalent # maybe == with Arrays too?

    # This could be changed to have [] return a Digits object (except when a single index is passed).
    # In that case we would have to define replace, ==, != to accept either Array or Digits arguments
    # (and also possibly the constructor)

    # Integral coefficient
    def value
      if @radix == 10
        @digits_array.join.to_i
      else
        @digits_array.inject(0){|x,y| x*@radix + y}
      end
    end

    def value=(v)
      replace v.to_s(@radix).each_char.map{|c| c.to_i(@radix)}
    end
  end

  # Numeral handles repeating decimals (repeating numerals actually)
  class Numeral
    include ModalSupport::StateEquivalent
    include ModalSupport::BracketConstructor

    @maximum_number_of_digits = 5000

    # Change the maximum number of digits that Numeral objects
    # can handle.
    def Numeral.maximum_number_of_digits=(n)
      @maximum_number_of_digits = [n,2048].max
    end
    # Return the maximum number of digits that Numeral objects
    # can handle.
    def Numeral.maximum_number_of_digits
      @maximum_number_of_digits
    end

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

    def initialize(*args)
      if args.empty?
        set_zero
      elsif args.size == 1 && Integer === args.first
        # base
        set_zero args.first
      elsif String === args.first
        # text, options
        text = args.shift
        set_text text, Options[*args]
      else
        x, y, *opt = args
        set_quotient x, y, Options[*opt]
      end
    end

    def set_zero(b=10)
      @radix = b
      @special = nil
      @sign = +1
      @digits = Digits[@radix, 0]  # Digits[@radix] ?
      @pnt_i = 1                   # 0 ?
      @rep_i = nil
      self
    end

    def scale
      @pnt_i - @digits.size
    end

    # unlike @rep_i this is nevel nil
    def repeating_position
      @rep_i || @digits.size
    end

    def scale=(s)
      @pnt_i = s + @digits.size
    end

    def set_text(str, opt=DEFAULT_OPTIONS)
      set_zero(opt.digits_defined? ? opt.digits.radix : @radix)

      sgn,i_str,f_str,ri,detect_rep = Numeral.parse(str,opt)
      @sign = sgn

      if i_str.kind_of?(Symbol)
        @special = i_str
      else
        # TODO: HANDLE leading 0 in i_str...
        # if i_str[0] == '0' && i_str.size > 1
        #   i_str = i_str[1..-1]
        # end
        if i_str == '0'
          if f_str && f_str!=''
            digits_str = f_str
            @pnt_i = 0
            i_size = 0
          else
            digits_str = opt.digits.digit_char(0)
            @pnt_i = 1
          end
        else
          digits_str = i_str+(f_str || '')
          @pnt_i = i_str.size
        end
        @digits.replace digits_str.chars.map{|digit| opt.digits.digit_value(digit)}
      end
      @rep_i = ri + @pnt_i if ri

      if detect_rep
        for l in 1..(@digits.size/2)
          l = @digits.size/2 + 1 - l
          if @digits[-l..-1] == @digits[-2*l...-l]

            for m in 1..l
              if l.modulo(m) == 0
                reduce_l = true
                for i in 2..l/m
                  if @digits[-m..-1] != @digits[-i*m...-i*m+m]
                     reduce_l = false
                     break
                  end
                end
                if reduce_l
                   l = m
                   break
                end
              end
            end

            @rep_i = @digits.size - 2*l
            l.times { @digits.pop }


            while @digits.size >= 2*l && @digits[-l..-1] == @digits[-2*l...-l]

              @rep_i = @digits.size - 2*l
              l.times { @digits.pop }

            end

            break
          end
        end

      end


      if @rep_i != nil
        if @digits.size == @rep_i+1 && @digits[@rep_i]==0
          @rep_i = nil
          @digits.pop
        end
      end
      @digits.pop while @digits[@digits.size-1]==0 && !@digits.empty?

      self
    end

    def Numeral.parse(str, opt=DEFAULT_OPTIONS)
      sgn, i_str, f_str, ri, detect_rep = nil,nil,nil,nil,nil

      i = 0
      l = str.size

      detect_rep = false

      i += 1 while i<str.size && str[i] =~/\s/

      neg = false

      if str[i, opt.minus_sign.size] == opt.minus_sign
        neg = true
        i += opt.minus_sign.size
      elsif str[i, opt.plus_sign.size] == opt.plus_sign
        i += opt.plus_sign.size
      end

      i += 1 while i<str.size && str[i] =~/\s/

      str = str.upcase
      if str[i, opt.nan_txt.size] == opt.nan_txt.upcase
        i_str = :indeterminate
      elsif str[i,opt.inf_txt.size] == opt.inf_txt.upcase
        i_str = neg ? :neginfinity : :posinfinity
      else
        i_str = ""
        while i < l && str[i, opt.dec_sep.size] != opt.dec_sep
          if opt.auto_rep && opt.auto_rep != ''
            break if str[i, opt.auto_rep.size] == opt.auto_rep
          end
          if str[i, opt.grp_sep.size] == opt.grp_sep
            i += opt.grp_sep.size
          else
            i_str << str[i]
            i += 1
          end
        end
        sgn = neg ? -1 : +1
        i += opt.dec_sep.size # skip the decimal separator
      end

      unless i_str.kind_of?(Symbol)
        i_str = opt.digits.digit_char(0) if i_str.empty?
        j = 0
        f_str = ""
        while i < l
          if opt.begin_rep && !opt.begin_rep.empty? && str[i, opt.begin_rep.size] == opt.begin_rep
            i += opt.begin_rep.size
            ri = j
          elsif opt.end_rep && !opt.end_rep.empty? && str[i, opt.end_rep.size] == opt.end_rep
            i = l
          elsif opt.auto_rep && !opt.auto_rep.empty? && str[i, opt.auto_rep.size] == opt.auto_rep
            detect_rep = true
            i = l
          else
            f_str << str[i]
            i += 1
            j += 1
          end
        end
      end
      [sgn, i_str, f_str, ri, detect_rep]
    end

    def digit_value_at(i)
      if i < 0
        0
      elsif i < @digits.size
        @digits[i]
      elsif @rep_i.nil?
        0
      else
        repeated_length = @digits.size - @rep_i
        i = (i - @rep_i) % repeated_length
        @digits[i + @rep_i]
      end
    end

    def get_text(nrep=0, opt=DEFAULT_OPTIONS)
      raise NumeralError,"Base mismatch: #{opt.digits.radix} when #{@radix} was expected." if opt.digits_defined? && @radix!=opt.digits.radix

      if @special
        case @special
        when :indeterminate
          opt.nan_txt
        when :posinfinity
          opt.inf_txt
        when :neginfinity
          opt.minus_sign + opt.inf_txt
        end
      else
        numeral = ""
        numeral << opt.minus_sign if @sign<0
        n_ip_digits = @pnt_i
        ip = (0...n_ip_digits).map{|i| opt.digits.digit_char(digit_value_at(i))}.join
        numeral << Numeral.group_digits(ip, opt)
        numeral = "0" if numeral.empty?

        fractional_part = ""
        if @rep_i
          i_first_fractional_rep = @rep_i
          repeated_length = @digits.size - @rep_i
          while i_first_fractional_rep < @pnt_i
            i_first_fractional_rep += repeated_length
          end
          (@pnt_i...i_first_fractional_rep).each do |i|
            fractional_part << opt.digits.digit_char(digit_value_at(i))
          end
          repeated_sequence = @digits[@rep_i..-1].map{|d| opt.digits.digit_char(d)}.join
          if nrep == 0
            fractional_part << opt.begin_rep
            fractional_part << repeated_sequence
            fractional_part << opt.end_rep
          else
            (nrep+1).times do
              fractional_part << repeated_sequence
            end
            fractional_part << opt.auto_rep
          end
        else
          (n_ip_digits...@digits.size).each do |i|
            fractional_part << opt.digits.digit_char(digit_value_at(i))
          end
        end

        unless fractional_part.empty?
          numeral << opt.dec_sep
          numeral << fractional_part
        end

        numeral
      end

    end

    def to_s()
      get_text
    end

    def normalize!(options = {})
      unless @special

        defaults = { remove_extra_reps: true, remove_trailing_zeros: true }
        options = defaults.merge(options)
        remove_trailing_zeros = options[:remove_trailing_zeros]
        remove_extra_reps = options[:remove_extra_reps]

        # Replace 'nines' repetition 0.999... -> 1
        if @rep_i && @rep_i==@digits.size-1 && @digits[@rep_i]==(@radix-1)
          @digits.pop
          @rep_i = nil

          i = @digits.size-1
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
          end
        end

        # Remove zeros repetition
        if @rep_i && @rep_i >= @digits.size
          @rep_i = nil
        end
        if @rep_i != nil && @rep_i >= 0
          unless @digits[@rep_i..-1].any?{|x| x!=0}
            @digits.replace @digits[0...@rep_i]
            @rep_i = nil
          end
        end

        if @rep_i && remove_extra_reps
          rep_length = @digits.size - @rep_i
          if rep_length > 0 && rep_length >= 2*rep_length
            while @rep_i > rep_length && @digits[@rep_i, rep_length] == @digits[@rep_i-rep_length, rep_length]
              @rep_i -= rep_length
              @digits.replace @digits[0...-rep_length]
            end
          end
        end

        # Remove trailing zeros
        if @rep_i.nil? && remove_trailing_zeros
          while @digits.last == 0
            @digits.pop
          end
        end
      end
    end

    def copy()
      c = clone
      c.digits = digits.clone
      return c
    end

    def ==(c)
      a = copy
      b = c.copy
      a.normalize!
      b.normalize!
      return a.sign == b.sign && a.rep_i == b.rep_i && a.digits == b.digits
    end

    #def !=(c)
    #  return !(self==c)
    #end

    def set_quotient(x, y, opt=DEFAULT_OPTIONS)
      return set_zero opt if x==0 && y!=0
      @radix = opt.digits.radix if opt.digits_defined?
      @radix ||= 10
      xy_sign = x==0 ? 0 : x<0 ? -1 : +1
      xy_sign = -xy_sign if y<0
      @sign = xy_sign
      x = x.abs
      y = y.abs

      @digits = Digits[@radix]
      @rep_i = nil
      @special = nil

      if y==0
        if x==0
          @special = :indeterminate
        else
          @special = xy_sign==-1 ? :neginfinity : :posinfinity
        end
      end

      unless @special
        @pnt_i = 1
        k = {}
        i = 0

        while (z = y*@radix) < x
          y = z
          @pnt_i += 1
        end

        max_d = opt.maximum_number_of_digits
        while x>0 && (max_d<=0 || i<max_d)
          break if @rep_i = k[x]
          k[x] = i
          d,x = x.divmod(y)
          x *= @radix
          @digits.push d
          i += 1
        end

        while @digits.size > 1 && @digits.first == 0
          @digits.shift
          @rep_i -= 1 if @rep_i
          @pnt_i -= 1
        end
      end

      self
    end

    def get_quotient(opt=DEFAULT_OPTIONS)
      if opt.digits_defined? && @radix!=opt.digits.radix
        raise NumeralError,"Base mismatch: #{opt.digits.radix} when #{@radix} was expected."
      end

      if @special
        y = 0
        case @special
        when :indeterminate
          x=0
        when :posinfinity
          x=1
        when :neginfinity
          x=-1
        end
        return x,y
      end

      n = @digits.size
      a = 0
      b = a

      for i in 0...n
        a *= @radix
        a += @digits[i]
        if @rep_i != nil && i < @rep_i
          b *= @radix
          b += @digits[i]
        end
      end

      x = a
      x -= b if @rep_i

      y = @radix**(n - @pnt_i)
      y -= @radix**(@rep_i - @pnt_i) if @rep_i

      d = Numerals.gcd(x,y)
      x /= d
      y /= d

      x = -x if @sign<0

      return x.to_i, y.to_i
    end

    def set_coefficient_scale(coefficient, scale, opt=DEFAULT_OPTIONS)
      @radix = opt.digits.radix if opt.digits_defined?
      @radix ||= 10
      @digits = Digits[@radix]
      @digits.value = coefficient
      @pnt_i = scale + @digits.size
      @rep_i = nil
      @special = nil
    end

    def get_coefficient_scale
      if @special || (@rep_i && @rep_i < @digits.size)
        raise NumeralError, "RedDec is not exact"
      end
      [@digits.value, scale]
    end


    attr_accessor :sign, :digits, :pnt_i, :rep_i, :special

  end


  def Numeral.group_digits(digits, opt)
    if opt.grp_sep!=nil && opt.grp_sep!='' && opt.grp.size>0
      grouped = ''
      i = 0
      while digits.size>0
        l = opt.grp[i]
        l = digits.size if l>digits.size
        grouped = opt.grp_sep + grouped if grouped.size>0
        grouped = digits[-l,l] + grouped
        digits = digits[0,digits.size-l]
        i += 1 if i<opt.grp.size-1
      end
      grouped
    else
     digits
    end
  end

  module_function

  def gcd(a,b)
    while b!=0 do
      a,b = b, a.modulo(b)
    end
    return a.abs
  end

end
