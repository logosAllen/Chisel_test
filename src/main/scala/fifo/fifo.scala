/*
 * Dummy file to start a Chisel project.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 * 
 */

package fifo

import chisel3._
import chisel3.util._

import scala.math.pow

// create a module
class GrayCoder(bitwidth: Int) extends Module {
  val io = IO(new Bundle{
    val in = Input(UInt(bitwidth.W))
    val out = Output(UInt(bitwidth.W))
    val encode = Input(Bool()) // decode on false
  })
  
  when (io.encode) { //encode
    io.out := io.in ^ (io.in >> 1.U)
  } .otherwise { // decode, much more complicated
    io.out := Seq.fill(log2Ceil(bitwidth))(Wire(UInt(bitwidth.W))).zipWithIndex.fold((io.in, 0)){
      case ((w1: UInt, i1: Int), (w2: UInt, i2: Int)) => {
        w2 := w1 ^ (w1 >> pow(2, log2Ceil(bitwidth)-i2-1).toInt.U)
        (w2, i1)
      }
    }._1
  }
}


class FIFO(size: Int, len: Int) extends Module {
  val io = IO(new Bundle {
    val w_clk = Input(Bool())
    val w_data = Input(UInt(size.W))
    val w_valid = Input(Bool())
    val w_full = Output(Bool())
    // val r_clk = Input(Clock())
    val r_data = Output(UInt(size.W))
    val r_req = Input(Bool())
    val r_empty = Output(Bool())
  })
  assert(isPow2(len),"len must be power of 2")
  // create memory
  
  val w_addr = withClock(io.w_clk.asClock){RegInit(0.U((log2Ceil(len)+1).W))}
  val r_addr = RegInit(0.U((log2Ceil(len)+1).W))
  val buffer = Mem(len,UInt(size.W))
  val reg_r_data = Reg(UInt(size.W))

  // val reg_o_rempty = RegInit(true.B)
  // val reg_o_wfull = RegInit(false.B)
  val reg_o_rempty = Wire(Bool())
  val reg_o_wfull = Wire(Bool())

  reg_o_rempty := w_addr===r_addr
  reg_o_wfull := (w_addr(log2Ceil(len)) =/= r_addr(log2Ceil(len))) && (w_addr(log2Ceil(len)-1,0) === r_addr(log2Ceil(len)-1,0))

  // printf("Print during simulation: Input is %d\n", io.w_data)
  // printf("w_addr: %d, r_addr: %d\n",w_addr,r_addr)
  // printf("w_addr(log2Ceil(len)-1): %x\n ",w_addr(log2Ceil(len)-1))
  // printf("log2Ceil(len): %d\n",log2Ceil(len))
  // println("log2Ceil(len): " + log2Ceil(len))
  // printf("reg_o_wfull: %d\n",reg_o_wfull)
  // printf("w_full: %d\n",io.w_full)
  // val reg_valid = RegNext(io.w_valid)
  
  withClock(io.w_clk.asClock){
    when(io.w_valid && !reg_o_wfull){
      buffer(w_addr(log2Ceil(len)-1,0)) := io.w_data
      w_addr := w_addr + 1.U
    }
  }
  

  when(io.r_req && !reg_o_rempty){
    r_addr := r_addr + 1.U
  }

  reg_r_data := buffer(r_addr(log2Ceil(len)-1,0))

  //io.w_full := addr===16.U
  io.w_full := reg_o_wfull
  io.r_empty := reg_o_rempty
  io.r_data := reg_r_data
  //io.w_full := true.B 
}

class FIFO_test(size: Int, len: Int) extends Module {
  val io = IO(new Bundle {
    val w_clk = Input(Clock())
    val w_data = Input(UInt(size.W))
    val w_valid = Input(Bool())
    val w_full = Output(Bool())
    val r_data = Output(UInt(size.W))
    val r_req = Input(Bool())
    val r_empty = Output(Bool())
  })
  assert(isPow2(len),"len must be power of 2")
  // create memory
  
  val w_addr = withClock(io.w_clk){RegInit(0.U((log2Ceil(len)+1).W))}
  val r_addr = RegInit(0.U((log2Ceil(len)+1).W))
  val buffer = Mem(len,UInt(size.W))
  val reg_r_data = Reg(UInt(size.W))

  val reg_o_rempty = Wire(Bool())
  val reg_o_wfull = Wire(Bool())

  reg_o_rempty := w_addr===r_addr
  reg_o_wfull := (w_addr(log2Ceil(len)) =/= r_addr(log2Ceil(len))) && (w_addr(log2Ceil(len)-1,0) === r_addr(log2Ceil(len)-1,0))
  
  withClock(io.w_clk){
    when(io.w_valid && !reg_o_wfull){
      buffer(w_addr(log2Ceil(len)-1,0)) := io.w_data
      w_addr := w_addr + 1.U
    }
  }
  

  when(io.r_req && !reg_o_rempty){
    r_addr := r_addr + 1.U
  }

  reg_r_data := buffer(r_addr(log2Ceil(len)-1,0))

  io.w_full := reg_o_wfull
  io.r_empty := reg_o_rempty
  io.r_data := reg_r_data
}
class FIFO_CLK_wraper(size: Int, len: Int) extends Module {
  val io = IO(new Bundle {
    val w_clk = Input(Bool())  // second clock must be defind as Bool at top level
    val w_data = Input(UInt(size.W))
    val w_valid = Input(Bool())
    val w_full = Output(Bool())
    // val r_clk = Input(Clock())
    val r_data = Output(UInt(size.W))
    val r_req = Input(Bool())
    val r_empty = Output(Bool())
  })

  //create w_clk

  //create r_clk

  //FIFO inst
  val fifo = withClock(io.w_clk.asClock){Module(new FIFO_test(size,len))}

  fifo.io.w_clk := clock  // connect the clock of current to sub module
  fifo.io.w_data := io.w_data
  fifo.io.w_valid := io.w_valid
  fifo.io.r_req := io.r_req

  io.w_full := fifo.io.w_full
  io.r_data := fifo.io.r_data
  io.r_empty := fifo.io.r_empty


}

object FIFOMain extends App {
  println("Generating the adder hardware")
  emitVerilog(new FIFO(size=8,len=16), Array("--target-dir", "generated"))
  emitVerilog(new FIFO_CLK_wraper(size=8,len=16), Array("--target-dir", "generated"))
}



