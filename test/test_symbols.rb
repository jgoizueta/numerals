require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals/rounding'

class TestSymbols <  Test::Unit::TestCase # < Minitest::Test

  include Numerals

  def test_symbols
    s = Format::Symbols[show_plus: false]
    s2 = s[uppercase: true]
    assert_equal true, s2.uppercase
    assert_equal false, s.uppercase
    assert_equal false, s.show_plus
    assert_equal false, s2.show_plus
    s3 = s2[show_plus: true]
    assert_equal true, s3.show_plus
    assert_equal false, s.show_plus
    assert_equal false, s2.show_plus
    assert_equal s3, s2.set_plus(true)
    s4 = s3[plus: ' ']
    assert_equal s4, s3.set_plus(' ')
    s5 = s4[show_exponent_plus: true]
    assert_equal s5, s4.set_plus(true, :exp)
    s6 = s5[show_exponent_plus: true, plus: ' ']
    assert_equal s6, s5.set_plus(' ', :exp)
    s7 = s6[show_exponent_plus: true, show_plus: true]
    assert_equal s6, s5.set_plus(:all)
    s7 = s6[show_exponent_plus: true, show_plus: true, plus: ' ']
    assert_equal s7, s6.set_plus(' ', :all)
  end

end
