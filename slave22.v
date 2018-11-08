//to take care of d_error
module slave(clk,reset,a_channel,d_channel,a_valid,a_ready,d_valid,d_ready,backpressureslave,d_error);

parameter a_channel_size = 53;
parameter d_channel_size = 43;

input clk,reset;
input[a_channel_size-1:0] a_channel;
input a_valid;
input a_ready;
input d_ready;
output[d_channel_size-1:0] d_channel;
output d_valid;
output backpressureslave;
output d_error;

reg[d_channel_size-1:0] d_channel;
reg [2:0]state;
reg d_valid;
reg backpressureslave;
reg temp;
reg d_error;
//a_opcode[52:50] a_param[49:47] a_size[46:44] a_source[43:42] a_address[41:32] a_data[31:0] 
//d_opcode[42:40] d_param[39:37] d_size[36:34] d_source[33:32]  d_data[31:0]
reg [31:0]memory[1023:0];

always@(negedge clk)
		begin
		if(reset==1)
		   begin
		        d_channel[d_channel_size-1:0] <= 0;
		        backpressureslave <= 0;
				d_error <= 0;
				d_valid <=0;
				state <= 0;
		    end
		else
		   begin
			case(state)
			  0: begin
				if(a_valid==1)
					begin
					    backpressureslave <= 1;
					    state <= 1;
					    d_valid <= 0;
					end
			         else
					begin
					     d_valid <=0;
					end
				end
			  1: begin
				if(d_ready==0)
					begin
					    state<=1;
					end
				else
				    begin
			               temp = ($random)%2;
		         	      if(temp==0)
					        begin
					 		if(d_ready==1&&a_channel[52:50]==4)     //get
				         		begin	
	 							$display("get");  
								state<=0;
								  d_valid <= 1;
								  backpressureslave <= 0;
								  d_channel[42:40] <= 1;   //opcode
								  d_channel[39:37]  <= 0;  //param
								  d_channel[36:34] <= 5;    //size
								  d_channel[33:32] <= 0;	  //source	
								  d_channel[31:0]  = memory[(a_channel[41:32])];
							    end
						    else if(d_ready==1&&a_channel[52:50]==0)    //put_data
							    begin	
								state<=0;
								  d_valid <= 1;
							 	  backpressureslave <= 0;
								  d_channel[42:40] <= 0;
								  d_channel[39:37]  <= 0;
								  d_channel[36:34] <= 5;
								  d_channel[33:32] <= 0;
								  memory[(a_channel[41:32])] = a_channel[31:0];
							    end
					        end
				     	  else
					      	begin
							  state<=2;
					         end
			         end
			   end
			2: begin
				if(d_ready==0)
					begin
					    state<=2;
					end
				else
				    begin
			               temp = ($random)%2;
		         	          if(temp==0)
					     begin
					 	if(d_ready==1&&a_channel[52:50]==4)     //get
				         		begin	
	 							$display("get");  
								state<=0;	
	 						    d_valid <= 1;
							 	backpressureslave <= 0;
								d_channel[42:40] <= 1;   //opcode
								d_channel[39:37]  <= 0;  //param
								d_channel[36:34] <= 5;    //size
								d_channel[33:32] <= 0;	  //source	
								d_channel[31:0]  = memory[(a_channel[41:32])];
							end
						else if(d_ready==1&&a_channel[52:50]==0)    //put_data
							begin	
									//$display("%d",a_channel[31:0]);  
									  
								state<=0;
								d_valid <= 1;
							 	backpressureslave <= 0;
								d_channel[42:40] <= 0;
								d_channel[39:37]  <= 0;
								d_channel[36:34] <= 5;
								d_channel[33:32] <= 0;
								memory[(a_channel[41:32])] = a_channel[31:0];
								//$display("%b",memory[(a_channel[41:32])]);
							end
					      end
				     	   else
					      begin
							state<=3;
					      end
			            end
			   end
			3: begin
				if(d_ready==0)
					begin
					    state<=3;
					end
				else
				    begin
			               temp = ($random)%2;
		         	          if(temp==0)
					     begin
					 	if(d_ready==1&&a_channel[52:50]==4)     //get
				         		begin	
	 							$display("get");  
								state<=0;
	 						    d_valid <= 1;
							 	backpressureslave <= 0;
								d_channel[42:40] <= 1;   //opcode
								d_channel[39:37]  <= 0;  //param
								d_channel[36:34] <= 5;    //size
								d_channel[33:32] <= 0;	  //source	
								d_channel[31:0]  = memory[(a_channel[41:32])];
							end
						else if(d_ready==1&&a_channel[52:50]==0)    //put_data
							begin	
									//$display("%d",a_channel[31:0]);  
									
								state <= 0;
								d_valid <= 1;
							 	backpressureslave <= 0;
								d_channel[42:40] <= 0;
								d_channel[39:37]  <= 0;
								d_channel[36:34] <= 5;
								d_channel[33:32] <= 0;
								memory[(a_channel[41:32])] = a_channel[31:0];
								//$display("%b",memory[(a_channel[41:32])]);
							end
					      end
				     	   else
					      begin
							state<=4;
					      end
			            end
			   end
			4: begin
				if(d_ready==0)
					begin
					    state<=4;
					end
				else
				    begin
			                 if(d_ready==1&&a_channel[52:50]==4)     //get
				         		begin
	 					//		$display("get");  
									state<=0;
	 						        d_valid <= 1;
								 	backpressureslave <= 0;
									d_channel[42:40] <= 1;   //opcode
									d_channel[39:37]  <= 0;  //param
									d_channel[36:34] <= 5;    //size
									d_channel[33:32] <= 0;	  //source	
								  	d_channel[31:0]  =  memory[a_channel[41:32]];
								end
						else if(d_ready==1&&a_channel[52:50]==0)    //put_data
							begin	 
									state<=0;
									d_valid <= 1;
							 		backpressureslave <= 0;
									d_channel[42:40] <= 0;
									d_channel[39:37]  <= 0;
									d_channel[36:34] <= 5;
									d_channel[33:32] <= 0;
									memory[(a_channel[41:32])] = a_channel[31:0]; 
							end
				    end   
			     end
			endcase
		//$display("%b %b %b",a_channel[31:0],memory[a_channel[41:32]],d_channel[31:0]);
		      end
		    end

		endmodule
