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
// CREATED		"Wed Feb 05 14:28:08 2025"

module read_data(
	Addr,
	LoadType,
	ReadData,
	ReadDataOut
);


input wire	[31:0] Addr;
input wire	[2:0] LoadType;
input wire	[31:0] ReadData;
output wire	[31:0] ReadDataOut;

wire	[7:0] SelectedByte;
wire	[15:0] SelectedHW;
wire	[31:0] SYNTHESIZED_WIRE_0;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	[31:0] SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	[31:0] SYNTHESIZED_WIRE_4;
wire	[31:0] SYNTHESIZED_WIRE_5;





sign_extend	b2v_ByteSE(
	.a(SelectedByte),
	.SignExt(SYNTHESIZED_WIRE_1));
	defparam	b2v_ByteSE.SIGNS = 24;
	defparam	b2v_ByteSE.WIDTH = 8;


mux4	b2v_ByteSelect(
	.d0(ReadData[7:0]),
	.d1(ReadData[15:8]),
	.d2(ReadData[23:16]),
	.d3(ReadData[31:24]),
	.sel(Addr[1:0]),
	.y(SelectedByte));
	defparam	b2v_ByteSelect.WIDTH = 8;


zero_extend	b2v_ByteZE(
	.a(SelectedByte),
	.ZeroExt(SYNTHESIZED_WIRE_0));
	defparam	b2v_ByteZE.WIDTH = 8;
	defparam	b2v_ByteZE.ZEROS = 24;


mux3	b2v_ExtendedByteSelect(
	.d0(ReadData),
	.d1(SYNTHESIZED_WIRE_0),
	.d2(SYNTHESIZED_WIRE_1),
	.sel(LoadType[1:0]),
	.y(SYNTHESIZED_WIRE_4));
	defparam	b2v_ExtendedByteSelect.WIDTH = 32;


mux2	b2v_ExtendedHWSelect(
	.sel(LoadType[0]),
	.d0(SYNTHESIZED_WIRE_2),
	.d1(SYNTHESIZED_WIRE_3),
	.y(SYNTHESIZED_WIRE_5));
	defparam	b2v_ExtendedHWSelect.WIDTH = 32;


sign_extend	b2v_HWSE(
	.a(SelectedHW),
	.SignExt(SYNTHESIZED_WIRE_3));
	defparam	b2v_HWSE.SIGNS = 16;
	defparam	b2v_HWSE.WIDTH = 16;


mux2	b2v_HWSelect(
	.sel(Addr[1]),
	.d0(ReadData[15:0]),
	.d1(ReadData[31:16]),
	.y(SelectedHW));
	defparam	b2v_HWSelect.WIDTH = 16;


zero_extend	b2v_HWZE(
	.a(SelectedHW),
	.ZeroExt(SYNTHESIZED_WIRE_2));
	defparam	b2v_HWZE.WIDTH = 16;
	defparam	b2v_HWZE.ZEROS = 16;


mux2	b2v_OutputSelect(
	.sel(LoadType[2]),
	.d0(SYNTHESIZED_WIRE_4),
	.d1(SYNTHESIZED_WIRE_5),
	.y(ReadDataOut));
	defparam	b2v_OutputSelect.WIDTH = 32;


endmodule
