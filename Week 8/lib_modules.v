module invert (input wire i, output wire o);
   assign o = !i;
endmodule

module and2 (input wire i0, i1, output wire o);
  assign o = i0 & i1;
endmodule

module or2 (input wire i0, i1, output wire o);
  assign o = i0 | i1;
endmodule

module xor2 (input wire i0, i1, output wire o);
  assign o = i0 ^ i1;
endmodule

module nand2 (input wire i0, i1, output wire o);
   wire t;
   and2 and2_0 (i0, i1, t);
   invert invert_0 (t, o);
endmodule

module nor2 (input wire i0, i1, output wire o);
   wire t;
   or2 or2_0 (i0, i1, t);
   invert invert_0 (t, o);
endmodule

module xnor2 (input wire i0, i1, output wire o);
   wire t;
   xor2 xor2_0 (i0, i1, t);
   invert invert_0 (t, o);
endmodule

module and3 (input wire i0, i1, i2, output wire o);
   wire t;
   and2 and2_0 (i0, i1, t);
   and2 and2_1 (i2, t, o);
endmodule

module or3 (input wire i0, i1, i2, output wire o);
   wire t;
   or2 or2_0 (i0, i1, t);
   or2 or2_1 (i2, t, o);
endmodule

module nor3 (input wire i0, i1, i2, output wire o);
   wire t;
   or2 or2_0 (i0, i1, t);
   nor2 nor2_0 (i2, t, o);
endmodule

module nand3 (input wire i0, i1, i2, output wire o);
   wire t;
   and2 and2_0 (i0, i1, t);
   nand2 nand2_1 (i2, t, o);
endmodule

module xor3 (input wire i0, i1, i2, output wire o);
   wire t;
   xor2 xor2_0 (i0, i1, t);
   xor2 xor2_1 (i2, t, o);
endmodule

module xnor3 (input wire i0, i1, i2, output wire o);
   wire t;
   xor2 xor2_0 (i0, i1, t);
   xnor2 xnor2_0 (i2, t, o);
endmodule

module mux2 (input wire i0, i1, j, output wire o);
  assign o = (j==0)?i0:i1;
endmodule

module mux3 (input wire [0:2] i, input wire j1, j0, output wire o);
  wire  t;
  mux2 mux2_0 (i[0], i[1], j0, t);
  mux2 mux2_1 (t, i[2], j1, o);
endmodule

module mux4 (input wire [0:3] i, input wire j1, j0, output wire o);
  wire  t0, t1;
  mux2 mux2_0 (i[0], i[1], j1, t0);
  mux2 mux2_1 (i[2], i[3], j1, t1);
  mux2 mux2_2 (t0, t1, j0, o);
endmodule

module mux8 (input wire [0:7] i, input wire j2, j1, j0, output wire o);
  wire  t0, t1;
  mux4 mux4_0 (i[0:3], j2, j1, t0);
  mux4 mux4_1 (i[4:7], j2, j1, t1);
  mux2 mux2_0 (t0, t1, j0, o);
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
  invert invert_0 (reset, reset_);
  and2 and2_0 (in, reset_, df_in);
  df df_0 (clk, df_in, out);
endmodule

module dfrl (input wire clk, reset, load, in, output wire out);
  wire _in;
  mux2 mux2_0(out, in, load, _in);
  dfr dfr_1(clk, reset, _in, out);
endmodule

module dfs (input wire clk, set, in, output wire out);
  wire dfr_in,dfr_out;
  invert invert_0(in, dfr_in);
  invert invert_1(dfr_out, out);
  dfr dfr_2(clk, set, dfr_in, dfr_out);
endmodule

module dfsl (input wire clk, set, load, in, output wire out);
  wire _in;
  mux2 mux2_0(out, in, load, _in);
  dfs dfs_1(clk, set, _in, out);
endmodule

module fa (input wire i0, i1, cin, output wire sum, cout);
   wire t0, t1, t2;
   xor3 _i0 (i0, i1, cin, sum);
   and2 _i1 (i0, i1, t0);
   and2 _i2 (i1, cin, t1);
   and2 _i3 (cin, i0, t2);
   or3 _i4 (t0, t1, t2, cout);
endmodule

module addsub (input wire addsub, i0, i1, cin, output wire sumdiff, cout);
  wire t;
  fa _i0 (i0, t, cin, sumdiff, cout);
  xor2 _i1 (i1, addsub, t);
