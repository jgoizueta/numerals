# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
require 'test/unit'
include Numerals
require 'yaml'

class TestDigitsDefinition < Test::Unit::TestCase

  DEFAULT_DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  MAX_TEST_BASE  = DEFAULT_DIGITS.size

  def default_digits(b)
    DEFAULT_DIGITS[0,b]
  end

  def define_from_digits(b)
    Format::Symbols::Digits[default_digits(b)]
  end

  def check_base(b, digits)
    assert_equal b, digits.max_base
    (0...b).each do |digit_value|
      digit_symbol = default_digits(b)[digit_value]
      assert_equal digit_symbol, digits.digit_symbol(digit_value)
      assert_equal digit_value, digits.digit_value(digit_symbol)
      assert digits.is_digit?(digit_symbol)
    end
    [-10,-5,-2,-1,b,b+1,b+2,b+10].each do |invalid_digit_value|
      assert_nil digits.digit_symbol(invalid_digit_value)
    end
    invalid_chars = %w(- / & ñ)
    if b < MAX_TEST_BASE
      (b+1...MAX_TEST_BASE).each do |i|
        invalid_chars << DEFAULT_DIGITS[i]
      end
    end
    invalid_chars.each do |invalid_digit_char|
      assert_nil digits.digit_value(invalid_digit_char)
      assert !digits.is_digit?(invalid_digit_char)
    end
  end

  def test_digits_definition
    (0..MAX_TEST_BASE).each do |base|
      check_base base, define_from_digits(base)
    end
  end

  def test_digits_case
    uppercase_digits = Format::Symbols::Digits[uppercase: true]

    assert_equal 10, uppercase_digits.digit_value('A')
    assert_equal 11, uppercase_digits.digit_value('B')
    assert_equal 15, uppercase_digits.digit_value('F')

    assert_equal 10, uppercase_digits.digit_value('a')
    assert_equal 11, uppercase_digits.digit_value('b')
    assert_equal 15, uppercase_digits.digit_value('f')

    assert_equal 'A', uppercase_digits.digit_symbol(10)
    assert_equal 'B', uppercase_digits.digit_symbol(11)
    assert_equal 'F', uppercase_digits.digit_symbol(15)

    downcase_digits = Format::Symbols::Digits[lowercase: true]

    assert_equal 10, downcase_digits.digit_value('A')
    assert_equal 11, downcase_digits.digit_value('B')
    assert_equal 15, downcase_digits.digit_value('F')

    assert_equal 10, downcase_digits.digit_value('a')
    assert_equal 11, downcase_digits.digit_value('b')
    assert_equal 15, downcase_digits.digit_value('f')

    assert_equal 'a', downcase_digits.digit_symbol(10)
    assert_equal 'b', downcase_digits.digit_symbol(11)
    assert_equal 'f', downcase_digits.digit_symbol(15)


    cs_uppercase_digits = Format::Symbols::Digits[uppercase: true, case_sensitive: true]

    assert_equal 10,  cs_uppercase_digits.digit_value('A')
    assert_equal 11,  cs_uppercase_digits.digit_value('B')
    assert_equal 15,  cs_uppercase_digits.digit_value('F')
    assert_nil        cs_uppercase_digits.digit_value('a')
    assert_nil        cs_uppercase_digits.digit_value('b')
    assert_nil        cs_uppercase_digits.digit_value('f')
    assert_equal 'A', cs_uppercase_digits.digit_symbol(10)
    assert_equal 'B', cs_uppercase_digits.digit_symbol(11)
    assert_equal 'F', cs_uppercase_digits.digit_symbol(15)

    cs_downcase_digits = Format::Symbols::Digits[lowercase: true, case_sensitive: true]

    assert_equal 10,  cs_downcase_digits.digit_value('a')
    assert_equal 11,  cs_downcase_digits.digit_value('b')
    assert_equal 15,  cs_downcase_digits.digit_value('f')
    assert_nil        cs_downcase_digits.digit_value('A')
    assert_nil        cs_downcase_digits.digit_value('B')
    assert_nil        cs_downcase_digits.digit_value('F')
    assert_equal 'a', cs_downcase_digits.digit_symbol(10)
    assert_equal 'b', cs_downcase_digits.digit_symbol(11)
    assert_equal 'f', cs_downcase_digits.digit_symbol(15)
  end

end
