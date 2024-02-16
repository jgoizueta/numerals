module Numerals

  class Format
    def self.<<(*args)
      Format[].<<(*args)
    end

    def self.>>(*args)
      Format[].>>(*args)
    end

    def <<(*args)
      FormattingStream[self].<<(*args)
    end

    def >>(*args)
      FormattingStream[self].>>(*args)
    end
  end

  # Auxiliar class to implement << & >> operators
  # on Format class and Format instances as a
  # shortcut for the Format#write and #read
  # formatting operators.
  class FormattingStream
    def initialize(format)
      @format = format
      @text = nil
      @type = nil
      @output = []
    end

    def self.[](*args)
      new(*args)
    end

    def to_a
      @output
    end

    def to_s
      to_a.join
    end

    def to_str
      to_s
    end

    def value
      if @output.size > 1
        @output
      else
        @output.first
      end
    end

    def <<(*objects)
      objects.each do |object|
        case object
        when Format, Hash, Array
          @format.set! object
        when String
          if @type
            @output << @format.read(object, type: @type)
          else
            @output << object
          end
        else
          if @text
            @output << @format.read(@text, type: object)
          elsif object.is_a?(Class)
            @type = object
          else
            @output << @format.write(object)
          end
        end
      end
      self
    end

    def >>(*objects)
      objects.each do |object|
        case object
        when Format, Hash, Array
          @format.set! object
        when String
          @text = object
          if @type
            @output << @format.read(object, type: @type)
          end
        else
          if @text
            @output << @format.read(@text, type: object)
          elsif object.is_a?(Class)
            @type = object
          else
            @output << @format.write(object)
          end
        end
      end
      self
    end

    def clear
      @output.clear
    end

  end

end
