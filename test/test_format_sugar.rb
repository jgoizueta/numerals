require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
require 'yaml'

class TestFormatSugar <  Test::Unit::TestCase # < Minitest::Test

  include Numerals

  def test_sweetness
    txt = Format << 0.1
    assert_equal Format[].write(0.1), txt.to_s

    fmt = Format[Rounding[places: 3]]
    txt = fmt << 0.1
    txt_x = fmt.write(0.1)
    assert_equal txt_x, txt.to_s

    txt = fmt << 0.1 << 0.2
    txt_y = fmt.write(0.2)
    assert_equal [txt_x, txt_y], txt.to_a
    assert_equal "#{txt_x}#{txt_y}", txt.to_s
    txt = fmt << 0.1 << "  " << 0.2
    assert_equal [txt_x, '  ', txt_y], txt.to_a
    assert_equal "#{txt_x}  #{txt_y}", txt.to_s

    assert_equal [txt_x, txt_y], fmt.<<(*[0.1, 0.2]).to_a
    result = fmt << 0.1 << [:sci, precision: 3] << 0.2
    assert_equal [txt_x, fmt[:sci, precision: 3].write(0.2)], result.to_a

    x = fmt >> '0.1' >> Float
    assert_equal fmt.read('0.1', type: Float), x.value

    to_float = fmt >> Float
    x = fmt.read('0.1', type: Float)
    y = fmt.read('0.2', type: Float)
    assert_same_number x, (to_float << '0.1').value
    to_float.clear
    assert_same_number y, (to_float << '0.2').value
    to_float.clear
    assert_equal [x, y], (to_float << '0.1' << '0.2').to_a

    assert_equal x, (fmt >> '0.1' >> Float).value

    convert = fmt >> '0.1'
    x = fmt.read('0.1', type: Float)
    y = fmt.read('0.1', type: Flt::DecNum)
    assert_same_number x, (convert >> Float).value
    convert.clear
    assert_same_number y, (convert >> Flt::DecNum).value
    convert.clear
    assert_equal [x, y], (convert >> Float >> Flt::DecNum).to_a
  end

end
