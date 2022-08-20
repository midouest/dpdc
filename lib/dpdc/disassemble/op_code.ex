defmodule DPDC.Disassemble.OpCode do
  alias DPDC.Disassemble

  @op_codes [
    :move,
    :loadi,
    :loadf,
    :loadk,
    :loadkx,
    :loadbool,
    :loadnil,
    :getupval,
    :setupval,
    :gettabup,
    :gettable,
    :geti,
    :getfield,
    :settabup,
    :settable,
    :seti,
    :setfield,
    :newtable,
    :self,
    :addi,
    :addk,
    :subk,
    :mulk,
    :modk,
    :powk,
    :divk,
    :idivk,
    :bandk,
    :bork,
    :bxork,
    :shri,
    :shli,
    :add,
    :sub,
    :mul,
    :mod,
    :pow,
    :div,
    :idiv,
    :band,
    :bor,
    :bxor,
    :shl,
    :shr,
    :mmbin,
    :mmbini,
    :mmbink,
    :unm,
    :bnot,
    :not,
    :len,
    :concat,
    :close,
    :tbc,
    :jmp,
    :eq,
    :lt,
    :le,
    :eqk,
    :eqi,
    :lti,
    :lei,
    :gti,
    :gei,
    :test,
    :testset,
    :call,
    :tailcall,
    :return,
    :return0,
    :return1,
    :forloop,
    :forprep,
    :tforprep,
    :tforcall,
    :tforloop,
    :setlist,
    :closure,
    :vararg,
    :varargprep,
    :extraarg
  ]

  @op_modes %{
    move: :abc,
    loadi: :asbx,
    loadf: :asbx,
    loadk: :abx,
    loadkx: :abx,
    loadbool: :abc,
    loadnil: :abc,
    getupval: :abc,
    setupval: :abc,
    gettabup: :abc,
    gettable: :abc,
    geti: :abc,
    getfield: :abc,
    settabup: :abc,
    settable: :abc,
    seti: :abc,
    setfield: :abc,
    newtable: :abc,
    self: :abc,
    addi: :abc,
    addk: :abc,
    subk: :abc,
    mulk: :abc,
    modk: :abc,
    powk: :abc,
    divk: :abc,
    idivk: :abc,
    bandk: :abc,
    bork: :abc,
    bxork: :abc,
    shri: :abc,
    shli: :abc,
    add: :abc,
    sub: :abc,
    mul: :abc,
    mod: :abc,
    pow: :abc,
    div: :abc,
    idiv: :abc,
    band: :abc,
    bor: :abc,
    bxor: :abc,
    shl: :abc,
    shr: :abc,
    mmbin: :abc,
    mmbini: :abc,
    mmbink: :abc,
    unm: :abc,
    bnot: :abc,
    not: :abc,
    len: :abc,
    concat: :abc,
    close: :abc,
    tbc: :abc,
    jmp: :sj,
    eq: :abc,
    lt: :abc,
    le: :abc,
    eqk: :abc,
    eqi: :abc,
    lti: :abc,
    lei: :abc,
    gti: :abc,
    gei: :abc,
    test: :abc,
    testset: :abc,
    call: :abc,
    tailcall: :abc,
    return: :abc,
    return0: :abc,
    return1: :abc,
    forloop: :abx,
    forprep: :abx,
    tforprep: :abx,
    tforcall: :abc,
    tforloop: :abx,
    setlist: :abc,
    closure: :abx,
    vararg: :abc,
    varargprep: :abc,
    extraarg: :ax
  }

  @mode_funs %{
    abc: &Disassemble.OpMode.load_abc/2,
    abx: &Disassemble.OpMode.load_abx/2,
    asbx: &Disassemble.OpMode.load_asbx/2,
    ax: &Disassemble.OpMode.load_ax/2,
    sj: &Disassemble.OpMode.load_sj/2
  }

  def op_codes, do: @op_codes

  def op_modes, do: @op_modes

  def mode_funs, do: @mode_funs
end
