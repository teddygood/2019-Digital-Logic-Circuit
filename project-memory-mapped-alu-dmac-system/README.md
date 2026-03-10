# Memory-Mapped ALU-DMAC System

## Overview

This project implements the 2019 Computer Engineering Design term project system composed of:

- `ALU_Top`
- `DMAC_Top`
- `BUS`
- `ram`
- `Top`

The system is organized as a memory-mapped structure in which the testbench writes operands and instructions into RAM, the DMAC transfers them to the ALU, and the ALU stores 64-bit results into the result FIFO so they can be copied back to the result RAM.

## Memory Map

- `0x0000 ~ 0x001F` : DMAC
- `0x0100 ~ 0x011F` : ALU
- `0x0200 ~ 0x023F` : Operand RAM
- `0x0300 ~ 0x033F` : Instruction RAM
- `0x0400 ~ 0x043F` : Result RAM

## Verification

Verification was performed with Quartus II and ModelSim-Altera using RTL simulation, waveform analysis, and testbench-based checking.

The main verification scenario is implemented in `tb_Top.v`, which checks the required RAM -> DMAC -> ALU -> DMAC -> RAM data path.

## File Guide

### Top-Level

- `README.md` : project overview, verification summary, and file guide
- `Top.v` : top-level integration of BUS, ALU, DMAC, and three RAM blocks
- `tb_Top.v` : top-level testbench for the RAM -> DMAC -> ALU -> DMAC -> RAM flow

### ALU Block

- `ALU_Top.v` : ALU memory-mapped top module
- `ALU_slave.v` : ALU slave-register interface and control/status register handling
- `ALU_alu_top.v` : ALU execution FSM between instruction FIFO, register file, and result FIFO
- `ALU_alu.v` : ALU core selecting one of the 16 operation blocks
- `ALU_operation.v` : arithmetic, logic, shift, and multiply operation modules
- `ALU_registerfile.v` : 16-entry 32-bit register file used by the 16-depth FIFO implementation
- `ALU_registerfile_2.v` : 16-entry operand register file for operand 00-15

### DMAC Block

- `DMAC_Top.v` : DMAC memory-mapped top module
- `DMAC_slave.v` : DMAC slave-register interface and descriptor push logic
- `DMAC_master.v` : DMAC bus-master transfer FSM
- `DMAC_fifo.v` : 16-entry FIFO wrapper used for DMAC descriptors and ALU result storage

### Bus And Memory

- `bus.v` : shared BUS module connecting 2 masters and 5 slaves
- `bus_arbiter.v` : bus grant arbitration logic for master 0 and master 1
- `bus_addressdecoder.v` : address decoder for DMAC, ALU, and RAM address regions
- `bus_seltosel.v` : helper block converting one-hot slave select to mux select encoding
- `ram.v` : 64-word 32-bit synchronous memory slave

### FIFO Blocks

- `fifo.v` : 8-entry FIFO for ALU instruction storage
- `fifo_16.v` : 16-entry FIFO for result and descriptor storage
- `fifo_ns.v` : next-state logic for the 8-entry FIFO
- `fifo_ns_16.v` : next-state logic for the 16-entry FIFO
- `fifo_cal_addr.v` : head/tail/data_count update logic for the 8-entry FIFO
- `fifo_cal_addr_16.v` : head/tail/data_count update logic for the 16-entry FIFO
- `fifo_out.v` : output-status logic for the 8-entry FIFO
- `fifo_out_16.v` : output-status logic for the 16-entry FIFO

### Register And Mux Blocks

- `Register_file.v` : 8-entry 32-bit register file used in the original FIFO structure
- `register32_8.v` : array of eight 32-bit registers
- `register32_r_en.v` : 32-bit register with enable
- `register8_r_en.v` : 8-bit register with enable
- `_dff_r_en.v` : 1-bit D flip-flop with reset and enable
- `_3_to_8_decoder.v` : 3-to-8 decoder for register selection
- `_8_to_1_MUX.v` : 8-to-1 multiplexer for register-file readback
- `write_operatinon.v` : write decoder for the 8-entry register file
- `read_operation.v` : read multiplexer control for the 8-entry register file
- `mux.v` : 1-bit, 16-bit, 32-bit, and 6-way 32-bit mux modules
- `mx2.v` : 2-way 32-bit mux used in FIFO output selection
- `dff.v` : 3-bit D flip-flop used in BUS response timing

### Arithmetic Blocks

- `gates.v` : basic logic gates and 4-bit/32-bit vector gate helpers
- `fa_v2.v` : full adder cell
- `clb4.v` : 4-bit carry lookahead block
- `cla4.v` : 4-bit carry lookahead adder
- `cla8.v` : 8-bit carry lookahead adder
- `cla32.v` : 32-bit carry lookahead adder
- `cla64.v` : 64-bit carry lookahead adder
- `cla128.v` : 128-bit carry lookahead adder

### Multiplier Blocks

- `multiplier.v` : iterative signed multiplier used by the ALU multiply operation
- `ASR128.v` : 128-bit arithmetic right shift helper
- `ROR128.v` : 128-bit rotate-right helper for Booth-style multiplication
- `m_to_y.v` : partial-product helper cell
- `multiplicand_to_y.v` : expands multiplicand data into the multiplier helper bus
