require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestNumeral <  Test::Unit::TestCase # < Minitest::Test

  def test_mutated_copy
    f1 = Format[Rounding[precision: 3, base: 2]]

    f2 = f1.set(rounding: :exact)
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:exact, base: 2], f2.rounding

    f2 = f1.set_rounding(:exact)
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:exact, base: 2], f2.rounding

    f2 = f1.set(rounding: { precision: 4 })
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[precision: 4, base: 2], f2.rounding

    f2 = f1.set_rounding(precision: 4)
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[precision: 4, base: 2], f2.rounding

    f2 = f1.set(rounding: Rounding[:simplify])
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:simplify, base: 10], f2.rounding

    f2 = f1.set(Rounding[:simplify])
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:simplify, base: 10], f2.rounding

    f2 = f1.set_rounding(Rounding[:simplify])
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:simplify, base: 10], f2.rounding
  end


end