endmodule


module alu_slice (input wire [1:0] op, input wire i0, i1, cin, output wire o, cout);
   wire t_sumdiff, t_and, t_or, t_andor;
   addsub _i0 (op[0], i0, i1, cin, t_sumdiff, cout);
   and2 _i1 (i0, i1, t_and);
   or2 _i2 (i0, i1, t_or);
   mux2 _i3 (t_and, t_or, op[0], t_andor);
   mux2 _i4 (t_sumdiff, t_andor, op[1], o);
endmodule

module alu (input wire [1:0] op, input wire [15:0] i0, i1,
    output wire [15:0] o, output wire cout);
   wire	[14:0] c;
   alu_slice _i0 (op, i0[0], i1[0], op[0] , o[0], c[0]);
   alu_slice _i1 (op, i0[1], i1[1], c[0], o[1], c[1]);
   alu_slice _i2 (op, i0[2], i1[2], c[1], o[2], c[2]);
   alu_slice _i3 (op, i0[3], i1[3], c[2], o[3], c[3]);
   alu_slice _i4 (op, i0[4], i1[4], c[3], o[4], c[4]);
   alu_slice _i5 (op, i0[5], i1[5], c[4], o[5], c[5]);
   alu_slice _i6 (op, i0[6], i1[6], c[5], o[6], c[6]);
   alu_slice _i7 (op, i0[7], i1[7], c[6], o[7], c[7]);
   alu_slice _i8 (op, i0[8], i1[8], c[7], o[8], c[8]);
   alu_slice _i9 (op, i0[9], i1[9], c[8], o[9], c[9]);
   alu_slice _i10 (op, i0[10], i1[10], c[9] , o[10], c[10]);
   alu_slice _i11 (op, i0[11], i1[11], c[10], o[11], c[11]);
   alu_slice _i12 (op, i0[12], i1[12], c[11], o[12], c[12]);
   alu_slice _i13 (op, i0[13], i1[13], c[12], o[13], c[13]);
   alu_slice _i14 (op, i0[14], i1[14], c[13], o[14], c[14]);
   alu_slice _i15 (op, i0[15], i1[15], c[14], o[15], cout);
endmodule

module dfrl_16 (input wire  clk, reset, load, input wire [0:15] in, output wire [0:15] out);
  dfrl dfrl_0(clk, reset, load, in[0], out[0]);
  dfrl dfrl_1(clk, reset, load, in[1], out[1]);
  dfrl dfrl_2(clk, reset, load, in[2], out[2]);
  dfrl dfrl_3(clk, reset, load, in[3], out[3]);
  dfrl dfrl_4(clk, reset, load, in[4], out[4]);
  dfrl dfrl_5(clk, reset, load, in[5], out[5]);
  dfrl dfrl_6(clk, reset, load, in[6], out[6]);
  dfrl dfrl_7(clk, reset, load, in[7], out[7]);
  dfrl dfrl_8(clk, reset, load, in[8], out[8]);
  dfrl dfrl_9(clk, reset, load, in[9], out[9]);
  dfrl dfrl_10(clk, reset, load, in[10], out[10]);
  dfrl dfrl_11(clk, reset, load, in[11], out[11]);
  dfrl dfrl_12(clk, reset, load, in[12], out[12]);
  dfrl dfrl_13(clk, reset, load, in[13], out[13]);
  dfrl dfrl_14(clk, reset, load, in[14], out[14]);
  dfrl dfrl_15(clk, reset, load, in[15], out[15]);
endmodule

module mux2_16 (input wire [15:0] i0, i1, input wire j, output wire [15:0] o);
  mux2 mux2_0 (i0[0], i1[0], j, o[0]);
  mux2 mux2_1 (i0[1], i1[1], j, o[1]);
  mux2 mux2_2 (i0[2], i1[2], j, o[2]);
  mux2 mux2_3 (i0[3], i1[3], j, o[3]);
  mux2 mux2_4 (i0[4], i1[4], j, o[4]);
  mux2 mux2_5 (i0[5], i1[5], j, o[5]);
  mux2 mux2_6 (i0[6], i1[6], j, o[6]);
  mux2 mux2_7 (i0[7], i1[7], j, o[7]);
  mux2 mux2_8 (i0[8], i1[8], j, o[8]);
  mux2 mux2_9 (i0[9], i1[9], j, o[9]);
  mux2 mux2_10 (i0[10], i1[10], j, o[10]);
  mux2 mux2_11 (i0[11], i1[11], j, o[11]);
  mux2 mux2_12 (i0[12], i1[12], j, o[12]);
  mux2 mux2_13 (i0[13], i1[13], j, o[13]);
  mux2 mux2_14 (i0[14], i1[14], j, o[14]);
  mux2 mux2_15 (i0[15], i1[15], j, o[15]);
