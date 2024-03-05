module controller (
  input wire [2: 0] phase,
  input wire zero,
  input wire [2: 0] opcode,
  output reg sel,
  output reg rd,
  output reg ld_ir,
  output reg halt,
  output reg inc_pc,
  output reg ld_ac,
  output reg wr,
  output reg ld_pc,
  output reg data_e
);

  always @ (phase, zero, opcode) begin
    case (phase)
      3'b000: begin
        sel    = 1;
        rd     = 0;
        ld_ir  = 0;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;
      end
      3'b001: begin
        sel    = 1;
        rd     = 1;
        ld_ir  = 0;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;
      end
      3'b010: begin
        sel    = 1;
        rd     = 1;
        ld_ir  = 1;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;
      end
      3'b011: begin
        sel    = 1;
        rd     = 1;
        ld_ir  = 1;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;
      end
      3'b100: begin
        sel    = 0;
        rd     = 0;
        ld_ir  = 0;
        halt   = (opcode == 3'b000);
        inc_pc = 1;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;
      end
      3'b101: begin
        sel    = 0;
        rd     = (opcode >= 3'b010 && opcode <= 3'b101);
        ld_ir  = 0;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;
      end
      3'b110: begin
        sel    = 0;
        rd     = (opcode >= 3'b010 && opcode <= 3'b101);
        ld_ir  = 0;
        halt   = 0;
        inc_pc = (opcode == 3'b001 && zero);
        ld_ac  = 0;
        ld_pc  = (opcode == 3'b111);
        wr     = 0;
        data_e = (opcode == 3'b110);
      end
      3'b111: begin
        sel    = 0;
        rd     = (opcode >= 3'b010 && opcode <= 3'b101);
        ld_ir  = 0;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = (opcode >= 3'b010 && opcode <= 3'b101);
        ld_pc  = (opcode == 3'b111);
        wr     = (opcode == 3'b110);
        data_e = (opcode == 3'b110);
      end
    endcase
  end

endmodule
