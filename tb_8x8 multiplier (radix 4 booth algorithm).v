module test(wire [15:0] z, reg [7:0] a, b);

multiplier mul(.a(a), .b(b), .c(z));

begin
end

$monitor($time, "multiplier: %d * %d = %d", a, b, z);
a = 8'b10001000; 
b = 8'b00101100;

endmodule;