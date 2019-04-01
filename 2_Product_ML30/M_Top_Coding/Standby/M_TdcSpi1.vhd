--------------------------------------------------------------------------------
--
--      ******** *           * *****           ***** *****   ***   **
--             *  *         *    *            *        *    *   *  * *
--            *    *       *     *           *         *   *     * *  *
--           *      *     *      *          *          *   *     * *   *   *
--         *         *   *       *         *           *   *     *      *  *
--       *            * *        *        *            *    *   *        * *
--      ********       *       ***** *****           *****   ***          **
--
--------------------------------------------------------------------------------
-- 版    权  :  ZVISION
-- 文件名称  :  M_TdcSpi1.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/10/09
-- 功能简述  :  TDC_GPX2 SPI Interface
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--library altera;
--use altera.altera_primitives_components.all;

entity M_TdcSpi1 is
    generic (
		PrSl_Sim_c                      : integer := 1                           -- Simulation
    );
    port (
		--------------------------------
		-- Clk & Reset
		--------------------------------
		CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
		CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz

		--------------------------------
		-- Start Trig
		--------------------------------
		CpSl_StartTrig_i				: in  std_logic;						-- Start Trig
        CpSl_SoftRstTrig_i              : in  std_logic;                        -- Reset Trig
        
        --------------------------------
		-- Config End Trig
		--------------------------------
        CpSl_CfgEnd1Trig_o              : out std_logic;                        -- Config End Trig
        
		-- SPI_IF
		CpSl_SSN1_o						: out std_logic;						-- TDC_GPX2_SSN
		CpSl_SClk1_o					: out std_logic;						-- TDC_GPX2_SClk
		CpSl_MOSI1_o					: out std_logic;						-- TDC_GPX2_MOSI
		CpSl_MISO1_i					: in  std_logic 						-- TDC_GPX2_MISO
	);
end M_TdcSpi1;

