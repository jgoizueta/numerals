require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
require 'flt/bigdecimal'
include Numerals

class TestBigConversions <  Test::Unit::TestCase # < Minitest::Test


  def test_write_special
    context = BigDecimal.context
    type = BigDecimal

    assert_equal Numeral.nan, Conversions.write(context.nan)
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:short, base: 2])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:short, base: 10])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.nan, Conversions.write(context.nan)

    assert_equal Numeral.infinity, Conversions.write(context.infinity)
    assert_equal Numeral.infinity, Conversions.write(context.infinity, rounding: Rounding[:short, base: 2])
    assert_equal Numeral.infinity, Conversions.write(context.infinity, rounding: Rounding[:short, base: 10])
    assert_equal Numeral.infinity, Conversions.write(context.infinity, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.infinity, Conversions.write(context.infinity)

    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1))
    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1), rounding: Rounding[:short, base: 2])
    assert_equal Numeral.infinity(-1), Conversions.write(context.infinity(-1), rounding: Rounding[:short, base: 10])
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

  def test_type_parameters
    c = Conversions[BigDecimal, input_rounding: :down]
    assert_equal :down, c.input_rounding
    c = Conversions[BigDecimal, input_rounding: :half_even]
    assert_equal :half_even, c.input_rounding

    # TODO: when type parameters are added test they can be set with
    #   Conversions.write(... type_options: { ... }) etc.
    # Curren parameter :input_rounding cannot be tested since
    # it is overrided by Conversions.write & read in each call
  end

end
