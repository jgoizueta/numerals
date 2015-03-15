require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'

class TestFormatOutput <  Test::Unit::TestCase # < Minitest::Test

  def test_write
    assert_equal '1.0', Format[].write(1.0)
  end

end
