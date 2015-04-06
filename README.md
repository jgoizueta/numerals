Numerals
========

[![Gem Version](https://badge.fury.io/rb/numerals.svg)](http://badge.fury.io/rb/numerals)
[![Build Status](https://travis-ci.org/jgoizueta/numerals.svg)](https://travis-ci.org/jgoizueta/numerals)

The Numerals module provides formatted input/output for numeric types.

## Use

    require 'numerals'
    include Numerals

The Numeral class is used internally to hold the representation of a numeric
quantity as numeral in a positional system. Since repeating figures are
supported in Numeral, a Numeral can represent exactly any rational number.

Numerals can be exact or approximate. Exact numerals don't keep trailing zeros:
they don't specify a fixed precision. Repeating numerals are always exact.

Approximate numerals may have trailing zeros and have a determinate number
of significant digits. Approximate numerals cannot held repeating figures,
since they have limited precision.

The Conversions module provides conversions between Numerals and the
numeric types Integer, Rational, Float, Flt::Num and BigDecimal.

The Format class holds formatting settings. It can be constructed
with this bracket syntax:

    format = Format[mode: :general, rounding: [precision: 10]]

Which is a shortcut for:

    format = Format[mode: Format::Mode[:general], rounding: Rounding[precision: 10]]

And can also be expressed as:

    format = Format[Format::Mode[:general], Rounding[precision: 10]]
    puts format.rounding.precision                 # -> 10
    puts format.rounding.mode                      # -> half_even

New formats can be derived from an existing one by overriding some of
its properties using the brackets operator on it:

    format2 = format[rounding: :half_down]
    puts format2.rounding.precision                # -> 10
    puts format2.rounding.mode                     # -> half_down

## Output

Let's see how to use a Format to format a number into text form. By
default the shortest possible output (that preserves the value) is produced:

    puts Format[].write(0.1)                       # -> 0.1

This is because the default Rounding property of Format is Rounding[:short]
(rounding to :short precision), so the above is equivalent to:

    puts Format[:short].write(0.1)                 # -> 0.1
    puts Format[rounding: :short].write(0.1)       # -> 0.1

To produce a numeric representation that shows explicitly all the precision
of the number, the :free rounding precision can be used:

    puts Format[:free].write(0.1)                  # -> 0.10000000000000001

Specific precision can be obtained like this:

    puts Format[precision: 6].write(0.1)           # -> 0.100000

But this won't show digits that are insignificant (when the input number
is regarded as an approximation):

    puts Format[precision: 20].write(0.1)            # -> 0.10000000000000001
    puts Format[precision: 20].write(Rational(1,10)) # -> 0.10000000000000000000

Although a Float is considered an approximation by default (since
it cannot represent arbitrary precision exactly), we can
reinterpret it as an exact quantity with the :exact_input Format option:

    puts Format[:exact_input, precision: 20].write(0.1)
    # -> 0.10000000000000000555
    puts Format[:exact_input].write(0.1)
    # -> 0.1000000000000000055511151231257827021181583404541015625

Rationals are always 'exact' quantities, and they may require infinite
digits to be represented exactly in some output bases. This is handled
by repeating numerals, which can be represented as text in two modes:

    puts Format[].write(Rational(1,3))             # -> 0.333...
    puts Format[symbols: [repeat_delimited: true]].write(Rational(1,3))# -> 0.<3>

## Input

The same Format class can be used to read formatted text into numeric values
with the Format#read() method.

    puts Format[].read('1.0', type: Float)         # -> 1.0

For Flt types such as Flt::DecNum or Flt::BinNum there are a few options
to determine the result, since these types can hold arbitrary precision.

By default, these types are considered 'approximate'. Thus, the result
will be a variable-precision result based on the input. The default
Format, which has :short (simplifying) precision will produce a simple
result with as few significant digits as possible:

    puts Format[:short].read('1.000', type: Flt::DecNum) # -> 1
    puts Format[:short].read('0.100', type: Flt::BinNum) # -> 0.1

To retain the precision of the input text, the :free precision should be
used:

    puts Format[:free].read('1.000', type: Flt::DecNum) # -> 1.000
    puts Format[:free].read('0.100', type: Flt::BinNum) # -> 0.1

As an alternative, the precision implied by the text input can be ignored
and the result adjusted to the precision of the destination context. This
is done by regarding the input as 'exact'.

    puts Format[:exact_input].read('1.000', type: Flt::DecNum) # -> 1.000000000000000000000000000
    puts Format[:exact_input].read('0.100', type: Flt::BinNum) # -> 0.1
    Flt::DecNum.context.precision = 8
    puts Format[:exact_input].read('1.000', type: Flt::DecNum) # -> 1.0000000

If the input specifies repeating digits, then it is automatically regarded
exact and rounded according to the destination context:

    puts Format[:exact_input].read('0.333...', type: Flt::DecNum) # -> 0.33333333

Note that the repeating digits have been automatically detected. This
happens because the repeating suffix '...' has ben found (it is defined
by the Format::Symbols property of Format). An alternative way of
specifying repeating digits is by the repeating delimiters specified
in Symbols, which are <> by default:

    puts Format[:exact_input].read('0.<3>', type: Flt::DecNum)# -> 0.33333333


A Format can also be used to read a formatted number into a Numeral:

    puts Format[].read('1.25', type: Numeral)
    # -> Numeral[1, 2, 5, :sign=>1, :point=>1, :normalize=>:approximate, :base=>10]
    puts Format[].read('1.<3>', type: Numeral)
    # -> Numeral[1, 3, :sign=>1, :point=>1, :repeat=>1, :base=>10]

Other examples:

    puts Format[:free, base: 2].read('0.1', type: Flt::DecNum)# -> 0.5

## Shortcut notation

The `<<` and `>>` operators can be applied to Format objects
as a shortcut for formatted writing and reading:

    fmt = Format[]
    puts fmt << 0.1                                            # -> 0.1
    puts fmt << 0.1 << ' ' << 0.2 << ' ' << [places: 3] << 0.3 # -> 0.1 0.2 0.300
    puts fmt >> '0.1' >> Rational                              # -> 1/10

These operators can also be applied to Format, which is equivalent
to apply them to de default Format, `Format[]`:

    puts Format << [:sci, places: 4] <<  0.1                   # -> 1.000e-1
    puts Format >> '0.1' >> Rational                           # -> 1/10

Roadmap
=======

Done:

* Numeral handles (repeating) numerals in any base with bidirectional
  quotient conversion.

* Numerical conversions (numbers to/from Numerals)

* Rounding can be applied to Numerals (with rounding options)

* Numerals can be written into text form using Formatting options

* Numerals con be read from text form using Formatting options

* Handling of 'unsignificant' digits: show them either as special
  symbol, as zeros or omit them (comfigured in Symbols)

* Padding aspect of formatting on output

* Show base indicators on output

Pending:

* HTML & Latex Input/Output
