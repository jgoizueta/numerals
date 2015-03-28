module Numerals
  class Format < FormattingAspect
    class Error < StandardError
    end

    class InvalidRepeatingNumeral < Error
    end
  end
end

require 'numerals/format/mode'
require 'numerals/format/symbols'
require 'numerals/format/exp_setter'
require 'numerals/format/base_scaler'
require 'numerals/format/text_parts'
require 'numerals/format/assembler'
require 'numerals/format/output'
require 'numerals/format/input'
require 'numerals/format/format'
