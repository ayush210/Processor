module master(clk,reset,a_channel,d_channel,fifo_output_load,fifo_output_store,load_fifo_empty_signal,store_fifo_empty_signal,read_load_fifo_signal,read_store_fifo_signal,fifo_input_response,response_fifo_signal,write_secondary_fifo_signal,read_secondary_fifo_signal,secondary_fifo_empty_signal);

parameter load_fifo_word_length = 22;		    
parameter store_fifo_word_length = 54;
parameter a_channel_size = 55;
parameter d_channel_size = 40;
parameter response_fifo_word_length = 45;

input clk,reset;
output[a_channel_size-1:0] a_channel;
input[d_channel_size-1:0] d_channel;
input[store_fifo_word_length-1:0] fifo_output_store;//fifo_output[53:47]opcode//fifo_output[46:42]source reg//fifo_output[41:32]add//[31:0]data
input[load_fifo_word_length-1:0] fifo_output_load;   //fifo_output[21:15] opcode //fifo_output[14:10] destination reg //fifo_output[9:0] addres
output[response_fifo_word_length-1:0] fifo_input_response;//[44:38]	opcode //[37:33] destination reg //[32:1] data //[0] error bit
input load_fifo_empty_signal,store_fifo_empty_signal;
output read_load_fifo_signal,read_store_fifo_signal;
output response_fifo_signal;
output write_secondary_fifo_signal;
output read_secondary_fifo_signal;
input secondary_fifo_empty_signal;

reg response_fifo_signal;
reg[a_channel_size-1:0] a_channel;       
reg[2:0] state;
reg read_load_fifo_signal,read_store_fifo_signal;
reg write_secondary_fifo_signal;
reg read_secondary_fifo_signal;

//a_channel[54:0]
//a_opcode[54:52] //a_param[51:49] //a_size[48:46] //a_source[45:44] //a_address[43:34] //a_data[33:2] //a_valid[1] //a_ready[0]

//d_channel [46:0]
//d_opcode[46:44] //d_param[43:42] //d_size[41:37] //d_source[36:35] //d_error[34] //d_data[33:2] //d_valid[1] //d_ready[0]

