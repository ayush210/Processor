module master(clk,reset,ir34,a_ready,a_valid,a_channel,d_channel,d_ready,backpressureslave,z4_input,md4_input,d_valid,d_error);

parameter a_channel_size = 53;
parameter d_channel_size = 43;

input[31:0] z4_input;
input[31:0] md4_input;
input clk,reset;
input[31:0] ir34;
input[d_channel_size-1:0] d_channel;
input backpressureslave;
input a_ready;
input d_ready;
input d_valid;
input d_error;

output[a_channel_size-1:0] a_channel;
output a_valid;
reg a_valid;
reg[a_channel_size-1:0] a_channel;
reg state;

//a_opcode[52:50] a_param[49:47] a_size[46:44] a_source[43:42] a_address[41:32] a_data[31:0] 
//d_opcode[42:40] d_param[39:37] d_size[36:34] d_source[33:32] d_error[31] d_data[31:0]

always@(posedge clk)
		begin
			if(reset==1)
				begin
					a_valid <= 0;
					a_channel <= 0;
					state <= 0;
				end
			else
				begin
					case(state)
						0: 	begin
									if(ir34[6:0]==7'b0000011&&backpressureslave==0&&a_ready==1)           //lw
										begin
											a_valid <= 1;
											state <=1;
											a_channel[52:50] <=   4;         //opcode
											a_channel[49:47] <=   0;         //param
											a_channel[46:44] <=   5;            //size
											a_channel[43:42] <=   0;            //source
											a_channel[41:32] <=   z4_input[9:0];           //address
											a_channel[31:0] <=    md4_input;           //data

										end
									else if(ir34[6:0]==7'b0100011&&backpressureslave==0&&a_ready==1)           //sw
										begin
											a_valid <= 1;
											state <= 1;
											a_channel[52:50] <=  0;					//opcode
											a_channel[49:47] <=	 0;			   //param
											a_channel[46:44] <=	 5;			   //size
											a_channel[43:42] <=	 0;			   //source
											a_channel[41:32] <=	 z4_input[9:0]; 				   //address
											a_channel[31:0] <=   md4_input;              //data
										end
							end
						1: begin
								if((d_valid!=1)&&backpressureslave==1)
									begin
											
											a_valid<=0;
									end
								else if(d_error==1&&d_valid==1)
									begin
											a_valid<=1;
									end
	 	 						else if((d_valid==1&&d_error!=1)&&(ir34[6:0]==7'b0000011||ir34[6:0]==7'b0100011)&&a_ready==1&&backpressureslave==0)
									begin
											a_valid <= 1;
											if(ir34[6:0]==7'b0000011)					//lw
												begin
													a_channel[52:50] <= 4;				//opcode
													a_channel[49:47] <= 0;				//param
													a_channel[46:44] <= 5;				//size
													a_channel[43:42] <= 0;				//source
													a_channel[41:32] <= z4_input[9:0];	//address
													a_channel[31:0] <= md4_input;		//data
												end
											else if(ir34[6:0]==7'b0100011)              	//sw
												begin
													a_channel[52:50] <= 0;					//opcode
													a_channel[49:47] <= 0;					//param
													a_channel[46:44] <= 5;					//size
													a_channel[43:42] <= 0;					//source
													a_channel[41:32] <= z4_input[9:0];		//address
													a_channel[31:0] <= md4_input;			//data
												end
									end
								else if(d_valid==1)
									begin
											a_valid <= 0;
											state <= 0;
									end
						   end
					endcase
				end
		end





endmodule
