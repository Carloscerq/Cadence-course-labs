module memory #(
  parameter AWIDTH = 5,
  parameter DWIDTH = 8
)(
  input wire clk,
  input wire wr,
  input wire rd,
  input wire [AWIDTH-1:0] addr,
  inout wire [DWIDTH-1:0] data
);

  // Use 1<<AWIDTH to calculate the number of memory locations
  // 1<<AWIDTH is equivalent to 2^AWIDTH
  reg [DWIDTH-1:0] mem[0:(1<<AWIDTH)-1];

  // Data output assignment
  //
  // If rd is high, assign data = mem[addr]
  // If rd is low, assign data = {DWIDTH{1'bz}}
  // This is equivalent to assigning data = 8'bzzzzzzzz
  // So if rd is false, the wr wire will win
  assign data = (rd) ? mem[addr] : {DWIDTH{1'bz}};

  always @(posedge clk) begin
    if (wr) begin
      mem[addr] <= data;
    end
  end

endmodule