architecture arch_M_TdcSpi of M_TdcSpi1 is
	----------------------------------------------------------------------------
    -- Constant Describe
    ----------------------------------------------------------------------------
    ------------------------------------
	-- Constant_State
	------------------------------------
    constant PrSv_Idle_c                : std_logic_vector( 4 downto 0) := "00000"; -- Idle
    constant PrSv_SSNTrig_c             : std_logic_vector( 4 downto 0) := "00001"; -- SSN_Trig
    constant PrSv_SSNHold_c             : std_logic_vector( 4 downto 0) := "00010"; -- SSN_Hold
    constant PrSv_SSNWait_c             : std_logic_vector( 4 downto 0) := "00011"; -- SSN_Wait
    constant PrSv_Opcode_c              : std_logic_vector( 4 downto 0) := "00100"; -- Send_Opcode
    constant PrSv_Dly120us_c            : std_logic_vector( 4 downto 0) := "00101"; -- Delay 120 us
    constant PrSv_CmpCfgCnt_c           : std_logic_vector( 4 downto 0) := "00110"; -- Compare Config Data
    constant PrSv_WrData_c              : std_logic_vector( 4 downto 0) := "00111"; -- Write Data
    constant PrSv_Wait120us_c           : std_logic_vector( 4 downto 0) := "01000"; -- wait 120 us
    constant PrSv_WrRegCnt_c            : std_logic_vector( 4 downto 0) := "01001"; -- Write Reg Cnt
    constant PrSv_CmpWrDataCnt_c        : std_logic_vector( 4 downto 0) := "01010"; -- Compare Write Data Cnt
    constant PrSv_RdWait_c              : std_logic_vector( 4 downto 0) := "01100"; -- Read 120 us
    constant PrSv_RdDataNum_c           : std_logic_vector( 4 downto 0) := "01110"; -- Compare Num
    constant PrSv_CheckData_c           : std_logic_vector( 4 downto 0) := "01111"; -- Compare Data
    constant PrSv_Stop_c                : std_logic_vector( 4 downto 0) := "10000"; -- End
    constant PrSv_CheckFail_c           : std_logic_vector( 4 downto 0) := "10001"; -- Check_Failed
    constant PrSv_DelayTime_c           : std_logic_vector( 4 downto 0) := "10010"; -- Delay_Time
    
    ------------------------------------
	-- TDC_GPX2 Interface
	------------------------------------
	-- Address_data
    constant PrSv_Addr0_c				: std_logic_vector( 7 downto 0) := x"B3";	-- Address_0_Data
    constant PrSv_Addr1_c				: std_logic_vector( 7 downto 0) := x"2F";	-- Address_1_Data
    constant PrSv_Addr2_c				: std_logic_vector( 7 downto 0) := x"0B";	-- Address_2_Data
    constant PrSv_Addr3_c				: std_logic_vector( 7 downto 0) := x"20";	-- Address_3_Data
    constant PrSv_Addr4_c				: std_logic_vector( 7 downto 0) := x"4E";	-- Address_4_Data
    constant PrSv_Addr5_c				: std_logic_vector( 7 downto 0) := x"00";	-- Address_5_Data
    constant PrSv_Addr6_c				: std_logic_vector( 7 downto 0) := x"C0";	-- Address_6_Data
    constant PrSv_Addr7_c				: std_logic_vector( 7 downto 0) := x"53";	-- Address_7_Data
    constant PrSv_Addr8_c				: std_logic_vector( 7 downto 0) := x"A1";	-- Address_8_Data
    constant PrSv_Addr9_c				: std_logic_vector( 7 downto 0) := x"13";	-- Address_9_Data
    constant PrSv_Addr10_c				: std_logic_vector( 7 downto 0) := x"00";	-- Address_10_Data
    constant PrSv_Addr11_c				: std_logic_vector( 7 downto 0) := x"0A";	-- Address_11_Data
    constant PrSv_Addr12_c				: std_logic_vector( 7 downto 0) := x"CC";	-- Address_12_Data
    constant PrSv_Addr13_c				: std_logic_vector( 7 downto 0) := x"CC";	-- Address_13_Data
    constant PrSv_Addr14_c				: std_logic_vector( 7 downto 0) := x"F1";	-- Address_14_Data
    constant PrSv_Addr15_c				: std_logic_vector( 7 downto 0) := x"7D";	-- Address_15_Data
    constant PrSv_Addr16_c				: std_logic_vector( 7 downto 0) := x"00";	-- Address_16_Data(LVDS)
    
    -- OPCODE
    constant PrSv_PowRst_c				: std_logic_vector( 7 downto 0) := x"30";	-- Power Reset
    constant PrSv_WrConfig_c			: std_logic_vector( 7 downto 0) := x"80";	-- Write Configuration
    constant PrSv_Init_c				: std_logic_vector( 7 downto 0) := x"18";	-- Initializa Chip and measurement
    constant PrSv_RdConfig_c			: std_logic_vector( 7 downto 0) := x"40";	-- Read Configuration

    constant PrSv_SSNCnt_c				: std_logic_vector( 1 downto 0) := "10";	-- SSN wait 1 Clk
    constant PrSv_RealWaitTime_c        : std_logic_vector(15 downto 0) := x"12BF"; -- 150 us(4800_Clk)
--    constant PrSv_RealWaitTime_c        : std_logic_vector(15 downto 0) := x"0010"; -- 150 us(4800_Clk)
    constant PrSv_SimWaitTime_c         : std_logic_vector(15 downto 0) := x"0010"; -- 100 ns(4_Clk)
    constant PrSv_DataDlyTime_c         : std_logic_vector(15 downto 0) := x"0FC7"; -- 101 us(4040_Clk)
    
    ----------------------------------------------------------------------------
    -- Signal Describe
    ----------------------------------------------------------------------------
    signal PrSv_CmdState_s				: std_logic_vector(  4 downto 0);		-- Init TDC_GPX2_State
    signal PrSl_StartTrigDly1_s         : std_logic;                            -- TDC Start Trig
    signal PrSl_StartTrig_s				: std_logic;		 					-- State Start Trig
    signal PrSv_SSNTrigCnt_s            : std_logic_vector(  3 downto 0);       -- SSNTrig_Cnt
    signal PrSv_SSNHigh_s				: std_logic_vector(  1 downto 0);		-- SSN High
    signal PrSv_SSNWaite_s				: std_logic_vector(  1 downto 0);		-- SSN Waite
    signal PrSv_SSNEnd_s			    : std_logic_vector(  1 downto 0);		-- SSN End
    signal PrSv_CfgCnt_s				: std_logic_vector(  3 downto 0);		-- Config Cmd cnt
    signal PrSv_OPCodeCnt_s				: std_logic_vector(  5 downto 0);		-- Send OPcode
    signal PrSl_MOSI_s                  : std_logic;                            -- Send MOSI
    signal PrSv_MOSIData_s 				: std_logic_vector(  7 downto 0);		-- Send MPSI Data
    signal PrSv_WriteDataCnt_s			: std_logic_vector(  4 downto 0);		-- write config Data
    signal PrSv_WaitTime_c              : std_logic_vector( 15 downto 0);       -- wait time constant
    signal PrSv_WaitTime_s              : std_logic_vector( 15 downto 0);       -- wait time 120 us
    signal PrSv_SClkNum_s               : std_logic_vector(  3 downto 0);       -- SClk Num
    signal PrSv_DataDlyTime_s           : std_logic_vector( 15 downto 0);       -- Data_Delay_time
    signal PrSl_CfgEndTrig_s            : std_logic;                            -- Config End

