module FIFO(
  input        clock,
  input        reset,
  input        io_w_clk,
  input  [7:0] io_w_data,
  input        io_w_valid,
  output       io_w_full,
  output [7:0] io_r_data,
  input        io_r_req,
  output       io_r_empty
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] buffer [0:15]; // @[fifo.scala 52:19]
  wire  buffer_reg_r_data_MPORT_en; // @[fifo.scala 52:19]
  wire [3:0] buffer_reg_r_data_MPORT_addr; // @[fifo.scala 52:19]
  wire [7:0] buffer_reg_r_data_MPORT_data; // @[fifo.scala 52:19]
  wire [7:0] buffer_MPORT_data; // @[fifo.scala 52:19]
  wire [3:0] buffer_MPORT_addr; // @[fifo.scala 52:19]
  wire  buffer_MPORT_mask; // @[fifo.scala 52:19]
  wire  buffer_MPORT_en; // @[fifo.scala 52:19]
  reg [4:0] w_addr; // @[fifo.scala 50:51]
  reg [4:0] r_addr; // @[fifo.scala 51:23]
  reg [7:0] reg_r_data; // @[fifo.scala 53:23]
  wire  reg_o_rempty = w_addr == r_addr; // @[fifo.scala 60:25]
  wire  reg_o_wfull = w_addr[4] != r_addr[4] & w_addr[3:0] == r_addr[3:0]; // @[fifo.scala 61:68]
  wire  _T_1 = ~reg_o_wfull; // @[fifo.scala 73:24]
  wire [4:0] _w_addr_T_2 = w_addr + 5'h1; // @[fifo.scala 75:24]
  wire [4:0] _r_addr_T_1 = r_addr + 5'h1; // @[fifo.scala 81:22]
  wire  _GEN_0 = io_w_clk;
  assign buffer_reg_r_data_MPORT_en = 1'h1;
  assign buffer_reg_r_data_MPORT_addr = r_addr[3:0];
  assign buffer_reg_r_data_MPORT_data = buffer[buffer_reg_r_data_MPORT_addr]; // @[fifo.scala 52:19]
  assign buffer_MPORT_data = io_w_data;
  assign buffer_MPORT_addr = w_addr[3:0];
  assign buffer_MPORT_mask = 1'h1;
  assign buffer_MPORT_en = io_w_valid & _T_1;
  assign io_w_full = w_addr[4] != r_addr[4] & w_addr[3:0] == r_addr[3:0]; // @[fifo.scala 61:68]
  assign io_r_data = reg_r_data; // @[fifo.scala 89:13]
  assign io_r_empty = w_addr == r_addr; // @[fifo.scala 60:25]
  always @(posedge _GEN_0) begin
    if (buffer_MPORT_en & buffer_MPORT_mask) begin
      buffer[buffer_MPORT_addr] <= buffer_MPORT_data; // @[fifo.scala 52:19]
    end
  end
  always @(posedge io_w_clk) begin
    if (reset) begin // @[fifo.scala 50:51]
      w_addr <= 5'h0; // @[fifo.scala 50:51]
    end else if (io_w_valid & ~reg_o_wfull) begin // @[fifo.scala 73:37]
      w_addr <= _w_addr_T_2; // @[fifo.scala 75:14]
    end
  end
  always @(posedge clock) begin
    if (reset) begin // @[fifo.scala 51:23]
      r_addr <= 5'h0; // @[fifo.scala 51:23]
    end else if (io_r_req & ~reg_o_rempty) begin // @[fifo.scala 80:34]
      r_addr <= _r_addr_T_1; // @[fifo.scala 81:12]
    end
    reg_r_data <= buffer_reg_r_data_MPORT_data; // @[fifo.scala 84:14]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    buffer[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  w_addr = _RAND_1[4:0];
  _RAND_2 = {1{`RANDOM}};
  r_addr = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  reg_r_data = _RAND_3[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
