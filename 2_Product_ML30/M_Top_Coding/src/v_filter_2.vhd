-------------------------------------------------------------------------------
--
-- Title       : v_filter_2
-- Design      : TestVHDL
-- Author      : urong9
-- Company     : bice
--
-------------------------------------------------------------------------------
--
-- File        : v_filter_2.vhd
-- Generated   : Mon Sep 17 14:30:45 2012
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {v_filter_2} architecture {rtl}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity v_filter_2 is
	generic(
		constant RESET_VALID : std_logic := '0';		-- 复位信号有效值
		constant RESET_VALUE : std_logic := '0';		-- 复位后的值
		constant SCALER_SIZE : integer := 8;			-- 滤波次数寄存器的位数
		constant SYNC_COUNT : integer := 2				-- 同步锁存拍数 
	);
	port(
		rst : in std_logic;            	-- 复位信号
		clk : in std_logic;            	-- 输入时钟
		clk_filter : in std_logic;		  	-- 滤波时钟, tick
		scaler : in std_logic_vector(SCALER_SIZE - 1 downto 0);	-- 滤波次数，滤波时间 = scaler * Period(clk_filter)，默认值为4
		signal_in : in std_logic; 			-- 输入信号
		
		signal_out : out std_logic        	-- 输出信号									 
	);
end v_filter_2;

architecture rtl of v_filter_2 is

constant ONES : std_logic_vector(SCALER_SIZE - 1 downto 0) := (others => '1');
constant MAX_TIMES : integer := CONV_INTEGER(ONES);
constant SCALER_DEFAULT : integer := 1;

signal s_signal_r : std_logic_vector(SYNC_COUNT downto 0);

signal s_scaler_data : integer range 0 to MAX_TIMES;
	
signal s_last_value : std_logic;
signal s_cnt : integer range 0 to MAX_TIMES;

begin

	s_scaler_data <= CONV_INTEGER(scaler);
	
	G_SYNC_COUNT_2 : if(SYNC_COUNT > 1) generate
	process(clk, rst)
	begin
		if(rst = RESET_VALID) then
			s_signal_r(SYNC_COUNT - 1 downto 0) <= (others => RESET_VALUE);
		elsif(clk'event and clk = '1') then
			s_signal_r(SYNC_COUNT - 1 downto 0) <= s_signal_r(SYNC_COUNT - 2 downto 0) & signal_in;
		end if;
	end process;
	s_signal_r(SYNC_COUNT) <= s_signal_r(SYNC_COUNT - 1);
	end generate;
	
	G_SYNC_COUNT_1 : if(SYNC_COUNT = 1) generate
	process(clk, rst)
	begin
		if(rst = RESET_VALID) then
			s_signal_r(SYNC_COUNT - 1 downto 0) <= (others => RESET_VALUE);
		elsif(clk'event and clk = '1') then
			s_signal_r(SYNC_COUNT - 1) <= signal_in;
		end if;
	end process;
	s_signal_r(SYNC_COUNT) <= s_signal_r(SYNC_COUNT - 1);
	end generate;
	
	G_SYNC_COUNT_0 : if(SYNC_COUNT = 0) generate
	s_signal_r(SYNC_COUNT) <= signal_in;
	end generate;
	
	process(clk ,rst)
	begin
		if(rst = RESET_VALID) then
			s_last_value <= RESET_VALUE;
			s_cnt <= 0;
			signal_out <= RESET_VALUE;
		elsif(clk'event and clk = '1') then
			if(clk_filter = '1') then
				s_last_value <= s_signal_r(SYNC_COUNT);
				
				if(s_last_value = s_signal_r(SYNC_COUNT)) then
					s_cnt <= s_cnt + 1;
				else
					s_cnt <= 0;
				end if;
			end if;
			
			if(s_cnt >= s_scaler_data) then
				signal_out <= s_last_value;
				s_cnt <= 0;
			end if;
		end if;
	end process;
end rtl;
