module comparator(taginput,tagoutput,match);
parameter index = 3;
input[index-1:0] taginput;
input[index-1:0] tagoutput;
output match;
wire match;
assign match = (taginput==tagoutput);
endmodule
