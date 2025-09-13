// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
// CREATED		"Wed Feb 26 15:49:22 2025"

module write_data(
	Addr,
	rd2,
	ReadData,
	StoreType,
	WriteData
);


input wire	[31:0] Addr;
input wire	[31:0] rd2;
input wire	[31:0] ReadData;
input wire	[1:0] StoreType;
output wire	[31:0] WriteData;

wire	[31:0] Byte0;
wire	[31:0] Byte1;
wire	[31:0] Byte2;
wire	[31:0] Byte3;
wire	[31:0] HW0;
wire	[31:0] HW1;
wire	[31:0] SYNTHESIZED_WIRE_0;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	[31:0] SYNTHESIZED_WIRE_2;




assign	Byte0[7:0] = rd2[7:0];


assign	Byte2[15:0] = ReadData[15:0];


assign	Byte3[23:0] = ReadData[23:0];


assign	Byte3[31:24] = rd2[7:0];


assign	HW0[31:16] = ReadData[31:16];


assign	HW0[15:0] = rd2[15:0];


assign	HW1[31:16] = rd2[15:0];


assign	HW1[15:0] = ReadData[15:0];


assign	Byte0[31:8] = ReadData[31:8];


assign	Byte1[31:16] = ReadData[31:16];


assign	Byte1[15:8] = rd2[7:0];


assign	Byte1[7:0] = ReadData[7:0];


assign	Byte2[31:24] = ReadData[31:24];


assign	Byte2[23:16] = rd2[7:0];



mux4	b2v_SelectByte(
	.d0(Byte0),
	.d1(Byte1),
	.d2(Byte2),
	.d3(Byte3),
	.sel(Addr[1:0]),
	.y(SYNTHESIZED_WIRE_2));
	defparam	b2v_SelectByte.WIDTH = 32;


mux2	b2v_SelectHW(
	.sel(Addr[1]),
	.d0(HW0),
	.d1(HW1),
	.y(SYNTHESIZED_WIRE_1));
	defparam	b2v_SelectHW.WIDTH = 32;


mux2	b2v_SelectOutput(
	.sel(StoreType[1]),
	.d0(SYNTHESIZED_WIRE_0),
	.d1(SYNTHESIZED_WIRE_1),
	.y(WriteData));
	defparam	b2v_SelectOutput.WIDTH = 32;


mux2	b2v_SelectWord(
	.sel(StoreType[0]),
	.d0(rd2),
	.d1(SYNTHESIZED_WIRE_2),
	.y(SYNTHESIZED_WIRE_0));
	defparam	b2v_SelectWord.WIDTH = 32;


endmodule
