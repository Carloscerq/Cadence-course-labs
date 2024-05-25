`timescale 1ns / 1 ns
`define CLOCK_TIME 5

module test;
  reg sclk = 1, rst, sdata, ack;
  wire ready;
  wire [7:0] dout;

  localparam BODY_SIZE = 16;
  localparam HEADER_SIZE = 8;
  localparam HEADER_VALUE = 8'hA5;


  rcvr #(.BODY_SIZE(BODY_SIZE),
    .HEADER_SIZE(HEADER_SIZE),
    .HEADER_VALUE(HEADER_VALUE)) r1 (
    .SCLK(sclk),
    .RST(rst),
    .SDATA(sdata),
    .ACK(ack),
    .READY(ready),
    .DOUT(dout)
  );

  always begin
    #(`CLOCK_TIME) sclk = ~sclk;
  end

  reg [BODY_SIZE-1:0] body1, body2, body3, body4;
  integer f_sent=0, f_rcvd=0;

  $display("Initialising the testbench...");
  $timeformat(-9, 1, " ns", 10);

  initial begin : STIM
    reg [255 : 0] stream;
    integer bit;
    body1 = $random;
    body2 = $random;
    body3 = $random;
    body4 = $random;
    stream = { 32'h0, HEADER_VALUE, body1,
               16'h0, HEADER_VALUE, body2,
               64'h0, HEADER_VALUE, body3,
               32'h0, HEADER_VALUE, body4,
               16'h0 };

    @(negedge sclk) rst <= 1;
    @(negedge sclk) rst <= 0; sdata <= 0;
    for (bit = 1; bit < 256; bit = bit + 1)
      @(negedge sclk) sdata <= stream[bit];
    @(negedge sclk);
    $display("%t: Stimulus complete", $time);
    f_sent = 4;
    $display("Sent %d frames", f_sent);
    $display("frams rcvd: %d", f_rcvd);

    (f_rcvd == f_sent) ? $display("Test passed") : $display("Test failed");

    $finish;
  end


  initial begin : RESP
    reg [BODY_SIZE-1:0] data_rcvd, data_rcvd_arr [0:3];
    integer i;
    @(negedge sclk);
    ack <= 0;
    data_rcvd_arr[0] = body1;
    data_rcvd_arr[1] = body2;
    data_rcvd_arr[2] = body3;
    data_rcvd_arr[3] = body4;
    for (i = 1; i <= 4; i = i + 1) begin
      @(posedge ready);
      @(negedge sclk) ack <= 1; data_rcvd <= dout;
      @(negedge sclk) ack <= 1; data_rcvd <= data_rcvd << 8 | dout;
      @(negedge sclk) ack <= 0;
      $display("%t: Frame %d received", $time, data_rcvd);
      if (data_rcvd != data_rcvd_arr[i]) begin
        $display("Frame %d mismatch", i);
        $display("Expected: %h", data_rcvd_arr[i-1]);
        $display("Received: %h", data_rcvd);
        $finish;
      end
      f_rcvd = f_rcvd + 1;
    end
    $display("%t: Response complete", $time);
  end
endmodule
