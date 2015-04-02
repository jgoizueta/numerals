require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'

class TestBaseScaler <  Test::Unit::TestCase # < Minitest::Test

  include Numerals

  def digits_string(part, base)
    part.map{|d| d.to_s(base)}.join
  end

  def check_scaler(scaler)
    "#{digits_string(scaler.integer_part, scaler.scaled_base)}.#{digits_string(scaler.fractional_part, scaler.scaled_base)}<#{digits_string(scaler.repeat_part, scaler.scaled_base)}>E#{scaler.exponent}"
  end

  def test_special
    numeral = Numeral[:nan]
    setter = Format::ExpSetter[numeral]
    scaler = Format::BaseScaler[setter, 4]

    assert_equal setter.base, scaler.exponent_base
    assert_equal setter.sign, scaler.sign
    assert_equal setter.exponent, scaler.exponent
    assert_equal setter.special?, scaler.special?
    assert_equal setter.special, scaler.special
  end


  def test_non_repeat
    digits = [1,1,0,0]*12 + [1,1,0,1,0]
    numeral = Numeral[digits, base: 2, point: -3]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "1.999999999999a<>E-4", check_scaler(scaler)
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "3.3333333333334<>E-5", check_scaler(scaler)
    setter.integer_part_size = 0
    scaler = Format::BaseScaler[setter, 4]
    assert_equal ".ccccccccccccd<>E-3", check_scaler(scaler)
    setter.integer_part_size = 3
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "6.6666666666668<>E-6", check_scaler(scaler)
    setter.integer_part_size = 4
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "c.cccccccccccd<>E-7", check_scaler(scaler)

    assert_equal 16, scaler.scaled_base
    assert_equal setter.base, scaler.exponent_base
    assert_equal setter.sign, scaler.sign
    assert_equal setter.exponent, scaler.exponent
    assert_equal setter.special?, scaler.special?
    assert_equal setter.special, scaler.special
  end

  def test_approx
    digits = [1,1,0,0]*12 + [1,1,0,1,0]
    numeral = Numeral[digits, base: 2, point: -3, normalize: :approximate]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "1.999999999999a<>E-4", check_scaler(scaler)
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "3.3333333333334<>E-5", check_scaler(scaler)
    setter.integer_part_size = 0
    scaler = Format::BaseScaler[setter, 4]
    assert_equal ".ccccccccccccd0<>E-3", check_scaler(scaler)
    setter.integer_part_size = 3
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "6.6666666666668<>E-6", check_scaler(scaler)
    setter.integer_part_size = 4
    scaler = Format::BaseScaler[setter, 4]
    assert_equal "c.cccccccccccd0<>E-7", check_scaler(scaler)

    assert_equal 16, scaler.scaled_base
    assert_equal setter.base, scaler.exponent_base
    assert_equal setter.sign, scaler.sign
    assert_equal setter.exponent, scaler.exponent
    assert_equal setter.special?, scaler.special?
    assert_equal setter.special, scaler.special
  end

  def test_repeating_4
    # 4 repeating bits
    numeral = Numeral[1, 0, 1, 1, 1, 0, base: 2, point: 2, repeat: 2, normalize: false]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.<e>E0', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    # Next: not 1.<7> because we weren't eager defining binary repetition
    # (we could have defined repetition one bit earlier)
    assert_equal '1.7<7>E1', check_scaler(scaler)

    numeral = Numeral[1, 0, 1, 1, 1, base: 2, point: 2, repeat: 1]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.<e>E0', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.<7>E1', check_scaler(scaler)

    numeral = Numeral[1, 0, 1, 1, 1, base: 2, point: 0, repeat: 1]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.<e>E-2', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.<7>E-1', check_scaler(scaler)

    numeral = Numeral[1, 0, 0, 1, 1, 1, base: 2, point: 2, repeat: 2]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.<7>E0', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.3<b>E1', check_scaler(scaler)

    numeral = Numeral[1, 0, 0, 1, 1, 1, base: 2, point: 3, repeat: 2]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.<7>E1', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.3<b>E2', check_scaler(scaler)

    numeral = Numeral[1, 0, 0, 1, 1, 1, base: 2, point: 1, repeat: 2]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.<7>E-1', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.3<b>E0', check_scaler(scaler)

    assert_equal 16, scaler.scaled_base
    assert_equal setter.base, scaler.exponent_base
    assert_equal setter.sign, scaler.sign
    assert_equal setter.exponent, scaler.exponent
    assert_equal setter.special?, scaler.special?
    assert_equal setter.special, scaler.special
  end

  def test_repeating_2
    # 2 repeating bits
    numeral = Numeral[1, 0, 1, 1, 1, 0, base: 2, point: 2, repeat: 4]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.e<a>E0', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.7<5>E1', check_scaler(scaler)

    assert_equal 16, scaler.scaled_base
    assert_equal setter.base, scaler.exponent_base
    assert_equal setter.sign, scaler.sign
    assert_equal setter.exponent, scaler.exponent
    assert_equal setter.special?, scaler.special?
    assert_equal setter.special, scaler.special
  end

  def test_repeating_3
    # 3 repeating bits
    numeral = Numeral[1, 0, 1, 1, 1, 0, 1, base: 2, point: 2, repeat: 4]
    setter = Format::ExpSetter[numeral]
    setter.integer_part_size = 2
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '2.e<db6>E0', check_scaler(scaler)
    setter.integer_part_size = 1
    scaler = Format::BaseScaler[setter, 4]
    assert_equal '1.7<6db>E1', check_scaler(scaler)

    assert_equal 16, scaler.scaled_base
    assert_equal setter.base, scaler.exponent_base
    assert_equal setter.sign, scaler.sign
    assert_equal setter.exponent, scaler.exponent
    assert_equal setter.special?, scaler.special?
    assert_equal setter.special, scaler.special
  end

end