endmodule

module mux8_16 (input wire [0:15] i0, i1, i2, i3, i4, i5, i6, i7, input wire [0:2] j, output wire [0:15] o);
  mux8 mux8_0({i0[0], i1[0], i2[0], i3[0], i4[0], i5[0], i6[0], i7[0]}, j[0], j[1], j[2], o[0]);
  mux8 mux8_1({i0[1], i1[1], i2[1], i3[1], i4[1], i5[1], i6[1], i7[1]}, j[0], j[1], j[2], o[1]);
  mux8 mux8_2({i0[2], i1[2], i2[2], i3[2], i4[2], i5[2], i6[2], i7[2]}, j[0], j[1], j[2], o[2]);
  mux8 mux8_3({i0[3], i1[3], i2[3], i3[3], i4[3], i5[3], i6[3], i7[3]}, j[0], j[1], j[2], o[3]);
  mux8 mux8_4({i0[4], i1[4], i2[4], i3[4], i4[4], i5[4], i6[4], i7[4]}, j[0], j[1], j[2], o[4]);
  mux8 mux8_5({i0[5], i1[5], i2[5], i3[5], i4[5], i5[5], i6[5], i7[5]}, j[0], j[1], j[2], o[5]);
  mux8 mux8_6({i0[6], i1[6], i2[6], i3[6], i4[6], i5[6], i6[6], i7[6]}, j[0], j[1], j[2], o[6]);
  mux8 mux8_7({i0[7], i1[7], i2[7], i3[7], i4[7], i5[7], i6[7], i7[7]}, j[0], j[1], j[2], o[7]);
  mux8 mux8_8({i0[8], i1[8], i2[8], i3[8], i4[8], i5[8], i6[8], i7[8]}, j[0], j[1], j[2], o[8]);
  mux8 mux8_9({i0[9], i1[9], i2[9], i3[9], i4[9], i5[9], i6[9], i7[9]}, j[0], j[1], j[2], o[9]);
  mux8 mux8_10({i0[10], i1[10], i2[10], i3[10], i4[10], i5[10], i6[10], i7[10]}, j[0], j[1], j[2], o[10]);
  mux8 mux8_11({i0[11], i1[11], i2[11], i3[11], i4[11], i5[11], i6[11], i7[11]}, j[0], j[1], j[2], o[11]);
  mux8 mux8_12({i0[12], i1[12], i2[12], i3[12], i4[12], i5[12], i6[12], i7[12]}, j[0], j[1], j[2], o[12]);
  mux8 mux8_13({i0[13], i1[13], i2[13], i3[13], i4[13], i5[13], i6[13], i7[13]}, j[0], j[1], j[2], o[13]);
  mux8 mux8_14({i0[14], i1[14], i2[14], i3[14], i4[14], i5[14], i6[14], i7[14]}, j[0], j[1], j[2], o[14]);
  mux8 mux8_15({i0[15], i1[15], i2[15], i3[15], i4[15], i5[15], i6[15], i7[15]}, j[0], j[1], j[2], o[15]);
endmodule

module reg_file (input wire  clk, reset, wr, input wire [0:2] rd_addr_a, rd_addr_b, wr_addr, input wire [0:15] d_in, output wire [0:15] d_out_a, d_out_b);
  wire [0:7] load;
  wire [0:15] dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7;
  dfrl_16 dfrl_16_0(clk, reset, load[0], d_in, dout_0);
  dfrl_16 dfrl_16_1(clk, reset, load[1], d_in, dout_1);
  dfrl_16 dfrl_16_2(clk, reset, load[2], d_in, dout_2);
  dfrl_16 dfrl_16_3(clk, reset, load[3], d_in, dout_3);
  dfrl_16 dfrl_16_4(clk, reset, load[4], d_in, dout_4);
  dfrl_16 dfrl_16_5(clk, reset, load[5], d_in, dout_5);
  dfrl_16 dfrl_16_6(clk, reset, load[6], d_in, dout_6);
  dfrl_16 dfrl_16_7(clk, reset, load[7], d_in, dout_7);
  demux8 demux8_0(wr, wr_addr[2], wr_addr[1], wr_addr[0], load);
  mux8_16 mux8_16_9(dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, rd_addr_a, d_out_a);
  mux8_16 mux8_16_10(dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, rd_addr_b, d_out_b);
