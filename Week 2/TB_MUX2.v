module TB;
reg A,B,S;
wire X;
initial
begin
$dumpfile("dump.vcd");
$dumpvars(0,TB);
end
MUX2 newMUX(.A(A), .B(B), .S(S), .Y(X));
initial
begin
S = 1'b0;
A = 1'b0;
B = 1'b0;
#5
A = 1'b0;
B = 1'b1;
#5
A = 1'b1;
B = 1'b0;
#5
A = 1'b1;
B = 1'b1;
#5
S = 1'b0;
A = 1'b0;
B = 1'b0;
#5
A = 1'b0;
B = 1'b1;
#5
A = 1'b1;
B = 1'b0;
#5
A = 1'b1;
B = 1'b1;
end
endmodule
