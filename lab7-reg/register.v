module register #(parameter integer WIDTH = 8) (
  input wire [WIDTH-1:0] data_in,
  input wire load,
  input wire clk,
  input wire rst,
  output reg [WIDTH-1:0] data_out
);

  always @ (posedge clk) begin : BLK
    //integer temp;
    //if (load) temp = data_in;
    //if (rst) temp = 8'b0;

    //data_out <= temp;
    //
    if (load) data_out <= data_in;

    if (rst) data_out <= 0;
  end

endmodule
