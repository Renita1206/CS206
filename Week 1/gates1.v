module and1(input wire A,B, output wire Y);
assign Y = A & B;
endmodule

module or1(input wire A,B, output wire Y);
assign Y = A | B;
endmodule

module not1(input wire A, output wire Y);
assign Y=~A;
endmodule

module nand1(input wire A,B, output wire Y);
wire x;
and1 a1(A,B,x);
not1 a2(x,Y);
endmodule


module nor1(input wire A,B, output wire Y);
wire x;
or1 a1(A,B,x);
not1 a2(x,Y);
endmodule


module xor1(input wire A,B, output wire C);
wire x,y,p,q;
not1 n1(A,x);
not1 n2(B,y);
and1 a1(B,x,p);
and1 a2(A,y,q);
or1 o1(p,q,C);
endmodule

module xnor1(input wire A,B, output wire C);
wire x,y,p,q;
not1 n1(A,x);
not1 n2(B,y);
and1 a1(y,x,p);
and1 a2(A,B,q);
or1 o1(p,q,C);
endmodule


