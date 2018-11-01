#!/bin/bash

python assembler.py
iverilog -o out adder.v datamemory.v dff.v instruction_memory.v alu_decode.v decoder.v execute_stage.v processor.v topmodule.v alu.v decode_stage.v fetch_stage.v memory_stage.v regfile.v dff2.v incby1.v mux2.v sext.v control2.v dff3.v mux4.v instantiate_master_slave_fifo2.v master.v slave.v synchronous_fifo_load.v synchronous_fifo_response.v synchronous_fifo_store.v
vvp out
