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
-- °æ    È¨  :  ZVISION
-- ÎÄ¼þÃû³Æ  :  eth_write.vhd
-- Éè    ¼Æ  :  xx
-- ÓÊ    ¼þ  :  M_TdcGpx2.vhd
-- Ð£    ¶Ô  :  -- Multion_ 0.384
-- Éè¼ÆÈÕÆÚ  :  2018/05/17
-- ¹¦ÄÜ¼òÊö  :  wenjun zhang
-- °æ±¾ÐòºÅ  :  0.1
-- ÐÞ¸ÄÀúÊ·  :  1. Initial, wenjun zhang, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_TdcGpx2 is
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
		CpSl_StartTrig_s				: in  std_logic;						-- Start Trig

		-- SPI_IF
		CpSl_SSN_o						: out std_logic;						-- TDC_GPX2_SSN
		CpSl_SClk_o						: out std_logic;						-- TDC_GPX2_SCLK
		CpSl_MOSI_o						: out std_logic;						-- TDC_GPX2_MOSI
		CpSl_MISO_i						: in  std_logic;						-- TDC_GPX2_MISO

		-- LVDS
		CpSl_RefClkP_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_RefClkN_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Intertupt_i				: in  std_logic;						-- TDC_GPX2_Interrupt
		CpSl_Frame1_i					: in  std_logic;						-- TDC_GPX2_Frame1
		CpSl_Frame2_i					: in  std_logic;						-- TDC_GPX2_Frame2
		CpSl_Frame3_i					: in  std_logic;						-- TDC_GPX2_Frame3
		CpSl_Frame4_i					: in  std_logic;						-- TDC_GPX2_Frame4
		CpSl_Sdo1_i	     				: in  std_logic;						-- TDC_GPX2_SDO1
		CpSl_Sdo2_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO2
		CpSl_Sdo3_i	     				: in  std_logic;						-- TDC_GPX2_SDO3
		CpSl_Sdo4_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO4
		CpSl_TdcDataVld_o				: out std_logic;						-- TDC_Recv_Data Valid
		CpSv_TdcData_o					: out std_logic_vector(47 downto 0)		-- TDC Recv Data
	);
end M_TdcGpx2;

architecture arch_M_TdcGpx2 of M_TdcGpx2 is
	----------------------------------------------------------------------------
    -- Constant Describe
    ----------------------------------------------------------------------------
    ------------------------------------
	-- Constant_State
	------------------------------------
    constant PrSv_Idle_c                : std_logic_vector( 3 downto 0) := "0000";  -- Idle
    constant PrSv_SSNTrig_c             : std_logic_vector( 3 downto 0) := "0001";  -- SSN_Trig
    constant PrSv_SSNHold_c             : std_logic_vector( 3 downto 0) := "0010";  -- SSN_Hold
    constant PrSv_SSNWait_c             : std_logic_vector( 3 downto 0) := "0011";  -- SSN_Wait
    constant PrSv_Opcode_c              : std_logic_vector( 3 downto 0) := "0100";  -- Send_Opcode
    constant PrSv_Dly120us_c            : std_logic_vector( 3 downto 0) := "0101";  -- Delay 120 us
    constant PrSv_CmpCfgCnt_c           : std_logic_vector( 3 downto 0) := "0110";  -- Compare Config Data
    constant PrSv_WrData_c              : std_logic_vector( 3 downto 0) := "0111";  -- Write Data
    constant PrSv_Wait120us_c           : std_logic_vector( 3 downto 0) := "1000";  -- wait 120 us
    constant PrSv_WrRegCnt_c            : std_logic_vector( 3 downto 0) := "1001";  -- Write Reg Cnt
    constant PrSv_CmpWrDataCnt_c        : std_logic_vector( 3 downto 0) := "1010";  -- Compare Write Data Cnt
    constant PrSv_Stop_c                : std_logic_vector( 3 downto 0) := "1011";  -- End
    constant PrSv_Check_c               : std_logic_vector( 3 downto 0) := "1100";  -- Start_Rd_State
    constant PrSv_CheckData_c           : std_logic_vector( 3 downto 0) := "1101";  -- Check_Data
    constant PrSv_CheckFail_c           : std_logic_vector( 3 downto 0) := "1110";  -- Check_Failed

    ------------------------------------
	-- TDC_GPX2 Interface
	------------------------------------
	-- OPCODE
    constant PrSv_Addr0_c				: std_logic_vector( 7 downto 0) := x"3F";	-- Address_0_Data
    constant PrSv_Addr1_c				: std_logic_vector( 7 downto 0) := x"0F";	-- Address_1_Data
    constant PrSv_Addr2_c				: std_logic_vector( 7 downto 0) := x"1F";	-- Address_2_Data
    constant PrSv_Addr3_c				: std_logic_vector( 7 downto 0) := x"40";	-- Address_3_Data
    constant PrSv_Addr4_c				: std_logic_vector( 7 downto 0) := x"0D";	-- Address_4_Data
    constant PrSv_Addr5_c				: std_logic_vector( 7 downto 0) := x"03";	-- Address_5_Data
    constant PrSv_Addr6_c				: std_logic_vector( 7 downto 0) := x"C0";	-- Address_6_Data
