#!/bin/bash
python assebler.py
iverilog -o out adder.v datamemory.v dff.v instruction_memory.v alu_decode.v decoder.v execute_stage.v processor.v topmodule.v alu.v decode_stage.v fetch_stage.v memory_stage.v regfile.v dff2.v incby1.v mux2.v sext.v control1.v dff3.v mux4.v
vvp out
