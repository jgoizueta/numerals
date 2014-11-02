require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestIntegerConversions <  Test::Unit::TestCase # < Minitest::Test

  def test_special
    assert_raise(ZeroDivisionError){ Conversions.numeral_to_number(Numeral.nan, Integer) }
    assert_raise(ZeroDivisionError){ Conversions.numeral_to_number(Numeral.infinity, Integer) }
    assert_raise(ZeroDivisionError){ Conversions.numeral_to_number(Numeral.infinity(-1), Integer) }
  end

  def test_integer_to_numeral
    exact = Rounding[:exact]
    nine_digits = Rounding[:half_even, precision: 9]

    assert_equal Numeral[1, point: 1], Conversions.number_to_numeral(1)
    assert_equal Numeral[1, point: 1], Conversions.number_to_numeral(1, exact)
    assert_equal Numeral[1, 0, 0, 0, 0, 0, 0, 0, 0, point: 1],
                 Conversions.number_to_numeral(1, nine_digits)

    assert_equal Numeral[1, point: 1, sign: -1], Conversions.number_to_numeral(-1)
    assert_equal Numeral[1, point: 1, sign: -1], Conversions.number_to_numeral(-1, exact)
    assert_equal Numeral[1, 0, 0, 0, 0, 0, 0, 0, 0, point: 1, sign: -1],
                 Conversions.number_to_numeral(-1, nine_digits)

    assert_equal Numeral[4, 2, point: 2], Conversions.number_to_numeral(42)
    assert_equal Numeral[4, 2, point: 2], Conversions.number_to_numeral(42, exact)
    assert_equal Numeral[4, 2, 0, 0, 0, 0, 0, 0, 0, point: 2],
                 Conversions.number_to_numeral(42, nine_digits)
  end

  def test_numeral_to_rational
    assert_raise IntegerConversion::InvalidConversion do
      Conversions.numeral_to_number(Numeral[3, point: 0, repeat: 0], Integer)
    end
    assert_raise IntegerConversion::InvalidConversion do
      Conversions.numeral_to_number(Numeral[[3]*9, point: 0, normalize: :approximate], Integer)
    end
    assert_raise IntegerConversion::InvalidConversion do
      Conversions.numeral_to_number(Numeral[1, point: 0], Integer)
    end
    assert_equal 1, Conversions.numeral_to_number(Numeral[1, point: 1], Integer)
    assert_equal -1, Conversions.numeral_to_number(Numeral[1, point: 1, sign: -1], Integer)
    assert_equal 42,
                 Conversions.numeral_to_number(Numeral[4, 2, point: 2], Integer)
  end

end