--    constant PrSv_Addr6_c				: std_logic_vector( 7 downto 0) := x"D0";	-- Address_6_LVDSTestData
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
--    constant PrSv_Addr16_c				: std_logic_vector( 7 downto 0) := x"04";	-- Address_16_Data(CMOS)

    constant PrSv_PowRst_c				: std_logic_vector( 7 downto 0) := x"30";	-- Power Reset
    constant PrSv_WrConfig_c			: std_logic_vector( 7 downto 0) := x"80";	-- Write Configuration
    constant PrSv_Init_c				: std_logic_vector( 7 downto 0) := x"18";	-- Initializa Chip and measurement
    constant PrSv_RdConfig_c			: std_logic_vector( 7 downto 0) := x"40";	-- Read Configuration

    constant PrSv_SSNCnt_c				: std_logic_vector( 1 downto 0) := "10";	-- SSN wait 1 Clk
    constant PrSv_CmdCnt_c				: std_logic_vector( 4 downto 0) := "10000"; -- Config Cmd Cnt_16
    constant PrSv_ConfigCnt_c			: std_logic_vector( 4 downto 0) := "10111";	-- Config Cnt_23
    constant PrSv_RdData_c				: std_logic_vector( 4 downto 0) := "10111"; -- Rd_Data_23
    constant PrSv_Cnt1us_c				: std_logic_vector( 7 downto 0) := x"C8";	-- 1us
    constant PrSv_RealWaitTime_c        : std_logic_vector(15 downto 0) := x"12BF"; -- 150 us(4800_Clk)
