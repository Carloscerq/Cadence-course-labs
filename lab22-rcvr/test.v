`timescale 1ns / 1 ns
`define CLOCK_TIME 5

module test;
  reg SCLK;
  reg RST;
  reg SDATA;
  reg ACK;
  wire READY;
  wire [7:0] DOUT;

  localparam integer HEADER_SIZE = 8;
  localparam integer HEADER_VALUE = 8'ha5;
  localparam integer BODY_SIZE = 16;

  rcvr #(
    .HEADER_SIZE(HEADER_SIZE),
    .HEADER_VALUE(HEADER_VALUE),
    .BODY_SIZE(BODY_SIZE)
  ) rcv1(
    .SCLK(SCLK),
    .RST(RST),
    .SDATA(SDATA),
    .ACK(ACK),
    .READY(READY),
    .DOUT(DOUT)
  );

  integer frames_sent=0, frames_rcvd=0 ;
  reg [15:0] BODY1, BODY2, BODY3, BODY4 ;

  always begin
    SCLK = 1; #1; SCLK = 0; #1;
  end

  initial begin : STIM
    reg [0:255] stream;
    integer bit;
    BODY1 = $random;
    BODY2 = $random;
    BODY3 = $random;
    BODY4 = $random;
    stream = { 32'h0, HEADER_VALUE, BODY1, 16'h0, HEADER_VALUE, BODY2,
               64'h0, HEADER_VALUE, BODY3, 32'h0, HEADER_VALUE, BODY4, 16'h0 } ;

    $timeformat ( -9, 0, "ns", 5 ) ;
    $display("here");
    @(negedge SCLK) RST <= 1 ;
    @(negedge SCLK) RST <= 0 ; SDATA <= 0 ;
    for (bit=1; bit<=256; bit=bit+1)
      @(negedge SCLK) SDATA <= stream[bit] ;
    @(negedge SCLK);
    $display ( "%t: Stimulus process complete", $time ) ;
    frames_sent = 4 ;
    $display ( "%t: frames_sent=%0d, frames_rcvd=%0d",
               $time, frames_sent, frames_rcvd ) ;

    if ( frames_sent !== frames_rcvd )
      $display ("ERROR: frames_sent=%0d, frames_rcvd=%0d",
                frames_sent, frames_rcvd ) ;
    else
      $display ("SUCCESS: frames_sent=%0d, frames_rcvd=%0d",
                 frames_sent, frames_rcvd ) ;
    $finish;
  end

  initial begin : RESPONSE
    reg [15:0] data_rcvd, data_array[0:3] ;
    integer frame ;
    @(negedge SCLK);
    ACK <= 0 ;
    data_array[0] = BODY1 ;
    data_array[1] = BODY2 ;
    data_array[2] = BODY3 ;
    data_array[3] = BODY4 ;
    for (frame=1; frame<=4; frame=frame+1)
      begin
        @(posedge READY);
        @(negedge SCLK) ACK <= 1 ; data_rcvd = DOUT ;
        @(negedge SCLK) ACK <= 1 ; data_rcvd = data_rcvd << 8 | DOUT ;
        @(negedge SCLK) ACK <= 0 ;
        $display ( "%t: Rcvd data %h", $time, data_rcvd ) ;
        if ( data_rcvd !== data_array[frame] )
          begin
            $display ( "ERROR: Want data %h", data_array[frame] ) ;
            $finish;
          end
        frames_rcvd = frames_rcvd + 1 ;
      end
    $display ( "%t: Response process complete", $time ) ;
  end

endmodule
