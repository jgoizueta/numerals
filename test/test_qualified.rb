require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

class TestQualified <  Test::Unit::TestCase # < Minitest::Test

  def test_qualified_use
    assert_equal '1', Numerals::Format[].write(1.0)
    assert_equal '1.00', Numerals::Format[Numerals::Rounding[precision: 3]].write(1.0)
    assert_equal '1.000', Numerals::Format[Numerals::Rounding[places: 3]].write(1.0)
    assert_equal '1234567.1234', Numerals::Format[rounding: :short].write(1234567.1234)
    assert_equal '1234567.123', Numerals::Format[Numerals::Rounding[places: 3]].write(1234567.1234)
  end

end
