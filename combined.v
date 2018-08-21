module combined(clk,reset,fulladdress,read_signal,write_signal,state,out_write,out_read);

parameter index = 3;
parameter memory_bits = 5;
parameter memory_size = 32;

input clk;
input[memory_bits-1:0] fulladdress;
input read_signal;
input write_signal;
input reset;
input[memory_size-1:0] out_write;
output[memory_size-1:0] out_read;
output[3:0] state;

wire[3:0] state;
wire read_signal_cache;wire write_signal_cache_out;wire write_signal_cache_mem;wire read_signal_memory;wire write_signal_memory;wire validbit;wire[memory_bits-index-1:0] tagoutput;
wire[31:0] main_memory_out_data;

control con(.clk(clk),.reset(reset),.state(state),.read_signal(read_signal),.write_signal(write_signal),.write_signal_cache_out(write_signal_cache_out),.read_signal_cache(read_signal_cache),.write_signal_cache_mem(write_signal_cache_mem),.read_signal_memory(read_signal_memory),.write_signal_memory(write_signal_memory),.validbit(validbit),.tag_in(fulladdress[memory_bits-1:index]),.tag_out(tagoutput));

Tagram tagmemory(.state(state),.taginput(fulladdress[memory_bits-1:index]),.tagoutput(tagoutput),.address(fulladdress[index-1:0]),.write_signal_cache(write_signal_cache_mem||write_signal_cache_out),.read_signal(read_signal_cache),.write_signal(write_signal),.clk(clk),.reset(reset));

Validram vram(.validoutput(validbit),.address(fulladdress[index-1:0]),.reset(reset),.write_signal_cache(write_signal_cache_mem||write_signal_cache_out),.clk(clk));

dataram dram(.out_write(out_write),.out_read(out_read),.memorydata_write(main_memory_out_data),.write_signal_cache_mem(write_signal_cache_mem),.write_signal_cache_out(write_signal_cache_out),.read_signal_cache(read_signal_cache),.address(fulladdress[index-1:0]),.clk(clk),.reset(reset));

mainmem mmem(.address(fulladdress),.write_signal_memory(write_signal_memory),.memory_out(main_memory_out_data),.write_data(out_write),.read_signal_memory(read_signal_memory),.reset(reset),.clk(clk));
initial begin
//$monitor("%d",state);
//$monitor("%d %d %d",main_memory_out_data,write_signal_cache_mem,fulladdress);
//$monitor("%d",validbit);
//$monitor("%d %d",tag_in,tag_out);
//$monitor("%d",write_signal_cache_out);
end
endmodule


