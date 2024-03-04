module alu #(parameter integer WIDTH=8) (
  input wire [WIDTH - 1: 0] in_a,
  input wire [WIDTH - 1: 0] in_b,
  input wire [2 : 0] opcode,
  output reg [WIDTH - 1: 0] alu_out,
  output wire a_is_zero
);

  assign a_is_zero = (in_a === 0);

  always @(in_a, in_b, opcode) begin
    if (opcode === 3'b000) alu_out = in_a;
    else if (opcode === 3'b001) alu_out = in_a;
    else if (opcode === 3'b010) alu_out = in_a + in_b;
    else if (opcode === 3'b011) alu_out = in_a & in_b;
    else if (opcode === 3'b100) alu_out = in_a ^ in_b;
    else if (opcode === 3'b101) alu_out = in_b;
    else if (opcode === 3'b110) alu_out = in_a;
    else if (opcode === 3'b111) alu_out = in_a;
  end

endmodule
