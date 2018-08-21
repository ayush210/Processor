module Tagram(state,taginput,tagoutput,address,write_signal_cache,read_signal,write_signal,clk,reset);

parameter memory_bits = 5;
parameter cache_size = 8;
parameter index = 3;

integer i;
input reset;
input[3:0] state;
output[memory_bits-1:index] tagoutput;
input[memory_bits-1:index] taginput;
input[index-1:0] address;             //input is on
input write_signal_cache;
input clk;
input read_signal,write_signal;

reg[memory_bits-1:index] tagoutput;

reg[memory_bits-1:index] tagbits[cache_size:0];

always @(posedge clk)     //write logic
		begin
			if(reset==1)
				begin
					for(i=0;i<cache_size;i++)
					tagbits[i] = 0;
				end
			else if(write_signal_cache==1)
				tagbits[address] = taginput;
		end

always @(negedge clk)      //read logic
		begin
			//if((read_signal==1)||(write_signal==1))                   
				tagoutput = tagbits[address];
		end
initial begin
//$monitor("%d %d %d %d",state,taginput,address,write_signal_cache);
//$monitor("%d",tagoutput);
end
endmodule

module Validram(state,validoutput,address,reset,write_signal_cache,clk);
		parameter memory_bits = 5;
		parameter cache_size = 8;
		parameter index = 3;
	
		integer i;
		input reset;
		input state;
		output validoutput;
		input[index-1:0] address;
		input write_signal_cache;
		input clk;
		reg validbits[cache_size:0];
		reg validoutput;

always @(posedge clk)     //write logic
		begin
			if(reset==1)
			begin
				for(i=0;i<=cache_size;i++)
					validbits[i] = 0;
			end
			else if(write_signal_cache==1)
				validbits[address] = 1;
		end

always @(negedge clk)      //read logic
		begin
		//	if(state==0)
				validoutput = validbits[address];
		end
initial begin
//$monitor("%d %d %d",write_signal_cache,address,validoutput);
end
endmodule
