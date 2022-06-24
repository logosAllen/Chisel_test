circuit FIFO_CLK_wraper :
  module FIFO_test :
    input clock : Clock
    input reset : Reset
    output io : { flip w_clk : Clock, flip w_data : UInt<8>, flip w_valid : UInt<1>, w_full : UInt<1>, r_data : UInt<8>, flip r_req : UInt<1>, r_empty : UInt<1>}

    reg w_addr : UInt<5>, io.w_clk with :
      reset => (reset, UInt<5>("h0")) @[fifo.scala 106:43]
    reg r_addr : UInt<5>, clock with :
      reset => (reset, UInt<5>("h0")) @[fifo.scala 107:23]
    cmem buffer : UInt<8> [16] @[fifo.scala 108:19]
    reg reg_r_data : UInt<8>, clock with :
      reset => (UInt<1>("h0"), reg_r_data) @[fifo.scala 109:23]
    wire reg_o_rempty : UInt<1> @[fifo.scala 111:26]
    wire reg_o_wfull : UInt<1> @[fifo.scala 112:25]
    node _reg_o_rempty_T = eq(w_addr, r_addr) @[fifo.scala 114:25]
    reg_o_rempty <= _reg_o_rempty_T @[fifo.scala 114:16]
    node _reg_o_wfull_T = bits(w_addr, 4, 4) @[fifo.scala 115:25]
    node _reg_o_wfull_T_1 = bits(r_addr, 4, 4) @[fifo.scala 115:51]
    node _reg_o_wfull_T_2 = neq(_reg_o_wfull_T, _reg_o_wfull_T_1) @[fifo.scala 115:41]
    node _reg_o_wfull_T_3 = bits(w_addr, 3, 0) @[fifo.scala 115:78]
    node _reg_o_wfull_T_4 = bits(r_addr, 3, 0) @[fifo.scala 115:108]
    node _reg_o_wfull_T_5 = eq(_reg_o_wfull_T_3, _reg_o_wfull_T_4) @[fifo.scala 115:98]
    node _reg_o_wfull_T_6 = and(_reg_o_wfull_T_2, _reg_o_wfull_T_5) @[fifo.scala 115:68]
    reg_o_wfull <= _reg_o_wfull_T_6 @[fifo.scala 115:15]
    node _T = eq(reg_o_wfull, UInt<1>("h0")) @[fifo.scala 118:24]
    node _T_1 = and(io.w_valid, _T) @[fifo.scala 118:21]
    when _T_1 : @[fifo.scala 118:37]
      node _T_2 = bits(w_addr, 3, 0) @[fifo.scala 119:20]
      infer mport MPORT = buffer[_T_2], io.w_clk @[fifo.scala 119:13]
      MPORT <= io.w_data @[fifo.scala 119:41]
      node _w_addr_T = add(w_addr, UInt<1>("h1")) @[fifo.scala 120:24]
      node _w_addr_T_1 = tail(_w_addr_T, 1) @[fifo.scala 120:24]
      w_addr <= _w_addr_T_1 @[fifo.scala 120:14]
    node _T_3 = eq(reg_o_rempty, UInt<1>("h0")) @[fifo.scala 125:20]
    node _T_4 = and(io.r_req, _T_3) @[fifo.scala 125:17]
    when _T_4 : @[fifo.scala 125:34]
      node _r_addr_T = add(r_addr, UInt<1>("h1")) @[fifo.scala 126:22]
      node _r_addr_T_1 = tail(_r_addr_T, 1) @[fifo.scala 126:22]
      r_addr <= _r_addr_T_1 @[fifo.scala 126:12]
    node _reg_r_data_T = bits(r_addr, 3, 0) @[fifo.scala 129:30]
    infer mport reg_r_data_MPORT = buffer[_reg_r_data_T], clock @[fifo.scala 129:23]
    reg_r_data <= reg_r_data_MPORT @[fifo.scala 129:14]
    io.w_full <= reg_o_wfull @[fifo.scala 131:13]
    io.r_empty <= reg_o_rempty @[fifo.scala 132:14]
    io.r_data <= reg_r_data @[fifo.scala 133:13]

  module FIFO_CLK_wraper :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip w_clk : UInt<1>, flip w_data : UInt<8>, flip w_valid : UInt<1>, w_full : UInt<1>, r_data : UInt<8>, flip r_req : UInt<1>, r_empty : UInt<1>}

    node _T = asClock(io.w_clk) @[fifo.scala 152:33]
    inst fifo of FIFO_test @[fifo.scala 152:48]
    fifo.clock <= _T
    fifo.reset <= reset
    fifo.io.w_clk <= clock @[fifo.scala 154:17]
    fifo.io.w_data <= io.w_data @[fifo.scala 155:18]
    fifo.io.w_valid <= io.w_valid @[fifo.scala 156:19]
    fifo.io.r_req <= io.r_req @[fifo.scala 157:17]
    io.w_full <= fifo.io.w_full @[fifo.scala 159:13]
    io.r_data <= fifo.io.r_data @[fifo.scala 160:13]
    io.r_empty <= fifo.io.r_empty @[fifo.scala 161:14]

