require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
require 'flt/bigdecimal'
include Numerals

class TestBigConversions <  Test::Unit::TestCase # < Minitest::Test


  def test_write_special
    context = BigDecimal.context
    type = BigDecimal

    assert_equal Numeral.nan, Conversions.write(context.nan)
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:exact, base: 2])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:exact, base: 10])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.nan, Conversions.write(context.nan)

    assert_equal Numeral.infinity, Conversions.write(context.infinity)
    assert_equal Numeral.infinity, Conversions.write(context.infinity, rounding: Rounding[:exact, base: 2])
    assert_equal Numeral.infinity, Conversions.write(context.infinity, rounding: Rounding[:exact, base: 10])
    assert_equal Numeral.infinity, Conversions.write(context.infinity, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity, Conversions.write(context.infinity)

    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1))
    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1), rounding: Rounding[:exact, base: 2])
    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1), rounding: Rounding[:exact, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1), rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1))
  end

  def test_read_special
    context = BigDecimal.context
    type = BigDecimal

    assert Conversions.read(Numeral.nan, type: type).nan?
    assert_equal context.infinity, Conversions.read(Numeral.infinity, type: type)
    assert_equal context.infinity(-1), Conversions.read(Numeral.infinity(-1), type: type)
  end

  def test_write_exact
    l = BigDecimal.limit(9)

    assert_equal Numeral[1,2,3,4,5,6,7,0,0, point: 3, normalize: :approximate],
                 Conversions.write(BigDecimal('123.4567'))
    assert_equal Numeral[1,2,3,4,5,6,7,0,0, point: 3, sign: -1, normalize: :approximate],
                 Conversions.write(BigDecimal('-123.4567'))

    BigDecimal.limit 0

    assert_equal Numeral[1,2,3,4,5,6,7, point: 3],
                 Conversions.write(BigDecimal('123.4567'))
    assert_equal Numeral[1,2,3,4,5,6,7, point: 3, sign: -1],
                 Conversions.write(BigDecimal('-123.4567'))

    BigDecimal.limit l
  end

  def test_write_simple
    l = BigDecimal.limit(9)

    assert_equal Numeral[1,2,3,4,5,6,7, point: 3],
                 Conversions.write(BigDecimal('123.4567'))
    assert_equal Numeral[1,2,3,4,5,6,7, point: 3, sign: -1],
                 Conversions.write(BigDecimal('-123.4567'))

    BigDecimal.limit 0

    assert_equal Numeral[1,2,3,4,5,6,7, point: 3],
                 Conversions.write(BigDecimal('123.4567'))
    assert_equal Numeral[1,2,3,4,5,6,7, point: 3, sign: -1],
                 Conversions.write(BigDecimal('-123.4567'))

    BigDecimal.limit l
  end

  def test_read

    assert_equal BigDecimal('123.4567'),
                 Conversions.read(
                   Numeral[1,2,3,4,5,6,7, point: 3], type: BigDecimal
                 )
    assert_equal BigDecimal('123.4567'),
                 Conversions.read(
                   Numeral[1,2,3,4,5,6,7, point: 3, normalize: :approximate],
                   type: BigDecimal
                 )
  end

  def test_special
    context = BigDecimal.context
    type = BigDecimal

    assert_equal Numeral.nan, Conversions.number_to_numeral(context.nan)
    assert_equal Numeral.nan, Conversions.number_to_numeral(context.nan, :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral.nan, Conversions.number_to_numeral(context.nan, :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral.nan, Conversions.number_to_numeral(context.nan, :fixed, Rounding[precision: 10, base: 10])
    assert_equal Numeral.nan, Conversions.number_to_numeral(context.nan, :free)

    assert_equal Numeral.infinity, Conversions.number_to_numeral(context.infinity)
    assert_equal Numeral.infinity, Conversions.number_to_numeral(context.infinity, :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral.infinity, Conversions.number_to_numeral(context.infinity, :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral.infinity, Conversions.number_to_numeral(context.infinity, :fixed, Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity, Conversions.number_to_numeral(context.infinity, :free)

    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(context.infinity(-1))
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(context.infinity(-1), :fixed, Rounding[:exact, base: 2])
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(context.infinity(-1), :fixed, Rounding[:exact, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(context.infinity(-1), :fixed, Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity(-1), Conversions.number_to_numeral(context.infinity(-1), :free)

    assert Conversions.numeral_to_number(Numeral.nan, type).nan?
    assert_equal context.infinity, Conversions.numeral_to_number(Numeral.infinity, type)
    assert_equal context.infinity(-1), Conversions.numeral_to_number(Numeral.infinity(-1), type)
  end

  def test_fixed_big_to_numeral
    l = BigDecimal.limit(9)

    assert_equal Numeral[1,2,3,4,5,6,7,0,0, point: 3, normalize: :approximate],
                 Conversions.number_to_numeral(BigDecimal('123.4567'), :fixed)
    assert_equal Numeral[1,2,3,4,5,6,7,0,0, point: 3, sign: -1, normalize: :approximate],
                 Conversions.number_to_numeral(BigDecimal('-123.4567'), :fixed)

    BigDecimal.limit 0

    assert_equal Numeral[1,2,3,4,5,6,7, point: 3],
                 Conversions.number_to_numeral(BigDecimal('123.4567'), :fixed)
    assert_equal Numeral[1,2,3,4,5,6,7, point: 3, sign: -1],
                 Conversions.number_to_numeral(BigDecimal('-123.4567'), :fixed)

    BigDecimal.limit l
  end

  def test_free_big_to_numeral
    l = BigDecimal.limit(9)

    assert_equal Numeral[1,2,3,4,5,6,7, point: 3],
                 Conversions.number_to_numeral(BigDecimal('123.4567'), :fixed)
    assert_equal Numeral[1,2,3,4,5,6,7, point: 3, sign: -1],
                 Conversions.number_to_numeral(BigDecimal('-123.4567'), :fixed)

    BigDecimal.limit 0

    assert_equal Numeral[1,2,3,4,5,6,7, point: 3],
                 Conversions.number_to_numeral(BigDecimal('123.4567'), :fixed)
    assert_equal Numeral[1,2,3,4,5,6,7, point: 3, sign: -1],
                 Conversions.number_to_numeral(BigDecimal('-123.4567'), :fixed)

    BigDecimal.limit l
  end

  def test_numeral_to_big

    assert_equal BigDecimal('123.4567'),
                 Conversions.numeral_to_number(
                   Numeral[1,2,3,4,5,6,7, point: 3], BigDecimal
                 )
    assert_equal BigDecimal('123.4567'),
                 Conversions.numeral_to_number(
                   Numeral[1,2,3,4,5,6,7, point: 3, normalize: :approximate],
                   BigDecimal
                 )
  end

end
