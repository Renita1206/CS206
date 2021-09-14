module tb;
reg p,q;
wire z;

//instantiation
nor1 a1(.A(p),.B(q),.Y(z));
initial begin
$dumpfile("abc.vcd");
$dumpvars(0,tb);
end

initial begin
$monitor(p,q,z);
p=1'b0;
q=1'b0;
#5
p=1'b0;
q=1'b1;
#5
p=1'b1;
q=1'b0;
#5
p=1'b1;
q=1'b1;
end
endmodule
