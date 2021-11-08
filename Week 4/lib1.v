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

module MUX4 (input wire [0:3] i, input wire j1, j0, output wire o);
wire x,y;
MUX2 M1(i[0],i[1],j1,x);
MUX2 M2(i[2],i[3],j1,y);
MUX2 M3(x,y,j0,o);
endmodule

module MUX8 (input wire [0:7] i, input wire j2, j1, j0, output wire o);
  wire  t0, t1;
  MUX4 m1 (i[0:3], j2, j1, t0);
  MUX4 m2 (i[4:7], j2, j1, t1);
  MUX2 m3 (t0, t1, j0, o);
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

module demux2 (input wire i, j, output wire o0, o1);
  assign o0 = (j==0)?i:1'b0;
  assign o1 = (j==1)?i:1'b0;
endmodule

module demux4 (input wire i, j1, j0, output wire [0:3] o);
  wire  t0, t1;
  demux2 demux2_0 (i, j1, t0, t1);
  demux2 demux2_1 (t0, j0, o[0], o[1]);
  demux2 demux2_2 (t1, j0, o[2], o[3]);
endmodule

module demux8 (input wire i, j2, j1, j0, output wire [0:7] o);
  wire  t0, t1;
  demux2 demux2_0 (i, j2, t0, t1);
  demux4 demux4_0 (t0, j1, j0, o[0:3]);
  demux4 demux4_1 (t1, j1, j0, o[4:7]);
endmodule

module df (input wire clk, in, output wire out);
  reg df_out;
  always@(posedge clk) df_out <= in;
  assign out = df_out;
endmodule

module dfr (input wire clk, reset, in, output wire out);
  wire reset_, df_in;
 or1 o1 (reset,in, reset_);
  and1 a1 (in, reset_, df_in);
  df df_0 (clk, df_in, out);
endmodule

module dfrl (input wire clk, reset, load, in, output wire out);
  wire _in;
 MUX2 m1(out, in, load, _in);
  dfr dfr_1(clk, reset, _in, out);
endmodule

