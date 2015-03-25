module Numerals

  class FormattingAspect

    def [](*args)
      set *args
    end

    def self.[](*args)
      new *args
    end

    def set(*args)
      dup.set! *args
    end

    def self.aspect(aspect, &blk)
      define_method :"set_#{aspect}!" do |*args|
        instance_exec(*args, &blk)
        self
      end
      define_method :"set_#{aspect}" do |*args|
        dup.send(:"set_#{aspect}!", *args)
      end
    end

    def self.set(*args, &blk)
      define_method :"set!" do |*args|
        instance_exec(*args, &blk)
        self
      end
    end

  end

end
