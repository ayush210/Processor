module combined2(clk,reset,load_fifo_write_signal,store_fifo_write_signal,load_fifo_write_data,store_fifo_write_data);

parameter a_channel_size = 55;
parameter d_channel_size = 47;
parameter load_fifo_word_length = 22;
parameter store_fifo_word_length = 54;
parameter response_fifo_word_length = 45;

input clk;
input reset;
input load_fifo_write_signal;
input store_fifo_write_signal;
input[load_fifo_word_length-1:0] load_fifo_write_data;
input[store_fifo_word_length-1:0] store_fifo_write_data;
wire load_fifo_write_signal;
wire store_fifo_write_signal;
wire[load_fifo_word_length-1:0] load_fifo_write_data;
wire[store_fifo_word_length-1:0] store_fifo_write_data;



//reg clk,reset;
wire [a_channel_size-1:0] a_channel;
wire[d_channel_size-1:0] d_channel;
wire[load_fifo_word_length-1:0] fifo_output_load;
wire[store_fifo_word_length-1:0] fifo_output_store;
wire load_fifo_empty_signal;
wire store_fifo_empty_signal;
wire read_load_fifo_signal;
wire read_store_fifo_signal;
//reg read_store_fifo_signal;
wire[response_fifo_word_length-1:0] fifo_input_response;
wire response_fifo_signal;
wire write_secondary_fifo_signal;
wire read_secondary_fifo_signal;
wire secondary_fifo_empty_signal;
wire load_fifo_full_signal;		    //to be given to processor
//reg[load_fifo_word_length-1:0] load_fifo_write_data;  			// just for simulation purpose //output coming from processor
wire store_fifo_full_signal;       //to be given to processor pipeline
//reg [store_fifo_word_length-1:0] store_fifo_write_data;	//just for simulation to be given by pipeline
wire a_valid;        //
reg read_response_fifo_signal;   //to be given by processor
wire[response_fifo_word_length-1:0] read_data_response_fifo;      //to be taken by processor
wire response_fifo_empty_signal;   // to be given to processor
wire response_fifo_full_signal;

master ma(.clk(clk),.reset(reset),.a_channel(a_channel),.d_channel(d_channel),.fifo_output_load(fifo_output_load),.fifo_output_store(fifo_output_store),.load_fifo_empty_signal(load_fifo_empty_signal),.store_fifo_empty_signal(store_fifo_empty_signal),.read_load_fifo_signal(read_load_fifo_signal),.read_store_fifo_signal(read_store_fifo_signal),.fifo_input_response(fifo_input_response),.response_fifo_signal(response_fifo_signal),.write_secondary_fifo_signal(write_secondary_fifo_signal),.read_secondary_fifo_signal(read_secondary_fifo_signal),.secondary_fifo_empty_signal(secondary_fifo_empty_signal),.response_fifo_full_signal(response_fifo_full_signal),.a_valid(a_valid));

fifol load_fifo(.clk(clk),.reset(reset),.write_enable(load_fifo_write_signal),.read_enable(read_load_fifo_signal),.data_in(load_fifo_write_data),.data_out(fifo_output_load),.empty_signal(load_fifo_empty_signal),.full_signal(load_fifo_full_signal));

fifos store_fifo(.clk(clk),.reset(reset),.write_enable(store_fifo_write_signal),.read_enable(read_store_fifo_signal),.data_in(store_fifo_write_data),.data_out(fifo_output_store),.empty_signal(store_fifo_empty_signal),.full_signal(store_fifo_full_signal));

slave sl(.clk(clk),.reset(reset),.a_channel(a_channel),.d_channel(d_channel),.a_valid(a_valid));

fifor response_fifo(.clk(clk),.reset(reset),.write_enable(response_fifo_signal),.read_enable(read_response_fifo_signal),.data_in(fifo_input_response),.data_out(read_data_response_fifo),.empty_signal(response_fifo_empty_signal),.full_signal(response_fifo_full_signal));

/*always@(*)
		begin
			#5 clk<= ~clk;
		end

initial begin
//$monitor("%b ",fifo_input_response);
	clk = 0;reset = 1;
#10 reset =0;
#10 store_fifo_write_signal = 1; store_fifo_write_data = 0;store_fifo_write_data[41:10] = 20; 
#20 store_fifo_write_signal = 0;//read_store_fifo_signal = 1;
//#20 read_store_fifo_signal = 0;
end*/
initial begin
$monitor("%d",store_fifo_empty_signal);
end

endmodule
