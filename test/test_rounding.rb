require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals/rounding'

class TestRounding <  Test::Unit::TestCase # < Minitest::Test

  include Numerals

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
    assert_equal Rounding[:short], Rounding[:simplify]
    r = Rounding[:short]
    assert r.free?
    refute r.fixed?
    assert r.simplifying?
    assert r.short?
    refute r.preserving?
    refute r.full?
    assert_equal :short, r.precision
    assert_equal 10, r.base
    assert_nil r.places

    r = Rounding[:short, base: 2]
    assert r.free?
    refute r.fixed?
    assert r.simplifying?
    refute r.preserving?
    assert_equal :short, r.precision
    assert_equal 2, r.base
    assert_nil r.places

    assert_equal Rounding[:free], Rounding[:preserve]
    r = Rounding[:free]
    assert r.free?
    refute r.fixed?
    refute r.simplifying?
    assert r.preserving?
    assert_equal :free, r.precision
    assert_equal 10, r.base
    assert_nil r.places

    r = Rounding[:free, base: 2]
    assert r.free?
    refute r.fixed?
    refute r.simplifying?
    assert r.preserving?
    assert_equal :free, r.precision
    assert_equal 2, r.base
    assert_nil r.places

    r = Rounding[precision: 5]
    refute r.free?
    assert r.fixed?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :half_even, r.mode
    assert_equal 10, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[precision: 5, base: 2]
    refute r.free?
    assert r.fixed?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :half_even, r.mode
    assert_equal 2, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[:down, precision: 5]
    refute r.free?
    assert r.fixed?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :down, r.mode
    assert_equal 10, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[:down, precision: 5, base: 2]
    refute r.free?
    assert r.fixed?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :down, r.mode
    assert_equal 2, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[mode: :down, precision: 5]
    refute r.free?
    assert r.fixed?
    refute r.simplifying?
    refute r.preserving?
    assert r.relative?
    refute r.absolute?
    assert_equal :down, r.mode
    assert_equal 10, r.base
    assert_equal 5, r.precision
    assert_nil r.places

    r = Rounding[places: 5]
    refute r.free?
    assert r.fixed?
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
    r1 = Rounding[:short]
    r2 = Rounding[r1]
    assert_equal :short, r2.precision
    r2.precision = :free
    assert_equal :short, r1.precision
    assert_equal :free, r2.precision

    r2 = r1[:free]
    assert_equal :short, r1.precision
    assert_equal :free, r2.precision

    r1 = Rounding[:short, :half_up, base: 2]
    r2 = r1[precision: 10]
    assert_equal 2, r2.base
    assert_equal 10, r2.precision
    assert_equal :short, r1.precision
    assert_equal :half_up, r1.mode
    assert_equal :half_up, r2.mode

    r1 = Rounding[:short, base: 2]
    r2 = r1.set(precision: 10)
    assert_equal 2, r2.base
    assert_equal 10, r2.precision
    assert_equal :short, r1.precision
  end

  def test_mutators
    r1 = Rounding[:free]
    r2 = r1.set!(:short)
    assert_equal :short, r1.precision
    assert_equal :short, r2.precision
    assert_equal r1.object_id, r2.object_id
  end

end
