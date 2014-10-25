require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestNumeral <  Test::Unit::TestCase # < Minitest::Test

  def test_numeral_reference_constructors
    # We'll use this forms as reference for comparisons:
    #   Numeral[digits, base: ..., point: ... , repeat: ...]
    #   Numeral[symbol, sign: ...]

    n = Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 8], n.digits
    assert_equal 0123456, n.digits.value
    assert_equal 8, n.digits.radix
    assert_equal 8, n.radix
    assert_equal 2, n.point
    assert_equal 4, n.repeat
    assert_equal 4, n.repeating_position
    assert_equal +1, n.sign
    assert n.repeating?

    n = Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: +1]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 8], n.digits
    assert_equal 0123456, n.digits.value
    assert_equal 8, n.digits.radix
    assert_equal 8, n.radix
    assert_equal 2, n.point
    assert_equal 4, n.repeat
    assert_equal 4, n.repeating_position
    assert_equal +1, n.sign
    assert n.repeating?

    n = Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: -1]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 8], n.digits
    assert_equal 0123456, n.digits.value
    assert_equal 8, n.digits.radix
    assert_equal 8, n.radix
    assert_equal 2, n.point
    assert_equal 4, n.repeat
    assert_equal 4, n.repeating_position
    assert_equal -1, n.sign
    assert n.repeating?

    n = Numeral[[1,2,3,4,5,6], point: 2, repeat: 4]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 10], n.digits
    assert_equal 123456, n.digits.value
    assert_equal 10, n.digits.radix
    assert_equal 10, n.radix
    assert_equal 2, n.point
    assert_equal 4, n.repeat
    assert_equal 4, n.repeating_position
    assert n.repeating?

    n = Numeral[[1,2,3,4,5,6], repeat: 4]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 10], n.digits
    assert_equal 123456, n.digits.value
    assert_equal 10, n.digits.radix
    assert_equal 10, n.radix
    assert_equal 6, n.point
    assert_equal 4, n.repeat
    assert_equal 4, n.repeating_position
    assert n.repeating?

    n = Numeral[[1,2,3,4,5,6], point: 2]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 10], n.digits
    assert_equal 123456, n.digits.value
    assert_equal 10, n.digits.radix
    assert_equal 10, n.radix
    assert_equal 2, n.point
    assert_equal 6, n.repeat
    assert_equal 6, n.repeating_position
    refute n.repeating?

    n = Numeral[[1,2,3,4,5,6], point: 2, normalize: :approximate]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 10], n.digits
    assert_equal 123456, n.digits.value
    assert_equal 10, n.digits.radix
    assert_equal 10, n.radix
    assert_equal 2, n.point
    assert_nil n.repeat
    assert_equal 6, n.repeating_position
    refute n.repeating?

    n = Numeral[[1,2,3,4,5,6], point: 2, repeat: 6]
    refute n.special?
    assert_equal Digits[1,2,3,4,5,6, base: 10], n.digits
    assert_equal 123456, n.digits.value
    assert_equal 10, n.digits.radix
    assert_equal 10, n.radix
    assert_equal 2, n.point
    assert_equal 6, n.repeat
    assert_equal 6, n.repeating_position
    refute n.repeating?

    n = Numeral[:inf, sign: +1]
    assert n.special?
    refute n.nan?
    assert n.infinite?
    assert n.positive_infinite?
    assert_equal :inf, n.special
    assert_equal +1, n.sign

    n = Numeral[:inf, sign: -1]
    assert n.special?
    assert !n.nan?
    assert n.infinite?
    assert n.negative_infinite?
    assert_equal :inf, n.special
    assert_equal -1, n.sign

    n = Numeral[:nan]
    assert n.special?
    assert n.nan?
    refute n.infinite?
    refute n.negative_infinite?
    refute n.positive_infinite?
    assert_equal :nan, n.special
  end

  def test_numeral_equality
    assert_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: +1], Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4]
    assert_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: -1], Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: -1]
    assert_equal Numeral[[1,2,3,4,5,6], base: 10, point: 2, repeat: 4], Numeral[[1,2,3,4,5,6], base: 10, point: 2, repeat: 4]
    assert_equal Numeral[[1,2,3,4,5,6], base: 10, point: 2, repeat: 4], Numeral[[1,2,3,4,5,6], point: 2, repeat: 4]
    assert_equal Numeral[[1,2,3,4,5,6], base: 10, point: 6, repeat: 4], Numeral[[1,2,3,4,5,6], point: 6, repeat: 4]
    assert_equal Numeral[[1,2,3,4,5,6], base: 10, point: 6, repeat: 4], Numeral[[1,2,3,4,5,6], repeat: 4]
    assert_equal Numeral[[1,2,3,4,5,6], base: 10, point: 6], Numeral[[1,2,3,4,5,6], point: 6]
    assert_equal Numeral[:nan], Numeral[:nan]
    assert_equal Numeral[:inf, sign: +1], Numeral[:inf, sign: +1]
    assert_equal Numeral[:inf, sign: -1], Numeral[:inf, sign: -1]

    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: +1], Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: -1]
    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: -1], Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4, sign: +1]
    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4], Numeral[[1,2,4,3,5,6], base: 8, point: 2, repeat: 4]
    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4], Numeral[[1,2,3,4,5,6], base: 10, point: 2, repeat: 4]
    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4], Numeral[[1,2,3,4,5,6], base: 8, point: 3, repeat: 4]
    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4], Numeral[[1,2,3,4,5,6], base: 8, repeat: 4]
    refute_equal Numeral[[1,2,3,4,5,6], base: 8, point: 2, repeat: 4], Numeral[[1,2,3,4,5,6], base: 8, point: 2]
    refute_equal Numeral[:nan], Numeral[:inf, sign: -1]
    refute_equal Numeral[:inf, sign: +1], Numeral[:inf, sign: -1]
    refute_equal Numeral[:inf, sign: -1], Numeral[:inf, sign: +1]
    refute_equal Numeral[:inf, sign: -1], Numeral[:nan]
  end


  def test_special_constructors
    assert_equal Numeral[:nan], Numeral.nan
    assert_equal Numeral[:inf, sign: +1], Numeral[:inf]
    assert_equal Numeral[:inf, sign: +1], Numeral.positive_infinity
    assert_equal Numeral[:inf, sign: -1], Numeral.negative_infinity
  end


  def test_numeral_constructors
    assert_equal Numeral[2, 3, 5, 7, 9, point: 2, base: 10], Numeral[2, 3, :point, 5, 7, 9]
    assert_equal Numeral[2, 3, 5, 7, 9, point: 2, repeat: 4], Numeral[2, 3, :point, 5, 7, :repeat, 9]
    assert_equal Numeral[2, 3, 5, 7, 9, point: 2, repeat: 3], Numeral[2, 3, :point, 5, :repeat, 7, 9]
    assert_equal Numeral[2, 3, 5, 7, 9, point: 2, repeat: 2], Numeral[2, 3, :point, :repeat, 5, 7, 9]
    assert_equal Numeral[2, 3, 5, 7, 9, point: 2, repeat: 2], Numeral[2, 3, :repeat, :point, 5, 7, 9]
    assert_equal Numeral[2, 3, 5, 7, 9, point: 3, repeat: 1], Numeral[2, :repeat, 3, 5, :point, 7, 9]
    assert_equal Numeral[2, 3, 5, 7, 9, point: 2, base: 10], Numeral[Digits[2, 3, 5, 7, 9, base: 10], point: 2]

    assert_equal Numeral[0, point: 1, base: 10], Numeral.zero
    assert_equal Numeral[0, point: 1, base: 8], Numeral.zero(base: 8)
    assert_equal Numeral[1, 1, 5, point: 5, sign: +1, base: 10], Numeral.integer(11500)
    assert_equal Numeral[1, 1, 5, point: 5, sign: -1, base: 10], Numeral.integer(-11500)
    assert_equal Numeral[2, 6, 3, 5, 4, point: 5, sign: +1, base: 8], Numeral.integer(+11500, base: 8)
    assert_equal Numeral[2, 6, 3, 5, 4, point: 5, sign: -1, base: 8], Numeral.integer(-11500, base: 8)
  end

  def test_quotient_to_numeral
    assert_equal Numeral[2, 3, point: 1, repeat: 1], Numeral.from_quotient(7,3)
    assert_equal Numeral[2, 3, point: 1, repeat: 1], Numeral.from_quotient([7,3])
    assert_equal Numeral[:nan], Numeral.from_quotient(0,0)
    assert_equal Numeral[:inf, sign: +1], Numeral.from_quotient(1,0)
    assert_equal Numeral[:inf, sign: +1], Numeral.from_quotient(10,0)
    assert_equal Numeral[:inf, sign: -1], Numeral.from_quotient(-1,0)
    assert_equal Numeral[:inf, sign: -1], Numeral.from_quotient(-10,0)
    assert_equal Numeral[2,5,4,3,4,2,1,2,6,7,8, point: 3, repeat: 8], Numeral.from_quotient(4234796411, 16650000)
    assert_equal Numeral[3, point: 0, repeat: 0], Numeral.from_quotient(1, 3)
    assert_equal Numeral[3, point: 1, repeat: 0], Numeral.from_quotient(10, 3)
    assert_equal Numeral[3, point: 2, repeat: 0], Numeral.from_quotient(100, 3)
    assert_equal Numeral[3, point: 3, repeat: 0], Numeral.from_quotient(1000, 3)
    assert_equal Numeral[3, point: -1, repeat: 0], Numeral.from_quotient(1, 30)
    assert_equal Numeral[3, point: -2, repeat: 0], Numeral.from_quotient(1, 300)
    assert_equal Numeral[3, point: -3, repeat: 0], Numeral.from_quotient(1, 3000)
    assert_equal Numeral[7,2,1,4, point: 1, repeat: 2, sign: -1], Numeral.from_quotient(-3571, 495)
    assert_equal Numeral[1,2,3,4,5,4,5, point: 1, repeat: 1], Numeral.from_quotient(1234544, 999999)
    assert_equal Numeral[1,2,3,4,5,4,5,2,3,4,5, point: 1, repeat: 9], Numeral.from_quotient(678999879, 550000000)
    assert_equal Numeral[1,2,3,4,5,4,5,2,3,4,5, point: 1, repeat: 9], Numeral.from_quotient(678999879, 550000000)
  end

  def test_numeral_to_quotient
    assert_equal [7, 3], Numeral[2, 3, point: 1, repeat: 1].to_quotient
    assert_equal [-7, 3], Numeral[2, 3, point: 1, repeat: 1, sign: -1].to_quotient
    assert_equal [0,0], Numeral[:nan].to_quotient
    assert_equal [1,0], Numeral[:inf, sign: +1].to_quotient
    assert_equal [-1,0], Numeral[:inf, sign: -1].to_quotient
    assert_equal [4, 3], Numeral[1, 3, point: 1, repeat: 1].to_quotient
    assert_equal [4234796411, 16650000], Numeral[2,5,4,3,4,2,1,2,6,7,8, point: 3, repeat: 8].to_quotient
    assert_equal [1, 3], Numeral[3, point: 0, repeat: 0].to_quotient
    assert_equal [1, 3], Numeral[0,3, point: 1, repeat: 1].to_quotient
    assert_equal [10, 3], Numeral[3, point: 1, repeat: 0].to_quotient
    assert_equal [100, 3], Numeral[3, point: 2, repeat: 0].to_quotient
    assert_equal [1000, 3], Numeral[3, point: 3, repeat: 0].to_quotient
    assert_equal [1000, 3], Numeral[3,3,3,3, point: 3, repeat: 3].to_quotient
    assert_equal [1, 30], Numeral[3, point: -1, repeat: 0].to_quotient
    assert_equal [1, 300], Numeral[3, point: -2, repeat: 0].to_quotient
    assert_equal [1, 3000], Numeral[3, point: -3, repeat: 0].to_quotient
    assert_equal [1, 3000], Numeral[0,0,0,0,3, point: 1, repeat: 4].to_quotient
    assert_equal [-3571, 495], Numeral[7,2,1,4, point: 1, repeat: 2, sign: -1].to_quotient
    assert_equal [-3571, 495], Numeral[7,2,1,4,1,4, point: 1, repeat: 4, sign: -1].to_quotient
    assert_equal [-3571, 495], Numeral[7,2,1,4,1,4,1,4, point: 1, repeat: 6, sign: -1].to_quotient
    assert_equal [1234544, 999999], Numeral[1,2,3,4,5,4,5, point: 1, repeat: 1].to_quotient
    assert_equal [678999879, 550000000], Numeral[1,2,3,4,5,4,5,2,3,4,5, point: 1, repeat: 9].to_quotient
    assert_equal [-3571, 495], Numeral[7,2,1,4, point: 1, repeat: 2, sign: -1].to_quotient
    assert_equal [-3571, 495], Numeral[7,2,1,4,1,4, point: 1, repeat: 4, sign: -1].to_quotient
    assert_equal [-3571, 495], Numeral[7,2,1,4,1,4,1,4, point: 1, repeat: 6, sign: -1].to_quotient
    assert_equal [1234544, 999999], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 7].to_quotient
    assert_equal [678999879, 550000000], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5,4,5, point: 1, repeat: 13].to_quotient
    assert_equal [678999879, 550000000], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 11].to_quotient
    assert_equal [678999879, 550000000], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 9].to_quotient

    assert_equal [1, 1], Numeral[9, point: 0, repeat: 0].to_quotient
    assert_equal [1, 5], Numeral[1,9, point: 0, repeat: 1].to_quotient
    assert_equal [1, 10], Numeral[1,9, point: 0, repeat: 1, base: 16].to_quotient
  end

  def test_numeral_normalization
    # exclude extra repetitions
    assert_equal Numeral[7,2,1,4, point: 1, repeat: 2], Numeral[7,2,1,4,1,4, point: 1, repeat: 4]
    assert_equal Numeral[7,2,1,4, point: 1, repeat: 2], Numeral[7,2,1,4,1,4,1,4, point: 1, repeat: 6]
    assert_equal Numeral[1,2,3,4,5,4,5, point: 1, repeat: 1], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 7]
    assert_equal Numeral[1,2,3,4,5,4,5,2,3,4,5, point: 1, repeat: 9], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5,4,5, point: 1, repeat: 13]
    assert_equal Numeral[1,2,3,4,5,4,5,2,3,4,5, point: 1, repeat: 9], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 11]
    assert_equal Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 9], Numeral[1,2,3,4,5,4,5,2,3,4,5,4,5, point: 1, repeat: 9]

    assert_equal Numeral.integer(1), Numeral[9, point: 0, repeat: 0]
    assert_equal Numeral[2, point: 0], Numeral[1,9, point: 0, repeat: 1]

  end

  def test_quotient_conversion
    [[7,3], [1,3], [10,3], [100,3], [1000,3], [1000000000000, 3], [3,1], [3,1000],
     [1, 30], [1, 300], [1, 3000],
     [117,119], [1,10], [1,100], [100,1]].each do |num, den|
      r = Rational(num, den)
      r = [r.numerator, r.denominator]
      [3,5,7,8,10,16,32,50].each do |base|
        assert_equal r, Numeral.from_quotient(r, base: base).to_quotient
      end
    end
    # TODO: set maximum_digits properly and test:
    # assert_equal Rational(23, 34324241934923424), Numeral.from_quotient(Rational(23, 34324241934923424)).to_quotient
  end

  def test_expand
    assert_equal Digits[1,2,3,4,5], Numeral[1,2,3,4,5, point: 1].expand(0).digits
    assert_equal 1, Numeral[1,2,3,4,5, point: 1].expand(0).point
    assert_equal Digits[1,2,3,4,5], Numeral[1,2,3,4,5, point: 1].expand(1).digits
    assert_equal Digits[1,2,3,4,5], Numeral[1,2,3,4,5, point: 1].expand(4).digits
    assert_equal Digits[1,2,3,4,5], Numeral[1,2,3,4,5, point: 1].expand(5).digits
    assert_equal Digits[1,2,3,4,5,0], Numeral[1,2,3,4,5, point: 1].expand(6).digits
    assert_equal Digits[1,2,3,4,5,0,0], Numeral[1,2,3,4,5, point: 1].expand(7).digits
    assert_equal Digits[1,2,3,4,5,0,0,0], Numeral[1,2,3,4,5, point: 1].expand(8).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0], Numeral[1,2,3,4,5, point: 1].expand(9).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0], Numeral[1,2,3,4,5, point: 1].expand(10).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0,0], Numeral[1,2,3,4,5, point: 1].expand(11).digits
    assert_equal Numeral[1,2,3,4,5,0,0,0,0,0,0, point: 1, unnormalized: true], Numeral[1,2,3,4,5, point: 1].expand(11)
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0,0], Numeral[1,2,3,4,5, point: 0].expand(11).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0,0], Numeral[1,2,3,4,5, point: 4].expand(11).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0,0], Numeral[1,2,3,4,5, point: 5].expand(11).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0,0], Numeral[1,2,3,4,5, point: 20].expand(11).digits
    assert_equal Digits[], Numeral[0, point: 1].expand(0).digits
    assert_equal Digits[0], Numeral[0, point: 1].expand(1).digits
    assert_equal Digits[0,0], Numeral[0, point: 1].expand(2).digits
    assert_equal Digits[0,0,0], Numeral[0, point: 1].expand(3).digits
    assert_equal Digits[0,0,0,0], Numeral[0, point: 1].expand(4).digits
    assert_equal Digits[1,2,3,4,5,0,0,0,0,0,0], Numeral[1,2,3,4,5, point: 1, sign: -1].expand(11).digits
    assert_equal Digits[7,2,1,4], Numeral[7,2,1,4,1,4, point: 1, repeat: 4].expand(3).digits
    assert_equal Digits[7,2,1,4], Numeral[7,2,1,4,1,4, point: 1, repeat: 4].expand(4).digits
    assert_equal Digits[7,2,1,4,1], Numeral[7,2,1,4,1,4, point: 1, repeat: 4].expand(5).digits
    assert_equal Digits[7,2,1,4,1,4], Numeral[7,2,1,4,1,4, point: 1, repeat: 4].expand(6).digits
    assert_equal Digits[7,2,1,4,1,4,1], Numeral[7,2,1,4,1,4, point: 1, repeat: 4].expand(7).digits
    assert_equal Numeral[1,2,3,4,5,0,0,0,0, point: 1, unnormalized: true], Numeral[1,2,3,4,5, point: 1].expand(11)
    assert_equal Digits[1,1,1,1], Numeral[0,1, point: 0, repeat: 1].expand(4).digits
  end

  def test_approximate_numerals
    approx = Numeral[1,2,3,4,5,0,0,0, point: 1, normalize: :approximate]
    assert approx.approximate?
    assert_equal Digits[1,2,3,4,5,0,0,0], approx.digits

    approx = Numeral[1,2,3,4,5, point: 1].approximate(8)
    assert approx.approximate?
    assert_equal Digits[1,2,3,4,5,0,0,0], approx.digits

    approx = Numeral.from_quotient([1,3]).approximate(10)
    assert approx.approximate?
    assert_equal Digits[3,3,3,3,3,3,3,3,3,3], approx.digits

    assert Numeral.from_quotient([1,3]).exact?
    assert Numeral[1,2,3,4,5, point: 1].exact?
    exact =  Numeral[1,2,3,4,5,0,0,0, point: 1]
    refute exact.approximate?
    assert_equal Digits[1,2,3,4,5], exact.digits
  end

end