endmodule

module reg_alu (input wire clk, reset, sel, wr, /*add_sub,*/ input wire [1:0] op, input wire [2:0] rd_addr_a,
  rd_addr_b, wr_addr, input wire [15:0] d_in, output wire [15:0] d_out_a, d_out_b, output wire cout);
  wire [15:0] d_in_alu, d_in_reg, pc_in, pc_out, alu_in_a, alu_in_b;
  wire cout_0;
  reg_file reg_file_0 (clk, reset, wr, rd_addr_a, rd_addr_b, wr_addr, d_in_reg,  alu_in_a, alu_in_b);
  mux2_16 mux2_16_0 (d_in, d_in_alu, sel, d_in_reg);
  alu alu_0 (op, alu_in_a, alu_in_b, d_in_alu, cout_0);
  dfrl dfrl_0 (clk, reset, /*add_sub*/1'b1, cout_0, cout);
endmodule

module pc_slice (input wire clk, reset, cin, load, inc, sub, offset,
  output wire cout, pc);
  wire in, inc_;
  invert invert_0 (inc, inc_);
  and2 and2_0 (offset, inc_, t);
  addsub addsub_0 (sub, pc, t, cin, in, cout);
  dfrl dfrl_0 (clk, reset, load, in, pc);
endmodule

module pc_slice0 (input wire clk, reset, cin, load, inc, sub, offset,
  output wire cout, pc);
  wire in;
  or2 or2_0 (offset, inc, t);
  addsub addsub_0 (sub, pc, t, cin, in, cout);
  dfrl dfrl_0 (clk, reset, load, in, pc);
endmodule

module pc (input wire clk, reset, inc, add, sub, input wire [15:0] offset,
  output wire [15:0] pc);
  input wire load; input wire [15:0] c;
  or3 or3_0 (inc, add, sub, load);
  pc_slice0 pc_slice_0 (clk, reset, sub, load, inc, sub, offset[0], c[0], pc[0]);
  pc_slice pc_slice_1 (clk, reset, c[0], load, inc, sub, offset[1], c[1], pc[1]);
  pc_slice pc_slice_2 (clk, reset, c[1], load, inc, sub, offset[2], c[2], pc[2]);
  pc_slice pc_slice_3 (clk, reset, c[2], load, inc, sub, offset[3], c[3], pc[3]);
  pc_slice pc_slice_4 (clk, reset, c[3], load, inc, sub, offset[4], c[4], pc[4]);
  pc_slice pc_slice_5 (clk, reset, c[4], load, inc, sub, offset[5], c[5], pc[5]);
  pc_slice pc_slice_6 (clk, reset, c[5], load, inc, sub, offset[6], c[6], pc[6]);
  pc_slice pc_slice_7 (clk, reset, c[6], load, inc, sub, offset[7], c[7], pc[7]);
  pc_slice pc_slice_8 (clk, reset, c[7], load, inc, sub, offset[8], c[8], pc[8]);
  pc_slice pc_slice_9 (clk, reset, c[8], load, inc, sub, offset[9], c[9], pc[9]);
  pc_slice pc_slice_10 (clk, reset, c[9], load, inc, sub, offset[10], c[10], pc[10]);
  pc_slice pc_slice_11 (clk, reset, c[10], load, inc, sub, offset[11], c[11], pc[11]);
  pc_slice pc_slice_12 (clk, reset, c[11], load, inc, sub, offset[12], c[12], pc[12]);
  pc_slice pc_slice_13 (clk, reset, c[12], load, inc, sub, offset[13], c[13], pc[13]);
  pc_slice pc_slice_14 (clk, reset, c[13], load, inc, sub, offset[14], c[14], pc[14]);
  pc_slice pc_slice_15 (clk, reset, c[14], load, inc, sub, offset[15], c[15], pc[15]);
endmodule


