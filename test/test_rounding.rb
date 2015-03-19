require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals/rounding'
include Numerals

class TestRounding <  Test::Unit::TestCase # < Minitest::Test

  def test_rounding
    r = Rounding[:half_even, places: 0]
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3])
    assert_equal Numeral[1,0,2, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3])

    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,2, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3, sign: -1])

    r = Rounding[:half_up, places: 0]
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3])
    assert_equal Numeral[1,0,2, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3])

    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,2, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3, sign: -1])

    r = Rounding[:half_even, precision: 3]
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3])
    assert_equal Numeral[1,0,2, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3])

    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,2, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3, sign: -1])

    r = Rounding[:half_up, precision: 3]
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3])
    assert_equal Numeral[1,0,2, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,1, point: 3, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3])
    assert_equal Numeral[1,0,0, point: 3, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3])

    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,2, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,5, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,5,0,0,1, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,6, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,1, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,1,4,9,9,9, point: 3, sign: -1])
    assert_equal Numeral[1,0,0, point: 3, sign: -1, normalize: :approximate], r.round(Numeral[1,0,0,4,9,9,9,9,9,9,9,9,9,9,9,9, point: 3, sign: -1])
  end

  def test_extended_rounding
    # Rounding past the precision of a number
    r = Rounding[:half_up, precision: 5]
    assert_equal Numeral[1, 2, 3, 0, 0, point: 1, normalize: :approximate], r.round(Numeral[1, 2, 3, point: 1, normalize: :exact])
    # currently, approximate numerals cannot be extended
    assert_equal Numeral[1, 2, 3, point: 1, normalize: :approximate], r.round(Numeral[1, 2, 3, point: 1, normalize: :approximate])
  end

  def test_constructor
    r = Rounding[:exact]
    assert r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert_equal :exact, r.mode
    assert_equal 10, r.base
    assert_equal 0, r.precision
    assert_nil r.places

    r = Rounding[:exact, base: 2]
    assert r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert_equal :exact, r.mode
    assert_equal 2, r.base
    assert_equal 0, r.precision
    assert_nil r.places

    r = Rounding[:simplify]
    assert r.exact?
    assert r.simplifying?
    refute r.preserving?
    assert_equal :simplify, r.mode
    assert_equal 10, r.base
    assert_equal 0, r.precision
    assert_nil r.places

    r = Rounding[:simplify, base: 2]
    assert r.exact?
    assert r.simplifying?
    refute r.preserving?
    assert_equal :simplify, r.mode
    assert_equal 2, r.base
    assert_equal 0, r.precision
    assert_nil r.places

    r = Rounding[:preserve]
    assert r.exact?
    refute r.simplifying?
    assert r.preserving?
    assert_equal :preserve, r.mode
    assert_equal 10, r.base
    assert_equal 0, r.precision
    assert_nil r.places

    r = Rounding[:preserve, base: 2]
    assert r.exact?
    refute r.simplifying?
    assert r.preserving?
    assert_equal :preserve, r.mode
    assert_equal 2, r.base
    assert_equal 0, r.precision
    assert_nil r.places

    r = Rounding[precision: 5]
    refute r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :half_even, r.mode
    assert_equal 10, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[precision: 5, base: 2]
    refute r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :half_even, r.mode
    assert_equal 2, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[:down, precision: 5]
    refute r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :down, r.mode
    assert_equal 10, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[:down, precision: 5, base: 2]
    refute r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :down, r.mode
    assert_equal 2, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[mode: :down, precision: 5]
    refute r.exact?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :down, r.mode
    assert_equal 10, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[places: 5]
    refute r.exact?
    refute r.simplifying?
    refute r.preserving?
    refute r.relative?
    assert r.absolute?
    assert_equal :half_even, r.mode
    assert_equal 10, r.base
    assert_nil r.precision
    assert_equal 5, r.places
  end

  def test_copy
    r1 = Rounding[:exact]
    r2 = Rounding[r1]
    assert_equal :exact, r2.mode
    r2.mode = :simplify
    assert_equal :exact, r1.mode
    assert_equal :simplify, r2.mode

    r2 = r1[:simplify]
    assert_equal :exact, r1.mode
    assert_equal :simplify, r2.mode

    r1 = Rounding[:exact, base: 2]
    r2 = r1[precision: 10]
    assert_equal 2, r2.base
    assert_equal 10, r2.precision
    assert_equal :exact, r1.mode
    assert_equal :half_even, r2.mode

    r1 = Rounding[:exact, base: 2]
    r2 = r1.set(precision: 10)
    assert_equal 2, r2.base
    assert_equal 10, r2.precision
    assert_equal :exact, r1.mode
    assert_equal :half_even, r2.mode
  end

  def test_mutators
    r1 = Rounding[:exact]
    r2 = r1.set!(:simplify)
    assert_equal :simplify, r1.mode
    assert_equal :simplify, r2.mode
    assert_equal r1.object_id, r2.object_id
  end

end
