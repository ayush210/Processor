module dataram(out_write,out_read,memorydata_write,write_signal_cache_mem,write_signal_cache_out,read_signal_cache,address,clk,reset);
parameter word_size = 32;
parameter cache_size = 8;
parameter index = 3;
parameter memory_bits = 5;

integer i;
input [index-1:0] address;
input[word_size-1:0] out_write;
output[word_size-1:0] out_read;
input[word_size-1:0] memorydata_write;
input write_signal_cache_mem;
input write_signal_cache_out;
input read_signal_cache;
input clk;
input reset;
reg[word_size-1:0] out_read;

reg[word_size-1:0] data[cache_size-1:0];

always @(posedge clk)
		begin
			if(reset==1)
			begin
				for(i=0;i<cache_size;i++)
				data[i] = 32'b0;
			end
			else if(write_signal_cache_out==1)
				data[address] = out_write;
			else if(write_signal_cache_mem==1)
				data[address] = memorydata_write;
		end

always @(negedge clk)
		begin
			if(read_signal_cache==1)
				out_read = data[address];
		end
initial begin
//$monitor($time," %d %d %d %d %d ",address,memorydata_write,write_signal_cache_mem,out_read,write_signal_cache_out);
end
endmodule