--    constant PrSv_RealWaitTime_c        : std_logic_vector(15 downto 0) := x"0003"; -- 150 us(6000_Clk)
    constant PrSv_SimWaitTime_c         : std_logic_vector(15 downto 0) := x"0003"; -- 100 ns(4_Clk)

    ----------------------------------------------------------------------------
    -- Signal Describe
    ----------------------------------------------------------------------------
    signal PrSv_CmdState_s				: std_logic_vector(  3 downto 0);		-- Init TDC_GPX2_State
    signal PrSl_StartTrig_s				: std_logic;		 					-- State Start Trig
    signal PrSv_SSNTrigCnt_s            : std_logic_vector(  3 downto 0);       -- SSNTrig_Cnt
    signal PrSv_SSNHigh_s				: std_logic_vector(  1 downto 0);		-- SSN High
    signal PrSv_SSNWaite_s				: std_logic_vector(  1 downto 0);		-- SSN Waite
    signal PrSv_SSNEnd_s			    : std_logic_vector(  1 downto 0);		-- SSN End
    signal PrSv_CfgCnt_s				: std_logic_vector(  4 downto 0);		-- Config Cmd cnt
    signal PrSv_OPCodeCnt_s				: std_logic_vector(  5 downto 0);		-- Send OPcode
    signal PrSl_MOSI_s                  : std_logic;                            -- Send MOSI
    signal PrSv_MOSIData_s 				: std_logic_vector(  7 downto 0);		-- Send MPSI Data
    signal PrSv_WriteDataCnt_s			: std_logic_vector(  4 downto 0);		-- write config Data
    signal PrSv_WaitTime_c              : std_logic_vector( 15 downto 0);       -- wait time constant
    signal PrSv_WaitTime_s              : std_logic_vector( 15 downto 0);       -- wait time 120 us
    signal PrSv_WrData_s                : std_logic_vector(135 downto 0);       -- Write Data
    signal PrSv_SClkNum_s               : std_logic_vector(  3 downto 0);       -- SClk Num
    
	-- Read Register Data
    signal PrSv_RdReg_s                 : std_logic_vector(  3 downto 0);       -- Read Register Data State
    signal PrSv_RdCfgDataNum_s          : std_logic_vector(  5 downto 0);       -- Read 1Byte Data Num
    signal PrSv_RdCfgData_s             : std_logic_vector(  7 downto 0);       -- Read 1Byte Data
    signal PrSv_RdRegCnt_s              : std_logic_vector(  4 downto 0);       -- Read Config Cnt
    signal PrSv_SimRdData_s             : std_logic_vector(135 downto 0);       -- Sim Read Data
    signal PrSv_RdData_s                : std_logic_vector(135 downto 0);       -- Read Data
    
	-- Receive data
	signal PrSv_RecvState_s 			: std_logic_vector( 2 downto 0);		-- Recv Data State
	signal PrSl_FrameTrig_s				: std_logic;							-- Frame Trig
	signal PrSl_Frame1Dly1Clk_s			: std_logic;							-- Frame Delay 1 Clk
	signal PrSl_Frame1Dly2Clk_s			: std_logic;							-- Frame Delay 2 Clk
	signal PrSl_Sdo1Dly1Clk_s			: std_logic;							-- SDO Delay 1 CLk
	signal PrSl_Sdo1Dly2Clk_s			: std_logic;							-- SDO Delay 2 CLk
	signal PrSv_RecvData_s				: std_logic_vector(23 downto 0);		-- Recv SDO Data
	signal PrSv_Cnt1us_s				: std_logic_vector( 7 downto 0);		-- 1us time
	signal PrSl_Trig1us_s				: std_logic;							-- 1us time Trig
	signal PrSv_EchoNum_s				: std_logic_vector( 2 downto 0);		-- Encho Num
	signal PrSv_RdDataCnt_s				: std_logic_vector( 4 downto 0);		-- Rd_Cnt
	signal PrSv_RecvEndCnt_s			: std_logic_vector( 3 downto 0);		-- End Cnt
	signal PrSv_TdcData_s				: std_logic_vector(47 downto 0);		-- Recv_Data
