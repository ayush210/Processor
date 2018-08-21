module control(clk,reset,state,hit,read_signal,write_signal,read_signal_cache,write_signal_cache_mem,write_signal_cache_out,read_signal_memory,write_signal_memory,validbit,tag_in,tag_out);

parameter memory_bits = 5;
parameter index = 3;
parameter cache_size = 8;

input reset;
input clk;
output[3:0] state;
output hit;
input read_signal;
input write_signal;
output read_signal_cache;
output write_signal_cache_mem;
output write_signal_cache_out;
output read_signal_memory;
output write_signal_memory;
input validbit;
input[memory_bits-index-1:0] tag_in;
input[memory_bits-index-1:0] tag_out;

reg[3:0] state;
reg hit;
reg read_signal_cache;
reg write_signal_cache_mem;
reg read_signal_memory;
reg write_signal_memory;
reg write_signal_cache_out;

always@(posedge clk)
		begin
		//		state = state + 1;
		if(reset==1)
		state = 0;
		else
		begin
case(state)
	0:begin	
			write_signal_cache_out = 0;
			write_signal_memory = 0;
			read_signal_cache = 0;
			write_signal_cache_mem = 0;
			read_signal_memory = 0;
	if(read_signal==1)      // go to read state
			state = 1;
	if(write_signal==1)
			state = 5;
	end		
	1: begin
		if(tag_in==tag_out&&validbit==1)
		 begin
			   hit = 1;
			   read_signal_cache = 1;
			   read_signal_memory = 0;
			   state = 0;
		 end
		else
		begin
	     	state = 2;
		end
	   end
	  //8:begin
	    //  state = 8;
	  //end
	2:begin
				read_signal_memory = 1;
				//write_signal_cache_mem = 1;
		        state = 3;  
	 end
	3:begin 
				read_signal_memory = 0;
				write_signal_cache_mem = 1;
				state = 4;
	  end
	4:begin
				write_signal_cache_mem = 0;
				read_signal_cache = 1;
				state = 0;
	  end
	5:begin
				if(tag_in==tag_out&&validbit==1)
				begin
				 hit = 1;
				 write_signal_cache_out = 1;
				 write_signal_memory = 1;
				 state = 0;
				end
				else 
				    state = 6;
	  end
	6:begin
				write_signal_cache_out = 1;
				write_signal_memory = 1;
				state = 0;
	  end
	  
endcase
end
		end
initial begin
//$monitor("%d %d %d",validbit,tag_out,state);
//$monitor("%d %d",write_signal_cache_out,write_signal_cache_out);
end
endmodule
