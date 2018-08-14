module ValidRam(address,ValidOut,write_signal,reset,clk,read_signal,prevread,match,prevaddress,prevmatch);
	parameter index = 3;
	parameter cachesize = 8;
	parameter memory_bits = 5;
	input[memory_bits-1:0] prevaddress;
	input match;
	input prevread;
	input[index-1:0] address;
	input write_signal;
	input reset;
	input clk;
	input read_signal;
	output ValidOut;
	integer i;
	reg ValidOut;
	reg Validbits[cachesize-1:0];
	input prevmatch;
	always@(posedge clk)       // write
		begin
			if(write_signal==1&&reset==0)
			//	$display("%d",address);
				Validbits[address] = 1;
			else if(reset==1)
			begin
					for(i=0;i<cachesize;i++)
							Validbits[i] = 0;
			end
			if(read_signal==1)
				ValidOut = Validbits[address];
			else 
				ValidOut = 0;
			if(prevread==1&&prevmatch==0)
				Validbits[prevaddress[index-1:0]] = 1; 
		end
	//initial begin
	//$monitor("%d",address);
	//end
//	always@(negedge clk)	  // read
//		begin
//			ValidOut = Validbits[address];
//		end
endmodule
