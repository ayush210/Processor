//ir4_input and state of sender can be used as a control so if ir4_input==1 but fsm is not in state=1 then pipeline needs to be stalled
//you cannot initite the sending from the 2nd stage as address is calculated in the 3rd stage for LW and SW
//therefore we can only initiate the sending process at the start of 4th stage
//for two load or two store simultaneously buuble has to be put in the 4th stage until 1st one gets to 5th stage then only we can put another load
//that is until state is zero pipeline cannot move forward therefore state will be used as the controlling input

module sender(clk,ir4_input,state_sender,a_channel,d_channel,address,data_write,d_ready,a_ready); //ir4_input input to memory_stage //ir4_input[6:0] 0000011 - LW 
	
	input[31:0] data_write;
	input[9:0] address;  //address for memory access (write or read)
	input clk;									//ir4_input[6:0] 0100011 - SW
	input[31:0] ir4_input;
	output[1:0] state_sender;
	output[54:0] a_channel;
	input[46:0] d_channel;
	reg[1:0] state_sender;
	reg[54:0] a_channel;
	output d_ready;
	input a_ready;
	reg d_ready;
//[54:52] a_opcode   //[51:49] a_param   //[48:46] a_size //[45:44] a_source //[43:34] a_address //[33:2] a_data //[1] a_valid  //[0] a_ready
//[46:44] d_opcode //[43:42] d_param  //[41:37] d_size //[36:35] d_source   //[34] d_error  //[33:2] d_data //[1] d_valid //[0] d_ready

always@(posedge clk)
		begin
			case(state_sender)
				0:begin
					if(ir4_input[6:0]==7'b0000011)     //LW
						begin
							state_sender = 1;
							a_channel[54:52] = 3'b100;  //a_opcode
							a_channel[51:49] = 3'b000;  //a_param
							a_channel[48:46] = 3'b101;  //a_size
							a_channel[45:44] = 2'b0;  //a_source
							a_channel[43:34] = address; //a_address
							a_channel[33:2] = 32'b0;   //a_data
							a_channel[1] = 	1'b1;   	//a_valid
							d_ready =  1'b1;  	//d_ready //when you are sending you should be ready for receiving ack req for link
						end
					
					if(ir4_input[6:0]==7'b0100011)     //SW
						begin
							state_sender = 2;
							a_channel[54:52] = 3'b000;	     //a_opcode
							a_channel[54:49] =	3'b000;     //a_param
							a_channel[48:46] =	3'b101;     //a_size
							a_channel[45:44] =	2'b0;        //a_source
							a_channel[43:34] = 	address;    //a_address
							a_channel[33:2]  =	data_write; //a_data
							a_channel[1] =		1'b1;       //a_valid
							d_ready =      1'b1;        //d_ready  //when you are sending you should be ready for receiving ack req for link
						end
				  end	
				1: begin     						//wait for ack of LW
						if(d_channel[1]==1'b1&&d_channel[46:44]==3'b001&&d_ready==1&&d_channel[34]!=1)  // correct ack and ready to accept ack
						begin 																			//error should not be 1 on d_channel
							state_sender = 0;
							a_channel[1] = 1'b0;        //a_valid        //valid has to be brought to 0;
						end

				   end
				2:   begin
						if(d_channel[1]==1'b1&&d_channel[46:44]==3'b000&&d_ready==1&&d_channel[34]!=1)
							state_sender = 0;
				     		a_channel[1] = 1'b0;
					 end//wait for ack of SW
			endcase
		end
endmodule
