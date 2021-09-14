module fulladd(input wire a, b, cin, output wire sum, cout);
wire [4:0] t;
    xor1 x0(a, b, t[0]);
    xor1 x1(t[0], cin, sum);

    and1 a0(a, b, t[1]);
    and1 a1(a, cin, t[2]);
    and1 a2(b, cin, t[3]);

    or1 o0(t[1], t[2], t[4]);
    or1 o1(t[3], t[4], cout);
endmodule