begin
	------------------------------------------------------------
	-- simulation
	------------------------------------------------------------
    Sim_Data : if (PrSl_Sim_c = 0) generate
        PrSv_WaitTime_c <= PrSv_SimWaitTime_c;
    end generate Sim_Data;
    
    Real_Data : if (PrSl_Sim_c = 1) generate 
        PrSv_WaitTime_c <= PrSv_RealWaitTime_c;
    end generate Real_Data;
    
	------------------------------------------------------------
	-- Main Area
	------------------------------------------------------------
	-- PrSl_StartTrig_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSl_StartTrigDly1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_StartTrigDly1_s <= CpSl_StartTrig_i;
        end if;
    end process;
    PrSl_StartTrig_s <= '1' when (PrSl_StartTrigDly1_s = '0' and CpSl_StartTrig_i = '1') else '0';

	-- PrSv_CmdState_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_CmdState_s <= (others => '0');
		elsif rising_edge(CpSl_Clk_i) then
		case PrSv_CmdState_s is
		    when PrSv_Idle_c => -- Idle
		    	if (PrSl_StartTrig_s = '1') then
                    PrSv_CmdState_s <= PrSv_SSNTrig_c;
                --elsif (CpSl_SoftRstTrig_i = '1') then 
                --    PrSv_CmdState_s <= PrSv_SSNTrig_c;
                else -- hold
                end if;
            when PrSv_SSNTrig_c => -- SSN_Trig
                if (PrSv_SSNTrigCnt_s = 4) then 
                    PrSv_CmdState_s <= PrSv_SSNHold_c;
                else -- hold
                end if;

		    when PrSv_SSNHold_c => -- SSN high 2 Clk
		    	if (PrSv_SSNHigh_s = PrSv_SSNCnt_c) then
		    		PrSv_CmdState_s <= PrSv_SSNWait_c;
		    	else -- hold
		    	end if;

		    when PrSv_SSNWait_c => -- wait SSN 2 Clk
		    	if (PrSv_SSNWaite_s = PrSv_SSNCnt_c) then
		    		PrSv_CmdState_s <= PrSv_Opcode_c;
		    	else -- hold
		    	end if;

		    when PrSv_Opcode_c => -- Send_OPcode
		    	if (PrSv_OPCodeCnt_s = 31) then
		    		PrSv_CmdState_s <= PrSv_Dly120us_c;
		    	else -- hold
		    	end if;

            when PrSv_Dly120us_c => -- Delay 120 us
                if (PrSv_WaitTime_s = PrSv_WaitTime_c) then
                    PrSv_CmdState_s <= PrSv_CmpCfgCnt_c;
                else -- hold
                end if;

		    when PrSv_CmpCfgCnt_c => -- compare config cnt
                if (PrSv_CfgCnt_s = 1) then
		    		PrSv_CmdState_s <= PrSv_WrData_c;
                else
		    		PrSv_CmdState_s <= PrSv_Stop_c;
                end if;

		    when PrSv_WrData_c => -- write data
		    	if (PrSv_OPCodeCnt_s = 31) then
		    		PrSv_CmdState_s <= PrSv_Wait120us_c;
		    	else -- hold
		    	end if;
            
            when PrSv_Wait120us_c => -- Delay 120 us;
                if (PrSv_WaitTime_s = PrSv_SimWaitTime_c) then
                    PrSv_CmdState_s <= PrSv_WrRegCnt_c;
                else -- hold
                end if;

		    when PrSv_WrRegCnt_c => -- reg cnt
		    	PrSv_CmdState_s <= PrSv_CmpWrDataCnt_c;

		    when PrSv_CmpWrDataCnt_c => -- compare write data
		    	if (PrSv_WriteDataCnt_s = 17) then
		    		PrSv_CmdState_s <= PrSv_Stop_c;
		    	else
		    		PrSv_CmdState_s <= PrSv_CmpCfgCnt_c;
		    	end if;
		   
		    when PrSv_Stop_c => -- config end
		        if (PrSv_SSNEnd_s = PrSv_SSNCnt_c) then
