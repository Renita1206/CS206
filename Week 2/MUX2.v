module MUX2(input wire A,B,S, output wire Y);
assign Y=(S==0)?A:B;
endmodule
