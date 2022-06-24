circuit FIFO :
  module FIFO :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip w_clk : UInt<1>, flip w_data : UInt<8>, flip w_valid : UInt<1>, w_full : UInt<1>, r_data : UInt<8>, flip r_req : UInt<1>, r_empty : UInt<1>}

    node _w_addr_T = asClock(io.w_clk) @[fifo.scala 50:35]
    reg w_addr : UInt<5>, _w_addr_T with :
      reset => (reset, UInt<5>("h0")) @[fifo.scala 50:51]
    reg r_addr : UInt<5>, clock with :
      reset => (reset, UInt<5>("h0")) @[fifo.scala 51:23]
    cmem buffer : UInt<8> [16] @[fifo.scala 52:19]
    reg reg_r_data : UInt<8>, clock with :
      reset => (UInt<1>("h0"), reg_r_data) @[fifo.scala 53:23]
    wire reg_o_rempty : UInt<1> @[fifo.scala 57:26]
    wire reg_o_wfull : UInt<1> @[fifo.scala 58:25]
    node _reg_o_rempty_T = eq(w_addr, r_addr) @[fifo.scala 60:25]
    reg_o_rempty <= _reg_o_rempty_T @[fifo.scala 60:16]
    node _reg_o_wfull_T = bits(w_addr, 4, 4) @[fifo.scala 61:25]
    node _reg_o_wfull_T_1 = bits(r_addr, 4, 4) @[fifo.scala 61:51]
    node _reg_o_wfull_T_2 = neq(_reg_o_wfull_T, _reg_o_wfull_T_1) @[fifo.scala 61:41]
    node _reg_o_wfull_T_3 = bits(w_addr, 3, 0) @[fifo.scala 61:78]
    node _reg_o_wfull_T_4 = bits(r_addr, 3, 0) @[fifo.scala 61:108]
    node _reg_o_wfull_T_5 = eq(_reg_o_wfull_T_3, _reg_o_wfull_T_4) @[fifo.scala 61:98]
    node _reg_o_wfull_T_6 = and(_reg_o_wfull_T_2, _reg_o_wfull_T_5) @[fifo.scala 61:68]
    reg_o_wfull <= _reg_o_wfull_T_6 @[fifo.scala 61:15]
    node _T = asClock(io.w_clk) @[fifo.scala 72:22]
    node _T_1 = eq(reg_o_wfull, UInt<1>("h0")) @[fifo.scala 73:24]
    node _T_2 = and(io.w_valid, _T_1) @[fifo.scala 73:21]
    when _T_2 : @[fifo.scala 73:37]
      node _T_3 = bits(w_addr, 3, 0) @[fifo.scala 74:20]
      infer mport MPORT = buffer[_T_3], _T @[fifo.scala 74:13]
      MPORT <= io.w_data @[fifo.scala 74:41]
      node _w_addr_T_1 = add(w_addr, UInt<1>("h1")) @[fifo.scala 75:24]
      node _w_addr_T_2 = tail(_w_addr_T_1, 1) @[fifo.scala 75:24]
      w_addr <= _w_addr_T_2 @[fifo.scala 75:14]
    node _T_4 = eq(reg_o_rempty, UInt<1>("h0")) @[fifo.scala 80:20]
    node _T_5 = and(io.r_req, _T_4) @[fifo.scala 80:17]
    when _T_5 : @[fifo.scala 80:34]
      node _r_addr_T = add(r_addr, UInt<1>("h1")) @[fifo.scala 81:22]
      node _r_addr_T_1 = tail(_r_addr_T, 1) @[fifo.scala 81:22]
      r_addr <= _r_addr_T_1 @[fifo.scala 81:12]
    node _reg_r_data_T = bits(r_addr, 3, 0) @[fifo.scala 84:30]
    infer mport reg_r_data_MPORT = buffer[_reg_r_data_T], clock @[fifo.scala 84:23]
    reg_r_data <= reg_r_data_MPORT @[fifo.scala 84:14]
    io.w_full <= reg_o_wfull @[fifo.scala 87:13]
    io.r_empty <= reg_o_rempty @[fifo.scala 88:14]
    io.r_data <= reg_r_data @[fifo.scala 89:13]

