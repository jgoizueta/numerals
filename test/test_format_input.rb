require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestFormatInput <  Test::Unit::TestCase # < Minitest::Test

  def assert_same_flt(x, y)
    assert_equal x.class, y.class, x.to_s
    assert_equal x.split, y.split, x.to_s
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
    assert_equal 1.0, f.read('1', type: Float)
    assert_equal 1.2345e-23, f.read('1.2345e-23', type: Float)
    assert_equal -1.2345e-23, f.read('-1.2345e-23', type: Float)
    assert_equal 1.2345e-23, f.read('1.2345E-23', type: Float)
    assert_equal 1.2345e23, f.read('1.2345E23', type: Float)
    assert_equal 1.2345e23, f.read('1.2345E+23', type: Float)
    assert_equal -1/3.0 - 123456, f.read('-123,456.<3>', type: Float)
    assert_equal 4/3.0, f.read('+1.<3>', type: Float)
    assert_equal 4/3.0, f.read('+1.333...', type: Float)
    assert_equal 0.1, f.read('0.1', type: Float)
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

  def test_read_equidistant
  end

  def test_read_single_nearest
  end

end
