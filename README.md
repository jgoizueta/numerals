numerals
========

Number representation as text.

This will be a successor gem to Nio.

Roadmap
=======

Numeral handles (repeating) numerals in any base with bidirectional quotient conversion.

Numerical conversions (numbers to/from Numerals) are defined for numeric types like this:

    Numeral.conversion_to Float do |numeral|
      ...
    end
    Numeral.conversion_from Float do |number|
      ...
    end
    # It is to be determined in conversion parameters are needed (such as exact/inexact or even rounding or tolerances)

Conversions can be used like this:

    Numeral.convert_to(Float, numeral)
    Numeral.convert_from(number)
    Numeral.apply_conversion(number, type)
      cnovert_to(type, convert_from(number))

Rounding can be applied to Numerals (with rounding options)

Numerals can be written into text form using Formatting options

Numerals con be read from text form using Formatting options
