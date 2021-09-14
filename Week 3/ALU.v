module and1(input wire A,B, output wire Y);
assign Y = A & B;
endmodule

module or1(input wire A,B, output wire Y);
assign Y = A | B;
endmodule

module not1(input wire A, output wire Y);
assign Y=~A;
endmodule

module xor1(input wire A,B, output wire C);
wire x,y,p,q;
not1 n1(A,x);
not1 n2(B,y);
and1 a1(B,x,p);
and1 a2(A,y,q);
or1 o1(p,q,C);
endmodule

module FA(input wire a, b, cin, output wire sum, cout);
wire x,y,p,q,r;
xor1 x0(a, b,x);
xor1 x1(x, cin, sum);
and1 a0(a, b, p);
and1 a1(a, cin, q);
and1 a2(b, cin, r);
or1 o0(p,q,y);
or1 o1(y,r, cout);
endmodule

module MUX2(input wire A,B,S, output wire Y);
assign Y=(S==0)?A:B;
endmodule

module addsub(input wire i0,i1,add_sub,cin,output wire cout,sumdiff);
	wire t;
	xor1 x2(i1,add_sub,t);
	FA f0(i0,t,cin,sumdiff,cout);
endmodule

module alu_slice(input wire [1:0]op,input wire i0,i1,cin,output wire o,cout);
	wire t_sumdiff,t_and,t_or,t_andor;
	addsub b1(i0,i1,op[0],cin,cout,sumdiff);
	and1 a4(i0,i1,t_and);
	or1 o2(i0,i1,t_or);	
	MUX2 m1(t_and,t_or,op[0],t_andor);
	MUX2 m2(t_andor,sumdiff,op[1],o);
endmodule

module alu (input wire [1:0] op, input wire [15:0] i0, i1,
    output wire [15:0] o, output wire cout);
	wire [14:0]c;
	alu_slice p0(op,i0[0],i1[0],op[0],o[0],c[0]);
	alu_slice p1(op,i0[1],i1[1],c[0],o[1],c[1]);
	alu_slice p2(op,i0[2],i1[2],c[1],o[2],c[2]);
	alu_slice p3(op,i0[3],i1[3],c[2],o[3],c[3]);
	alu_slice p4(op,i0[4],i1[4],c[3],o[4],c[4]);
	alu_slice p5(op,i0[5],i1[5],c[4],o[5],c[5]);
	alu_slice p6(op,i0[6],i1[6],c[5],o[6],c[6]);
	alu_slice p7(op,i0[7],i1[7],c[6],o[7],c[7]);			
	alu_slice p8(op,i0[8],i1[8],c[7],o[8],c[8]);
	alu_slice p9(op,i0[9],i1[9],c[8],o[9],c[9]);
	alu_slice p10(op,i0[10],i1[10],c[9],o[10],c[10]);
	alu_slice p11(op,i0[11],i1[11],c[10],o[11],c[11]);
	alu_slice p12(op,i0[12],i1[12],c[11],o[12],c[12]);
	alu_slice p13(op,i0[13],i1[13],c[12],o[13],c[13]);
	alu_slice p14(op,i0[14],i1[14],c[13],o[14],c[14]);
	alu_slice p15(op,i0[15],i1[15],c[14],o[15],cout);
endmodule


