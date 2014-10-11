require File.expand_path(File.join(File.dirname(__FILE__),'helper.rb'))
require 'test/unit'
include Numerals
require 'yaml'

class TestNumeral < Test::Unit::TestCase

  def setup

  end


    def test_basic_numeral
      r = Numeral.new
      assert_equal "2.<3>", r.set_quotient(7,3).get_text(0)
      assert_equal [7, 3], r.set_quotient(7,3).get_quotient

      assert_equal "1.<3>", r.set_text("1.<3>").get_text(0)
      assert_equal [4, 3], r.set_text("1.<3>").get_quotient

      assert_equal "254.34212<678>", r.set_text("254.34212<678>").get_text(0)
      assert_equal [4234796411, 16650000], r.set_text("254.34212<678>").get_quotient

      assert_equal "254.34212<678>", r.set_text("254.34212678678...").get_text(0)
      assert_equal [4234796411, 16650000], r.set_text("254.34212678678...").get_quotient

      assert_equal "254.34212<678>", r.set_text("254.34212678678678678...").get_text(0)
      assert_equal [4234796411, 16650000], r.set_text("254.34212678678678678...").get_quotient

      assert_equal "0.<3>", r.set_text("0.3333333...").get_text(0)
      assert_equal [1, 3], r.set_text("0.3333333...").get_quotient

      assert_equal "-7.2<14>", r.set_text("-7.2141414...").get_text(0)
      assert_equal [-3571, 495], r.set_text("-7.2141414...").get_quotient

      assert_equal "-7.21414...", r.set_text("-7.2141414...").get_text(1)
      assert_equal [-3571, 495], r.set_text("-7.2141414...").get_quotient

      assert_equal "1.<234545>", r.set_text("1.234545234545...").get_text(0)
      assert_equal [1234544, 999999], r.set_text("1.234545234545...").get_quotient

      assert_equal "1.234545234545...", r.set_text("1.234545234545...").get_text(1)
      assert_equal [1234544, 999999], r.set_text("1.234545234545...").get_quotient

      assert_equal "1.23454523<45>", r.set_text("1.23454523454545...").get_text(0)
      assert_equal [678999879, 550000000], r.set_text("1.23454523454545...").get_quotient

      assert_equal "1.234545234545...", r.set_text("1.23454523454545...").get_text(1)
      assert_equal [678999879, 550000000], r.set_text("1.23454523454545...").get_quotient

      assert_equal "0.<9>", r.set_text(".<9>").get_text(0)
      assert_equal [1, 1], r.set_text(".<9>").get_quotient

      assert_equal "0.1<9>", r.set_text("0.1999999...",Numeral::DEF_OPT.dup.set_digits(DigitsDefinition.base(16))).get_text(0)
      assert_equal [1, 10], r.set_text("0.1999999...",Numeral::DEF_OPT.dup.set_digits(DigitsDefinition.base(16))).get_quotient

      r = Numeral.new

      assert_equal "Infinity", r.set_quotient(10,0).get_text(0)
      assert_equal [1, 0], r.set_quotient(10,0).get_quotient

      assert_equal "-Infinity", r.set_quotient(-10,0).get_text(0)
      assert_equal [-1, 0], r.set_quotient(-10,0).get_quotient

      assert_equal "NaN", r.set_quotient(0,0).get_text(0)
      assert_equal [0, 0], r.set_quotient(0,0).get_quotient

      assert_equal "NaN", r.set_text("NaN").get_text(0)
      assert_equal [0, 0], r.set_text("NaN").get_quotient

      assert_equal "Infinity", r.set_text("Infinity").get_text(0)
      assert_equal [1, 0], r.set_text("Infinity").get_quotient

      assert_equal "-Infinity", r.set_text("-Infinity").get_text(0)
      assert_equal [-1, 0], r.set_text("-Infinity").get_quotient

      assert_equal [1, 3], r.set_quotient(1, 3).get_quotient
      assert_equal [10, 3], r.set_quotient(10, 3).get_quotient
      assert_equal [100, 3], r.set_quotient(100, 3).get_quotient
      assert_equal [1000000000000, 3], r.set_quotient(1000000000000, 3).get_quotient
      assert_equal [1, 30], r.set_quotient(1, 30).get_quotient
      assert_equal [1, 300], r.set_quotient(1, 300).get_quotient
      assert_equal [1, 30000000000], r.set_quotient(1, 30000000000).get_quotient
      # TODO: set maximum_digits properly and test:
      # assert_equal [23, 34324241934923424], r.set_quotient(23, 34324241934923424).get_quotient
    end

end
