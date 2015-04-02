require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'

class TestRepeatDetector <  Test::Unit::TestCase # < Minitest::Test

  include Numerals

  def test_repeat_detector

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], nil],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8])
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], 8],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8])
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8], nil],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8], 2)
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], 8],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8], 2)
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], 8],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8])
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8], nil],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8], 3)
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], 8],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8,6,7,8], 3)
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], 8],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8,6,7,8], 2)
    )

    assert_equal(
      [[2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8], 8],
      RepeatDetector.detect([2, 5, 4, 3, 4, 2, 1, 2, 6, 7, 8, 6, 7, 8, 6, 7, 8,6,7,8])
    )

    assert_equal(
      [[3], 0],
      RepeatDetector.detect([3, 3], 1)
    )

    assert_equal(
      [[3, 3], nil],
      RepeatDetector.detect([3, 3], 2)
    )

    assert_equal(
      [[3], 0],
      RepeatDetector.detect([3, 3, 3], 2)
    )

  end

end
