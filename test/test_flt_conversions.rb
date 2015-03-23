require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestFltConversions <  Test::Unit::TestCase # < Minitest::Test

  def test_write_special_binary
    context = Flt::BinNum.context = Flt::BinNum::FloatContext
    type = Flt::BinNum

    assert_equal Numeral.nan, Conversions.write(context.nan)
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:exact, base: 2])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:exact, base: 10])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[precision: 10, base: 10])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:simplify])
    assert_equal Numeral.nan, Conversions.write(context.nan, rounding: Rounding[:perserve])

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
    context = Flt::BinNum.context = Flt::BinNum::FloatContext
    type = Flt::BinNum

    assert Conversions.read(Numeral.nan, type: type).nan?
    assert_equal context.infinity, Conversions.read(Numeral.infinity, type: type)
    assert_equal context.infinity(-1), Conversions.read(Numeral.infinity(-1), type: type)
  end

  def test_write_preserved
    assert_equal Numeral[1,2,3,4,5,6,0,0,0, base: 10, point: 3, sign: -1],
                 Conversions.write(Flt::DecNum('-123.456000'), rounding: :preserve)
    assert_equal Numeral[1,2,3,4,5,6,0,0,0, base: 10, point: 3, sign: +1],
                 Conversions.write(Flt::DecNum('+123.456000'), rounding: :preserve)
    assert_equal Numeral[1,2,3,4,5,6, base: 10, point: 3, sign: -1],
                 Conversions.write(Flt::DecNum('-123.456'), rounding: :preserve)
    assert_equal Numeral[1,2,3,4,5,6, base: 10, point: 3, sign: +1],
                 Conversions.write(Flt::DecNum('+123.456'), rounding: :preserve)
  end

  def test_write_exact_binary
    one = nil
    context = Flt::BinNum::FloatContext
    Flt::BinNum.context(context) do
      one = Flt::BinNum(1, :fixed)
    end
    rounding = Rounding[:exact, base: 10]
    assert_equal Numeral[1, point: 1],
                 Conversions.write(one, rounding: rounding, exact: true)
    assert_equal Numeral[1, point: 1, sign: -1],
                 Conversions.write(-one, rounding: rounding, exact: true)

    rounding_2 = Rounding[:exact, base: 2]
    assert_equal Numeral[1, point: 1, base: 2],
                 Conversions.write(one, rounding: rounding_2, exact: true)
    assert_equal Numeral[1, point: 1, sign: -1, base: 2],
                 Conversions.write(-one, rounding: rounding_2, exact: true)

    [0.1, 0.01, 0.001, 1/3.0, 10/3.0, 100/3.0, Math::PI,
      0.5, 123.0, 123.45, 1.23E32, 1.23E-32].each do |x|
      [x, -x].each do |y|
        y = Flt::BinNum(y)
        numeral = exact_decimal(y)
        rounding = Rounding[:exact, base: 10]
        assert_equal numeral, Conversions.write(y, rounding: rounding, exact: true),
                     "#{y} to base 10 exact numeral"
      end
    end
  end

  def test_read_exact_binary
    context = Flt::BinNum::FloatContext
    [0.1, 0.01, 0.001, 1/3.0, 10/3.0, 100/3.0, Math::PI,
      0.5, 123.0, 123.45, 1.23E32, 1.23E-32].each do |x|
      [x, -x].each do |y|
        y = Flt::BinNum(y)
        numeral = exact_decimal(y)
        rounding = Rounding[:exact, base: 10]
        assert_equal y, Conversions.read(numeral, context: context),
                     "#{x} base 10 numeral to float"
      end
    end
  end

  def test_read_by_context
    Flt::DecNum.context(precision: 20) do
      numeral = Numeral[1, point: 0]
      context = Flt::DecNum::ExtendedContext
      converted = Conversions.read(numeral, context: context)
      assert_equal Flt::DecNum('0.100000000'), converted
      assert_equal 9, converted.number_of_digits
    end
  end

  def test_read_by_class
    Flt::DecNum.context(precision: 9) do
      numeral = Numeral[1, point: 0]
      converted = Conversions.read(numeral, type: Flt::DecNum)
      assert_equal Flt::DecNum('0.100000000'), converted
      assert_equal 9, converted.number_of_digits
    end
  end

  def test_read_write_equidistiant_nearest
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
      x = Conversions.read(numeral, type: Flt::BinNum)
      assert_equal lo, x
    end
    # x = Conversions.read(numeral, type: context[:half_even])

    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.read(numeral, type: Flt::BinNum)
      assert_equal lo, x
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.read(numeral, type: Flt::BinNum)
      assert_equal hi, x
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      x = Conversions.read(-numeral, type: Flt::BinNum)
      assert_equal -lo, x
    end
    # x = Conversions.read(numeral, type: context[:half_even])

    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.read(-numeral, type: Flt::BinNum)
      assert_equal -lo, x
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.read(-numeral, type: Flt::BinNum)
      assert_equal -hi, x
    end

    rounding = Rounding[:simplify]

    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral, Conversions.write(lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral_lo, Conversions.write(lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral, Conversions.write(lo, rounding: rounding)
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral, Conversions.write(hi, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral_hi, Conversions.write(hi, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral_hi, Conversions.write(hi, rounding: rounding)
    end

    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral, Conversions.write(-lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral_lo, Conversions.write(-lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral, Conversions.write(-lo, rounding: rounding)
    end

    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral, Conversions.write(-hi, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral_hi, Conversions.write(-hi, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral_hi, Conversions.write(-hi, rounding: rounding)
    end

    # now avoiding Flt contexts by using the :input_rounding option

    x = Conversions.read(numeral, type: Flt::BinNum, rounding: :half_even)
    assert_equal lo, x
    x = Conversions.read(numeral, type: Flt::BinNum, rounding: :half_down)
    assert_equal lo, x
    x = Conversions.read(numeral, type: Flt::BinNum, rounding: :half_up)
    assert_equal hi, x
    x = Conversions.read(-numeral, type: Flt::BinNum, rounding: :half_even)
    assert_equal -lo, x
    x = Conversions.read(-numeral, type: Flt::BinNum, rounding: :half_down)
    assert_equal -lo, x
    x = Conversions.read(-numeral, type: Flt::BinNum, rounding: :half_up)
    assert_equal -hi, x

    rounding = Rounding[:simplify]

    assert_equal numeral, Conversions.write(lo, rounding: rounding, input_rounding: :half_down)
    assert_equal numeral_lo, Conversions.write(lo, rounding: rounding, input_rounding: :half_up)
    assert_equal numeral, Conversions.write(lo, rounding: rounding, input_rounding: :half_even)
    assert_equal numeral, Conversions.write(hi, rounding: rounding, input_rounding: :half_up)
    assert_equal numeral_hi, Conversions.write(hi, rounding: rounding, input_rounding: :half_down)
    assert_equal numeral_hi, Conversions.write(hi, rounding: rounding, input_rounding: :half_even)
    assert_equal -numeral, Conversions.write(-lo, rounding: rounding, input_rounding: :half_down)
    assert_equal -numeral_lo, Conversions.write(-lo, rounding: rounding, input_rounding: :half_up)
    assert_equal -numeral, Conversions.write(-lo, rounding: rounding, input_rounding: :half_even)
    assert_equal -numeral, Conversions.write(-hi, rounding: rounding, input_rounding: :half_up)
    assert_equal -numeral_hi, Conversions.write(-hi, rounding: rounding, input_rounding: :half_down)
    assert_equal -numeral_hi, Conversions.write(-hi, rounding: rounding, input_rounding: :half_even)
  end

  def test_read_write_single_nearest
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
      x = Conversions.read(numeral, type: Flt::BinNum)
      assert_equal lo, x
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.read(numeral, type: Flt::BinNum)
      assert_equal lo, x
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.read(numeral, type: Flt::BinNum)
      assert_equal lo, x
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      x = Conversions.read(-numeral, type: Flt::BinNum)
      assert_equal -lo, x
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      x = Conversions.read(-numeral, type: Flt::BinNum)
      assert_equal -lo, x
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      x = Conversions.read(-numeral, type: Flt::BinNum)
      assert_equal -lo, x
    end

    rounding = Rounding[:simplify]
    rounding_16 = Rounding[:half_even, precision: 16]

    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral, Conversions.write(lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal numeral_lo, Conversions.write(lo, rounding: rounding_16, exact: true)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral, Conversions.write(lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal numeral_lo, Conversions.write(lo, rounding: rounding_16, exact: true)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral, Conversions.write(lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal numeral_lo, Conversions.write(lo, rounding: rounding_16, exact: true)
    end

    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral, Conversions.write(-lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_even) do
      assert_equal -numeral_lo, Conversions.write(-lo, rounding: rounding_16, exact: true)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral, Conversions.write(-lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_down) do
      assert_equal -numeral_lo, Conversions.write(-lo, rounding: rounding_16, exact: true)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral, Conversions.write(-lo, rounding: rounding)
    end
    Flt::BinNum.context(context, rounding: :half_up) do
      assert_equal -numeral_lo, Conversions.write(-lo, rounding: rounding_16, exact: true)
    end
  end

  def test_read_short
    assert_equal Flt::DecNum('1'),
                 Conversions.read(Numeral[1,0,0,0,0,0,0, point: 1, base: 10, normalize: :approximate], simplify: true, type: Flt::DecNum)

    assert_equal Flt::BinNum('0.000110011', base: 2),
                 Conversions.read(Numeral[1,0, point: 0, base: 10, normalize: :approximate], simplify: false, type: Flt::BinNum)
    assert_equal Flt::BinNum('0.0001100110011', base: 2),
                 Conversions.read(Numeral[1,0,0, point: 0, base: 10, normalize: :approximate], simplify: false, type: Flt::BinNum)
    assert_equal Flt::BinNum('0.00011001100110011', base: 2),
                 Conversions.read(Numeral[1,0,0,0, point: 0, base: 10, normalize: :approximate], simplify: false, type: Flt::BinNum)

    assert_equal Flt::BinNum('0.0001101', base: 2),
                 Conversions.read(Numeral[1,0, point: 0, base: 10, normalize: :approximate], simplify: true, type: Flt::BinNum)
    assert_equal Flt::BinNum('0.00011001101', base: 2),
                 Conversions.read(Numeral[1,0,0, point: 0, base: 10, normalize: :approximate], simplify: true, type: Flt::BinNum)
    assert_equal Flt::BinNum('0.00011001100111', base: 2),
                 Conversions.read(Numeral[1,0,0,0, point: 0, base: 10, normalize: :approximate], simplify: true, type: Flt::BinNum)
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