begin
	------------------------------------------------------------
	-- Component Map
	------------------------------------------------------------
    PrSv_WrData_s <= PrSv_Addr0_c & PrSv_Addr1_c & PrSv_Addr2_c & PrSv_Addr3_c & PrSv_Addr4_c & PrSv_Addr5_c & PrSv_Addr6_c
                    & PrSv_Addr7_c & PrSv_Addr8_c & PrSv_Addr9_c & PrSv_Addr10_c & PrSv_Addr11_c & PrSv_Addr12_c & PrSv_Addr13_c
                    & PrSv_Addr14_c & PrSv_Addr15_c & PrSv_Addr16_c;
    
    Sim_Data : if (PrSl_Sim_c = 0) generate
        PrSv_SimRdData_s <= PrSv_Addr0_c & PrSv_Addr1_c & PrSv_Addr2_c & PrSv_Addr3_c & PrSv_Addr4_c & PrSv_Addr5_c & PrSv_Addr6_c
                    & PrSv_Addr7_c & PrSv_Addr8_c & PrSv_Addr9_c & PrSv_Addr10_c & PrSv_Addr11_c & PrSv_Addr12_c & PrSv_Addr13_c
                    & PrSv_Addr14_c & PrSv_Addr15_c & PrSv_Addr16_c;
        PrSv_WaitTime_c <= PrSv_SimWaitTime_c;
    end generate Sim_Data;
    
    Real_Data : if (PrSl_Sim_c = 1) generate 
        PrSv_SimRdData_s <= PrSv_RdData_s;
        PrSv_WaitTime_c <= PrSv_RealWaitTime_c;
    end generate Real_Data;
    
	------------------------------------------------------------
	-- Main Area
	------------------------------------------------------------
	-- PrSl_StartTrig_s
	PrSl_StartTrig_s <= CpSl_StartTrig_s;
	-- PrSv_CmdState_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_CmdState_s <= (others => '0');
		elsif rising_edge(CpSl_Clk_i) then
		case PrSv_CmdState_s is
		    when PrSv_Idle_c => -- Idle
		    	if (PrSl_StartTrig_s = '1') then
                    PrSv_CmdState_s <= PrSv_SSNTrig_c;
		    	else -- hold
		    	end if;
            when PrSv_SSNTrig_c => -- SSN_Trig
                if (PrSv_SSNTrigCnt_s = 9) then 
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
--                if (PrSv_WaitTime_s = PrSv_WaitTime_c) then
                if (PrSv_WaitTime_s = PrSv_SimWaitTime_c) then
                    PrSv_CmdState_s <= PrSv_WrRegCnt_c;
                else -- hold
                end if;

		    when PrSv_WrRegCnt_c => -- reg cnt
		    	PrSv_CmdState_s <= PrSv_CmpWrDataCnt_c;

		    when PrSv_CmpWrDataCnt_c => -- compare write data
		    	if (PrSv_WriteDataCnt_s = 17) then
--                if (PrSv_WriteDataCnt_s = 8) then
		    		PrSv_CmdState_s <= PrSv_Stop_c;
		    	else
		    		PrSv_CmdState_s <= PrSv_CmpCfgCnt_c;
		    	end if;

		    when PrSv_Stop_c => -- config end
		    	if (PrSv_SSNEnd_s = PrSv_SSNCnt_c) then
                    if (PrSv_CfgCnt_s = 2) then
		    			PrSv_CmdState_s <= PrSv_Check_c;
		    		elsif (PrSv_CfgCnt_s = 3) then
		    		    PrSv_CmdState_s <= (others => '0');
		    		else
		    			PrSv_CmdState_s <= PrSv_SSNHold_c;
		    		end if;
		    	else -- hold
		    	end if;
            
            when PrSv_Check_c => -- Start_Rd_State
                PrSv_CmdState_s <= PrSv_CheckData_c;

            when PrSv_CheckData_c => -- Check_Rd_Data
--		        if (PrSv_RdReg_s = "1010") then
--		            PrSv_CmdState_s <= PrSv_SSNHold_c;
--		        elsif (PrSv_RdReg_s = "1011") then 
--		            PrSv_CmdState_s <= PrSv_CheckFail_c;
--		        else -- hold
--		        end if;
		        PrSv_CmdState_s <= PrSv_SSNHold_c;
		    when PrSv_CheckFail_c => -- Ctrl_Config_Cnt
		        PrSv_CmdState_s <= PrSv_SSNHold_c;
		    
		    when others => PrSv_CmdState_s <= (others => '0');
		end case;
		end if;
	end  process;

	------------------------------------
	-- Read Register Data
	------------------------------------
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_RdReg_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_RdReg_s is
                when "0000" => 
                    if (PrSv_CmdState_s = PrSv_CheckFail_c) then 