--		            if (PrSv_CfgCnt_s = 3) then 
		            if (PrSv_CfgCnt_s = 3) then
		                PrSv_CmdState_s <= PrSv_DelayTime_c;
		            else
		            	PrSv_CmdState_s <= PrSv_SSNHold_c;
		            end if;
		        else -- hold
		        end if;

		    when PrSv_DelayTime_c => -- Delay 100 us
		        if (PrSv_DataDlyTime_s = PrSv_DataDlyTime_c) then 
		            PrSv_CmdState_s <= (others => '0');
		        else -- hold
		        end if;
		    when others => PrSv_CmdState_s <= (others => '0');
        end case;
        end if;
    end  process;

    -- PrSv_SSNTrigCnt_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_SSNTrigCnt_s <= (others => '0');
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_SSNTrig_c) then
				PrSv_SSNTrigCnt_s <= PrSv_SSNTrigCnt_s + '1';
			else
				PrSv_SSNTrigCnt_s <= (others => '0');
			end if;
		end if;
    end process;
    
    -- PrSv_SSNHigh_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_SSNHigh_s <= (others => '0');
        elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_SSNHold_c) then
				PrSv_SSNHigh_s <= PrSv_SSNHigh_s + '1';
			else
				PrSv_SSNHigh_s <= (others => '0');
			end if;
    end if;
    end process;

	-- PrSv_SSNWaite_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_SSNWaite_s <= (others => '0');
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_SSNWait_c) then
				PrSv_SSNWaite_s <= PrSv_SSNWaite_s + '1';
			else
				PrSv_SSNWaite_s <= (others => '0');
			end if;
		end if;
    end process;

	-- PrSv_SSNEnd_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_SSNEnd_s <= (others => '0');
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_Stop_c) then
				PrSv_SSNEnd_s <= PrSv_SSNEnd_s + '1';
			else
				PrSv_SSNEnd_s <= (others => '0');
			end if;
		end if;
	end process;

	-- PrSv_OPCodeCnt_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_OPCodeCnt_s <= (others => '0');
		elsif rising_edge(CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_Opcode_c) then
				if (PrSv_OPCodeCnt_s = 31) then
					PrSv_OPCodeCnt_s <= (others => '0');
				else
					PrSv_OPCodeCnt_s <= PrSv_OPCodeCnt_s + '1';
				end if;
			elsif (PrSv_CmdState_s = PrSv_WrData_c) then 
			    if (PrSv_OPCodeCnt_s = 31) then
					PrSv_OPCodeCnt_s <= (others => '0');
				else
					PrSv_OPCodeCnt_s <= PrSv_OPCodeCnt_s + '1';
				end if;
			else
				PrSv_OPCodeCnt_s <= (others => '0');
			end if;
		end if;
	end process;

	-- PrSv_CfgCnt_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_CfgCnt_s <= (others => '0');
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_Idle_c) then
			    PrSv_CfgCnt_s <= (others => '0');
			    --if (CpSl_SoftRstTrig_i = '1') then
			    --    PrSv_CfgCnt_s <= x"2";
			    --else
       --             PrSv_CfgCnt_s <= (others => '0');
			    --end if;
			elsif (PrSv_CmdState_s = PrSv_Stop_c and PrSv_SSNEnd_s = 0) then
				PrSv_CfgCnt_s <= PrSv_CfgCnt_s  + '1';
			elsif (PrSv_CmdState_s = PrSv_CheckFail_c) then 
				PrSv_CfgCnt_s <= (others => '0');
			else -- hold
			end if;
		end if;
	end process;

	-- PrSv_MOSIData_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_MOSIData_s <= (others => '0');
		elsif rising_edge(CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_SSNHold_c and PrSv_SSNHigh_s = 0) then
				if (PrSv_CfgCnt_s = 0) then
					PrSv_MOSIData_s <= PrSv_PowRst_c;