always@(posedge clk)
		begin
			if(reset==1)								//initializations
				begin
					state = 0;                    		//state to 0
					a_channel[1] = 0;             		//a_valid to 0
					response_fifo_signal = 0;     		//response_fifo_signal //write signal to response fifo
					write_secondary_fifo_signal = 0;   //write_signal_to_secondary_fifo
					read_secondary_fifo_signal = 0;		//read_signal_to_secondary_fifo
					response_fifo_signal = 0;			//response_fifo_signal
					read_store_fifo_signal = 0;			//store fifo read signal
				end
			else
				begin
					case(state)
						0:begin
								response_fifo_signal = 0;             //again turning off the write signal of response fifo		
								if(load_fifo_empty_signal!=1)			//giving more priority to load_fifo then store fifo and then secondary
									begin	
										state = 1;					 
										read_load_fifo_signal = 1;		//read from load fifo
									end
								else if(store_fifo_empty_signal!=1)     //read from store fifo
									begin
										state = 1;
										read_store_fifo_signal = 1;
									end
								else if(secondary_fifo_empty_signal!=1)	//read from secondary fifo contains ins not able to process earlier
									begin
										state = 1;
										read_secondary_fifo_signal = 1;
									end

						  end
						1:begin
								state = 2;                                
								response_fifo_signal = 0;					//data written to response fifo or coming from state = 0	
								a_channel[1] = 1;             				//a_valid = 1;
								if(read_load_fifo_signal==1)
									begin
										a_channel[54:52] = 4 ;                  //a_opcode               //get opcode
										a_channel[51:49] = 0 ;                    //a_param
										a_channel[48:46] = 5;                   //a_size
										a_channel[45:44] = 1;                  //a_source
										a_channel[43:34] = fifo_output_load[9:0];                //a_address
										a_channel[33:2] = 0;                //a_data
										//a_channel[0] = 0;                  //a_ready
										read_load_fifo_signal = 0;
									end
								else if(read_store_fifo_signal==1)
									begin
										a_channel[54:52] =  0;              //a_opcode               //put opcode
										a_channel[51:49] = 0;               //a_param
										a_channel[48:46] = 5;              //a_size
										a_channel[45:44] = 1;            //a_source
										a_channel[43:34] = fifo_output_store[9:0];           //a_address
										a_channel[33:2] = fifo_output_store[41:10];           //a_data
										//a_channel[0] = 0;              //a_ready
										read_store_fifo_signal = 0;
									end
								else if(read_secondary_fifo_signal==1)
									begin
									  a_channel[54:52] = 4;
									  a_channel[51:49] = 0;
									  a_channel[48:46] = 0;
									  a_channel[45:44] = 0;
									  a_channel[43:34] = 0;
									  a_channel[33:2] = 0;
									  //a_channel[0] = 0;
									  read_secondary_fifo_signal = 0;
									end
						  end
						2:begin
								a_channel[1] = 0;
								if(d_channel[1]==1'b1&&a_channel[0]==1'b1)  //d_valid==1 && a_ready ==1 //to change d_valid with d_channel index
									begin
										if(load_fifo_empty_signal!=1)			//read_fifo_not _empty
											begin
												read_load_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else if(store_fifo_empty_signal!=1)		//store_fifo_not_empty
											begin
												read_store_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else if(secondary_fifo_empty_signal!=1)	
											begin
												read_secondary_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else					//no remaining instructions go to idle state
										   begin
										       response_fifo_signal = 1;
											   state = 0;
										   end
									end
								else							//not received ack so go to next waiting state
								  begin	
									state = 3;
								  end

						  end
						3:begin
								if(d_channel[1]==1'b1&&a_channel[0]==1'b1)	//d_valid==1 &&	a_ready ==1 //received ack
									begin
										if(load_fifo_empty_signal!=1)			//load fifo not empty
											begin
												read_load_fifo_signal = 1;		//read signal to  load fifo
												response_fifo_signal = 1;		//write signal to response fifo
												state = 1;						
											end
										else if(store_fifo_empty_signal!=1) 	//store fifo not empty
											begin
												read_store_fifo_signal = 1;		//read signal to store fifo
												response_fifo_signal = 1;		//write signal to response fifo
												state = 1;
											end
										else if(secondary_fifo_empty_signal!=1)
											begin
												read_secondary_fifo_signal = 1;	//read signal to secondary fifo
												response_fifo_signal = 1;		//write signal to response fifo
												state = 1;
											end
										else
											begin
												response_fifo_signal = 1;		//no remaining instructions go to idle state
												state = 0;
											end
									end
								else
									begin
										state = 4;
									end
						  end
						4:begin
								if(d_channel[1]==1'b1&&a_channel[0]==1'b1)	//d_valid ==1 && a_ready==1 //received ack
									begin
										if(load_fifo_empty_signal!=1)	//load_fifo not empty
											begin
												read_load_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else if(store_fifo_empty_signal!=1)	//store fifo not empty
											begin
												read_store_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else if(secondary_fifo_empty_signal!=1)	//secondary fifo not empty
											begin
												read_secondary_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else						// no remaining instructions goto idle state
											begin
												response_fifo_signal = 1;
												state = 0;
											end
									end
								else
									begin
										state = 5;
									end
						  end
						5:begin
								if(d_channel[1]==1'b1&&a_channel[0]==1'b1)
									begin
										if(load_fifo_empty_signal!=1)		//load fifo not empty
											begin
												read_load_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else if(store_fifo_empty_signal!=1)	//store fifo not empty
											begin
												read_store_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else if(secondary_fifo_empty_signal!=1)	//secondary fifo not empty
											begin
												read_secondary_fifo_signal = 1;
												response_fifo_signal = 1;
												state = 1;
											end
										else 						//no remaining instructions
											begin
												response_fifo_signal = 1;
												state = 0;
											end
									end
								else
									begin								
										write_secondary_fifo_signal = 1;  	//to_add_secondary_fifo_for not processed instructions
										if(load_fifo_empty_signal!=1)		//load fifo not empty
											begin
												read_load_fifo_signal = 1;
												state = 1;
											end
										else if(store_fifo_empty_signal!=1)			//store fifo not empty
											begin
												read_store_fifo_signal = 1;
												state = 1;
											end
										else if(secondary_fifo_empty_signal!=1)		//secondary fifo not empty
											begin
												read_secondary_fifo_signal = 1;
												state = 1;
											end
										else			//no remaining instructions 
											begin
												state = 0;
											end
									end
						  end
					endcase
				end
		end
endmodule
