module macish
(
	input [7:0] dataa,
	input [7:0] datab,
	input clk, aclr, clken, sload,
	output reg [15:0] adder_out
);

	// Declare registers and wires
	reg  [15:0] dataa_reg, datab_reg;
	reg  sload_reg;
	reg	 [15:0] old_result;
	wire [15:0] multa;

	// Store the results of the operations on the current data
	eightbitmultiplier MACISH(.i1(dataa_reg), .i2(datab_reg), .result(multa));
	// assign multa = dataa_reg * datab_reg;

	// Store the value of the accumulation (or clear it)
	always @ (adder_out, sload_reg)
	begin
		if (sload_reg)
			old_result <= 0;
		else
			old_result <= adder_out;
	end

	// Clear or update data, as appropriate
	always @ (posedge clk or posedge aclr)
	begin
		if (aclr)
		begin
			dataa_reg <= 0;
			datab_reg <= 0;
			sload_reg <= 0;
			adder_out <= 0;
		end

		else if (clken)
		begin
			dataa_reg <= dataa;
			datab_reg <= datab;
			sload_reg <= sload;
			adder_out <= old_result + multa;
		end
	end
endmodule

//============================================================================================
// LSM -> MSM
//--------------------------------------------------------------------------------------------
// ISH_1 | M4 M1 M1 M1        | M1 M1 M4 M1        | M1 M1 M1 M1        | M3 M4 M1 M4        |
//       | fourbitmultiplier0 | fourbitmultiplier1 | fourbitmultiplier2 | fourbitmultiplier3 |
//============================================================================================

module eightbitmultiplier
(
	input [7:0] i1,
	input [7:0] i2,
	output [15:0] result
);
wire [7:0] temp1;
wire [7:0] temp2;
wire [7:0] temp3;
wire [7:0] temp4;

fourbitmultiplier0 M1_4(.i1(i1[3:0]), .i2(i2[3:0]), .result(temp1)); //LSM
fourbitmultiplier1 M2_4(.i1(i1[3:0]), .i2(i2[7:4]), .result(temp2)); //MidSM
fourbitmultiplier2 M3_4(.i1(i1[7:4]), .i2(i2[3:0]), .result(temp3)); //MidSM
fourbitmultiplier3 M4_4(.i1(i1[7:4]), .i2(i2[7:4]), .result(temp4)); //MSM


assign result = temp1 + (temp2 << 4) + (temp3 << 4) + (temp4 << 8);
endmodule

//--------------------------------------------------------------------------------------------


module fourbitmultiplier0
(
	input [3:0] i1,
	input [3:0] i2,
	output [7:0] result
);

wire [3:0] temp1;
wire [3:0] temp2;
wire [3:0] temp3;
wire [3:0] temp4;

M4 M1_2(.i1(i1[1:0]), .i2(i2[1:0]), .result(temp1)); //LSM
M1 M2_2(.i1(i1[1:0]), .i2(i2[3:2]), .result(temp2)); //MidSM
M1 M3_2(.i1(i1[3:2]), .i2(i2[1:0]), .result(temp3)); //MidSM
M1 M4_2(.i1(i1[3:2]), .i2(i2[3:2]), .result(temp4)); //MSM

assign result = temp1 + (temp2 << 2) + (temp3 << 2) + (temp4 << 4);
endmodule

module fourbitmultiplier1
(
	input [3:0] i1,
	input [3:0] i2,
	output [7:0] result
);
wire [3:0] temp1;
wire [3:0] temp2;
wire [3:0] temp3;
wire [3:0] temp4;

M1 M1_2(.i1(i1[1:0]), .i2(i2[1:0]), .result(temp1)); //LSM
M1 M2_2(.i1(i1[1:0]), .i2(i2[3:2]), .result(temp2)); //MidSM
M4 M3_2(.i1(i1[3:2]), .i2(i2[1:0]), .result(temp3)); //MidSM
M1 M4_2(.i1(i1[3:2]), .i2(i2[3:2]), .result(temp4)); //MSM

