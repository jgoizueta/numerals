require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestIntegerConversions <  Test::Unit::TestCase # < Minitest::Test

  def test_read_special
    assert_raise(ZeroDivisionError){ Conversions.read(Numeral.nan, type: Integer) }
    assert_raise(ZeroDivisionError){ Conversions.read(Numeral.infinity, type: Integer) }
    assert_raise(ZeroDivisionError){ Conversions.read(Numeral.infinity(-1), type: Integer) }
  end

  def test_write
    exact = Rounding[:short]
    nine_digits = Rounding[:half_even, precision: 9]

    assert_equal Numeral[1, point: 1], Conversions.write(1)
    assert_equal Numeral[1, point: 1], Conversions.write(1, rounding: exact)
    assert_equal Numeral[1, 0, 0, 0, 0, 0, 0, 0, 0, point: 1],
                 Conversions.write(1, rounding: nine_digits)

    assert_equal Numeral[1, point: 1, sign: -1], Conversions.write(-1)
    assert_equal Numeral[1, point: 1, sign: -1], Conversions.write(-1, rounding: exact)
    assert_equal Numeral[1, 0, 0, 0, 0, 0, 0, 0, 0, point: 1, sign: -1],
                 Conversions.write(-1, rounding: nine_digits)

    assert_equal Numeral[4, 2, point: 2], Conversions.write(42)
    assert_equal Numeral[4, 2, point: 2], Conversions.write(42, rounding: exact)
    assert_equal Numeral[4, 2, 0, 0, 0, 0, 0, 0, 0, point: 2],
                 Conversions.write(42, rounding: nine_digits)
  end

  def test_read
    assert_raise IntegerConversion::InvalidConversion do
      Conversions.read(Numeral[3, point: 0, repeat: 0], type: Integer)
    end
    assert_raise IntegerConversion::InvalidConversion do
      Conversions.read(Numeral[[3]*9, point: 0, normalize: :approximate], type: Integer)
    end
    assert_raise IntegerConversion::InvalidConversion do
      Conversions.read(Numeral[1, point: 0], type: Integer)
    end
    assert_equal 1, Conversions.read(Numeral[1, point: 1], type: Integer)
    assert_equal -1, Conversions.read(Numeral[1, point: 1, sign: -1], type: Integer)
    assert_equal 42,
                 Conversions.read(Numeral[4, 2, point: 2], type: Integer)
  end

end
