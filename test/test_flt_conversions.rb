require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestFltConversions <  Test::Unit::TestCase # < Minitest::Test

  def test_special_binary

    context = Flt::BinNum.context = Flt::BinNum::FloatContext
    type = Flt::BinNum

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

  def test_exact_binary
    one = nil
    context = Flt::BinNum::FloatContext
    Flt::BinNum.context(context) do
      one = Flt::BinNum(1, :fixed)
    end
    rounding = Rounding[:exact, base: 10]
    assert_equal Numeral[1, point: 1],
                 Conversions.number_to_numeral(one, :fixed, rounding)
    assert_equal Numeral[1, point: 1, sign: -1],
                 Conversions.number_to_numeral(-one, :fixed, rounding)

    rounding_2 = Rounding[:exact, base: 2]
    assert_equal Numeral[1, point: 1, base: 2],
                 Conversions.number_to_numeral(one, :fixed, rounding_2)
    assert_equal Numeral[1, point: 1, sign: -1, base: 2],
                 Conversions.number_to_numeral(-one, :fixed, rounding_2)

    [0.1, 0.01, 0.001, 1/3.0, 10/3.0, 100/3.0, Math::PI,
      0.5, 123.0, 123.45, 1.23E32, 1.23E-32].each do |x|
      [x, -x].each do |y|
        y = Flt::BinNum(y)
        numeral = exact_decimal(y)
        rounding = Rounding[:exact, base: 10]
        assert_equal numeral, Conversions.number_to_numeral(y, :fixed, rounding),
                     "#{y} to base 10 exact numeral"
        assert_equal y, Conversions.numeral_to_number(numeral, context),
                     "#{x} base 10 numeral to float"
      end
    end
  end

  def test_conversions_by_context
    Flt::DecNum.context(precision: 20) do
      numeral = Numeral[1, point: 0]
      context = Flt::DecNum::ExtendedContext
      converted = Conversions.numeral_to_number(numeral, context, :fixed)
      assert_equal Flt::DecNum('0.100000000'), converted
      assert_equal 9, converted.number_of_digits
    end
  end

  def test_conversions_by_class
    Flt::DecNum.context(precision: 9) do
      numeral = Numeral[1, point: 0]
      converted = Conversions.numeral_to_number(numeral, Flt::DecNum, :fixed)
      assert_equal Flt::DecNum('0.100000000'), converted
      assert_equal 9, converted.number_of_digits
    end
  end


  def test_equidistiant_nearest
    # In IEEEDoubleContext
    # 1E23 is equidistant from 2 Floats: lo & hi
    # one or the other will be chosen based on the rounding mode

    context = Flt::BinNum::IEEEDoubleContext

    # 1E23
    numeral = Numeral[1, point: 24]
    # 9.999999999999999E22
    numeral_lo = Numeral[[9]*16, point: 23]
    # 1.0000000000000001E23
    numeral_hi = Numeral[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1, point: 24]

    lo = hi = nil
    Flt::BinNum.context(context) do
      lo = Flt::BinNum('0x1.52d02c7e14af6p+76', :fixed)
      hi = Flt::BinNum('0x1.52d02c7e14af7p+76', :fixed)
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      x = Conversions.numeral_to_number(numeral, Flt::BinNum, :fixed)
      assert_equal lo, x
    end
    # x = Conversions.numeral_to_number(numeral, context[rounding: :half_even], :fixed)

    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.numeral_to_number(numeral, Flt::BinNum, :fixed)
      assert_equal lo, x
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.numeral_to_number(numeral, Flt::BinNum, :fixed)
      assert_equal hi, x
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      x = Conversions.numeral_to_number(-numeral, Flt::BinNum, :fixed)
      assert_equal -lo, x
    end
    # x = Conversions.numeral_to_number(numeral, context[rounding: :half_even], :fixed)

    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.numeral_to_number(-numeral, Flt::BinNum, :fixed)
      assert_equal -lo, x
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.numeral_to_number(-numeral, Flt::BinNum, :fixed)
      assert_equal -hi, x
    end

    rounding = Rounding[:exact]

    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral, Conversions.number_to_numeral(lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral_lo, Conversions.number_to_numeral(lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral, Conversions.number_to_numeral(lo, :free, rounding)
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral, Conversions.number_to_numeral(hi, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral_hi, Conversions.number_to_numeral(hi, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral_hi, Conversions.number_to_numeral(hi, :free, rounding)
    end

    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral, Conversions.number_to_numeral(-lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral_lo, Conversions.number_to_numeral(-lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral, Conversions.number_to_numeral(-lo, :free, rounding)
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral, Conversions.number_to_numeral(-hi, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral_hi, Conversions.number_to_numeral(-hi, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral_hi, Conversions.number_to_numeral(-hi, :free, rounding)
    end
  end

  def test_single_nearest
    # In IEEEDoubleContext
    # 64.1 between the floats lo, hi, but is closer to lo
    # So there's a closet Float that should be chosen for rounding

    context = Flt::BinNum::IEEEDoubleContext

    numeral = Numeral[6, 4, 1, point: 2]
    numeral_lo = Numeral[6, 4, 0, 9, 9, 9 ,9, 9, 9, 9, 9, 9, 9, 9, 9, 9, point: 2]

    lo = hi = nil
    Flt::BinNum.context(context) do
      lo = Flt::BinNum('0x1.0066666666666p+6', :fixed) # this is nearer to the 64.1 Float
      hi = Flt::BinNum('0x1.0066666666667p+6', :fixed)
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      x = Conversions.numeral_to_number(numeral, Flt::BinNum, :fixed)
      assert_equal lo, x
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.numeral_to_number(numeral, Flt::BinNum, :fixed)
      assert_equal lo, x
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.numeral_to_number(numeral, Flt::BinNum, :fixed)
      assert_equal lo, x
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      x = Conversions.numeral_to_number(-numeral, Flt::BinNum, :fixed)
      assert_equal -lo, x
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.numeral_to_number(-numeral, Flt::BinNum, :fixed)
      assert_equal -lo, x
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.numeral_to_number(-numeral, Flt::BinNum, :fixed)
      assert_equal -lo, x
    end

    rounding = Rounding[:exact]
    rounding_16 = Rounding[:half_even, precision: 16]

    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral, Conversions.number_to_numeral(lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral_lo, Conversions.number_to_numeral(lo, :free, rounding_16)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral, Conversions.number_to_numeral(lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral_lo, Conversions.number_to_numeral(lo, :free, rounding_16)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral, Conversions.number_to_numeral(lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral_lo, Conversions.number_to_numeral(lo, :free, rounding_16)
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral, Conversions.number_to_numeral(-lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral_lo, Conversions.number_to_numeral(-lo, :free, rounding_16)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral, Conversions.number_to_numeral(-lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral_lo, Conversions.number_to_numeral(-lo, :free, rounding_16)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral, Conversions.number_to_numeral(-lo, :free, rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral_lo, Conversions.number_to_numeral(-lo, :free, rounding_16)
    end
  end


  def exact_decimal(x)
    Flt::DecNum.context(exact: true){
      Flt::BinNum.context(Flt::BinNum::FloatContext){
        d = Flt::BinNum(x).to_decimal_exact
        Numeral[d.coefficient.to_s.chars.map(&:to_i), sign: d.sign, point: d.fractional_exponent, normalize: :exact]
      }
    }
  end

end
