require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'

class TestConversions <  Test::Unit::TestCase # < Minitest::Test

  include Numerals
  include Flt

  def setup
    @dec_context = Flt::DecNum.context
    @bin_context = Flt::BinNum.context
    Flt::DecNum.context = Flt::DecNum::ExtendedContext
    Flt::BinNum.context = Flt::BinNum::ExtendedContext
  end

  def tear_down
    Flt::DecNum.context = @dec_context
    Flt::BinNum.context = @bin_context
  end

  def test_special
    assert Conversions.convert(Float::NAN, type: DecNum).nan?
    assert Conversions.convert(Float::NAN, type: DecNum, exact: true).nan?
    assert Conversions.convert(DecNum.context.nan, type: Float).nan?
    assert_equal DecNum.context.infinity, Conversions.convert(Float::INFINITY, type: DecNum)
    assert_equal Float::INFINITY, Conversions.convert(DecNum.context.infinity, type: Float)
    assert_equal -DecNum.context.infinity, Conversions.convert(-Float::INFINITY, type: DecNum)
    assert_equal -Float::INFINITY, Conversions.convert(-DecNum.context.infinity, type: Float)
  end

  def test_regular

    x = 0.1
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1000000000000000055511151231257827021181583404541015625'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1000000000000000055511151231257827021181583404541015625'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000000000001'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000000000001'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(3602879701896397, 36028797018963968),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(3602879701896397, 36028797018963968),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(3602879701896397, 36028797018963968),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(10000000000000001, 100000000000000000),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(10000000000000001, 100000000000000000),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(10000000000000001, 100000000000000000),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = 0.5
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1P-1'), # 0.5
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -53], # 0.5
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 134217728, -28], # 0.5
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -53], # 0.5
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -53], # 0.5
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -53], # 0.5
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -53], # 0.5
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -1], # 0.5
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 134217728, -28], # 0.5
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -53], # 0.5
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.500000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.50000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.500000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.500000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.50000000000000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.500000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.5'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.50000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.500000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 2),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Flt::BinNum('0.1', :fixed)
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 3602879701896397, -55], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1000000000000000055511151231257827021181583404541015625'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1000000000000000055511151231257827021181583404541015625'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000000000001'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000000000001'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(3602879701896397, 36028797018963968),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(3602879701896397, 36028797018963968),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(3602879701896397, 36028797018963968),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(10000000000000001, 100000000000000000),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(10000000000000001, 100000000000000000),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(10000000000000001, 100000000000000000),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Flt::BinNum('0.1', :free)
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.A1CAC083126E9P-4'), # 0.102
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.A1CAC083126E9P-4'), # 0.102
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.A1CAC083126E9P-4'), # 0.102
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7318349394477056, -56], # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 27262976, -28], # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7318349394477056, -56], # 0.1015625
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7318349394477056, -56], # 0.1015625
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 26, -8], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7318349394477056, -56], # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 209, -11], # 0.102
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7349874591868649, -56], # 0.102
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1015625'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1015625'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.101562500'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1015625'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10156250'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.101562500'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.102'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.102'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.102000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.102'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.102'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.102000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(13, 128),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(13, 128),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(13, 128),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(13, 128),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(13, 128),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(13, 128),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(51, 500),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(51, 500),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(51, 500),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(51, 500),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(51, 500),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(51, 500),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Flt::DecNum('0.1')
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1P-3'), # 0.125
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1P-3'), # 0.125
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1P-3'), # 0.125
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.AP-4'), # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -3], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1, -3], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 4503599627370496, -55], # 0.125
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 26, -8], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7318349394477056, -56], # 0.1015625
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13, -7], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 51, -9], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Flt::DecNum('0.1000')
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.99CP-4'), # 0.10003662109375
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.99CP-4'), # 0.10003662109375
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.99CP-4'), # 0.10003662109375
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.9998P-4'), # 0.09999847412109375
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.9998P-4'), # 0.09999847412109375
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.9998P-4'), # 0.09999847412109375
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1639, -14], # 0.10004
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 1639, -14], # 0.10004
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7208398231699456, -56], # 0.10003662109375
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13107, -17], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13107, -17], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205649452630016, -56], # 0.09999847412109375
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 26215, -18], # 0.100002
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 209715, -21], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1000'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Flt::DecNum('0.1000', :fixed)
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999AP-4'), # 0.10000000009313226
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999AP-4'), # 0.10000000009313226
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999AP-4'), # 0.10000000009313226
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.99999998P-4'), # 0.09999999997671694
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.99999998P-4'), # 0.09999999997671694
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.99999998P-4'), # 0.09999999997671694
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 214748365, -31], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 214748365, -31], # 0.1
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759410503680, -56], # 0.10000000009313226
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 858993459, -33], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 858993459, -33], # 0.1
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759402115072, -56], # 0.09999999997671694
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:short], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Rational(1,10)
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.999999999999AP-4'), # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 13421773, -27], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 53687091, -29], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 7205759403792794, -56], # 0.1
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.1'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.10000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.100000000'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 10),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )
    x = Rational(1,3)
    assert_same_number(
      Float('0X1.5555555555555P-2'), # 0.3333333333333333
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.5555555555555P-2'), # 0.3333333333333333
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.5555555555555P-2'), # 0.3333333333333333
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Float('0X1.5555551C112DAP-2'), # 0.33333333
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Float)
    )
    assert_same_number(
      Float('0X1.5555551C112DAP-2'), # 0.33333333
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Float)
    )
    assert_same_number(
      Float('0X1.5555551C112DAP-2'), # 0.33333333
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Float)
    )
    assert_same_number(
      Flt::BinNum[1, 6004799503160661, -54], # 0.3333333333333333
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 6004799503160661, -54], # 0.3333333333333333
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 6004799503160661, -54], # 0.3333333333333333
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 22369621, -26], # 0.33333333
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 89478484, -28], # 0.33333333
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::BinNum)
    )
    assert_same_number(
      Flt::BinNum[1, 6004799443112666, -54], # 0.33333333
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::BinNum)
    )
    assert_same_number(
      DecNum('0.333333333'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.333333333'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.333333333'),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.33333333'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.33333333'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Flt::DecNum)
    )
    assert_same_number(
      DecNum('0.333333330'),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Flt::DecNum)
    )
    assert_same_number(
      Rational(1, 3),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(1, 3),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(1, 3),
      Conversions.convert(x, exact_input: true, rounding:[:free], output_mode: :fixed, type: Rational)
    )
    assert_same_number(
      Rational(33333333, 100000000),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :short, type: Rational)
    )
    assert_same_number(
      Rational(33333333, 100000000),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :free, type: Rational)
    )
    assert_same_number(
      Rational(33333333, 100000000),
      Conversions.convert(x, exact_input: true, rounding:[precision: 8], output_mode: :fixed, type: Rational)
    )


  end



end
