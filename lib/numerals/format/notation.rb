module Numerals

  class Format

    class Notation

      def initialize(format)
        @format = format
      end

      attr_reader :format

      def assemble(output, text_parts)
        raise "assemble must be implemented in Notation derived class #{self.class}"
      end

      def disassemble(text)
        raise "disassemble must be implemented in Notation derived class #{self.class}"
      end

    end

    @notations = {}

    def self.define_notation(id, notation_class)
      unless notation_class.class == Class && notation_class.superclass == Notation
        raise "Notation class must be derived from Format::Notation"
      end
      @notations[id] = notation_class
    end

    def self.notation(id, format)
      @notations[id].new(format) || raise("Unknown notation #{id.inspect}")
    end


    def self.assemble(id, output, format, text_parts)
      notation(id, format).assemble(output, text_parts)
    end

    def self.disassemble(id, format, text)
      notation(id, format).disassemble(text)
    end

  end

end

require 'numerals/format/notations/text'
require 'numerals/format/notations/latex'
require 'numerals/format/notations/html'
