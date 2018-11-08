module datamemory(clk,reset,address,write_data,read_data,write_signal);

reg[5:0] i; //temporary variable only for "for" loop
input clk,reset,write_signal;     
input[31:0] address,write_data;  //address of write/read
output[31:0] read_data;    //data that has been read
reg [31:0] memory[40:0];  //memory registers
reg[31:0] read_data;		//read data output

always @(posedge clk)
		begin
			if(reset==1)
				begin
					for(i=0;i<41;i=i+1)
						memory[i] = 0;     //resetting to 0
				end
			else if(write_signal==1)
				memory[address] = write_data;  
			else
				read_data = memory[address]; //data read
		end

endmodule

