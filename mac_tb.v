// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module mac_tb;

  logic [7:0] dataa;
	logic [7:0] datab;
	logic [15:0] adder_out;
  logic clk, aclr, clken, sload;
  integer seed,i,j,exact;
  real relative_error;
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
    $display("A, B, Approx Result, Exact Result, Relative Error [\%]");
      for (i=0; i<10000; i=i+1)
        begin
           clken=1;
           dataa=$urandom%255;
           datab=$urandom%255;
           exact=dataa*datab;
           sload=1;
           #2 sload=0;
           #1 clken=0;
	   if (exact > adder_out) begin
		   relative_error = -(adder_out-exact);
	   	   relative_error = (relative_error/exact)*100;
	   end else begin
		   relative_error = (adder_out-exact);
	   	   relative_error = (relative_error/exact)*100;
	   end
	   #1 $display("%d, %d, %d, %d, %f",dataa,datab,adder_out, exact, relative_error);
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
