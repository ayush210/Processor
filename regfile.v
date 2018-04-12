module regfile(r1_add,r2_add,write_add,z5_output,write_enable,clk,reset,r1_value,r2_value);
reg[5:0] i;  //temp reg only for "for" loop
reg[31:0] registers[31:0]; //register file
input[4:0] r1_add,r2_add,write_add; //read1(r1) address  //read2(r2) add  //address of register write
input[31:0] z5_output;  //input from output of 4th stage after passing through dff
input write_enable,reset,clk;
output[31:0] r1_value,r2_value; //value read from registers
reg[31:0] r1_value,r2_value;

	always @(posedge clk)
		begin
			if(reset==1)
				begin
					for(i=0;i<32;i=i+1)
						begin
							registers[i] = 0;  //if reset ==1 initialize all registers to 0
						end
				end
			else
				begin
					if(write_enable==1)   //if write_enable == 1 write value at z5_output to register write address
						begin
							registers[write_add] <= z5_output;
						end
						//value read from r1_add and r2_add
					r1_value <= registers[r1_add];   
					r2_value <= registers[r2_add];
				end
		end
		initial begin
		$monitor("r0=%d r1=%d r2=%d r3=%d r4=%d r5=%d r6=%d r7=%d\n r8=%d r9=%d r10=%d r11=%d r12=%d r13=%d r14=%d r15=%d\n r16=%d r17=%d r18=%d r19=%d r20=%d r21=%d r22=%d r23=%d\n r24=%d r25=%d r26=%d r27=%d r28=%d r29=%d r30=%d r31=%d\n",registers[0],registers[1],registers[2],registers[3],registers[4],registers[5],registers[6],registers[7],registers[8],registers[9],registers[10],registers[11],registers[12],registers[13],registers[14],registers[15],registers[16],registers[17],registers[18],registers[19],registers[20],registers[21],registers[22],registers[23],registers[24],registers[25],registers[26],registers[27],registers[28],registers[29],registers[30],registers[31]);
		end
		
endmodule
