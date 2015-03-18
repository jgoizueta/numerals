require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestFormatOutput <  Test::Unit::TestCase # < Minitest::Test

  def test_write
    assert_equal '1', Format[].write(1.0)
    assert_equal '1.00', Format[Rounding[precision: 3]].write(1.0)
    assert_equal '1.000', Format[Rounding[places: 3]].write(1.0)
    assert_equal '1234567.1234', Format[rounding: :simplify].write(1234567.1234)
    assert_equal '1234567.123', Format[Rounding[places: 3]].write(1234567.1234)
    grouping = Format::Symbols[grouping: [3]]
    assert_equal '1,234,567.123', Format[Rounding[places: 3], grouping].write(1234567.1234)
    # TODO: proper coverage
  end

end
