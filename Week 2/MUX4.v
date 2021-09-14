module MUX4 (input wire [0:3] i, input wire j1, j0, output wire o);
wire x,y;
MUX2 M1(i[0],i[1],j1,x);
MUX2 M2(i[2],i[3],j1,y);
MUX2 M3(x,y,j0,o);
endmodule
