//cache memory 
module DataRam(address,datainput,dataoutput,clk,write_signal,read_signal,match,prevaddress,prevread,prevvalue,prevmatch);

parameter index = 3;                    //number of index bits
parameter cachesize = 8;				
parameter memorybits = 5;				//number of bits reqd to represent full address of main memory

input[index-1:0] address;				//index field
input[31:0] datainput;					//data to be written	
output[31:0] dataoutput;				//data to be read
input[31:0] prevvalue;					//data which was read in previous cycle if it was a miss then need to be stored to cache
input[memorybits-1:0] prevaddress;		//previous add reqd. to replace the block
input prevread;
input clk;
input write_signal;
input read_signal;
input match;
input prevmatch;					 // previous was a miss or a hit

reg[31:0] dataoutput;
reg[31:0] data[7:0];

always @(posedge clk)
begin
if(write_signal==1)
			data[address] = datainput;
if(prevread==1&&prevmatch==0)				// if in previous cycle it was a miss then we need to replace the block
			data[prevaddress[index-1:0]] = prevvalue;
end

always @(negedge clk)
begin
		if(read_signal==1&&match==1)
			dataoutput = data[address];
end

endmodule
