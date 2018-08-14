//`define index 3;
//integer index=3;
module TagRam(address,Taginput,Tagout,write_signal,clk,read_signal,prevaddress,prevread,prevmatch);
	parameter index = 3;
	parameter cachesize = 8;
	parameter memorybits = 5;
	input read_signal;
	input[index-1:0] address;          //input index
	input[memorybits-index-1:0] Taginput;
	output[memorybits-index-1:0] Tagout;
	input write_signal;
	input clk;
	reg[memorybits-index-1:0] Tagout;
	reg[memorybits-index-1:0] Tagbits[cachesize-1:0];
	input[memorybits-1:0] prevaddress;
	input prevread;
	input prevmatch;
	
	always@(posedge clk)     //write
		begin
			if(write_signal==1)
				Tagbits[address] = Taginput;
			if(read_signal==1)
				Tagout = Tagbits[address];
			else 
				Tagout = 0;
			if(prevread==1&&prevmatch==0)
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
