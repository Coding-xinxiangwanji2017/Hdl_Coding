-- megafunction wizard: %PARALLEL_ADD%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: parallel_add 

-- ============================================================
-- File Name: M_ParAdd.vhd
-- Megafunction Name(s):
-- 			parallel_add
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 17.1.0 Build 590 10/25/2017 SJ Standard Edition
-- ************************************************************


--Copyright (C) 2017  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel FPGA IP License Agreement, or other applicable license
--agreement, including, without limitation, that your use is for
--the sole purpose of programming logic devices manufactured by
--Intel and sold by Intel or its authorized distributors.  Please
--refer to the applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY M_ParAdd IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data3x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END M_ParAdd;


ARCHITECTURE SYN OF m_paradd IS

--	type ALTERA_MF_LOGIC_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sub_wire1	: ALTERA_MF_LOGIC_2D (3 DOWNTO 0, 1 DOWNTO 0);
	SIGNAL sub_wire2	: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sub_wire3	: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sub_wire4	: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sub_wire5	: STD_LOGIC_VECTOR (4 DOWNTO 0);

BEGIN
	sub_wire4    <= data0x(1 DOWNTO 0);
	sub_wire3    <= data1x(1 DOWNTO 0);
	sub_wire2    <= data2x(1 DOWNTO 0);
	sub_wire0    <= data3x(1 DOWNTO 0);
	sub_wire1(3, 0)    <= sub_wire0(0);
	sub_wire1(3, 1)    <= sub_wire0(1);
	sub_wire1(2, 0)    <= sub_wire2(0);
	sub_wire1(2, 1)    <= sub_wire2(1);
	sub_wire1(1, 0)    <= sub_wire3(0);
	sub_wire1(1, 1)    <= sub_wire3(1);
	sub_wire1(0, 0)    <= sub_wire4(0);
	sub_wire1(0, 1)    <= sub_wire4(1);
	result    <= sub_wire5(4 DOWNTO 0);

	parallel_add_component : parallel_add
	GENERIC MAP (
		msw_subtract => "NO",
		pipeline => 0,
		representation => "UNSIGNED",
		result_alignment => "LSB",
		shift => 0,
		size => 4,
		width => 2,
		widthr => 5,
		lpm_type => "parallel_add"
	)
	PORT MAP (
		data => sub_wire1,
		result => sub_wire5
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX 10"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: MSW_SUBTRACT STRING "NO"
-- Retrieval info: CONSTANT: PIPELINE NUMERIC "0"
-- Retrieval info: CONSTANT: REPRESENTATION STRING "UNSIGNED"
-- Retrieval info: CONSTANT: RESULT_ALIGNMENT STRING "LSB"
-- Retrieval info: CONSTANT: SHIFT NUMERIC "0"
-- Retrieval info: CONSTANT: SIZE NUMERIC "4"
-- Retrieval info: CONSTANT: WIDTH NUMERIC "2"
-- Retrieval info: CONSTANT: WIDTHR NUMERIC "5"
-- Retrieval info: USED_PORT: data0x 0 0 2 0 INPUT NODEFVAL "data0x[1..0]"
-- Retrieval info: USED_PORT: data1x 0 0 2 0 INPUT NODEFVAL "data1x[1..0]"
-- Retrieval info: USED_PORT: data2x 0 0 2 0 INPUT NODEFVAL "data2x[1..0]"
-- Retrieval info: USED_PORT: data3x 0 0 2 0 INPUT NODEFVAL "data3x[1..0]"
-- Retrieval info: USED_PORT: result 0 0 5 0 OUTPUT NODEFVAL "result[4..0]"
-- Retrieval info: CONNECT: @data 1 0 2 0 data0x 0 0 2 0
-- Retrieval info: CONNECT: @data 1 1 2 0 data1x 0 0 2 0
-- Retrieval info: CONNECT: @data 1 2 2 0 data2x 0 0 2 0
-- Retrieval info: CONNECT: @data 1 3 2 0 data3x 0 0 2 0
-- Retrieval info: CONNECT: result 0 0 5 0 @result 0 0 5 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL M_ParAdd.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL M_ParAdd.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL M_ParAdd.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL M_ParAdd.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL M_ParAdd_inst.vhd FALSE
-- Retrieval info: LIB_FILE: altera_mf
