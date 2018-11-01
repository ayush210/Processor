module slave(clk,reset,a_channel,d_channel,a_valid);

parameter a_channel_size = 55;
parameter d_channel_size = 47;

input a_valid;
input clk;
input reset;
input[a_channel_size-1:0] a_channel;
output[d_channel_size-1:0] d_channel;

reg[d_channel_size-1:0] d_channel;
reg[2:0] temp;
reg[31:0] memory[1023:0];

//a_channel[54:0]
//a_opcode[54:52] //a_param[51:49] //a_size[48:46] //a_source[45:44] //a_address[43:34] //a_data[33:2] //a_valid[1] //a_ready[0]

//d_channel [46:0]
//d_opcode[46:44] //d_param[43:42] //d_size[41:37] //d_source[36:35] //d_error[34] //d_data[33:2] //d_valid[1] //d_ready[0]

always @(posedge a_valid)
		begin
		//$display("ehf");
		temp = {$random}%6;
		#(temp*5);
			if(a_channel[54:52]==4)
				begin
					d_channel[46:44] <=  1;                       //d_opcode
					d_channel[43:42] <=	0;					 //d_param
					d_channel[41:37] <=	5;					//d_size
					d_channel[36:35] <=  0;                  //d_source
					d_channel[34] <=  0;						//d_error   //can randomize
					d_channel[33:2] <= memory[(a_channel[43:34])]; 						//d_data
					d_channel[1] <= 	1;						//d_valid
					d_channel[0] <= 1;							//d_ready
				end
			else if(a_channel[54:52]==0)
				begin
					//$display("%b",a_channel);
					//$display("%d",);
					d_channel[46:44] <=	0;					//d_opcode
					d_channel[43:42] <=	0;					//d_param
					d_channel[41:37] <=	5;					//d_size
					d_channel[36:35] <= 0;						//d_source
					d_channel[34] <=	0;						//d_error    //can randomize
					memory[(a_channel[43:34])]	<= a_channel[33:2] ;  						//d_data
					d_channel[33:2] <= 0;    //no use as operation is store;  
					d_channel[1] <=	1;						//d_valid
					d_channel[0] <=	1;						//d_ready
				end
			end
		
endmodule

//a_channel[54:0]
//a_opcode[54:52] //a_param[51:49] //a_size[48:46] //a_source[45:44] //a_address[43:34] //a_data[33:2] //a_valid[1] //a_ready[0]

//d_channel [46:0]
//d_opcode[46:44] //d_param[43:42] //d_size[41:37] //d_source[36:35] //d_error[34] //d_data[33:2] //d_valid[1] //d_ready[0]


/*module test;

parameter d_channel_size = 47;
parameter a_channel_size = 55;

reg clk,reset;
wire[d_channel_size-1:0] d_channel;
reg[a_channel_size-1:0] a_channel;
reg a_valid;

always@(*)
		begin
			#5 clk<=~clk;
		end

slave s(.clk(clk),.reset(reset),.a_channel(a_channel),.d_channel(d_channel),.a_valid(a_valid));

initial begin
	$monitor("%d %d %d",$time,a_channel[33:2],d_channel[33:2]);
	a_channel[1] = 0; reset = 1;clk = 0; a_valid = 0;
	#10 a_channel[54:52] <=  0;
		a_channel[51:49] <= 0;
		a_channel[48:46] <= 	5;
		a_channel[45:44] <=  0;
		a_channel[43:34] <= 	5;
		a_channel[33:2] <= 20;
		a_channel[1] <= 	1;
		a_channel[0] <= 1;
		a_valid <= 1;
	#50 a_valid <= 0;
	#100 a_channel[54:52] <= 4;
		a_channel[51:49] <= 0;
		a_channel[48:46] <= 5;
		a_channel[45:44] <= 0;
		a_channel[43:34] <= 5;
		a_channel[33:2] <= 0;
		a_channel[1]  <= 1;
		a_channel[0] <= 1;
		a_valid <= 1;
end

endmodule*/
