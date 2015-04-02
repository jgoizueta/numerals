require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestFormatInput <  Test::Unit::TestCase # < Minitest::Test

  def assert_same_flt(x, y)
    assert_equal x.class, y.class, x.to_s
    assert_equal x.split, y.split, x.to_s
  end

  def assert_same_float(x, y)
    assert_equal x.class, y.class, x.to_s
    assert_equal Float.context.split(x), Float.context.split(y), x.to_s
  end

  def test_read_special_float
    f = Format[]
    assert f.read('NaN', type: Float).nan?
    assert f.read('NAN', type: Float).nan?
    assert_raise(RuntimeError) { f[case_sensitive: true].read('NAN', type: Float) }
    assert_equal Float::INFINITY, f.read('Infinity', type: Float)
    assert_equal Float::INFINITY, f.read('+Infinity', type: Float)
    assert_equal Float::INFINITY, f.read('+INFINITY', type: Float)
    assert_equal -Float::INFINITY, f.read('-Infinity', type: Float)
    assert_equal -Float::INFINITY, f.read('-INFINITY', type: Float)
  end

  def test_read_float
    f = Format[]
    assert_same_float 1.0, f.read('1', type: Float)
    assert_same_float 1.2345e-23, f.read('1.2345e-23', type: Float)
    assert_same_float -1.2345e-23, f.read('-1.2345e-23', type: Float)
    assert_same_float 1.2345e-23, f.read('1.2345E-23', type: Float)
    assert_same_float 1.2345e23, f.read('1.2345E23', type: Float)
    assert_same_float 1.2345e23, f.read('1.2345E+23', type: Float)
    assert_same_float -1/3.0 - 123456, f.read('-123,456.<3>', type: Float)
    assert_same_float 4/3.0, f.read('+1.<3>', type: Float)
    assert_same_float 4/3.0, f.read('+1.333...', type: Float)
    assert_same_float 0.1, f.read('0.1', type: Float)
  end

  def test_read_rational
    f = Format[]
    assert_equal Rational(1,1), f.read('1.0', type: Rational)
    assert_equal Rational(-370369,3), f.read('-123,456.<3>', type: Rational)
    assert_equal Rational(4,3), f.read('+1.<3>', type: Rational)
    assert_equal Rational(1,10), f.read('0.1', type: Rational)
    assert_equal Rational(41000000000,333), f.read('1,23123123...', type: Rational)
  end

  def test_read_decnum
    f = Format[]
    Flt::DecNum.context(precision: 20) do
      assert_same_flt Flt::DecNum('123123123.12312312312'), f.read('1,23123123...', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('-123456.33333333333333'), f.read('-123,456.<3>', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('1.3333333333333333333'), f.read('+1.<3>', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('0.1'), f.read('0.1', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('0.10000000000000000000'), f[:exact_input].read('0.1', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('0.10000000000000000000'), f[:exact_input].read('0.1000', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('0.1'), f[:short].read('0.1000', type: Flt::DecNum)
      assert_same_flt Flt::DecNum('0.1000'), f[:free].read('0.1000', type: Flt::DecNum)
    end
    context = Flt::DecNum.context(precision: 19)
    assert_same_flt Flt::DecNum('123123123.1231231231'), f.read('1,23123123...', type: context)
    assert_same_flt Flt::DecNum('-123456.3333333333333'), f.read('-123,456.<3>', type: context)
    assert_same_flt Flt::DecNum('1.333333333333333333'), f.read('+1.<3>', type: context)
    assert_same_flt Flt::DecNum('0.1'), f.read('0.1', type: context)
    assert_same_flt Flt::DecNum('0.1000000000000000000'), f[:exact_input].read('0.1', type: context)
    assert_same_flt Flt::DecNum('0.1000000000000000000'), f[:exact_input].read('0.1000', type: context)
    assert_same_flt Flt::DecNum('0.1'), f[:short].read('0.1000', type: context)
    assert_same_flt Flt::DecNum('0.1000'), f[:free].read('0.1000', type: context)
  end

  def test_read_binnum
    f = Format[]
    Flt::BinNum.context(Flt::BinNum::IEEEDoubleContext) do
      assert_same_flt Flt::BinNum('1', :short), f.read('1', type: Flt::BinNum)
      assert_same_flt Flt::BinNum('1', :free), f[:free].read('1', type: Flt::BinNum)
      assert_same_flt Flt::BinNum('1.00', :free), f[:free].read('1.00', type: Flt::BinNum)
      assert_same_flt Flt::BinNum('1.2345E-23', :short), f.read('1.2345E-23', type: Flt::BinNum)
      assert_same_flt Flt::BinNum('-123456.333333333333333', :fixed), f.read('-123,456.<3>', type: Flt::BinNum)
      assert_same_flt Flt::BinNum('1.33333333333333333333', :fixed), f.read('+1.<3>', type: Flt::BinNum)
      assert_same_flt Flt::BinNum('0.1', :short), f.read('0.1', type: Flt::BinNum)
    end
  end

  def test_read_hexbin
    context = Flt::BinNum::IEEEDoubleContext
    Flt::BinNum.context(context) do
      f = Format[:free, :hexbin]
      x = Flt::BinNum('0.1', :fixed)
      assert_same_flt x, f.read("1.999999999999Ap-4", type: Flt::BinNum)
      assert_same_flt -x, f.read("-1.999999999999Ap-4", type: Flt::BinNum)
      assert_same_flt x, f.read("19.99999999999Ap-8", type: Flt::BinNum)
      %w(1.52d02c7e14af6p+76 1.52d02c7e14af7p+76 1.0066666666666p+6 1.0066666666667p+6).each do |txt|
        x =  Flt::BinNum("0x#{txt}", :fixed)
        assert_same_flt x, f.read(txt, type: Flt::BinNum)
      end
    end
  end

  def test_read_equidistant_flt
    # In IEEEDoubleContext
    # 1E23 is equidistant from 2 Floats: lo & hi
    # one or the other will be chosen based on the rounding mode

    context = Flt::BinNum::IEEEDoubleContext

    lo = hi = nil
    Flt::BinNum.context(context) do
      lo = Flt::BinNum('0x1.52d02c7e14af6p+76', :fixed) # 9.999999999999999E22
      hi = Flt::BinNum('0x1.52d02c7e14af7p+76', :fixed) # 1.0000000000000001E23
    end

    f = Format[:exact_input]

    # define rounding mode with :type_options
    x = f.read('1E23', type: context, type_options: { input_rounding: :half_even })
    assert_same_flt lo, x
    x = f.read('1E23', type: context, type_options: { input_rounding: :half_down })
    assert_equal lo, x
    x = f.read('1E23', type: context, type_options: { input_rounding: :half_up })
    assert_equal hi, x

    x = f.read('-1E23', type: context, type_options: { input_rounding: :half_even })
    assert_equal -lo, x
    x = f.read('-1E23', type: context, type_options: { input_rounding: :half_down })
    assert_equal -lo, x
    x = f.read('-1E23', type: context, type_options: { input_rounding: :half_up })
    assert_equal -hi, x

    # define rounding mode with Format's Rounding
    x = f[:half_even].read('1E23', type: context)
    assert_same_flt lo, x
    x = f[:half_down].read('1E23', type: context)
    assert_equal lo, x
    x = f[:half_up].read('1E23', type: context)
    assert_equal hi, x

    x = f[:half_even].read('-1E23', type: context)
    assert_equal -lo, x
    x = f[:half_down].read('-1E23', type: context)
    assert_equal -lo, x
    x = f[:half_up].read('-1E23', type: context)
    assert_equal -hi, x

    # define rounding mode with Format's input_rounding
    x = f[input_rounding: :half_even].read('1E23', type: context)
    assert_same_flt lo, x
    x = f[input_rounding: :half_down].read('1E23', type: context)
    assert_equal lo, x
    x = f[input_rounding: :half_up].read('1E23', type: context)
    assert_equal hi, x

    x = f[input_rounding: :half_even].read('-1E23', type: context)
    assert_equal -lo, x
    x = f[input_rounding: :half_down].read('-1E23', type: context)
    assert_equal -lo, x
    x = f[input_rounding: :half_up].read('-1E23', type: context)
    assert_equal -hi, x
  end

  def test_read_single_nearest
    # In IEEEDoubleContext
    # 64.1 between the floats lo, hi, but is closer to lo
    # So there's a closet Float that should be chosen for rounding

    context = Flt::BinNum::IEEEDoubleContext

    lo = hi = nil
    Flt::BinNum.context(context) do
      lo = Flt::BinNum('0x1.0066666666666p+6', :fixed) # this is nearer to the 64.1 Float
      hi = Flt::BinNum('0x1.0066666666667p+6', :fixed)
    end

    f = Format[:exact_input]

    # define rounding mode with type_optoins
    x = f.read('64.1', type: context, type_options: { input_rounding: :half_even })
    assert_equal lo, x
    x = f.read('64.1', type: context, type_options: { input_rounding: :half_down })
    assert_equal lo, x
    x = f.read('64.1', type: context, type_options: { input_rounding: :half_up })
    assert_equal lo, x

    x = f.read('-64.1', type: context, type_options: { input_rounding: :half_even })
    assert_equal -lo, x
    x = f.read('-64.1', type: context, type_options: { input_rounding: :half_even })
    assert_equal -lo, x
    x = f.read('-64.1', type: context, type_options: { input_rounding: :half_up })
    assert_equal -lo, x

    # define rounding mode with Format's Rounding
    x = f[:half_even].read('64.1', type: context)
    assert_equal lo, x
    x = f[:half_down].read('64.1', type: context)
    assert_equal lo, x
    x = f[:half_up].read('64.1', type: context)
    assert_equal lo, x

    x = f[:half_even].read('-64.1', type: context)
    assert_equal -lo, x
    x = f[:half_down].read('-64.1', type: context)
    assert_equal -lo, x
    x = f[:half_up].read('-64.1', type: context)
    assert_equal -lo, x

    # define rounding mode with Format's input_rounding
    x = f[input_rounding: :half_even].read('64.1', type: context)
    assert_equal lo, x
    x = f[input_rounding: :half_down].read('64.1', type: context)
    assert_equal lo, x
    x = f[input_rounding: :half_up].read('64.1', type: context)
    assert_equal lo, x

    x = f[input_rounding: :half_even].read('-64.1', type: context)
    assert_equal -lo, x
    x = f[input_rounding: :half_down].read('-64.1', type: context)
    assert_equal -lo, x
    x = f[input_rounding: :half_up].read('-64.1', type: context)
    assert_equal -lo, x

  end

  def test_padding
    f = Format[padding: '*']
    assert_equal 643454333.32,  f.read("******643,454,333.32", type: Float)
    assert_equal -643454333.32, f.read("*****-643,454,333.32", type: Float)
    assert_equal -643454333.32, f.read("-*****643,454,333.32", type: Float)
    assert_equal 643454333.32,  f.read("+*****643,454,333.32", type: Float)
    assert_equal 643454333.32,  f.read("643,454,333.32******", type: Float)
    assert_equal -643454333.32, f.read("-643,454,333.32*****", type: Float)
    assert_equal 643454333.32,  f.read("***643,454,333.32***", type: Float)
    assert_equal 643454333.32,  f.read("***643,454,333.32***", type: Float)
    f.set_leading_zeros! 10
    assert_equal 123, f.read("0000000123", type: Integer)
    assert_equal -123, f.read("-000000123", type: Integer)
    assert_equal 123.5, f.read("00000123.5", type: Float)
    assert_equal -123.5, f.read("-00000123.5000", type: Float)
    assert_equal 123.5, f.read("00000123.5000", type: Float)
    assert_equal 100.5, f.read("00000100.5", type: Float)
    assert_equal -100.5, f.read("-0000100.5", type: Float)
    assert_equal Rational(1,3), f.read("000000.<3>", type: Rational)
    assert_equal Rational(-1,3), f.read("-00000.<3>", type: Rational)
    f.set_padding! '*'
    assert_equal Flt::DecNum('0.667'), f.read("********0.667*******", type: Flt::DecNum)
    assert_equal Flt::DecNum('-0.667'), f.read("*******-0.667*******", type: Flt::DecNum)
  end

end
