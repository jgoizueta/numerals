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

  def test_set_base
    f = Format[base: 2, rounding: :exact]
    assert_equal 2, f.base
    assert_equal Rounding[:exact, base: 2], f.rounding
    f.set_base! 5
    assert_equal 5, f.base
    assert_equal Rounding[:exact, base: 5], f.rounding
    f = f[base: 6]
    assert_equal 6, f.base
    assert_equal Rounding[:exact, base: 6], f.rounding
  end

  def test_aspects
    f = Format[exact_input: true, rounding: Rounding[precision: 5]]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding

    f = Format[:exact_input, Rounding[precision: 5]]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding

    f = Format[Rounding[precision: 5], exact_input: false]
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding

    f = f[exact_input: true]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding

    f = f[rounding: { precision: 6 }]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 6], f.rounding

    f = f.set_exact_input(false)
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 6], f.rounding

    f = f.set_rounding(precision: 10)
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 10], f.rounding
  end

end
