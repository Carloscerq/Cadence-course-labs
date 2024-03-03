module multiplexor(
  input wire [4:0] in0,
  input wire [4:0] in1,
  input wire sel,
  output reg [4:0] mux_out
);

  always @ * begin
    if (sel == 1'b0) mux_out <= in0;
    else mux_out <= in1;
  end

endmodule
