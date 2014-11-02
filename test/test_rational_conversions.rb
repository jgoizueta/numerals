require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestRationalConversions <  Test::Unit::TestCase # < Minitest::Test

  def test_special
    assert_raise(ZeroDivisionError){ Conversions.numeral_to_number(Numeral.nan, Rational) }
    assert_raise(ZeroDivisionError){ Conversions.numeral_to_number(Numeral.infinity, Rational) }
    assert_raise(ZeroDivisionError){ Conversions.numeral_to_number(Numeral.infinity(-1), Rational) }
  end

  def test_rational_to_numeral

    exact = Rounding[:exact]
    nine_digits = Rounding[:half_even, precision: 9]

    assert_equal Numeral[3, point: 0, repeat: 0],
                 Conversions.number_to_numeral(Rational(1, 3))
    assert_equal Numeral[3, point: 0, repeat: 0],
                 Conversions.number_to_numeral(Rational(1, 3), exact)
    assert_equal Numeral[[3]*9, point: 0, normalize: :approximate],
                 Conversions.number_to_numeral(Rational(1, 3), nine_digits)

    assert_equal Numeral[3, point: 0, repeat: 0, sign: -1],
                 Conversions.number_to_numeral(Rational(-1, 3))
    assert_equal Numeral[3, point: 0, repeat: 0, sign: -1],
                 Conversions.number_to_numeral(Rational(-1, 3), exact)
    assert_equal Numeral[[3]*9, point: 0, sign: -1, normalize: :approximate],
                 Conversions.number_to_numeral(Rational(-1, 3), nine_digits)

    assert_equal Numeral[1, point: 0],
                 Conversions.number_to_numeral(Rational(1, 10))
    assert_equal Numeral[1, point: 0],
                 Conversions.number_to_numeral(Rational(1, 10), exact)
    assert_equal Numeral[1,0,0,0,0,0,0,0,0, point: 0, normalize: :approximate],
                 Conversions.number_to_numeral(Rational(1, 10), nine_digits)

    assert_equal Numeral[1, point: 0, sign: -1],
                 Conversions.number_to_numeral(Rational(-1, 10))
    assert_equal Numeral[1, point: 0, sign: -1],
                 Conversions.number_to_numeral(Rational(-1, 10), exact)
    assert_equal Numeral[1,0,0,0,0,0,0,0,0, point: 0, sign: -1, normalize: :approximate],
                 Conversions.number_to_numeral(Rational(-1, 10), nine_digits)

    assert_equal Numeral[4,2, point: 2],
                 Conversions.number_to_numeral(Rational(42, 1))
    assert_equal Numeral[4,2, point: 2],
                 Conversions.number_to_numeral(Rational(42, 1), exact)
    assert_equal Numeral[4,2,0,0,0,0,0,0,0, point: 2, normalize: :approximate],
                 Conversions.number_to_numeral(Rational(42, 1), nine_digits)

  end

  def test_numeral_to_rational

    assert_equal Rational(1, 3),
                 Conversions.numeral_to_number(Numeral[3, point: 0, repeat: 0], Rational)
    assert_equal Rational(333_333_333, 1_000_000_000),
                 Conversions.numeral_to_number(Numeral[[3]*9, point: 0, normalize: :approximate], Rational)

    assert_equal Rational(1, 10),
                 Conversions.numeral_to_number(Numeral[1, point: 0], Rational)
    assert_equal Rational(1_000_000_000, 10_000_000_000),
                 Conversions.numeral_to_number(Numeral[1,0,0,0,0,0,0,0,0, point: 0, normalize: :approximate], Rational)

    assert_equal Rational(42, 1),
                 Conversions.numeral_to_number(Numeral[4, 2, point: 2], Rational)
   assert_equal Rational(42_000_000_000, 1_000_000_000),
                Conversions.numeral_to_number(Numeral[4,2,0,0,0,0,0,0,0, point: 2, normalize: :approximate], Rational)

  end

end
