//ram to store valid bits for cache

module ValidRam(address,ValidOut,write_signal,reset,clk,read_signal,prevread,match,prevaddress,prevmatch);
	
	parameter index = 3;                  
	parameter cachesize = 8;
	parameter memory_bits = 5;
	input[memory_bits-1:0] prevaddress;              //prev address which was accessed
	input match;								 // prev was a miss or a hit
	input prevread;
	input[index-1:0] address;                      // index field for address               
	input write_signal;                            // write_signal =1-> write else not 
	input reset;									
	input clk;
	input read_signal;
	output ValidOut;								// output valid bits
	integer i;
	reg ValidOut;
	reg Validbits[cachesize-1:0];					// registers or valid bits
	input prevmatch;
	always@(posedge clk)       // write
		begin
			if(write_signal==1&&reset==0)              
			//	$display("%d",address);
				Validbits[address] = 1;
			else if(reset==1)						//when reset ==1 validbits for all address -> 0
			begin
					for(i=0;i<cachesize;i++)
							Validbits[i] = 0;
			end
			if(read_signal==1)						
				ValidOut = Validbits[address];
			else 
				ValidOut = 0;
			if(prevread==1&&prevmatch==0)			//if previously we were reading and it was a miss then replace the block
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
