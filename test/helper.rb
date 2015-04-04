require 'test/unit'
# require 'minitest/spec'
# require 'minitest/unit'
$: << "." unless $:.include?(".") # for Ruby 1.9.2
require File.expand_path(File.join(File.dirname(__FILE__),'/../lib/numerals'))

require 'yaml'

module PrepareData

    @@data = []

    def self.add(x)
      @@data << [x].pack('E').unpack('H*')[0].upcase
    end

    def self.init
      unless File.exist?('test/data.yaml')
        100.times do
           x = rand
           x *= rand(1000) if rand<0.5
           x /= rand(1000) if rand<0.5
           x *= rand(9999) if rand<0.5
           x /= rand(9999) if rand<0.5
           x = -x if rand<0.5
           #puts x
           add x
         end
         add 1.0/3
         add 0.1
         File.open('test/data.yaml','w') { |out| out << @@data.to_yaml }
       end
    end
end

PrepareData.init

def BigDec(x)
  BigDecimal.new(x.to_s)
end


def assert_same_number(x, y)
  assert_equal x.class, y.class, x.to_s
  case x
  when Flt::Num
    assert_equal x.split, y.split, x.to_s
  when Float
    assert_equal Float.context.split(x), Float.context.split(y), x.to_s
  when Rational
    assert_equal [x.numerator, x.denominator], [y.numerator, y.denominator]
  else
    assert_equal x, y
  end
end
