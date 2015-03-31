module Numerals
  class Format < FormattingAspect
    class Error < StandardError
    end

    class InvalidRepeatingNumeral < Error
    end

    class InvalidNumberFormat < Error
    end

    class InvalidNumericType < Error
    end
  end
end

require 'numerals/format/mode'
require 'numerals/format/symbols'
require 'numerals/format/exp_setter'
require 'numerals/format/base_scaler'
require 'numerals/format/text_parts'
require 'numerals/format/notation'
require 'numerals/format/output'
require 'numerals/format/input'
require 'numerals/format/format'
