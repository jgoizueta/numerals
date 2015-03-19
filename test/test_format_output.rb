require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
include Numerals
require 'yaml'
require 'tempfile'

class TestFormatOutput <  Test::Unit::TestCase # < Minitest::Test

  def test_write_float_dec
    assert_equal '1', Format[rounding: :simplify].write(1.0)
    assert_equal '1', Format[].write(1.0)
    assert_equal '1.00', Format[Rounding[precision: 3]].write(1.0)
    assert_equal '1.000', Format[Rounding[places: 3]].write(1.0)
    assert_equal '1234567.1234', Format[rounding: :simplify].write(1234567.1234)
    assert_equal '1234567.123', Format[Rounding[places: 3]].write(1234567.1234)
    grouping = Format::Symbols[grouping: [3]]
    assert_equal '1,234,567.123', Format[Rounding[places: 3], grouping].write(1234567.1234)

    assert_equal '0.1', Format[].write(0.1)
    assert_equal '0.1', Format[rounding: :simplify].write(0.1)
    assert_equal '0.100', Format[Rounding[precision: 3]].write(0.1)
    assert_equal '0.1000000000000000', Format[Rounding[precision: 16]].write(0.1)
    assert_equal '0.10000000000000001', Format[Rounding[precision: 17]].write(0.1)
    assert_equal '0.10000000000000001', Format[Rounding[precision: 18]].write(0.1)

    assert_equal '0.1000000000000000055511151231257827021181583404541015625',
                 Format[Rounding[:exact], exact_input: true].write(0.1)


    assert_equal '0.1000000000000000055511151231257827021181583404541015625',
                 Format[Rounding[:preserve], exact_input: true].write(0.1)

    assert_equal '0.100000000000000005551115123125782702118158340454101562500000',
                 Format[Rounding[precision:60], exact_input: true].write(0.1)


    assert_equal '0.100000000000000005551115123125782702118158340454101562',
                 Format[Rounding[precision:54], exact_input: true].write(0.1)
    assert_equal '0.100000000000000005551115123125782702118158340454101563',
                 Format[Rounding[:half_up, precision:54], exact_input: true].write(0.1)
    assert_equal '0.100000000000000006', Format[Rounding[precision:18], exact_input: true].write(0.1)
    assert_equal '0.10000000000000001', Format[Rounding[precision:17], exact_input: true].write(0.1)
    assert_equal '0.1000000000000000', Format[Rounding[precision:16], exact_input: true].write(0.1)
    assert_equal '0.100', Format[Rounding[precision: 3], exact_input: true].write(0.1)
  end

  def test_write_decnum_dec
    assert_equal '1', Format[rounding: :simplify].write(Flt::DecNum('1.0'))
    assert_equal '1.0', Format[rounding: :preserve].write(Flt::DecNum('1.0'))
    assert_equal '1', Format[].write(Flt::DecNum('1.0'))

    assert_equal '1', Format[rounding: :simplify].write(Flt::DecNum('1.00'))
    assert_equal '1.00', Format[rounding: :preserve].write(Flt::DecNum('1.00'))
    assert_equal '1', Format[].write(Flt::DecNum('1.00'))

    # Note that currently, insignificant digits are not shown
    # (note also the 'additional' 0 is not insignificant, since it could only
    # be 0-5 without altering the rounded value 1.00)
    assert_equal '1.000', Format[Rounding[precision: 10]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', Format[Rounding[places: 5]].write(Flt::DecNum('1.00'))

    assert_equal '1.000', Format[Rounding[precision: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', Format[Rounding[precision: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', Format[Rounding[precision: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', Format[Rounding[places: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', Format[Rounding[places: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', Format[Rounding[places: 1]].write(Flt::DecNum('1.00'))


    assert_equal '1.000000000', Format[Rounding[precision: 10], exact_input: true].write(Flt::DecNum('1.00'))
    assert_equal '1.00000', Format[Rounding[places: 5], exact_input: true].write(Flt::DecNum('1.00'))

    assert_equal '1.000', Format[Rounding[precision: 4], exact_input: true].write(Flt::DecNum('1.00'))
    assert_equal '1.00', Format[Rounding[precision: 3], exact_input: true].write(Flt::DecNum('1.00'))
    assert_equal '1.0', Format[Rounding[precision: 2], exact_input: true].write(Flt::DecNum('1.00'))
    assert_equal '1.000', Format[Rounding[places: 3], exact_input: true].write(Flt::DecNum('1.00'))
    assert_equal '1.00', Format[Rounding[places: 2], exact_input: true].write(Flt::DecNum('1.00'))
    assert_equal '1.0', Format[Rounding[places: 1], exact_input: true].write(Flt::DecNum('1.00'))


    assert_equal '1.00', Format[Rounding[precision: 3], exact_input: true].write(Flt::DecNum('1.0'))
    assert_equal '1.000', Format[Rounding[places: 3], exact_input: true].write(Flt::DecNum('1.0'))

    assert_equal '1234567.1234', Format[rounding: :simplify].write(Flt::DecNum('1234567.1234'))

    assert_equal '1234567.123', Format[Rounding[places: 3]].write(Flt::DecNum('1234567.1234'))
    grouping = Format::Symbols[grouping: [3]]
    assert_equal '1,234,567.123', Format[Rounding[places: 3], grouping].write(Flt::DecNum('1234567.1234'))
  end


  def test_write_binnum_dec
    context = Flt::BinNum::IEEEDoubleContext
    x = Flt::BinNum('1.0', :fixed, context: context)
    assert_equal '1', Format[rounding: :simplify].write(x)
    assert_equal '1', Format[].write(x)
    assert_equal '1.00', Format[Rounding[precision: 3]].write(x)
    assert_equal '1.000', Format[Rounding[places: 3]].write(x)
    x = Flt::BinNum('1234567.1234', :fixed, context: context)
    assert_equal '1234567.1234', Format[rounding: :simplify].write(x)
    assert_equal '1234567.123', Format[Rounding[places: 3]].write(x)
    grouping = Format::Symbols[grouping: [3]]
    assert_equal '1,234,567.123', Format[Rounding[places: 3], grouping].write(x)

    x = Flt::BinNum('0.1', :fixed, context: context)
    assert_equal '0.1', Format[].write(x)
    assert_equal '0.1', Format[rounding: :simplify].write(x)
    assert_equal '0.100', Format[Rounding[precision: 3]].write(x)
    assert_equal '0.1000000000000000', Format[Rounding[precision: 16]].write(x)
    assert_equal '0.10000000000000001', Format[Rounding[precision: 17]].write(x)
    assert_equal '0.10000000000000001', Format[Rounding[precision: 18]].write(x)

    assert_equal '0.1000000000000000055511151231257827021181583404541015625',
                 Format[Rounding[:exact], exact_input: true].write(x)

    assert_equal '0.1000000000000000055511151231257827021181583404541015625',
                 Format[Rounding[:preserve], exact_input: true].write(x)

    assert_equal '0.100000000000000005551115123125782702118158340454101562500000',
                 Format[Rounding[precision:60], exact_input: true].write(x)

    assert_equal '0.100000000000000005551115123125782702118158340454101562',
                 Format[Rounding[precision:54], exact_input: true].write(x)
    assert_equal '0.100000000000000005551115123125782702118158340454101563',
                 Format[Rounding[:half_up, precision:54], exact_input: true].write(x)
    assert_equal '0.100000000000000006', Format[Rounding[precision:18], exact_input: true].write(x)
    assert_equal '0.10000000000000001', Format[Rounding[precision:17], exact_input: true].write(x)
    assert_equal '0.1000000000000000', Format[Rounding[precision:16], exact_input: true].write(x)
    assert_equal '0.100', Format[Rounding[precision: 3], exact_input: true].write(x)
  end


  def test_write_decnum_bin
    sym = Format::Symbols[repeat_delimited: true]
    assert_equal '0.0<0011>', Format[sym, exact_input: true, base: 2].write(Flt::DecNum('0.1'))
  end


  def test_write_rational_dec
    assert_equal '0.333...', Format[].write(Rational(1,3))
    sym = Format::Symbols[repeat_delimited: true]
    assert_equal '0.<3>', Format[sym].write(Rational(1,3))
    assert_equal '0.0<0011>', Format[sym, base: 2].write(Rational(1,10))
  end


  def test_write_float_bin
    x = 0.1
    assert_equal '0.0001100110011001100110011001100110011001100110011001101',
                  Format[base: 2].write(x)

    assert_equal '0.00011001100110011001100110011001100110011001100110011010',
                  Format[base: 2, rounding: :preserve].write(x)

  end

  def test_write_binnum_bin
    context = Flt::BinNum::IEEEDoubleContext
    x = Flt::BinNum('0.1', :fixed, context: context)
    assert_equal '0.0001100110011001100110011001100110011001100110011001101',
                  Format[base: 2].write(x)

    assert_equal '0.00011001100110011001100110011001100110011001100110011010',
                  Format[base: 2, rounding: :preserve].write(x)

  end


  def test_write_binnum_hex
    context = Flt::BinNum::IEEEDoubleContext
    x = Flt::BinNum('0.1', :fixed, context: context)
    assert_equal "1.999999999999Ap-4", Format[:hexbin].write(x)
  end



  def test_write_to_file
    file = Tempfile.new('numerals')
    Format[Rounding[places: 3]].write(1.0, output: file)
    file.close
    assert_equal '1.000', File.read(file.path)
    file.unlink
  end

end