--                    if (PrSv_CmdState_s = PrSv_Check_c) then
                        PrSv_RdReg_s <= "1100";
                    else
                    end if;
                when "1100" => -- SSN_Trig
                    if (PrSv_SSNTrigCnt_s = 9) then
                        PrSv_RdReg_s <= "0001";
                    else -- hold
                    end if;
                    
                when "0001" => -- SSN_Hold
                    if (PrSv_SSNHigh_s = PrSv_SSNCnt_c) then 
                        PrSv_RdReg_s <= "0010";
                    else -- hold
                    end if;
                        
                when "0010" => -- SSN_Wait_Low
                    if (PrSv_SSNWaite_s = PrSv_SSNCnt_c) then 
                        PrSv_RdReg_s <= "0011";
                    else -- hold
                    end if;
                
                when "0011" => -- OpCode
                    if (PrSv_OPCodeCnt_s = 31) then
                        PrSv_RdReg_s <= "0100";
                    else -- hold
                    end if;        
                
                when "0100" => -- wait 120 us
                    if (PrSv_WaitTime_s = PrSv_WaitTime_c) then
                        PrSv_RdReg_s <= "0101";
                    else -- hold
                    end if;
                
                when "0101" => -- Rd_1Byte_ConfigData
                    if (PrSv_RdCfgDataNum_s = 31) then 
                        PrSv_RdReg_s <= "0110";
                    else -- hold
                    end if;
                        
                when "0110" => -- wait 120 us
                    if (PrSv_WaitTime_s = PrSv_SimWaitTime_c) then
--                    if (PrSv_WaitTime_s = PrSv_WaitTime_c) then 
                        PrSv_RdReg_s <= "0111";
                    else -- hold
                    end if;
                
                when "0111" => -- Rd_Cnt
                    PrSv_RdReg_s <= "1000";
                
                when "1000" => -- Rd_Config_Data(Head + Data)
                    if (PrSv_RdRegCnt_s = 18) then 
                        PrSv_RdReg_s <= "1001";
                    else
                        PrSv_RdReg_s <= "0101";
                    end if;
                when "1001" => -- Check_Reault
                    if (PrSv_SimRdData_s = PrSv_WrData_s) then 
                        PrSv_RdReg_s <= "1010";
                    else
                        PrSv_RdReg_s <= "1011";
                    end if;
                when "1010" => -- Config_Successful
                    PrSv_RdReg_s <= (others => '0');
                when "1011" => -- Config_Failed
                    PrSv_RdReg_s <= (others => '0');
                when others => PrSv_RdReg_s <= (others => '0');
            end case;
        end if;
    end process;
    
    -- PrSv_SSNTrigCnt_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_SSNTrigCnt_s <= (others => '0');
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_SSNTrig_c or PrSv_RdReg_s = "1100") then
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
			elsif (PrSv_RdReg_s = "0001") then 
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
			elsif (PrSv_RdReg_s = "0010") then 
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
			if (PrSv_CmdState_s = PrSv_Opcode_c or PrSv_CmdState_s = PrSv_WrData_c) then
				if (PrSv_OPCodeCnt_s = 31) then
					PrSv_OPCodeCnt_s <= (others => '0');
				else
					PrSv_OPCodeCnt_s <= PrSv_OPCodeCnt_s + '1';
				end if;
			elsif (PrSv_RdReg_s = "0011") then 
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
				elsif (PrSv_CfgCnt_s = 1) then
					PrSv_MOSIData_s <= PrSv_WrConfig_c;
			    elsif (PrSv_CfgCnt_s = 2) then
					PrSv_MOSIData_s <= PrSv_Init_c;
