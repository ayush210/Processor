//module implemented to store tags in cache

module TagRam(address,Taginput,Tagout,write_signal,clk,read_signal,prevaddress,prevread,prevmatch);
	parameter index = 3;                              //index of cache i.e last three bits of fulladdress
	parameter cachesize = 8;						  
	parameter memorybits = 5;						 //bits required to represent full memory addresses
	input read_signal;								 // read_signal = 1 when reading from memory
	input[index-1:0] address;          					
	input[memorybits-index-1:0] Taginput;
	output[memorybits-index-1:0] Tagout;
	input write_signal;								// write_signal = 1 when we want to write so update both cache and mainmemory
	input clk;
	reg[memorybits-index-1:0] Tagout;              
	reg[memorybits-index-1:0] Tagbits[cachesize-1:0];
	input[memorybits-1:0] prevaddress;
	input prevread;								  // previous operation was a read or not
	input prevmatch; 
	
	always@(posedge clk)     //write
		begin
			if(write_signal==1)                    // write into the memory  
				Tagbits[address] = Taginput;
			if(read_signal==1)							
				Tagout = Tagbits[address];
			else 									
				Tagout = 0;
			if(prevread==1&&prevmatch==0)          // when previous was as miss so storing previous value in Tagram 
				Tagbits[prevaddress[index-1:0]] = prevaddress[memorybits-1:index];
		end
	//always@(negedge clk)	//read
	//	begin
	//				Tagout = Tagbits[address];
	//	end
//	initial begin
//		$monitor("%d",address);
//	end
endmodule
