require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'

class TestFloatConversions <  Test::Unit::TestCase # < Minitest::Test

  include Numerals

  def test_write_special
    assert_equal Numeral.nan, Conversions.write(Float.context.nan)
    assert_equal Numeral.nan, Conversions.write(Float.context.nan, rounding: Rounding[:short, base: 2])
    assert_equal Numeral.nan, Conversions.write(Float.context.nan, rounding: Rounding[:short, base: 10])
    assert_equal Numeral.nan, Conversions.write(Float.context.nan, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.nan, Conversions.write(Float.context.nan)

    assert_equal Numeral.infinity, Conversions.write(Float.context.infinity)
    assert_equal Numeral.infinity, Conversions.write(Float.context.infinity, rounding: Rounding[:short, base: 2])
    assert_equal Numeral.infinity, Conversions.write(Float.context.infinity, rounding: Rounding[:short, base: 10])
    assert_equal Numeral.infinity, Conversions.write(Float.context.infinity, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity, Conversions.write(Float.context.infinity)

    assert_equal Numeral.infinity(-1), Conversions.write(Float.context.infinity(-1))
    assert_equal Numeral.infinity(-1), Conversions.write(Float.context.infinity(-1), rounding: Rounding[:short, base: 2])
    assert_equal Numeral.infinity(-1), Conversions.write(Float.context.infinity(-1), rounding: Rounding[:short, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.write(Float.context.infinity(-1), rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.write(Float.context.infinity(-1))
  end

  def test_read_special
    assert       Conversions.read(Numeral.nan, type: Float).nan?
    assert_equal Float.context.infinity, Conversions.read(Numeral.infinity, type: Float)
    assert_equal Float.context.infinity(-1), Conversions.read(Numeral.infinity(-1), type: Float)
  end

  def test_write_read_exact
    assert_equal Numeral[1,point:1], Conversions.write(1.0, rounding: Rounding[:short, base: 10])
    assert_equal Numeral[1,point:1, sign: -1], Conversions.write(-1.0, rounding: Rounding[:short, base: 10])

    assert_equal Numeral[1,point:1, base: 2], Conversions.write(1.0, rounding: Rounding[:short, base: 2])
    assert_equal Numeral[1,point:1, sign: -1, base: 2], Conversions.write(-1.0, rounding: Rounding[:short, base: 2])

    [0.1, 0.01, 0.001, 1/3.0, 10/3.0, 100/3.0, Math::PI, 0.5, 123.0, 123.45, 1.23E32, 1.23E-32].each do |x|
      [x, -x].each do |y|
        numeral = exact_decimal(y)
        tmp = Conversions.write(y, rounding: Rounding[:short, base: 10])
        assert_equal numeral, Conversions.write(y, exact: true, rounding: Rounding[:short, base: 10]), "#{y} to base 10 exact numeral"
        assert_equal y, Conversions.read(numeral, type: Float), "#{x} base 10 numeral to float"
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

  def test_type_parameters
    c = Conversions[Float, input_rounding: :down]
    assert_equal Rounding[:down, base: Float::RADIX], c.input_rounding
    c = Conversions[Float, input_rounding: :half_even]
    assert_equal Rounding[:half_even, base: Float::RADIX], c.input_rounding

    c = Conversions[Float, input_rounding: Rounding[:half_up, precision: 7, base: 3]]
    assert_equal Rounding[:half_up, base: Float::RADIX], c.input_rounding

    c = Conversions[Float.context, input_rounding: :context]
    assert_equal Float.context.radix, c.input_rounding.base
    assert_equal Float.context.rounding, c.input_rounding.mode
    assert_equal Float.context.precision, c.input_rounding.precision
  end

end
