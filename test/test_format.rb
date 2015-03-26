require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestFormat <  Test::Unit::TestCase # < Minitest::Test

  def test_mutated_copy
    f1 = Format[Rounding[precision: 3, base: 2]]

    f2 = f1.set(rounding: :simplify)
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:simplify, base: 2], f2.rounding

    f2 = f1.set_rounding(:simplify)
    assert_equal Rounding[precision: 3, base: 2], f1.rounding
    assert_equal Rounding[:simplify, base: 2], f2.rounding

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
    f = Format[base: 2, rounding: :simplify]
    assert_equal 2, f.base
    assert_equal Rounding[:simplify, base: 2], f.rounding
    f.set_base! 5
    assert_equal 5, f.base
    assert_equal Rounding[:simplify, base: 5], f.rounding
    f = f[base: 6]
    assert_equal 6, f.base
    assert_equal Rounding[:simplify, base: 6], f.rounding
  end

  def test_aspects
    f = Format[exact_input: true, rounding: Rounding[precision: 5]]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding
    assert_equal Format::Mode[], f.mode

    f = Format[:exact_input, Rounding[precision: 5]]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding
    assert_equal Format::Mode[], f.mode

    f = Format[Rounding[precision: 5], exact_input: false]
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding
    assert_equal Format::Mode[], f.mode

    f = Format[Rounding[precision: 5], mode: :fixed]
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding
    assert_equal Format::Mode[:fixed], f.mode

    f = f[exact_input: true]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 5], f.rounding
    assert_equal Format::Mode[:fixed], f.mode

    f = f[rounding: { precision: 6 }]
    assert_equal true, f.exact_input
    assert_equal Rounding[precision: 6], f.rounding
    assert_equal Format::Mode[:fixed], f.mode

    f = f.set_exact_input(false)
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 6], f.rounding
    assert_equal Format::Mode[:fixed], f.mode

    f = f.set_rounding(precision: 10)
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 10], f.rounding
    assert_equal Format::Mode[:fixed], f.mode

    f = f.set_rounding(precision: 10).set_mode(:engineering)
    assert_equal false, f.exact_input
    assert_equal Rounding[precision: 10], f.rounding
    assert_equal Format::Mode[:engineering], f.mode
  end

  def test_redefine_aspects
    f = Format[Format::Mode[max_leading: 10]]
    f2 = f[Format::Mode[:scientific]]
    assert_equal :scientific, f2.mode.mode
    assert_equal Format[].mode.max_leading, f2.mode.max_leading
    f2 = f[mode: :scientific]
    assert_equal :scientific, f2.mode.mode
    assert_equal 10, f2.mode.max_leading

    f = Format[Rounding[base: 2]]
    f2 = f[Rounding[:simplify]]
    assert_equal :simplify, f2.rounding.precision
    assert_equal 10, f2.rounding.base
    f2 = f[rounding: :simplify]
    assert_equal :simplify, f2.rounding.precision
    assert_equal 2, f2.rounding.base

    f = Format[Format::Symbols[plus: 'PLUS']]
    f2 = f[Format::Symbols[nan: 'Not a Number']]
    assert_equal 'Not a Number', f2.symbols.nan
    assert_equal '+', f2.symbols.plus
    f2 = f[symbols: { nan: 'Not a Number' }]
    assert_equal 'Not a Number', f2.symbols.nan
    assert_equal 'PLUS', f2.symbols.plus
  end

end
