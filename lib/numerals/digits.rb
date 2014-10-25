require 'forwardable'

module Numerals

  # Sequence of digit values type, with an Array-compatible interface
  # Having this encapsulated here allow to change the implementation
  # e.g. to an Integer or packed in a String, ...
  class Digits
    def initialize(*args)
      if Hash === args.last
        options = args.pop
      else
        options = {}
      end
      @radix = options[:base] || options[:radix] || 10
      if args.size == 1 && Array === args.first
        @digits_array = args.first
      else
        @digits_array = args
      end
      if options[:value]
        self.value = options[:value]
      end
    end

    include ModalSupport::BracketConstructor

    attr_reader :digits_array, :radix

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
      raise "Invalid digits value" if v < 0
      if @radix < 37
        replace v.to_s(@radix).each_char.map{|c| c.to_i(@radix)}
      else
        if v == 0
          replace [0]
        else
          while v > 0
            v, r = v.divmod(@radix)
            unshift r
          end
        end
      end
    end

    # Deep copy
    def dup
      Digits[@digits_array.dup, base: @radix]
    end

    def to_s
      args = ""
      if @digits_array.size > 0
        args << @digits_array.to_s.unwrap('[]')
        args << ', '
      end
      args << "base: #{radix}"
      "Digits[#{args}]"
    end

    def inspect
      to_s
    end

    def truncate!(n)
      @digits_array.slice! n..-1
    end
  end

end

