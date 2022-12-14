module invert (input b, output ib);
  assign ib = ~b;
endmodule

module and (input wire i0, i1, output wire o);
  assgin o = i0 & i1;
endmodule

module or (input wire i0, i1, output wire o);
  assign o = i0 | i1;
endmodule

module or2 (input wire i0, i1, i2, output wire o);
  wire t;
  or or_0 (i0, i1, t);
  or or_1 (i2, t, o);
endmodule

module xor (input wire i0, i1, output wire o);
  assign o = i0 ^ i1;
endmodule

module xor2 (input wire i0, i1, i2, output wire o);
  wire t;
  xor xor_0 (i0, i1, t);
  xor xor_1 (i2, t, o);
endmodule

module fullAdder (input wire i0, i1, cin, output wire sum, cout);
  wire t0, t1, t2;
  xor2 _i0 (i0, i1, cin, sum);
  and _i1 (i0, i1, t0);
  and _i2 (i1, cin, t1);
  and _i3 (cin, i0, t2);
  or2 _i4 (t0, t1, t2, cout);
endmodule

module adder (a, b, sum);
  input [7:0] a, b;
  output [7:0] sum;
  wire cout;
  wire [7:0] q;
  fullAdder _fa1(a[0], b[0], 1'b0, sum[0], q[0]);
  fullAdder _fa2(a[1], b[1], q[0], sum[1], q[1]);
  fullAdder _fa3(a[2], b[2], q[1], sum[2], q[2]);
  fullAdder _fa4(a[3], b[3], q[2], sum[3], q[3]);
  fullAdder _fa5(a[4], b[4], q[3], sum[4], q[4]);
  fullAdder _fa6(a[5], b[5], q[4], sum[5], q[5]);
  fullAdder _fa7(a[6], b[6], q[5], sum[6], q[6]);
  fullAdder _fa8(a[7], b[7], q[6], sum[7], q[7]);
endmodule

module subtractor (a, b, sum);
  input [7:0] a, b;
  output [7:0] sum;
  wire [7:0] ib;
  wire [7:0] q;
  wire cout;
  invert _b1(ib[0], b[0]);
  invert _b2(ib[1], b[1]);
  invert _b3(ib[2], b[2]);
  invert _b4(ib[3], b[3]);
  invert _b5(ib[4], b[4]);
  invert _b6(ib[5], b[5]);
  invert _b7(ib[6], b[6]);
  invert _b8(ib[7], b[7]);
  fullAdder _fa1(a[0], ib[0], 1'b1, sum[0], q[0]);
  fullAdder _fa2(a[1], ib[1], q[0], sum[1], q[1]);
  fullAdder _fa3(a[2], ib[2], q[1], sum[2], q[2]);
  fullAdder _fa4(a[3], ib[3], q[2], sum[3], q[3]);
  fullAdder _fa5(a[4], ib[4], q[3], sum[4], q[4]);
  fullAdder _fa6(a[5], ib[5], q[4], sum[5], q[5]);
  fullAdder _fa7(a[6], ib[6], q[5], sum[6], q[6]);
  fullAdder _fa8(a[7], ib[7], q[6], sum[7], cout);
endmodule

module booth_mul (input wire [7:0] a, Q, input wire q0, input wire [7:0] m,
                 output reg [7:0] f, output reg [7:0] l, output reg cq);
  wire [7:0] addam, subam;
  adder add (a, m, addam);
  subtractor sub (a, m, subam);
  always @(*) begin
  if(Q[0] == q0) begin
  cq = Q[0];
  l = Q>>1;
  l[7] = a[0];
  f = a>>1;
  if(a[7] == 1)
  f[7] = 1;
  end
  else if(Q[0] == 1 && q0 == 0) begin
  cq = Q[0];
  l = Q>>1;
  l[7] = subam[0];
  f = subam>>1;
  if(subam[7] == 1)
  f[7] = 1;
  endl
  else begin
  cq = Q[0];
  l = Q>>1;
  l[7] = addam[0];
  f = addam>>1;
  if(addam[7] == 1)
  f[7] = 1;
  end
end
endmodule

module multiplier (input [7:0]a, b, output [15:0] sum);
  wire [7:0] Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
  wire [7:0] A0, A1, A2, A3, A4, A5, A6, A7;
  wire [7:0] q0;
  wire qout;

  booth_mul mul1(8'b00000000, a, 1'b0, b, A1, Q1, q0[1]);
  booth_mul mul2(A1, Q1, q0[1], b, A2, Q2, q0[2]);
  booth_mul mul3(A2, Q2, q0[2], b, A3, Q3, q0[3]);
  booth_mul mul4(A3, Q3, q0[3], b, A4, Q4, q0[4]);
  booth_mul mul5(A4, Q4, q0[4], b, A5, Q5, q0[5]);
  booth_mul mul6(A5, Q5, q0[5], b, A6, Q6, q0[6]);
  booth_mul mul7(A6, Q6, q0[6], b, A7, Q7, q0[7]);
  booth_mul mul8(A7, Q7, q0[7], b, sum[15:8], sum[7:0], qout);
endmodule
