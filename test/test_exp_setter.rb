require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals'
include Numerals

class TestExpSetter <  Test::Unit::TestCase # < Minitest::Test

  def check_setter(numeral, n=nil)
    adjust = ExpSetter[numeral]
    adjust.integer_part_size = n if n
    "#{adjust.integer_part.join}.#{adjust.fractional_part.join}<#{adjust.repeat_part.join}>E#{adjust.exponent}"
  end

  def test_approx_no_exp
    digits_1_6 = (1..6).to_a

    assert_equal ".00000000000000000000000000000000000000000000000000123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -50, normalize: :approximate], nil)
    assert_equal ".0000000000000000000000000123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -25, normalize: :approximate], nil)
    assert_equal ".000000123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -6, normalize: :approximate], nil)
    assert_equal ".00000123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -5, normalize: :approximate], nil)
    assert_equal ".0000123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -4, normalize: :approximate], nil)
    assert_equal ".000123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -3, normalize: :approximate], nil)
    assert_equal ".00123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -2, normalize: :approximate], nil)
    assert_equal ".0123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -1, normalize: :approximate], nil)
    assert_equal ".123456<>E0",
                 check_setter(Numeral[digits_1_6, point: 0, normalize: :approximate], nil)
    assert_equal "1.23456<>E0",
                 check_setter(Numeral[digits_1_6, point: 1, normalize: :approximate], nil)
    assert_equal "12.3456<>E0",
                 check_setter(Numeral[digits_1_6, point: 2, normalize: :approximate], nil)
    assert_equal "123.456<>E0",
                 check_setter(Numeral[digits_1_6, point: 3, normalize: :approximate], nil)
    assert_equal "1234.56<>E0",
                 check_setter(Numeral[digits_1_6, point: 4, normalize: :approximate], nil)
    assert_equal "12345.6<>E0",
                 check_setter(Numeral[digits_1_6, point: 5, normalize: :approximate], nil)
    assert_equal "123456.<>E0",
                 check_setter(Numeral[digits_1_6, point: 6, normalize: :approximate], nil)
    assert_equal "1234560.<>E0",
                 check_setter(Numeral[digits_1_6, point: 7, normalize: :approximate], nil)
    assert_equal "12345600.<>E0",
                 check_setter(Numeral[digits_1_6, point: 8, normalize: :approximate], nil)
    assert_equal "123456000.<>E0",
                 check_setter(Numeral[digits_1_6, point: 9, normalize: :approximate], nil)
    assert_equal "1234560000.<>E0",
                 check_setter(Numeral[digits_1_6, point: 10, normalize: :approximate], nil)
    assert_equal "12345600000.<>E0",
                 check_setter(Numeral[digits_1_6, point: 11, normalize: :approximate], nil)
    assert_equal "1234560000000000000000000.<>E0",
                 check_setter(Numeral[digits_1_6, point: 25, normalize: :approximate], nil)
    assert_equal "12345600000000000000000000000000000000000000000000.<>E0",
                 check_setter(Numeral[digits_1_6, point: 50, normalize: :approximate], nil)
  end

  def test_approx_exp_1
    digits_1_6 = (1..6).to_a

    assert_equal "1.23456<>E-51",
                 check_setter(Numeral[digits_1_6, point: -50, normalize: :approximate], 1)
    assert_equal "1.23456<>E-26",
                 check_setter(Numeral[digits_1_6, point: -25, normalize: :approximate], 1)
    assert_equal "1.23456<>E-7",
                 check_setter(Numeral[digits_1_6, point: -6, normalize: :approximate], 1)
    assert_equal "1.23456<>E-6",
                 check_setter(Numeral[digits_1_6, point: -5, normalize: :approximate], 1)
    assert_equal "1.23456<>E-5",
                 check_setter(Numeral[digits_1_6, point: -4, normalize: :approximate], 1)
    assert_equal "1.23456<>E-4",
                 check_setter(Numeral[digits_1_6, point: -3, normalize: :approximate], 1)
    assert_equal "1.23456<>E-3",
                 check_setter(Numeral[digits_1_6, point: -2, normalize: :approximate], 1)
    assert_equal "1.23456<>E-2",
                 check_setter(Numeral[digits_1_6, point: -1, normalize: :approximate], 1)
    assert_equal "1.23456<>E-1",
                 check_setter(Numeral[digits_1_6, point: 0, normalize: :approximate], 1)
    assert_equal "1.23456<>E0",
                 check_setter(Numeral[digits_1_6, point: 1, normalize: :approximate], 1)
    assert_equal "1.23456<>E1",
                 check_setter(Numeral[digits_1_6, point: 2, normalize: :approximate], 1)
    assert_equal "1.23456<>E2",
                 check_setter(Numeral[digits_1_6, point: 3, normalize: :approximate], 1)
    assert_equal "1.23456<>E3",
                 check_setter(Numeral[digits_1_6, point: 4, normalize: :approximate], 1)
    assert_equal "1.23456<>E4",
                 check_setter(Numeral[digits_1_6, point: 5, normalize: :approximate], 1)
    assert_equal "1.23456<>E5",
                 check_setter(Numeral[digits_1_6, point: 6, normalize: :approximate], 1)
    assert_equal "1.23456<>E6",
                 check_setter(Numeral[digits_1_6, point: 7, normalize: :approximate], 1)
    assert_equal "1.23456<>E7",
                 check_setter(Numeral[digits_1_6, point: 8, normalize: :approximate], 1)
    assert_equal "1.23456<>E8",
                 check_setter(Numeral[digits_1_6, point: 9, normalize: :approximate], 1)
    assert_equal "1.23456<>E9",
                 check_setter(Numeral[digits_1_6, point: 10, normalize: :approximate], 1)
    assert_equal "1.23456<>E10",
                 check_setter(Numeral[digits_1_6, point: 11, normalize: :approximate], 1)
    assert_equal "1.23456<>E24",
                 check_setter(Numeral[digits_1_6, point: 25, normalize: :approximate], 1)
    assert_equal "1.23456<>E49",
                 check_setter(Numeral[digits_1_6, point: 50, normalize: :approximate], 1)
  end

  def test_approx_exp_2
    digits_1_6 = (1..6).to_a

    assert_equal "12.3456<>E-52",
                 check_setter(Numeral[digits_1_6, point: -50, normalize: :approximate], 2)
    assert_equal "12.3456<>E-27",
                 check_setter(Numeral[digits_1_6, point: -25, normalize: :approximate], 2)
    assert_equal "12.3456<>E-8",
                 check_setter(Numeral[digits_1_6, point: -6, normalize: :approximate], 2)
    assert_equal "12.3456<>E-7",
                 check_setter(Numeral[digits_1_6, point: -5, normalize: :approximate], 2)
    assert_equal "12.3456<>E-6",
                 check_setter(Numeral[digits_1_6, point: -4, normalize: :approximate], 2)
    assert_equal "12.3456<>E-5",
                 check_setter(Numeral[digits_1_6, point: -3, normalize: :approximate], 2)
    assert_equal "12.3456<>E-4",
                 check_setter(Numeral[digits_1_6, point: -2, normalize: :approximate], 2)
    assert_equal "12.3456<>E-3",
                 check_setter(Numeral[digits_1_6, point: -1, normalize: :approximate], 2)
    assert_equal "12.3456<>E-2",
                 check_setter(Numeral[digits_1_6, point: 0, normalize: :approximate], 2)
    assert_equal "12.3456<>E-1",
                 check_setter(Numeral[digits_1_6, point: 1, normalize: :approximate], 2)
    assert_equal "12.3456<>E0",
                 check_setter(Numeral[digits_1_6, point: 2, normalize: :approximate], 2)
    assert_equal "12.3456<>E1",
                 check_setter(Numeral[digits_1_6, point: 3, normalize: :approximate], 2)
    assert_equal "12.3456<>E2",
                 check_setter(Numeral[digits_1_6, point: 4, normalize: :approximate], 2)
    assert_equal "12.3456<>E3",
                 check_setter(Numeral[digits_1_6, point: 5, normalize: :approximate], 2)
    assert_equal "12.3456<>E4",
                 check_setter(Numeral[digits_1_6, point: 6, normalize: :approximate], 2)
    assert_equal "12.3456<>E5",
                 check_setter(Numeral[digits_1_6, point: 7, normalize: :approximate], 2)
    assert_equal "12.3456<>E6",
                 check_setter(Numeral[digits_1_6, point: 8, normalize: :approximate], 2)
    assert_equal "12.3456<>E7",
                 check_setter(Numeral[digits_1_6, point: 9, normalize: :approximate], 2)
    assert_equal "12.3456<>E8",
                 check_setter(Numeral[digits_1_6, point: 10, normalize: :approximate], 2)
    assert_equal "12.3456<>E9",
                 check_setter(Numeral[digits_1_6, point: 11, normalize: :approximate], 2)
    assert_equal "12.3456<>E23",
                 check_setter(Numeral[digits_1_6, point: 25, normalize: :approximate], 2)
    assert_equal "12.3456<>E48",
                 check_setter(Numeral[digits_1_6, point: 50, normalize: :approximate], 2)
  end

  def test_approx_exp_3
    digits_1_6 = (1..6).to_a

    assert_equal "123.456<>E-53",
                 check_setter(Numeral[digits_1_6, point: -50, normalize: :approximate], 3)
    assert_equal "123.456<>E-28",
                 check_setter(Numeral[digits_1_6, point: -25, normalize: :approximate], 3)
    assert_equal "123.456<>E-9",
                 check_setter(Numeral[digits_1_6, point: -6, normalize: :approximate], 3)
    assert_equal "123.456<>E-8",
                 check_setter(Numeral[digits_1_6, point: -5, normalize: :approximate], 3)
    assert_equal "123.456<>E-7",
                 check_setter(Numeral[digits_1_6, point: -4, normalize: :approximate], 3)
    assert_equal "123.456<>E-6",
                 check_setter(Numeral[digits_1_6, point: -3, normalize: :approximate], 3)
    assert_equal "123.456<>E-5",
                 check_setter(Numeral[digits_1_6, point: -2, normalize: :approximate], 3)
    assert_equal "123.456<>E-4",
                 check_setter(Numeral[digits_1_6, point: -1, normalize: :approximate], 3)
    assert_equal "123.456<>E-3",
                 check_setter(Numeral[digits_1_6, point: 0, normalize: :approximate], 3)
    assert_equal "123.456<>E-2",
                 check_setter(Numeral[digits_1_6, point: 1, normalize: :approximate], 3)
    assert_equal "123.456<>E-1",
                 check_setter(Numeral[digits_1_6, point: 2, normalize: :approximate], 3)
    assert_equal "123.456<>E0",
                 check_setter(Numeral[digits_1_6, point: 3, normalize: :approximate], 3)
    assert_equal "123.456<>E1",
                 check_setter(Numeral[digits_1_6, point: 4, normalize: :approximate], 3)
    assert_equal "123.456<>E2",
                 check_setter(Numeral[digits_1_6, point: 5, normalize: :approximate], 3)
    assert_equal "123.456<>E3",
                 check_setter(Numeral[digits_1_6, point: 6, normalize: :approximate], 3)
    assert_equal "123.456<>E4",
                 check_setter(Numeral[digits_1_6, point: 7, normalize: :approximate], 3)
    assert_equal "123.456<>E5",
                 check_setter(Numeral[digits_1_6, point: 8, normalize: :approximate], 3)
    assert_equal "123.456<>E6",
                 check_setter(Numeral[digits_1_6, point: 9, normalize: :approximate], 3)
    assert_equal "123.456<>E7",
                 check_setter(Numeral[digits_1_6, point: 10, normalize: :approximate], 3)
    assert_equal "123.456<>E8",
                 check_setter(Numeral[digits_1_6, point: 11, normalize: :approximate], 3)
    assert_equal "123.456<>E22",
                 check_setter(Numeral[digits_1_6, point: 25, normalize: :approximate], 3)
    assert_equal "123.456<>E47",
                 check_setter(Numeral[digits_1_6, point: 50, normalize: :approximate], 3)
  end

  def test_approx_exp_m1
    digits_1_6 = (1..6).to_a

    assert_equal ".0123456<>E-49",
                 check_setter(Numeral[digits_1_6, point: -50, normalize: :approximate], -1)
    assert_equal ".0123456<>E-24",
                 check_setter(Numeral[digits_1_6, point: -25, normalize: :approximate], -1)
    assert_equal ".0123456<>E-5",
                 check_setter(Numeral[digits_1_6, point: -6, normalize: :approximate], -1)
    assert_equal ".0123456<>E-4",
                 check_setter(Numeral[digits_1_6, point: -5, normalize: :approximate], -1)
    assert_equal ".0123456<>E-3",
                 check_setter(Numeral[digits_1_6, point: -4, normalize: :approximate], -1)
    assert_equal ".0123456<>E-2",
                 check_setter(Numeral[digits_1_6, point: -3, normalize: :approximate], -1)
    assert_equal ".0123456<>E-1",
                 check_setter(Numeral[digits_1_6, point: -2, normalize: :approximate], -1)
    assert_equal ".0123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -1, normalize: :approximate], -1)
    assert_equal ".0123456<>E1",
                 check_setter(Numeral[digits_1_6, point: 0, normalize: :approximate], -1)
    assert_equal ".0123456<>E2",
                 check_setter(Numeral[digits_1_6, point: 1, normalize: :approximate], -1)
    assert_equal ".0123456<>E3",
                 check_setter(Numeral[digits_1_6, point: 2, normalize: :approximate], -1)
    assert_equal ".0123456<>E4",
                 check_setter(Numeral[digits_1_6, point: 3, normalize: :approximate], -1)
    assert_equal ".0123456<>E5",
                 check_setter(Numeral[digits_1_6, point: 4, normalize: :approximate], -1)
    assert_equal ".0123456<>E6",
                 check_setter(Numeral[digits_1_6, point: 5, normalize: :approximate], -1)
    assert_equal ".0123456<>E7",
                 check_setter(Numeral[digits_1_6, point: 6, normalize: :approximate], -1)
    assert_equal ".0123456<>E8",
                 check_setter(Numeral[digits_1_6, point: 7, normalize: :approximate], -1)
    assert_equal ".0123456<>E9",
                 check_setter(Numeral[digits_1_6, point: 8, normalize: :approximate], -1)
    assert_equal ".0123456<>E10",
                 check_setter(Numeral[digits_1_6, point: 9, normalize: :approximate], -1)
    assert_equal ".0123456<>E11",
                 check_setter(Numeral[digits_1_6, point: 10, normalize: :approximate], -1)
    assert_equal ".0123456<>E12",
                 check_setter(Numeral[digits_1_6, point: 11, normalize: :approximate], -1)
    assert_equal ".0123456<>E26",
                 check_setter(Numeral[digits_1_6, point: 25, normalize: :approximate], -1)
    assert_equal ".0123456<>E51",
                 check_setter(Numeral[digits_1_6, point: 50, normalize: :approximate], -1)

  end

  def test_approx_exp_m2
    digits_1_6 = (1..6).to_a

    assert_equal ".00123456<>E-48",
                 check_setter(Numeral[digits_1_6, point: -50, normalize: :approximate], -2)
    assert_equal ".00123456<>E-23",
                 check_setter(Numeral[digits_1_6, point: -25, normalize: :approximate], -2)
    assert_equal ".00123456<>E-4",
                 check_setter(Numeral[digits_1_6, point: -6, normalize: :approximate], -2)
    assert_equal ".00123456<>E-3",
                 check_setter(Numeral[digits_1_6, point: -5, normalize: :approximate], -2)
    assert_equal ".00123456<>E-2",
                 check_setter(Numeral[digits_1_6, point: -4, normalize: :approximate], -2)
    assert_equal ".00123456<>E-1",
                 check_setter(Numeral[digits_1_6, point: -3, normalize: :approximate], -2)
    assert_equal ".00123456<>E0",
                 check_setter(Numeral[digits_1_6, point: -2, normalize: :approximate], -2)
    assert_equal ".00123456<>E1",
                 check_setter(Numeral[digits_1_6, point: -1, normalize: :approximate], -2)
    assert_equal ".00123456<>E2",
                 check_setter(Numeral[digits_1_6, point: 0, normalize: :approximate], -2)
    assert_equal ".00123456<>E3",
                 check_setter(Numeral[digits_1_6, point: 1, normalize: :approximate], -2)
    assert_equal ".00123456<>E4",
                 check_setter(Numeral[digits_1_6, point: 2, normalize: :approximate], -2)
    assert_equal ".00123456<>E5",
                 check_setter(Numeral[digits_1_6, point: 3, normalize: :approximate], -2)
    assert_equal ".00123456<>E6",
                 check_setter(Numeral[digits_1_6, point: 4, normalize: :approximate], -2)
    assert_equal ".00123456<>E7",
                 check_setter(Numeral[digits_1_6, point: 5, normalize: :approximate], -2)
    assert_equal ".00123456<>E8",
                 check_setter(Numeral[digits_1_6, point: 6, normalize: :approximate], -2)
    assert_equal ".00123456<>E9",
                 check_setter(Numeral[digits_1_6, point: 7, normalize: :approximate], -2)
    assert_equal ".00123456<>E10",
                 check_setter(Numeral[digits_1_6, point: 8, normalize: :approximate], -2)
    assert_equal ".00123456<>E11",
                 check_setter(Numeral[digits_1_6, point: 9, normalize: :approximate], -2)
    assert_equal ".00123456<>E12",
                 check_setter(Numeral[digits_1_6, point: 10, normalize: :approximate], -2)
    assert_equal ".00123456<>E13",
                 check_setter(Numeral[digits_1_6, point: 11, normalize: :approximate], -2)
    assert_equal ".00123456<>E27",
                 check_setter(Numeral[digits_1_6, point: 25, normalize: :approximate], -2)
    assert_equal ".00123456<>E52",
                 check_setter(Numeral[digits_1_6, point: 50, normalize: :approximate], -2)
  end

  def test_repeating_no_exp
    digits_1_9 = (1..9).to_a

    assert_equal ".00000000000000000000000000000000000000000000000000123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -50, repeat: 6], nil)
    assert_equal ".0000000000000000000000000123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -25, repeat: 6], nil)
    assert_equal ".000000123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -6, repeat: 6], nil)
    assert_equal ".00000123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -5, repeat: 6], nil)
    assert_equal ".0000123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -4, repeat: 6], nil)
    assert_equal ".000123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -3, repeat: 6], nil)
    assert_equal ".00123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -2, repeat: 6], nil)
    assert_equal ".0123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -1, repeat: 6], nil)
    assert_equal ".123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 0, repeat: 6], nil)
    assert_equal "1.23456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 1, repeat: 6], nil)
    assert_equal "12.3456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 2, repeat: 6], nil)
    assert_equal "123.456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 3, repeat: 6], nil)
    assert_equal "1234.56<789>E0",
                 check_setter(Numeral[digits_1_9, point: 4, repeat: 6], nil)
    assert_equal "12345.6<789>E0",
                 check_setter(Numeral[digits_1_9, point: 5, repeat: 6], nil)
    assert_equal "123456.<789>E0",
                 check_setter(Numeral[digits_1_9, point: 6, repeat: 6], nil)
    assert_equal "1234567.<897>E0",
                 check_setter(Numeral[digits_1_9, point: 7, repeat: 6], nil)
    assert_equal "12345678.<978>E0",
                 check_setter(Numeral[digits_1_9, point: 8, repeat: 6], nil)
    assert_equal "123456789.<789>E0",
                 check_setter(Numeral[digits_1_9, point: 9, repeat: 6], nil)
    assert_equal "1234567897.<897>E0",
                 check_setter(Numeral[digits_1_9, point: 10, repeat: 6], nil)
    assert_equal "12345678978.<978>E0",
                 check_setter(Numeral[digits_1_9, point: 11, repeat: 6], nil)
    assert_equal "123456789789.<789>E0",
                 check_setter(Numeral[digits_1_9, point: 12, repeat: 6], nil)
    assert_equal "1234567897897.<897>E0",
                 check_setter(Numeral[digits_1_9, point: 13, repeat: 6], nil)
    assert_equal "12345678978978.<978>E0",
                 check_setter(Numeral[digits_1_9, point: 14, repeat: 6], nil)
    assert_equal "1234567897897897897897897.<897>E0",
                 check_setter(Numeral[digits_1_9, point: 25, repeat: 6], nil)
    assert_equal "12345678978978978978978978978978978978978978978978.<978>E0",
                 check_setter(Numeral[digits_1_9, point: 50, repeat: 6], nil)
  end

  def test_repeating_exp_1
    digits_1_9 = (1..9).to_a

    assert_equal "1.23456<789>E-51",
                 check_setter(Numeral[digits_1_9, point: -50, repeat: 6], 1)
    assert_equal "1.23456<789>E-26",
                 check_setter(Numeral[digits_1_9, point: -25, repeat: 6], 1)
    assert_equal "1.23456<789>E-7",
                 check_setter(Numeral[digits_1_9, point: -6, repeat: 6], 1)
    assert_equal "1.23456<789>E-6",
                 check_setter(Numeral[digits_1_9, point: -5, repeat: 6], 1)
    assert_equal "1.23456<789>E-5",
                 check_setter(Numeral[digits_1_9, point: -4, repeat: 6], 1)
    assert_equal "1.23456<789>E-4",
                 check_setter(Numeral[digits_1_9, point: -3, repeat: 6], 1)
    assert_equal "1.23456<789>E-3",
                 check_setter(Numeral[digits_1_9, point: -2, repeat: 6], 1)
    assert_equal "1.23456<789>E-2",
                 check_setter(Numeral[digits_1_9, point: -1, repeat: 6], 1)
    assert_equal "1.23456<789>E-1",
                 check_setter(Numeral[digits_1_9, point: 0, repeat: 6], 1)
    assert_equal "1.23456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 1, repeat: 6], 1)
    assert_equal "1.23456<789>E1",
                 check_setter(Numeral[digits_1_9, point: 2, repeat: 6], 1)
    assert_equal "1.23456<789>E2",
                 check_setter(Numeral[digits_1_9, point: 3, repeat: 6], 1)
    assert_equal "1.23456<789>E3",
                 check_setter(Numeral[digits_1_9, point: 4, repeat: 6], 1)
    assert_equal "1.23456<789>E4",
                 check_setter(Numeral[digits_1_9, point: 5, repeat: 6], 1)
    assert_equal "1.23456<789>E5",
                 check_setter(Numeral[digits_1_9, point: 6, repeat: 6], 1)
    assert_equal "1.23456<789>E6",
                 check_setter(Numeral[digits_1_9, point: 7, repeat: 6], 1)
    assert_equal "1.23456<789>E7",
                 check_setter(Numeral[digits_1_9, point: 8, repeat: 6], 1)
    assert_equal "1.23456<789>E8",
                 check_setter(Numeral[digits_1_9, point: 9, repeat: 6], 1)
    assert_equal "1.23456<789>E9",
                 check_setter(Numeral[digits_1_9, point: 10, repeat: 6], 1)
    assert_equal "1.23456<789>E10",
                 check_setter(Numeral[digits_1_9, point: 11, repeat: 6], 1)
    assert_equal "1.23456<789>E11",
                 check_setter(Numeral[digits_1_9, point: 12, repeat: 6], 1)
    assert_equal "1.23456<789>E12",
                 check_setter(Numeral[digits_1_9, point: 13, repeat: 6], 1)
    assert_equal "1.23456<789>E13",
                 check_setter(Numeral[digits_1_9, point: 14, repeat: 6], 1)
    assert_equal "1.23456<789>E24",
                 check_setter(Numeral[digits_1_9, point: 25, repeat: 6], 1)
    assert_equal "1.23456<789>E49",
                 check_setter(Numeral[digits_1_9, point: 50, repeat: 6], 1)
  end

  def test_repeating_exp_2
    digits_1_9 = (1..9).to_a

    assert_equal "12.3456<789>E-52",
                 check_setter(Numeral[digits_1_9, point: -50, repeat: 6], 2)
    assert_equal "12.3456<789>E-27",
                 check_setter(Numeral[digits_1_9, point: -25, repeat: 6], 2)
    assert_equal "12.3456<789>E-8",
                 check_setter(Numeral[digits_1_9, point: -6, repeat: 6], 2)
    assert_equal "12.3456<789>E-7",
                 check_setter(Numeral[digits_1_9, point: -5, repeat: 6], 2)
    assert_equal "12.3456<789>E-6",
                 check_setter(Numeral[digits_1_9, point: -4, repeat: 6], 2)
    assert_equal "12.3456<789>E-5",
                 check_setter(Numeral[digits_1_9, point: -3, repeat: 6], 2)
    assert_equal "12.3456<789>E-4",
                 check_setter(Numeral[digits_1_9, point: -2, repeat: 6], 2)
    assert_equal "12.3456<789>E-3",
                 check_setter(Numeral[digits_1_9, point: -1, repeat: 6], 2)
    assert_equal "12.3456<789>E-2",
                 check_setter(Numeral[digits_1_9, point: 0, repeat: 6], 2)
    assert_equal "12.3456<789>E-1",
                 check_setter(Numeral[digits_1_9, point: 1, repeat: 6], 2)
    assert_equal "12.3456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 2, repeat: 6], 2)
    assert_equal "12.3456<789>E1",
                 check_setter(Numeral[digits_1_9, point: 3, repeat: 6], 2)
    assert_equal "12.3456<789>E2",
                 check_setter(Numeral[digits_1_9, point: 4, repeat: 6], 2)
    assert_equal "12.3456<789>E3",
                 check_setter(Numeral[digits_1_9, point: 5, repeat: 6], 2)
    assert_equal "12.3456<789>E4",
                 check_setter(Numeral[digits_1_9, point: 6, repeat: 6], 2)
    assert_equal "12.3456<789>E5",
                 check_setter(Numeral[digits_1_9, point: 7, repeat: 6], 2)
    assert_equal "12.3456<789>E6",
                 check_setter(Numeral[digits_1_9, point: 8, repeat: 6], 2)
    assert_equal "12.3456<789>E7",
                 check_setter(Numeral[digits_1_9, point: 9, repeat: 6], 2)
    assert_equal "12.3456<789>E8",
                 check_setter(Numeral[digits_1_9, point: 10, repeat: 6], 2)
    assert_equal "12.3456<789>E9",
                 check_setter(Numeral[digits_1_9, point: 11, repeat: 6], 2)
    assert_equal "12.3456<789>E10",
                 check_setter(Numeral[digits_1_9, point: 12, repeat: 6], 2)
    assert_equal "12.3456<789>E11",
                 check_setter(Numeral[digits_1_9, point: 13, repeat: 6], 2)
    assert_equal "12.3456<789>E12",
                 check_setter(Numeral[digits_1_9, point: 14, repeat: 6], 2)
    assert_equal "12.3456<789>E23",
                 check_setter(Numeral[digits_1_9, point: 25, repeat: 6], 2)
    assert_equal "12.3456<789>E48",
                 check_setter(Numeral[digits_1_9, point: 50, repeat: 6], 2)
  end

  def test_repeating_exp_3
    digits_1_9 = (1..9).to_a

    assert_equal "123.456<789>E-53",
                 check_setter(Numeral[digits_1_9, point: -50, repeat: 6], 3)
    assert_equal "123.456<789>E-28",
                 check_setter(Numeral[digits_1_9, point: -25, repeat: 6], 3)
    assert_equal "123.456<789>E-9",
                 check_setter(Numeral[digits_1_9, point: -6, repeat: 6], 3)
    assert_equal "123.456<789>E-8",
                 check_setter(Numeral[digits_1_9, point: -5, repeat: 6], 3)
    assert_equal "123.456<789>E-7",
                 check_setter(Numeral[digits_1_9, point: -4, repeat: 6], 3)
    assert_equal "123.456<789>E-6",
                 check_setter(Numeral[digits_1_9, point: -3, repeat: 6], 3)
    assert_equal "123.456<789>E-5",
                 check_setter(Numeral[digits_1_9, point: -2, repeat: 6], 3)
    assert_equal "123.456<789>E-4",
                 check_setter(Numeral[digits_1_9, point: -1, repeat: 6], 3)
    assert_equal "123.456<789>E-3",
                 check_setter(Numeral[digits_1_9, point: 0, repeat: 6], 3)
    assert_equal "123.456<789>E-2",
                 check_setter(Numeral[digits_1_9, point: 1, repeat: 6], 3)
    assert_equal "123.456<789>E-1",
                 check_setter(Numeral[digits_1_9, point: 2, repeat: 6], 3)
    assert_equal "123.456<789>E0",
                 check_setter(Numeral[digits_1_9, point: 3, repeat: 6], 3)
    assert_equal "123.456<789>E1",
                 check_setter(Numeral[digits_1_9, point: 4, repeat: 6], 3)
    assert_equal "123.456<789>E2",
                 check_setter(Numeral[digits_1_9, point: 5, repeat: 6], 3)
    assert_equal "123.456<789>E3",
                 check_setter(Numeral[digits_1_9, point: 6, repeat: 6], 3)
    assert_equal "123.456<789>E4",
                 check_setter(Numeral[digits_1_9, point: 7, repeat: 6], 3)
    assert_equal "123.456<789>E5",
                 check_setter(Numeral[digits_1_9, point: 8, repeat: 6], 3)
    assert_equal "123.456<789>E6",
                 check_setter(Numeral[digits_1_9, point: 9, repeat: 6], 3)
    assert_equal "123.456<789>E7",
                 check_setter(Numeral[digits_1_9, point: 10, repeat: 6], 3)
    assert_equal "123.456<789>E8",
                 check_setter(Numeral[digits_1_9, point: 11, repeat: 6], 3)
    assert_equal "123.456<789>E9",
                 check_setter(Numeral[digits_1_9, point: 12, repeat: 6], 3)
    assert_equal "123.456<789>E10",
                 check_setter(Numeral[digits_1_9, point: 13, repeat: 6], 3)
    assert_equal "123.456<789>E11",
                 check_setter(Numeral[digits_1_9, point: 14, repeat: 6], 3)
    assert_equal "123.456<789>E22",
                 check_setter(Numeral[digits_1_9, point: 25, repeat: 6], 3)
    assert_equal "123.456<789>E47",
                 check_setter(Numeral[digits_1_9, point: 50, repeat: 6], 3)
  end

  def test_repeating_exp_m1
    digits_1_9 = (1..9).to_a

    assert_equal ".0123456<789>E-49",
                 check_setter(Numeral[digits_1_9, point: -50, repeat: 6], -1)
    assert_equal ".0123456<789>E-24",
                 check_setter(Numeral[digits_1_9, point: -25, repeat: 6], -1)
    assert_equal ".0123456<789>E-5",
                 check_setter(Numeral[digits_1_9, point: -6, repeat: 6], -1)
    assert_equal ".0123456<789>E-4",
                 check_setter(Numeral[digits_1_9, point: -5, repeat: 6], -1)
    assert_equal ".0123456<789>E-3",
                 check_setter(Numeral[digits_1_9, point: -4, repeat: 6], -1)
    assert_equal ".0123456<789>E-2",
                 check_setter(Numeral[digits_1_9, point: -3, repeat: 6], -1)
    assert_equal ".0123456<789>E-1",
                 check_setter(Numeral[digits_1_9, point: -2, repeat: 6], -1)
    assert_equal ".0123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -1, repeat: 6], -1)
    assert_equal ".0123456<789>E1",
                 check_setter(Numeral[digits_1_9, point: 0, repeat: 6], -1)
    assert_equal ".0123456<789>E2",
                 check_setter(Numeral[digits_1_9, point: 1, repeat: 6], -1)
    assert_equal ".0123456<789>E3",
                 check_setter(Numeral[digits_1_9, point: 2, repeat: 6], -1)
    assert_equal ".0123456<789>E4",
                 check_setter(Numeral[digits_1_9, point: 3, repeat: 6], -1)
    assert_equal ".0123456<789>E5",
                 check_setter(Numeral[digits_1_9, point: 4, repeat: 6], -1)
    assert_equal ".0123456<789>E6",
                 check_setter(Numeral[digits_1_9, point: 5, repeat: 6], -1)
    assert_equal ".0123456<789>E7",
                 check_setter(Numeral[digits_1_9, point: 6, repeat: 6], -1)
    assert_equal ".0123456<789>E8",
                 check_setter(Numeral[digits_1_9, point: 7, repeat: 6], -1)
    assert_equal ".0123456<789>E9",
                 check_setter(Numeral[digits_1_9, point: 8, repeat: 6], -1)
    assert_equal ".0123456<789>E10",
                 check_setter(Numeral[digits_1_9, point: 9, repeat: 6], -1)
    assert_equal ".0123456<789>E11",
                 check_setter(Numeral[digits_1_9, point: 10, repeat: 6], -1)
    assert_equal ".0123456<789>E12",
                 check_setter(Numeral[digits_1_9, point: 11, repeat: 6], -1)
    assert_equal ".0123456<789>E13",
                 check_setter(Numeral[digits_1_9, point: 12, repeat: 6], -1)
    assert_equal ".0123456<789>E14",
                 check_setter(Numeral[digits_1_9, point: 13, repeat: 6], -1)
    assert_equal ".0123456<789>E15",
                 check_setter(Numeral[digits_1_9, point: 14, repeat: 6], -1)
    assert_equal ".0123456<789>E26",
                 check_setter(Numeral[digits_1_9, point: 25, repeat: 6], -1)
    assert_equal ".0123456<789>E51",
                 check_setter(Numeral[digits_1_9, point: 50, repeat: 6], -1)
  end

  def test_repeating_exp_m2
    digits_1_9 = (1..9).to_a

    assert_equal ".00123456<789>E-48",
                 check_setter(Numeral[digits_1_9, point: -50, repeat: 6], -2)
    assert_equal ".00123456<789>E-23",
                 check_setter(Numeral[digits_1_9, point: -25, repeat: 6], -2)
    assert_equal ".00123456<789>E-4",
                 check_setter(Numeral[digits_1_9, point: -6, repeat: 6], -2)
    assert_equal ".00123456<789>E-3",
                 check_setter(Numeral[digits_1_9, point: -5, repeat: 6], -2)
    assert_equal ".00123456<789>E-2",
                 check_setter(Numeral[digits_1_9, point: -4, repeat: 6], -2)
    assert_equal ".00123456<789>E-1",
                 check_setter(Numeral[digits_1_9, point: -3, repeat: 6], -2)
    assert_equal ".00123456<789>E0",
                 check_setter(Numeral[digits_1_9, point: -2, repeat: 6], -2)
    assert_equal ".00123456<789>E1",
                 check_setter(Numeral[digits_1_9, point: -1, repeat: 6], -2)
    assert_equal ".00123456<789>E2",
                 check_setter(Numeral[digits_1_9, point: 0, repeat: 6], -2)
    assert_equal ".00123456<789>E3",
                 check_setter(Numeral[digits_1_9, point: 1, repeat: 6], -2)
    assert_equal ".00123456<789>E4",
                 check_setter(Numeral[digits_1_9, point: 2, repeat: 6], -2)
    assert_equal ".00123456<789>E5",
                 check_setter(Numeral[digits_1_9, point: 3, repeat: 6], -2)
    assert_equal ".00123456<789>E6",
                 check_setter(Numeral[digits_1_9, point: 4, repeat: 6], -2)
    assert_equal ".00123456<789>E7",
                 check_setter(Numeral[digits_1_9, point: 5, repeat: 6], -2)
    assert_equal ".00123456<789>E8",
                 check_setter(Numeral[digits_1_9, point: 6, repeat: 6], -2)
    assert_equal ".00123456<789>E9",
                 check_setter(Numeral[digits_1_9, point: 7, repeat: 6], -2)
    assert_equal ".00123456<789>E10",
                 check_setter(Numeral[digits_1_9, point: 8, repeat: 6], -2)
    assert_equal ".00123456<789>E11",
                 check_setter(Numeral[digits_1_9, point: 9, repeat: 6], -2)
    assert_equal ".00123456<789>E12",
                 check_setter(Numeral[digits_1_9, point: 10, repeat: 6], -2)
    assert_equal ".00123456<789>E13",
                 check_setter(Numeral[digits_1_9, point: 11, repeat: 6], -2)
    assert_equal ".00123456<789>E14",
                 check_setter(Numeral[digits_1_9, point: 12, repeat: 6], -2)
    assert_equal ".00123456<789>E15",
                 check_setter(Numeral[digits_1_9, point: 13, repeat: 6], -2)
    assert_equal ".00123456<789>E16",
                 check_setter(Numeral[digits_1_9, point: 14, repeat: 6], -2)
    assert_equal ".00123456<789>E27",
                 check_setter(Numeral[digits_1_9, point: 25, repeat: 6], -2)
    assert_equal ".00123456<789>E52",
                 check_setter(Numeral[digits_1_9, point: 50, repeat: 6], -2)
  end

end