--				elsif (PrSv_CfgCnt_s = 1) then
--					PrSv_MOSIData_s <= PrSv_PowRst_c; -- PrSv_WrConfig_c;
			    elsif (PrSv_CfgCnt_s = 1) then
					PrSv_MOSIData_s <= PrSv_WrConfig_c; -- PrSv_RdConfig_c;
				elsif (PrSv_CfgCnt_s = 2) then
				    PrSv_MOSIData_s <= PrSv_Init_c;
				else -- hold
				end if;
            elsif (PrSv_CmdState_s = PrSv_CmpCfgCnt_c and PrSv_CfgCnt_s = 1) then
				if (PrSv_WriteDataCnt_s = 0) then
					PrSv_MOSIData_s <= PrSv_Addr0_c;
				elsif (PrSv_WriteDataCnt_s = 1) then
					PrSv_MOSIData_s <= PrSv_Addr1_c;
				elsif (PrSv_WriteDataCnt_s = 2) then
					PrSv_MOSIData_s <= PrSv_Addr2_c;
				elsif (PrSv_WriteDataCnt_s = 3) then
					PrSv_MOSIData_s <= PrSv_Addr3_c;
				elsif (PrSv_WriteDataCnt_s = 4) then
					PrSv_MOSIData_s <= PrSv_Addr4_c;
				elsif (PrSv_WriteDataCnt_s = 5) then
					PrSv_MOSIData_s <= PrSv_Addr5_c;
				elsif (PrSv_WriteDataCnt_s = 6) then
					PrSv_MOSIData_s <= PrSv_Addr6_c;
				elsif (PrSv_WriteDataCnt_s = 7) then
					PrSv_MOSIData_s <= PrSv_Addr7_c;
			    elsif (PrSv_WriteDataCnt_s = 8) then
                    PrSv_MOSIData_s <= PrSv_Addr8_c;
				elsif (PrSv_WriteDataCnt_s = 9) then
					PrSv_MOSIData_s <= PrSv_Addr9_c;
				elsif (PrSv_WriteDataCnt_s = 10) then
					PrSv_MOSIData_s <= PrSv_Addr10_c;
				elsif (PrSv_WriteDataCnt_s = 11) then
					PrSv_MOSIData_s <= PrSv_Addr11_c;
				elsif (PrSv_WriteDataCnt_s = 12) then
					PrSv_MOSIData_s <= PrSv_Addr12_c;
				elsif (PrSv_WriteDataCnt_s = 13) then
					PrSv_MOSIData_s <= PrSv_Addr13_c;
				elsif (PrSv_WriteDataCnt_s = 14) then
					PrSv_MOSIData_s <= PrSv_Addr14_c;
				elsif (PrSv_WriteDataCnt_s = 15) then
					PrSv_MOSIData_s <= PrSv_Addr15_c;
				elsif (PrSv_WriteDataCnt_s = 16) then
					PrSv_MOSIData_s <= PrSv_Addr16_c;
				else -- hold
				end if;
			end if;
		end if;
	end process;

	-- PrSv_WriteDataCnt_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
	    if (CpSl_Rst_i = '0') then
	    	PrSv_WriteDataCnt_s <= (others => '0');
	    elsif rising_edge (CpSl_Clk_i) then
	        if (PrSv_CmdState_s = PrSv_Idle_c) then 
                PrSv_WriteDataCnt_s <= (others => '0');
            elsif (PrSv_CmdState_s = PrSv_WrRegCnt_c) then
	            if (PrSv_WriteDataCnt_s = 17) then
	            	PrSv_WriteDataCnt_s <= (others => '0');
	            else
	            	PrSv_WriteDataCnt_s <= PrSv_WriteDataCnt_s + '1';
	            end if;
	        else -- hold
	        end if;
	    end if;
    end process;

    -- PrSv_WaitTime_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
	    if (CpSl_Rst_i = '0') then
	    	PrSv_WaitTime_s <= (others => '0');
	    elsif rising_edge (CpSl_Clk_i) then
	        if (PrSv_CmdState_s = PrSv_Dly120us_c) then
	        	PrSv_WaitTime_s <= PrSv_WaitTime_s + '1';
	        elsif (PrSv_CmdState_s = PrSv_Wait120us_c) then 
	            PrSv_WaitTime_s <= PrSv_WaitTime_s + '1';
	        else
	        	PrSv_WaitTime_s <= (others => '0');
	        end if;
	    end if;
    end process;

	-- CpSl_SSN1_o
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
           CpSl_SSN1_o <= '1';
		elsif rising_edge (CpSl_Clk_i) then
		    if (PrSv_CmdState_s = PrSv_SSNTrig_c) then
		        CpSl_SSN1_o <= '0';
		    elsif (PrSv_CmdState_s = PrSv_SSNHold_c) then
		        CpSl_SSN1_o <= '1';
		    elsif (PrSv_CmdState_s = PrSv_SSNWait_c) then
		        CpSl_SSN1_o <= '0';
		    elsif (PrSv_CmdState_s = PrSv_DelayTime_c) then
                CpSl_SSN1_o <= '1';
		    else -- hold
		    end if;
        end if;
    end process;

    -- PrSv_SClkNum_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_SClkNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CmdState_s = PrSv_Opcode_c) then
                if (PrSv_SClkNum_s = 3) then
                    PrSv_SClkNum_s <= (others => '0');
                else
                    PrSv_SClkNum_s <= PrSv_SClkNum_s + '1';
                end if;
            elsif (PrSv_CmdState_s = PrSv_WrData_c) then 
                if (PrSv_SClkNum_s = 3) then
                    PrSv_SClkNum_s <= (others => '0');
                else
                    PrSv_SClkNum_s <= PrSv_SClkNum_s + '1';
                end if;
            else
                PrSv_SClkNum_s <= (others => '0');
            end if;
        end if;
    end process;

	-- CpSl_SClk1_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            CpSl_SClk1_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CmdState_s = PrSv_Opcode_c) then
                if (PrSv_SClkNum_s = 0) then 
                    CpSl_SClk1_o <= '1';
                elsif (PrSv_SClkNum_s = 2) then
                    CpSl_SClk1_o <= '0';
                else -- hold 
                end if;
            elsif (PrSv_CmdState_s = PrSv_WrData_c) then 
                if (PrSv_SClkNum_s = 0) then 
                    CpSl_SClk1_o <= '1';
                elsif (PrSv_SClkNum_s = 2) then
                    CpSl_SClk1_o <= '0';
                else -- hold 
                end if;
            else
                CpSl_SClk1_o <= '0';
            end if;
        end if;
    end process;

	-- PrSl_MOSI_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
	    if (CpSl_Rst_i = '0') then
	        PrSl_MOSI_s <= '0';
	    elsif rising_edge (CpSl_Clk_i) then
            if (PrSv_CmdState_s = PrSv_Opcode_c or PrSv_CmdState_s = PrSv_WrData_c) then
	            case PrSv_OPCodeCnt_s is
                    when "000000" => PrSl_MOSI_s <= PrSv_MOSIData_s(7);
                    when "000100" => PrSl_MOSI_s <= PrSv_MOSIData_s(6);
                    when "001000" => PrSl_MOSI_s <= PrSv_MOSIData_s(5);
                    when "001100" => PrSl_MOSI_s <= PrSv_MOSIData_s(4);
                    when "010000" => PrSl_MOSI_s <= PrSv_MOSIData_s(3);
                    when "010100" => PrSl_MOSI_s <= PrSv_MOSIData_s(2);
                    when "011000" => PrSl_MOSI_s <= PrSv_MOSIData_s(1);
                    when "011100" => PrSl_MOSI_s <= PrSv_MOSIData_s(0);
                    when others => PrSl_MOSI_s <= PrSl_MOSI_s;
	            end case;
	        else
	        	PrSl_MOSI_s <= '0';
	        end if;
	    end if;
    end process;
	-- CpSl_MOSI1_o
	CpSl_MOSI1_o <= PrSl_MOSI_s;
    
    -- PrSv_DataDlyTime_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_DataDlyTime_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CmdState_s = PrSv_DelayTime_c) then
                PrSv_DataDlyTime_s <= PrSv_DataDlyTime_s + '1';
            else 
                PrSv_DataDlyTime_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSl_CfgEndTrig_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then
            PrSl_CfgEndTrig_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_CmdState_s = PrSv_DelayTime_c) then 
                if (PrSv_DataDlyTime_s = PrSv_DataDlyTime_c - 9) then 
                    PrSl_CfgEndTrig_s <= '1';
                elsif (PrSv_DataDlyTime_s = PrSv_DataDlyTime_c) then 
                    PrSl_CfgEndTrig_s <= '0';
                else -- hold
                end if;
            else
                PrSl_CfgEndTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- CpSl_CfgEnd1Trig_o
    CpSl_CfgEnd1Trig_o <= PrSl_CfgEndTrig_s;
----------------------------------------------------------------------------
-- End Describe
----------------------------------------------------------------------------
end arch_M_TdcSpi;