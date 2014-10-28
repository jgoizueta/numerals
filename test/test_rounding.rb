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
end