assign result = temp1 + (temp2 << 2) + (temp3 << 2) + (temp4 << 4);

endmodule

module fourbitmultiplier2
(
	input [3:0] i1,
	input [3:0] i2,
	output [7:0] result
);

wire [3:0] temp1;
wire [3:0] temp2;
wire [3:0] temp3;
wire [3:0] temp4;

M1 M1_2(.i1(i1[1:0]), .i2(i2[1:0]), .result(temp1)); //LSM
M1 M2_2(.i1(i1[1:0]), .i2(i2[3:2]), .result(temp2)); //MidSM
M1 M3_2(.i1(i1[3:2]), .i2(i2[1:0]), .result(temp3)); //MidSM
M1 M4_2(.i1(i1[3:2]), .i2(i2[3:2]), .result(temp4)); //MSM

assign result = temp1 + (temp2 << 2) + (temp3 << 2) + (temp4 << 4);
endmodule

module fourbitmultiplier3
(
	input [3:0] i1,
	input [3:0] i2,
	output [7:0] result
);
wire [3:0] temp1;
wire [3:0] temp2;
wire [3:0] temp3;
wire [3:0] temp4;

M3 M1_2(.i1(i1[1:0]), .i2(i2[1:0]), .result(temp1)); //LSM
M4 M2_2(.i1(i1[1:0]), .i2(i2[3:2]), .result(temp2)); //MidSM
M1 M3_2(.i1(i1[3:2]), .i2(i2[1:0]), .result(temp3)); //MidSM
M4 M4_2(.i1(i1[3:2]), .i2(i2[3:2]), .result(temp4)); //MSM

assign result = temp1 + (temp2 << 2) + (temp3 << 2) + (temp4 << 4);
endmodule

//-------------------------------------------------------------------

module M1
(
	input [1:0] i1,
	input [1:0] i2,
	output [3:0] result
);
wire [3:0] temp;

assign temp[0] = i1[0] & i2[1];
assign temp[1] = i1[1] & i2[0];
assign temp[2] = temp[0] & temp[1];
assign temp[3] = i1[1] & i2[1];

assign result  = {temp[2] , (temp[2] ^ temp[3]), (temp[0] ^ temp[1]), temp[2]};

endmodule

//-------------------------------------------------------------------

module M3
(
	input [1:0] i1,
	input [1:0] i2,
	output [3:0] result
);

reg [3:0] temp;

always @ ( i1, i2 ) begin
	temp[0]  <= i1[0] & i2[0];
	temp[1]  <= i1[0] & i2[1];
	temp[2]  <= i1[1] & i2[0];
	temp[3]  <= i1[1] & i2[1];
end
assign result   = {(temp[3] & temp[0]) , (temp[3] & ( ~ temp[0])) , (temp[1] | temp[2]) , temp[0]};

endmodule

//-------------------------------------------------------------------

module M4
(
	input [1:0] i1,
	input [1:0] i2,
	output [3:0] result
);
wire [9:0] temp;

assign temp[0]  = i1[1] & i2[1]; //AC −> O2
assign temp[1]  = i1[0] & i2[0]; //DB −> O0
assign temp[6]  = i2[0] & ~ i1[0];
assign temp[2]  = temp[6] & i1[1]; //DB‘A
assign temp[7]  = i2[1] & ~ i1[1];
assign temp[3]  = temp[7] & i1[0]; //CA‘B
assign temp[8]  = temp[1] & i1[1];
assign temp[4]  = temp[8] & ~ i2[1]; //DBAC‘
assign temp[9]  = temp[1] & ~ i1[1];
assign temp[5]  = temp[9] & i2[1]; //DBA‘C

assign result   = {(temp[0] & temp[1]) , (temp[0]) , ( temp[2] | temp[3] | temp[4] | temp[5]) , (temp[1])};


endmodule
