`default_nettype none
`timescale 1ns/ 100ps

module counter #(parameter WIDTH = 5) (
  input wire [WIDTH-1:0] cnt_in,
  input wire enab,
  input wire load,
  input wire clk,
  input wire rst,
  output reg [WIDTH-1:0] cnt_out
);

  always @ (posedge clk) begin
    if (rst) begin
      cnt_out <= 0;
    end else if (load) begin
      cnt_out <= cnt_in;
    end else if (enab) begin
      cnt_out <= cnt_out + 1;
    end
  end

endmodule
