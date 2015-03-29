require 'numerals/conversions'
require 'flt'

# Base class for Conversions of type with context
class Numerals::ContextConversion

  def initialize(context_or_type, options={})
    if Class === context_or_type && context_or_type.respond_to?(:context)
      @type = context_or_type
      @context = @type.context
    elsif context_or_type.respond_to?(:num_class)
      @context = context_or_type
      @type = @context.num_class
    else
      raise "Invalid Conversion definition"
    end
    self.input_rounding = options[:input_rounding]
  end

  attr_reader :context, :type, :input_rounding

  def input_rounding=(rounding)
    if rounding
      if rounding == :context
        @input_rounding = Rounding[@context.rounding, precision: @context.precision, base: @context.radix]
      else
        rounding = Rounding[base: @context.radix].set!(rounding)
        if rounding.base == @context.radix
          @input_rounding = rounding
        else
          # The rounding precision is not meaningful for the destination type on input
          @input_rounding = Rounding[rounding.mode, base: @context.radix]
        end
      end
    else
      @input_rounding = nil
    end
  end

end
