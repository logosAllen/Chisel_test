/*
 * Dummy tester to start a Chisel project.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 * 
 */

package fifo

import chisel3._
import chiseltest._
import chiseltest.experimental.UncheckedClockPoke._
import chiseltest.experimental.UncheckedClockPeek._
import org.scalatest.flatspec.AnyFlatSpec

class FIFOTester extends AnyFlatSpec with ChiselScalatestTester {

  "FIFO" should "work" in {
    val Len = 32
    val margin = 10
    test(new FIFO(size=8,len=Len))
    .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      for (a <- 0 to Len + margin) {
        //val result = Bool()
        val result = a>=Len
        println("write " + a)
        dut.io.w_full.expect(result)
        dut.io.w_data.poke(a.U)
        if(!dut.io.w_full.peek.litToBoolean){
          dut.io.w_valid.poke(true.B)
        }
        dut.io.w_clk.poke(true.B)
        dut.clock.step(1)
        dut.io.w_clk.poke(false.B)
        // dut.io.w_clk.step()
        dut.io.w_valid.poke(false.B)
      }

      for (a <- 0 to Len) {
        //val result = Bool()
        val result = a>=Len
        println("read " + a)
        dut.io.r_empty.expect(result)
        if(!dut.io.r_empty.peek.litToBoolean){
          dut.io.r_req.poke(true.B)
        }
        dut.clock.step(1)
        dut.io.r_req.poke(false.B)
        
      }

      for (a <- 0 to Len) {
        //val result = Bool()
        val result = a>=Len
        println("write " + a)
        dut.io.w_full.expect(result)
        dut.io.w_data.poke(a.U)
        if(!dut.io.w_full.peek.litToBoolean){
          dut.io.w_valid.poke(true.B)
        }
        dut.clock.step(1)
        dut.io.w_valid.poke(false.B)
      }

      for (a <- 0 to Len) {
        //val result = Bool()
        val result = a>=Len
        println("read " + a)
        dut.io.r_empty.expect(result)
        if(!dut.io.r_empty.peek.litToBoolean){
          dut.io.r_req.poke(true.B)
        }
        dut.clock.step(1)
        dut.io.r_req.poke(false.B)
        
      }
    }
  }
}
