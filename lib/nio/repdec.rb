require 'nio/tools'

module Nio

  class RepDecError <StandardError
  end

  # Digits definition
  class DigitsDef
    include ModalSupport::StateEquivalent

    def initialize(ds='0123456789', cs=true)
      @digits = ds
      @casesens = cs
      @dncase = (ds.downcase==ds)
      @radix = @digits.size
    end

    def is_digit?(ch_code)
      ch_code = set_case(ch_code) unless @casesens
      @digits.include?(ch_code)
    end

    def digit_value(ch_code)
      ch_code = set_case(ch_code) unless @casesens
      @digits.index(ch_code.chr)
    end

    def digit_char(v)
      @digits[v]
    end

    def digit_char_safe(v)
      v>=0 && v<@radix ? @digits[v] : nil
    end

    def radix
      @radix
    end

    def DigitsDef.base(b,dncase=false,casesens=false)
      dgs = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[0,b]
      dgs.downcase! if dncase
      DigitsDef.new(dgs,casesens)
    end

    private

    def set_case(ch_code)
      ch_code = ch_code.chr if ch_code.kind_of?(Numeric)
      @dncase ? ch_code.downcase[0] : ch_code.upcase[0]
    end

  end

  # RepDec handles repeating decimals (repeating numerals actually)
  class RepDec
    include ModalSupport::StateEquivalent
    include ModalSupport::BracketConstructor

    @maximum_number_of_digits = 5000

    # Change the maximum number of digits that RepDec objects
    # can handle.
    def RepDec.maximum_number_of_digits=(n)
      @maximum_number_of_digits = [n,2048].max
    end
    # Return the maximum number of digits that RepDec objects
    # can handle.
    def RepDec.maximum_number_of_digits
      @maximum_number_of_digits
    end

    # Repeating decimal configuration options
    class Opt
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
            maximum_number_of_digits: RepDec.maximum_number_of_digits
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

      def set_digits(ds=nil, dncase=false, casesens=false)
        if ds
          @digits_defined = true
          if ds.kind_of?(DigitsDef)
            @digits = ds
          elsif ds.kind_of?(Numeric)
            @digits = DigitsDef.base(ds, dncase, casesens)
          else
            @digits = DigitsDef.new(ds,casesens)
          end
        else
          @digits = DigitsDef.new
          @digits_defined = false
        end
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

    DEF_OPT = Opt[]

    def initialize(*args)
      if args.empty?
        set_zero
      elsif args.size == 1 && Integer === args.first
        # base
        set_zero args.first
      elsif String === args.first
        # text, options
        text = args.shift
        set_text text, Opt[*args]
      else
        x, y, *opt = args
        set_quotient x, y, Opt[*opt]
      end
    end

    def set_zero(b=10)
      @radix = b
      @special = nil
      @sign = +1
      @digits = [0] # digit values # [] ?
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

    def set_text(str, opt=DEF_OPT)
      set_zero(opt.digits_defined? ? opt.digits.radix : @radix)

      sgn,i_str,f_str,ri,detect_rep = RepDec.parse(str,opt)
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
        @digits = digits_str.chars.map{|digit| opt.digits.digit_value(digit)}
      end
      @rep_i = ri + @pnt_i if ri

      if detect_rep
        for l in 1..(@digits.length/2)
          l = @digits.length/2 + 1 - l
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

            @rep_i = @digits.length - 2*l
            l.times { @digits.pop }


            while @digits.length >= 2*l && @digits[-l..-1] == @digits[-2*l...-l]

              @rep_i = digits.length - 2*l
              l.times { @digits.pop }

            end

            break
          end
        end

      end


      if @rep_i != nil
        if @digits.length == @rep_i+1 && @digits[@rep_i]==0
          @rep_i = nil
          @digits.pop
        end
      end
      @digits.pop while @digits[@digits.length-1]==0 && !@digits.empty?

      self
    end

    def RepDec.parse(str, opt=DEF_OPT)
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
            break if str[i, opt.auto_rep.length] == opt.auto_rep
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

    def get_text(nrep=0, opt=DEF_OPT)
      raise RepDecError,"Base mismatch: #{opt.digits.radix} when #{@radix} was expected." if opt.digits_defined? && @radix!=opt.digits.radix

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
        numeral << RepDec.group_digits(ip, opt)
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
        if @rep_i && @rep_i==@digits.length-1 && @digits[@rep_i]==(@radix-1)
          @digits.pop
          @rep_i = nil

          i = @digits.length-1
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
        if @rep_i && @rep_i >= @digits.length
          @rep_i = nil
        end
        if @rep_i != nil && @rep_i >= 0
          unless @digits[@rep_i..-1].any?{|x| x!=0}
            @digits = @digits[0...@rep_i]
            @rep_i = nil
          end
        end

        if @rep_i && remove_extra_reps
          rep_length = @digits.size - @rep_i
          if rep_length > 0 && rep_length >= 2*rep_length
            while @rep_i > rep_length && @digits[@rep_i, rep_length] == @digits[@rep_i-rep_length, rep_length]
              @rep_i -= rep_length
              @digits = @digits[0...-rep_length]
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

    def set_quotient(x, y, opt=DEF_OPT)
      return set_zero opt if x==0 && y!=0
      @radix = opt.digits.radix if opt.digits_defined?
      @radix ||= 10
      xy_sign = x==0 ? 0 : x<0 ? -1 : +1
      xy_sign = -xy_sign if y<0
      @sign = xy_sign
      x = x.abs
      y = y.abs

      @digits = []
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

    def get_quotient(opt=DEF_OPT)
      if opt.digits_defined? && @radix!=opt.digits.radix
        raise RepDecError,"Base mismatch: #{opt.digits.radix} when #{@radix} was expected."
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

      d = Nio.gcd(x,y)
      x /= d
      y /= d

      x = -x if @sign<0

      return x.to_i, y.to_i
    end

    #protected

    attr_accessor :sign, :digits, :pnt_i, :rep_i, :special

  end


  def RepDec.group_digits(digits, opt)
    if opt.grp_sep!=nil && opt.grp_sep!='' && opt.grp.length>0
      grouped = ''
      i = 0
      while digits.length>0
        l = opt.grp[i]
        l = digits.length if l>digits.length
        grouped = opt.grp_sep + grouped if grouped.length>0
        grouped = digits[-l,l] + grouped
        digits = digits[0,digits.length-l]
        i += 1 if i<opt.grp.length-1
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