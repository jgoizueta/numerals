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

    unless Float::RADIX == 2 && Float::MANT_DIG == 53
      skip "Non IEEE Float unsupported for some tests"
      return
    end

    assert_equal '0', Format[rounding: :exact].write(0.0)
    assert_equal '0', Format[rounding: :simplify].write(0.0)
    assert_equal '0e-17', Format[rounding: :preserve].write(0.0)

    assert_equal '0.10000000000000001', Format[rounding: :preserve].write(0.1)
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

    fmt = Format[:exact_input]
    assert_equal "64.099999999999994315658113919198513031005859375", fmt.write(64.1)
    assert_equal '0.5', fmt.write(0.5)
    assert_equal "0.333333333333333314829616256247390992939472198486328125", fmt.write(1.0/3.0)
    assert_equal "0.66666666666666662965923251249478198587894439697265625", fmt.write(2.0/3.0)
    assert_equal "-0.333333333333333314829616256247390992939472198486328125", fmt.write(-1.0/3.0)
    assert_equal "-0.66666666666666662965923251249478198587894439697265625", fmt.write(-2.0/3.0)
    assert_equal "1267650600228229401496703205376",  fmt.write(2.0**100)
    assert_equal "0.10000000000000001942890293094023945741355419158935546875", fmt.write(Float.context.next_plus(0.1))
    assert_equal "1023.9999999999998863131622783839702606201171875", fmt.write(Float.context.next_minus(1024))

    assert_equal "2.225073858507201383090232717332404064219215980462331830553327416887204434813918195854283159012511020564067339731035811005152434161553460108856012385377718821130777993532002330479610147442583636071921565046942503734208375250806650616658158948720491179968591639648500635908770118304874799780887753749949451580451605050915399856582470818645113537935804992115981085766051992433352114352390148795699609591288891602992641511063466313393663477586513029371762047325631781485664350872122828637642044846811407613911477062801689853244110024161447421618567166150540154285084716752901903161322778896729707373123334086988983175067838846926092773977972858659654941091369095406136467568702398678315290680984617210924625396728515625e-308",
                 fmt.write(Float.context.minimum_normal)
    assert_equal "2.2250738585072008890245868760858598876504231122409594654935248025624400092282356951787758888037591552642309780950434312085877387158357291821993020294379224223559819827501242041788969571311791082261043971979604000454897391938079198936081525613113376149842043271751033627391549782731594143828136275113838604094249464942286316695429105080201815926642134996606517803095075913058719846423906068637102005108723282784678843631944515866135041223479014792369585208321597621066375401613736583044193603714778355306682834535634005074073040135602968046375918583163124224521599262546494300836851861719422417646455137135420132217031370496583210154654068035397417906022589503023501937519773030945763173210852507299305089761582519159720757232455434770912461317493580281734466552734375e-308",
                 fmt.write(Float.context.maximum_subnormal)
    assert_equal "2.225073858507200394958941034839315711081630244019587100433722188237675583642553194503268618595007289964394616459051051412023043270117998255542591673498126023581185971968246077878183766819774580380287229348978296356771103136809189170558146173902184049999817014701706089569539838241444028984739501272818269238398287937541863482503350197395249647392622007205322474852963190178391854932391064931720791430455764953943127215325436859833344767109289929102154994338687742727610729450624487971196675896144263447425089844325111161570498002959146187656616550482084690619235135756396957006047593447154776156167693340095043268338435252390549256952840748419828640113148805198563919935252207510837343961185884248936392555587988206944151446491086954182492263498716056346893310546875e-308",
                 fmt.write(Float.context.next_minus(Float.context.maximum_subnormal))
    assert_equal "9.88131291682493088353137585736442744730119605228649528851171365001351014540417503730599672723271984759593129390891435461853313420711879592797549592021563756252601426380622809055691634335697964207377437272113997461446100012774818307129968774624946794546339230280063430770796148252477131182342053317113373536374079120621249863890543182984910658610913088802254960259419999083863978818160833126649049514295738029453560318710477223100269607052986944038758053621421498340666445368950667144166486387218476578691673612021202301233961950615668455463665849580996504946155275185449574931216955640746893939906729403594535543517025132110239826300978220290207572547633450191167477946719798732961988232841140527418055848553508913045817507736501283943653106689453125e-324",
                 fmt.write(Float.context.next_plus(Float.context.minimum_nonzero))
    assert_equal "4.940656458412465441765687928682213723650598026143247644255856825006755072702087518652998363616359923797965646954457177309266567103559397963987747960107818781263007131903114045278458171678489821036887186360569987307230500063874091535649843873124733972731696151400317153853980741262385655911710266585566867681870395603106249319452715914924553293054565444011274801297099995419319894090804165633245247571478690147267801593552386115501348035264934720193790268107107491703332226844753335720832431936092382893458368060106011506169809753078342277318329247904982524730776375927247874656084778203734469699533647017972677717585125660551199131504891101451037862738167250955837389733598993664809941164205702637090279242767544565229087538682506419718265533447265625e-324",
                 fmt.write(Float.context.minimum_nonzero)

  end

  def test_write_decnum_dec
    assert_equal '1', Format[rounding: :simplify].write(Flt::DecNum('1.0'))
    assert_equal '1.0', Format[rounding: :preserve].write(Flt::DecNum('1.0'))
    assert_equal '1', Format[].write(Flt::DecNum('1.0'))

    assert_equal '1', Format[rounding: :simplify].write(Flt::DecNum('1.00'))
    assert_equal '1.00', Format[rounding: :preserve].write(Flt::DecNum('1.00'))
    assert_equal '1', Format[].write(Flt::DecNum('1.00'))

    # Note that insignificant digits are not shown by default
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

    assert_equal '0', Format[rounding: :exact].write(Flt::DecNum('0'))
    assert_equal '0', Format[rounding: :exact].write(Flt::DecNum('0.0'))
    assert_equal '0', Format[rounding: :exact].write(Flt::DecNum('0.0000'))
    assert_equal '0', Format[rounding: :exact].write(Flt::DecNum('0E-15'))

    assert_equal '0', Format[rounding: :simplify].write(Flt::DecNum('0'))
    assert_equal '0', Format[rounding: :simplify].write(Flt::DecNum('0.0'))
    assert_equal '0', Format[rounding: :simplify].write(Flt::DecNum('0.0000'))
    assert_equal '0', Format[rounding: :simplify].write(Flt::DecNum('0E-15'))

    assert_equal '0', Format[rounding: :preserve].write(Flt::DecNum('0'))
    assert_equal '0.0', Format[rounding: :preserve].write(Flt::DecNum('0.0'))
    assert_equal '0.0000', Format[rounding: :preserve].write(Flt::DecNum('0.0000'))
    assert_equal '0e-15', Format[rounding: :preserve].write(Flt::DecNum('0E-15'))
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

    unless Float::RADIX == 2 && Float::MANT_DIG == 53
      skip "Non IEEE Float unsupported for some tests"
      return
    end

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

  def test_modes
    f = Format[mode: [:general, max_leading: 3, max_trailing: 0], symbols: [uppercase: true]]
    assert_equal '123.45', f.write(Flt::DecNum('123.45'))
    assert_equal '0.00012345', f.write(Flt::DecNum('0.00012345'))
    assert_equal '1.2345E-5', f.write(Flt::DecNum('0.000012345'))
    assert_equal '1.2345E-6', f.write(Flt::DecNum('0.0000012345'))
    assert_equal '1234.5', f.write(Flt::DecNum('1234.5'))
    assert_equal '12345', f.write(Flt::DecNum('12345.0'))
    assert_equal '1.2345E5', f.write(Flt::DecNum('12345E1'))
    assert_equal '1.2345E6', f.write(Flt::DecNum('12345E2'))

    f = Format[mode: [:scientific, max_leading: 3, max_trailing: 0], symbols: [uppercase: true]]
    assert_equal '1.2345E2', f.write(Flt::DecNum('123.45'))
    assert_equal '1.2345E-4', f.write(Flt::DecNum('0.00012345'))
    assert_equal '1.2345E-5', f.write(Flt::DecNum('0.000012345'))
    assert_equal '1.2345E-6', f.write(Flt::DecNum('0.0000012345'))
    assert_equal '1.2345E3', f.write(Flt::DecNum('1234.5'))
    assert_equal '1.2345E4', f.write(Flt::DecNum('12345.0'))
    assert_equal '1.2345E5', f.write(Flt::DecNum('12345E1'))
    assert_equal '1.2345E6', f.write(Flt::DecNum('12345E2'))

    f = Format[mode: [:fixed, max_leading: 3, max_trailing: 0], symbols: [uppercase: true]]
    assert_equal '123.45', f.write(Flt::DecNum('123.45'))
    assert_equal '0.00012345', f.write(Flt::DecNum('0.00012345'))
    assert_equal '0.000012345', f.write(Flt::DecNum('0.000012345'))
    assert_equal '0.0000012345', f.write(Flt::DecNum('0.0000012345'))
    assert_equal '1234.5', f.write(Flt::DecNum('1234.5'))
    assert_equal '12345', f.write(Flt::DecNum('12345.0'))
    assert_equal '123450', f.write(Flt::DecNum('12345E1'))
    assert_equal '1234500', f.write(Flt::DecNum('12345E2'))

    f = Format[mode: :engineering, symbols: [uppercase: true]]
    assert_equal '123.45E0', f.write(Flt::DecNum('123.45'))
    assert_equal '123.45E-6', f.write(Flt::DecNum('0.00012345'))
    assert_equal '12.345E-6', f.write(Flt::DecNum('0.000012345'))
    assert_equal '1.2345E-6', f.write(Flt::DecNum('0.0000012345'))
    assert_equal '1.2345E3', f.write(Flt::DecNum('1234.5'))
    assert_equal '12.345E3', f.write(Flt::DecNum('12345.0'))
    assert_equal '123.45E3', f.write(Flt::DecNum('12345E1'))
    assert_equal '1.2345E6', f.write(Flt::DecNum('12345E2'))
  end

  def test_insignificant_fractional
    fmt = Format[symbols: [insignificant_digit: '?']]

    assert_equal '1.000??????', fmt[Rounding[precision: 10]].write(Flt::DecNum('1.00'))
    assert_equal '1.000??', fmt[Rounding[places: 5]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[precision: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[precision: 3]].write(Flt::DecNum('1.00'))

    assert_equal '1.000??', fmt[Rounding[places: 5]].write(Flt::DecNum('1.00'))
    assert_equal '1.000?', fmt[Rounding[places: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[places: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[places: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', fmt[Rounding[places: 1]].write(Flt::DecNum('1.00'))

    assert_equal '1.000?', fmt[Rounding[precision: 5]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[precision: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[precision: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', fmt[Rounding[precision: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[places: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[places: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', fmt[Rounding[places: 1]].write(Flt::DecNum('1.00'))

    fmt = Format[symbols: [insignificant_digit: 0]]

    assert_equal '1.000000000', fmt[Rounding[precision: 10]].write(Flt::DecNum('1.00'))
    assert_equal '1.00000', fmt[Rounding[places: 5]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[precision: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[precision: 3]].write(Flt::DecNum('1.00'))

    assert_equal '1.00000', fmt[Rounding[places: 5]].write(Flt::DecNum('1.00'))
    assert_equal '1.0000', fmt[Rounding[places: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[places: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[places: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', fmt[Rounding[places: 1]].write(Flt::DecNum('1.00'))

    assert_equal '1.0000', fmt[Rounding[precision: 5]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[precision: 4]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[precision: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', fmt[Rounding[precision: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.000', fmt[Rounding[places: 3]].write(Flt::DecNum('1.00'))
    assert_equal '1.00', fmt[Rounding[places: 2]].write(Flt::DecNum('1.00'))
    assert_equal '1.0', fmt[Rounding[places: 1]].write(Flt::DecNum('1.00'))

    fmt = Format[symbols: [insignificant_digit: '?']]
    context = Flt::BinNum::IEEEDoubleContext
    x = Flt::BinNum('0.1', :fixed, context: context)
    assert_equal '0.100000000000000', fmt[rounding: [precision: 15]].write(x)
    assert_equal '0.1000000000000000', fmt[rounding: [precision: 16]].write(x)
    assert_equal '0.10000000000000001', fmt[rounding: [precision: 17]].write(x)
    assert_equal '0.10000000000000001?', fmt[rounding: [precision: 18]].write(x)
    assert_equal '0.10000000000000001??', fmt[rounding: [precision: 19]].write(x)
    assert_equal '0.10000000000000001???', fmt[rounding: [precision: 20]].write(x)

    fmt = fmt[exact_input: true]
    assert_equal '0.100000000000000', fmt[rounding: [precision: 15]].write(x)
    assert_equal '0.1000000000000000', fmt[rounding: [precision: 16]].write(x)
    assert_equal '0.10000000000000001', fmt[rounding: [precision: 17]].write(x)
    assert_equal '0.100000000000000006', fmt[rounding: [precision: 18]].write(x)
    assert_equal '0.1000000000000000056', fmt[rounding: [precision: 19]].write(x)
    assert_equal '0.10000000000000000555', fmt[rounding: [precision: 20]].write(x)
  end

  def test_insignificant_integral
    fmt = Format[mode: :fixed]
    x = Flt::DecNum('1234E5')
    assert_equal '123400000', fmt[rounding: [precision: 7]].write(x)
    assert_equal '123400000', fmt[rounding: [precision: 15]].write(x)
    fmt = fmt[symbols: [insignificant_digit: '?']]
    assert_equal '12340????.??????', fmt[rounding: [precision: 15]].write(x)
    assert_equal '12340????', fmt[rounding: [precision: 7]].write(x)
    fmt = fmt[symbols: [grouping: [3]]]
    assert_equal '123,40?,???.??????', fmt[rounding: [precision: 15]].write(x)
  end

  def test_basic_fmt
    fmt = Format[]
    assert_equal "0", fmt.write(0.0)
    assert_equal "0", fmt.write(0)
    assert_equal "0", fmt.write(BigDecimal('0'))
    assert_equal "0", fmt.write(Rational(0,1))

    assert_equal "123456789", fmt.write(123456789.0)
    assert_equal "123456789", fmt.write(123456789)
    assert_equal "123456789", fmt.write(BigDecimal('123456789'))
    assert_equal "123456789", fmt.write(Rational(123456789,1))
    assert_equal "123456789.25", fmt.write(123456789.25)
    assert_equal "123456789.25", fmt.write(BigDecimal('123456789.25'))
    assert_equal "123456789.25", fmt.write((Rational(123456789)+Rational(1,4)))
  end

  def test_optional_mode_prec_parameters
    x = 0.1
    fmt = Format[]
    assert_equal '0.1000000000', fmt[rounding: [precision: 10]].write(x)
    assert_equal '1.000000000e-1', fmt[rounding: [precision: 10], mode: :scientific].write(x)
    assert_equal '0.1', fmt[rounding: :simpliry] .write(x)
    assert_equal '0.10000', fmt[rounding: [precision: 5]].write(x)
    assert_equal '1.0000e-1', fmt[rounding: [precision: 5], mode: :scientific].write(x)
  end


end