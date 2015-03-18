require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))

require 'numerals/rounding'
include Numerals

class TestFormatMode <  Test::Unit::TestCase # < Minitest::Test

  def test_format_mode_constructor
    mode = Format::Mode[:scientific]
    assert mode.scientific?
    refute mode.engineering?
    refute mode.fixed?
    refute mode.general?
    assert_equal :scientific, mode.mode
    assert_equal 1, mode.sci_int_digits
    assert_equal 1, mode.base_scale
    assert_equal Format::Mode[:scientific], Format::Mode[:sci]
    assert_equal Format::Mode[:scientific, sci_int_digits: 2], Format::Mode[:sci, sci_int_digits: 2]
    assert_equal Format::Mode[:scientific, sci_int_digits: :engineering], Format::Mode[:sci, sci_int_digits: :engineering]
    assert_equal Format::Mode[:scientific, sci_int_digits: :eng], Format::Mode[:sci, sci_int_digits: :eng]

    mode = Format::Mode[:scientific, sci_int_digits: 0]
    assert mode.scientific?
    refute mode.engineering?
    refute mode.fixed?
    refute mode.general?
    assert_equal :scientific, mode.mode
    assert_equal 0, mode.sci_int_digits
    assert_equal 1, mode.base_scale

    mode = Format::Mode[:scientific, base_scale: 4]
    assert mode.scientific?
    refute mode.engineering?
    refute mode.fixed?
    refute mode.general?
    assert_equal :scientific, mode.mode
    assert_equal 1, mode.sci_int_digits
    assert_equal 4, mode.base_scale

    mode = Format::Mode[:engineering]
    assert mode.engineering?
    assert mode.scientific?
    refute mode.fixed?
    refute mode.general?
    assert_equal :engineering, mode.sci_int_digits
    assert_equal :scientific, mode.mode
    assert_equal 1, mode.base_scale
    assert_equal Format::Mode[:engineering], Format::Mode[:eng]
    assert_equal Format::Mode[:engineering], Format::Mode[:scientific, sci_int_digits: :engineering]
    assert_equal Format::Mode[:engineering], Format::Mode[:scientific, sci_int_digits: :eng]

    mode = Format::Mode[:fixed]
    refute mode.scientific?
    refute mode.engineering?
    assert mode.fixed?
    refute mode.general?
    assert_equal :fixed, mode.mode
    assert_equal 1, mode.base_scale
    assert_equal Format::Mode[:fixed], Format::Mode[:fix]
    assert_equal Format::Mode[:fixed, base_scale: 4], Format::Mode[:fix, base_scale: 4]

    mode = Format::Mode[:general]
    refute mode.scientific?
    refute mode.engineering?
    refute mode.fixed?
    assert mode.general?
    assert_equal :general, mode.mode
    assert_equal 1, mode.sci_int_digits
    assert_equal Format::Mode::DEFAULTS[:max_leading], mode.max_leading
    assert_equal Format::Mode::DEFAULTS[:max_trailing], mode.max_trailing
    assert_equal 1, mode.base_scale
    assert_equal Format::Mode[:general], Format::Mode[]
    assert_equal Format::Mode[:general], Format::Mode[:gen]
    assert_equal Format::Mode[:general, sci_int_digits: 0], Format::Mode[:gen, sci_int_digits: 0]
    assert_equal Format::Mode[:general, sci_int_digits: :engineering], Format::Mode[:gen, sci_int_digits: :engineering]
    assert_equal Format::Mode[:general, sci_int_digits: :eng], Format::Mode[:gen, sci_int_digits: :eng]

    mode = Format::Mode[:general, max_leading: 8, max_trailing: 2, base_scale: 2, sci_int_digits: 0]
    refute mode.scientific?
    refute mode.engineering?
    refute mode.fixed?
    assert mode.general?
    assert_equal :general, mode.mode
    assert_equal 0, mode.sci_int_digits
    assert_equal 8, mode.max_leading
    assert_equal 2, mode.max_trailing
    assert_equal 2, mode.base_scale
  end

  def test_copy
    m1 = Format::Mode[:fixed]
    m2 = Format::Mode[m1]
    assert_equal :fixed, m2.mode
    m2.mode = :scientific
    assert_equal :fixed, m1.mode
    assert_equal :scientific, m2.mode

    m2 = m1[:scientific]
    assert_equal :fixed, m1.mode
    assert_equal :scientific, m2.mode

    m1 = Format::Mode[:scientific, sci_int_digits: 0]
    m2 = m1[sci_int_digits: 2]
    assert_equal 0, m1.sci_int_digits
    assert_equal 2, m2.sci_int_digits
    assert_equal :scientific, m1.mode
    assert_equal :scientific, m2.mode

    m1 = Format::Mode[:scientific, sci_int_digits: 0]
    m2 = m1.set(sci_int_digits: 2)
    assert_equal 0, m1.sci_int_digits
    assert_equal 2, m2.sci_int_digits
    assert_equal :scientific, m1.mode
    assert_equal :scientific, m2.mode
  end

  def test_mutators
    m1 = Format::Mode[:fixed]
    m2 = m1.set!(:scientific)
    assert_equal :scientific, m1.mode
    assert_equal :scientific, m2.mode
    assert_equal m1.object_id, m2.object_id
  end
end
