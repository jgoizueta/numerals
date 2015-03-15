require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestFormatInput <  Test::Unit::TestCase # < Minitest::Test

  def test_read
    assert_equal 1.0, Format[].read('1', type: Float)
  end

end