--				elsif (PrSv_CfgCnt_s = 3) then
--				    PrSv_MOSIData_s <= PrSv_Init_c;
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
			elsif (PrSv_RdReg_s = "0001" and PrSv_SSNHigh_s = 0) then 
			    PrSv_MOSIData_s <= PrSv_RdConfig_c;
			end if;
		end if;
	end process;

	-- PrSv_WriteDataCnt_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_WriteDataCnt_s <= (others => '0');
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_WrRegCnt_c) then
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
			if (PrSv_CmdState_s = PrSv_Dly120us_c or PrSv_CmdState_s = PrSv_Wait120us_c) then
				PrSv_WaitTime_s <= PrSv_WaitTime_s + '1';
			elsif (PrSv_RdReg_s = "0100" or PrSv_RdReg_s = "0110") then 
			    PrSv_WaitTime_s <= PrSv_WaitTime_s + '1';
			else
				PrSv_WaitTime_s <= (others => '0');
			end if;
		end if;
    end process;

    -- PrSv_RdCfgDataNum_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_RdCfgDataNum_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_RdReg_s = "0101") then
                if (PrSv_RdCfgDataNum_s = 31) then 
                    PrSv_RdCfgDataNum_s <= (others => '0');
                else
                    PrSv_RdCfgDataNum_s <= PrSv_RdCfgDataNum_s + '1';
                end if;
            else
                PrSv_RdCfgDataNum_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_RdCfgData_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_RdCfgData_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RdReg_s = "0101") then
                case PrSv_RdCfgDataNum_s is
                    when "000010" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "000110" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "001010" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "001110" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "010010" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "010110" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "011010" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when "011110" => PrSv_RdCfgData_s <= PrSv_RdCfgData_s(6 downto 0) & CpSl_MISO_i;
                    when others   => PrSv_RdCfgData_s <= PrSv_RdCfgData_s;
                end case;
            elsif (PrSv_RdReg_s = "1000") then 
                PrSv_RdCfgData_s <= (others => '0');
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_RdRegCnt_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_RdRegCnt_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RdReg_s = "0000") then 
                PrSv_RdRegCnt_s <= (others => '0'); 
            elsif (PrSv_RdReg_s = "0111") then
                PrSv_RdRegCnt_s <= PrSv_RdRegCnt_s + '1';
            elsif (PrSv_RdReg_s = "1001") then 
                PrSv_RdRegCnt_s <= (others => '0'); 
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_RdData_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_RdData_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_RdReg_s = "0000") then
--                PrSv_RdData_s <= (others => '0'); 
            if (PrSv_RdReg_s = "0111") then
                PrSv_RdData_s <= PrSv_RdData_s(127 downto 0) & PrSv_RdCfgData_s;
--            elsif () then 
--                PrSv_RdData_s <= (others => '0'); 
            else -- hold
            end if;
        end if;
    end process;

	-- CpSl_SSN_o
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
           CpSl_SSN_o <= '1';
		elsif rising_edge (CpSl_Clk_i) then
			-- Write Data
			if (PrSv_CmdState_s = PrSv_SSNTrig_c) then 
			    CpSl_SSN_o <= '0';
			elsif (PrSv_CmdState_s = PrSv_SSNHold_c) then
                CpSl_SSN_o <= '1';
			elsif (PrSv_CmdState_s = PrSv_SSNWait_c) then 
			    CpSl_SSN_o <= '0';
			elsif (PrSv_CmdState_s = PrSv_Stop_c and PrSv_SSNEnd_s = PrSv_SSNCnt_c and PrSv_CfgCnt_s = 3) then 
			    CpSl_SSN_o <= '1';
			else -- hold
			end if;
			
			-- Read Data
			if (PrSv_RdReg_s = "1100") then 
			    CpSl_SSN_o <= '0';
			elsif (PrSv_RdReg_s = "0001") then
			    CpSl_SSN_o <= '1';
			elsif (PrSv_RdReg_s = "0010") then 
			    CpSl_SSN_o <= '0';
			elsif (PrSv_RdReg_s = "1001") then 
			    CpSl_SSN_o <= '1';
			else -- hold
			end if;
			
			-- original_Data
