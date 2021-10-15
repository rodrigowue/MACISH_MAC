// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module mac_tb;

  logic [7:0] dataa;
	logic [7:0] datab;
	logic [15:0] adder_out;
  logic clk, aclr, clken, sload;
  integer seed,i,j,exact;
  //reset Generation
  initial begin
    clk = 0;
    aclr = 1;
    #1 aclr = 0;
    sload=0;
    $dumpfile("macish.vcd");
		$dumpvars(0,mac_tb);
    #1 dataa=4;
    datab=4;
    clken=1;
    sload=1;
    #0.5 sload=0;
    $display("A, B, Approx Result, Exact Result");
      for (i=0; i<1000000; i=i+1)
        begin
           clken=1;
           dataa=$urandom%255;
           datab=$urandom%255;
           exact=dataa*datab;
           sload=1;
           #2 sload=0;
           #1 clken=0;
           #1 $display("%d, %d, %d, %d",dataa,datab,adder_out, exact);
    end
    $finish;
  end

  always
  begin
    #1 clk = 1;
    #1 clk = 0;
  end
  //DUT instance, interface signals are connected to the DUT ports
  macish DUT (.dataa(dataa), .datab(datab), .adder_out(adder_out), .clk(clk), .aclr(aclr), .clken(clken), .sload(sload));

endmodule
