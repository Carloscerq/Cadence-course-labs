module test_cpu();

  reg clk = 1;
  reg rst = 0;
  wire halt;

  cpu cpu_inst(clk, rst, halt);

  always begin
    #5 clk = ~clk;
  end

  task init();
    begin
      $display("Hello! Init cpu test....");
      $display("Choose the file with:");
      $display("deposit test_cpu.run.number n; task test_cpu.run; run");
    end 
  endtask

  task reset();
    begin
      $display("rst = 1...");
      @(negedge clk) rst = 1;
      $display("rst = 0...");
      @(negedge clk) rst = 0;
      $display(cpu_inst.pc);
    end
  endtask

  initial begin
    $display("Running setup...");
    reset();

    init();
    $stop;
  end

  task run (
    input [7:0] number
  );
    reg [9*8:1] testfile;
    begin
      testfile = { "PROG", 8'h30+number, ".txt" };
      $readmemb( testfile, cpu_inst.mem );
      reset();
    end
  endtask

  task endtst();
    reg [4: 0] cmp_num;
    begin
      case (run.number)
        1: cmp_num = 5'h17;
        2: cmp_num = 5'h17;
        3: cmp_num = 5'h17;
      endcase
      if (cmp_num === halt) $display("SUCESS");
      else $display("ERROR");
    end
  endtask

  always @(halt)
  begin
    endtst();
    init();
  end

endmodule