--			if (PrSv_CmdState_s = PrSv_SSNHold_c) then
--				CpSl_SSN_o <= '1';
--			elsif (PrSv_RdReg_s = "0001") then 
--			    CpSl_SSN_o <= '1';
--			else
--				CpSl_SSN_o <= '0';
--			end if;
		end if;
	end process;

    -- PrSv_SClkNum_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_SClkNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CmdState_s = PrSv_Opcode_c or PrSv_CmdState_s = PrSv_WrData_c) then
                if (PrSv_SClkNum_s = 3) then
                    PrSv_SClkNum_s <= (others => '0');
                else
                    PrSv_SClkNum_s <= PrSv_SClkNum_s + '1';
                end if;
            elsif (PrSv_RdReg_s = "0011" or PrSv_RdReg_s = "0101") then 
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

	-- CpSl_SClk_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            CpSl_SClk_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CmdState_s = PrSv_Opcode_c or PrSv_CmdState_s = PrSv_WrData_c) then
                if (PrSv_SClkNum_s = 0) then 
                    CpSl_SClk_o <= '1';
                elsif (PrSv_SClkNum_s = 2) then
                    CpSl_SClk_o <= '0';
                else -- hold 
                end if;
            elsif (PrSv_RdReg_s = "0011" or PrSv_RdReg_s = "0101") then 
                if (PrSv_SClkNum_s = 0) then 
                    CpSl_SClk_o <= '1';
                elsif (PrSv_SClkNum_s = 2) then
                    CpSl_SClk_o <= '0';
                else -- hold 
                end if;
            else 
                CpSl_SClk_o <= '0';
            end if;
        end if;
    end process;

	-- PrSl_MOSI_s
	process (CpSl_Rst_i,CpSl_Clk_i) begin
		if (CpSl_Rst_i = '0') then
			PrSl_MOSI_s <= '0';
		elsif rising_edge (CpSl_Clk_i) then
			if (PrSv_CmdState_s = PrSv_Opcode_c or PrSv_CmdState_s = PrSv_WrData_c or PrSv_RdReg_s = "0011") then
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
	
	-- CpSl_MOSI_o
	CpSl_MOSI_o <= PrSl_MOSI_s;

	------------------------------------
	-- Receive Data
	------------------------------------
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSl_Frame1Dly1Clk_s <= '0';
			PrSl_Frame1Dly2Clk_s <= '0';
		elsif rising_edge (CpSl_RefClkP_i) then
			PrSl_Frame1Dly1Clk_s <= CpSl_Frame1_i;
			PrSl_Frame1Dly2Clk_s <= PrSl_Frame1Dly1Clk_s;
		end if;
	end process;

	-- PrSl_FrameTrig_s
	PrSl_FrameTrig_s <= '1' when (PrSl_Frame1Dly1Clk_s = '0' and CpSl_Frame1_i = '1') else '0';

	-- Delay SDO 2 CLK
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSl_Sdo1Dly1Clk_s <= '0';
			PrSl_Sdo1Dly2Clk_s <= '0';
		elsif rising_edge (CpSl_RefClkP_i) then
			PrSl_Sdo1Dly1Clk_s <= CpSl_Sdo1_i;
			PrSl_Sdo1Dly2Clk_s <= PrSl_Sdo1Dly1Clk_s;
		end if;
	end process;

	-- Recv_Data_State
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_RecvState_s <= (others => '0');
		elsif rising_edge(CpSl_RefClkP_i) then
			case PrSv_RecvState_s is
				when "000" =>
					if (PrSl_FrameTrig_s ='1') then
						PrSv_RecvState_s <= "001";
					else -- hold
					end if;
				when "001" =>
					if (PrSv_RdDataCnt_s = PrSv_RdData_c) then
						PrSv_RecvState_s <= "010";
					else -- hold
					end if;
				when "010" =>
					PrSv_RecvState_s <= "011";
				when "011" =>
					if (PrSl_FrameTrig_s ='1') then
						PrSv_RecvState_s <= "001";
					elsif (PrSv_EchoNum_s = 4) then
						PrSv_RecvState_s <= "100";
					elsif (PrSl_Trig1us_s = '1') then
						PrSv_RecvState_s <= "100";
					else -- hold
					end if;
				when "100"  =>
					if (PrSv_RecvEndCnt_s = 5) then
						PrSv_RecvState_s <= (others => '0');
					else -- hold
					end if;
				when others => PrSv_RecvState_s <= (others => '0');
			end case;
		end if;
	end process;

	-- PrSv_EchoNum_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_EchoNum_s <= (others => '0');
		elsif rising_edge (CpSl_RefClkP_i) then
			if (PrSv_RecvState_s = "010") then
				PrSv_EchoNum_s <= PrSv_EchoNum_s + '1';
			elsif (PrSv_RecvState_s = "000") then
				PrSv_EchoNum_s <= (others => '0');
			else -- hold
			end if;
		end if;
	end process;

	--  PrSv_RdDataCnt_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_RdDataCnt_s <= (others => '0');
		elsif rising_edge (CpSl_RefClkP_i) then
			if (PrSv_RecvState_s = "001") then
				PrSv_RdDataCnt_s <= PrSv_RdDataCnt_s + '1';
			else
				PrSv_RdDataCnt_s <= (others => '0');
			end if;
		end if;
	end process;

	-- PrSv_RecvData_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_RecvData_s <= (others => '0');
		elsif rising_edge (CpSl_RefClkP_i) then
			if (PrSv_RecvState_s = "001") then
				PrSv_RecvData_s <= PrSv_RecvData_s(22 downto 0) & PrSl_Sdo1Dly1Clk_s;
			else -- hold
			end if;
		end if;
	end process;

	-- PrSv_Cnt1us_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_Cnt1us_s <= (others => '0');
		elsif rising_edge(CpSl_RefClkP_i) then
			if (PrSv_RecvState_s /= "000") then
				if (PrSv_Cnt1us_s = PrSv_Cnt1us_c) then
					PrSv_Cnt1us_s <= PrSv_Cnt1us_c;
				else
					PrSv_Cnt1us_s <= PrSv_Cnt1us_s + '1';
				end if;
			else
				PrSv_Cnt1us_s <= (others => '0');
			end if;
		end if;
	end process;

	-- PrSl_Trig1us_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSl_Trig1us_s <= '0';
		elsif rising_edge(CpSl_RefClkP_i) then
			if (PrSv_RecvState_s /= "000") then
				if (PrSv_Cnt1us_s = PrSv_Cnt1us_c) then
					PrSl_Trig1us_s <= '1';
				else
					PrSl_Trig1us_s <= '0';
				end if;
			else
				PrSl_Trig1us_s <= '0';
			end if;
		end if;
	end process;

	-- PrSv_RecvEndCnt_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_RecvEndCnt_s <= (others => '0');
		elsif rising_edge(CpSl_RefClkP_i) then
			if (PrSv_RecvState_s = "100") then
				PrSv_RecvEndCnt_s <= PrSv_RecvEndCnt_s + '1';
			else
				PrSv_RecvEndCnt_s <= (others => '0');
			end if;
		end if;
	end process;

	-- CpSl_TdcDataVld_o
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			CpSl_TdcDataVld_o <= '0';
		elsif rising_edge(CpSl_RefClkP_i) then
			if (PrSv_RecvState_s = "100") then
				CpSl_TdcDataVld_o <= '1';
			else
				CpSl_TdcDataVld_o <= '0';
			end if;
		end if;
	end process;

	-- PrSv_TdcData_s
	process (CpSl_Rst_i,CpSl_RefClkP_i) begin
		if (CpSl_Rst_i = '0') then
			PrSv_TdcData_s <= (others => '0');
		elsif rising_edge(CpSl_RefClkP_i) then
			if (PrSv_RecvState_s = "011") then
				case PrSv_EchoNum_s is
					when "001" => PrSv_TdcData_s(15 downto  0) <= PrSv_RecvData_s(15 downto 0);
					when "010" => PrSv_TdcData_s(31 downto 16) <= PrSv_RecvData_s(15 downto 0);
					when "011" => PrSv_TdcData_s(47 downto 32) <= PrSv_RecvData_s(15 downto 0);
					when others => PrSv_TdcData_s <= PrSv_TdcData_s;
				end case ;
			else -- hold
			end if;
		end if;
	end process;
	--- CpSv_TdcData_o
	CpSv_TdcData_o <= PrSv_TdcData_s;
----------------------------------------------------------------------------
-- End Describe
----------------------------------------------------------------------------
end arch_M_TdcGpx2 ;