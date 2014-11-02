require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestFloatConversions <  Test::Unit::TestCase # < Minitest::Test

  def test_special
    assert_equal Numeral.nan, Conversions.number_to_numeral(Float.context.nan)
    assert_equal Numeral.nan, Conversions.number_to_numeral(Float.context.nan, :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral.nan, Conversions.number_to_numeral(Float.context.nan, :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral.nan, Conversions.number_to_numeral(Float.context.nan, :fixed, Rounding[precision: 10, base: 10])
    assert_equal Numeral.nan, Conversions.number_to_numeral(Float.context.nan, :free)

    assert_equal Numeral.infinity, Conversions.number_to_numeral(Float.context.infinity)
    assert_equal Numeral.infinity, Conversions.number_to_numeral(Float.context.infinity, :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral.infinity, Conversions.number_to_numeral(Float.context.infinity, :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral.infinity, Conversions.number_to_numeral(Float.context.infinity, :fixed, Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity, Conversions.number_to_numeral(Float.context.infinity, :free)

    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(Float.context.infinity(-1))
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(Float.context.infinity(-1), :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(Float.context.infinity(-1), :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(Float.context.infinity(-1), :fixed, Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(Float.context.infinity(-1), :free)

    assert       Conversions.numeral_to_number(Numeral.nan, Float).nan?
    assert_equal Float.context.infinity, Conversions.numeral_to_number(Numeral.infinity, Float)
    assert_equal Float.context.infinity(-1), Conversions.numeral_to_number(Numeral.infinity(-1), Float)
  end

  def test_exact
    assert_equal Numeral[1,point:1], Conversions.number_to_numeral(1.0, :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral[1,point:1, sign: -1], Conversions.number_to_numeral(-1.0, :fixed, Rounding[:exact, base: 10])

    assert_equal Numeral[1,point:1, base: 2], Conversions.number_to_numeral(1.0, :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral[1,point:1, sign: -1, base: 2], Conversions.number_to_numeral(-1.0, :fixed, Rounding[:exact, base: 2])

    [0.1, 0.01, 0.001, 1/3.0, 10/3.0, 100/3.0, Math::PI, 0.5, 123.0, 123.45, 1.23E32, 1.23E-32].each do |x|
      [x, -x].each do |y|
        numeral = exact_decimal(y)
        tmp = Conversions.number_to_numeral(y, :fixed, Rounding[:exact, base: 10])
        assert_equal numeral, Conversions.number_to_numeral(y, :fixed, Rounding[:exact, base: 10]), "#{y} to base 10 exact numeral"
        assert_equal y, Conversions.numeral_to_number(numeral, Float), "#{x} base 10 numeral to float"
      end
    end
  end

  def exact_decimal(x)
    Flt::DecNum.context(exact: true){
      Flt::BinNum.context(Flt::BinNum::FloatContext){
        d = Flt::BinNum(x).to_decimal_exact
        Numeral[d.coefficient.to_s.chars.map(&:to_i), sign: d.sign, point: d.fractional_exponent, normalize: :exact]
      }
    }
  end

end