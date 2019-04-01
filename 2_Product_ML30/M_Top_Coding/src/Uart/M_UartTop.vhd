--------------------------------------------------------------------------------
-- °æ    È¨  :  ZVISION
-- ÎÄ¼þÃû³Æ  :  M_GpsTop.vhd
-- Éè    ¼Æ  :  Zhang Wenjun
-- ÓÊ    ¼þ  :  wenjun.zhang@zvision.xyz
-- Ð£    ¶Ô  :
-- Éè¼ÆÈÕÆÚ  :  2018/05/20
-- ¹¦ÄÜ¼òÊö  :  Uart receive, transfer to parallel data
--              Receive Time command ($GNRMC);
-- °æ±¾ÐòºÅ  :  0.1
-- ÐÞ¸ÄÀúÊ·  :  1. Initial, Zhang Wenjun, 2018/05/20
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity M_UartTop is
    port (
        --------------------------------
        -- Reset and clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
        CpSl_Clk_i                      : in  std_logic;                        -- 40MHz Clock,single

        --------------------------------
        -- Uart Receive Interface
        --------------------------------
        CpSl_RxD_i                      : in  std_logic;                        -- Receive Voltage Data

        --------------------------------
        -- Parallel Time Indicator
        --------------------------------
        CpSl_WrTrig1_o                  : out std_logic;                        -- Wr_Trig1        
        CpSl_WrTrig2_o                  : out std_logic;                        -- Wr_Trig2
        CpSv_Addr_o                     : out std_logic_vector(10 downto 0);    -- Parallel Time data
        CpSl_RecvDvld_o                 : out std_logic;                        -- Parallel Time data valid
        CpSv_RecvData_o                 : out std_logic_vector(11 downto 0)     -- Parallel Time data
    );
end M_UartTop;

architecture arch_M_UartTop of M_UartTop is
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------
    -- Frame
    constant PrSv_AddrHead_c            : std_logic_vector(7 downto 0) := x"AA";    -- FrameHead_AA
    constant PrSv_AddrEnd_c             : std_logic_vector(7 downto 0) := x"55";    -- Frame_End
    
    -- Baud Constant
--    constant PrSv_Baud115200_c          : std_logic_vector(11 downto 0) := x"364";  -- 868
--    constant PrSv_Half115200_c          : std_logic_vector(11 downto 0) := x"1B2";  -- 434
    
    -- 40MHz
    constant PrSv_Baud115200_c          : std_logic_vector(11 downto 0) := x"15B";  -- 347
    constant PrSv_Half115200_c          : std_logic_vector(11 downto 0) := x"0AD";  -- 173

    -- Recv_Data_State
    constant PrSv_FrameIdle_c           : std_logic_vector(3 downto 0) := "0000";
    constant PrSv_FrameHead_ID_c        : std_logic_vector(3 downto 0) := "0001";
    constant PrSv_FrameHead_G_c         : std_logic_vector(3 downto 0) := "0010";
    constant PrSv_FrameHead_P_c         : std_logic_vector(3 downto 0) := "0011";
    constant PrSv_FrameHead_R_c         : std_logic_vector(3 downto 0) := "0100";
    constant PrSv_FrameHead_M_c         : std_logic_vector(3 downto 0) := "0101";
    constant PrSv_FrameHead_C_c         : std_logic_vector(3 downto 0) := "0110";
    constant PrSv_FrameRecvTime_c       : std_logic_vector(3 downto 0) := "0111";
    constant PrSv_FrameAtrsk_c          : std_logic_vector(3 downto 0) := "1000";
    constant PrSv_FrameRecvEnd_c        : std_logic_vector(3 downto 0) := "1001";
    constant PrSv_FrameCheck_c          : std_logic_vector(3 downto 0) := "1010";
    constant PrSv_FrameEnd_c            : std_logic_vector(3 downto 0) := "1011";
    constant PrSv_UtcTime_c             : std_logic_vector(3 downto 0) := "1100";
    constant PrSv_UtcEnd_c              : std_logic_vector(3 downto 0) := "1101";

    ----------------------------------------------------------------------------
    -- component declaration
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal PrSl_RxDDly1_s               : std_logic;                            -- Delay 1 CpSl_RxD_i
    signal PrSl_RxDDly2_s               : std_logic;                            -- Delay 2 CpSl_RxD_i
    signal PrSl_RxDDly3_s               : std_logic;                            -- Delay 3 CpSl_RxD_i
    signal PrSl_RxDFallEdge_s           : std_logic;                            -- Falling edge of CpSl_RxD_i
    signal PrSv_BaudCnt_s               : std_logic_vector(15 downto 0);        -- Baud counter
    signal PrSl_CapEn_s                 : std_logic;                            -- Capture enable
    signal PrSv_NumCnt_s                : std_logic_vector( 3 downto 0);        -- Number of a parallel data
    signal PrSv_RxShifter_s             : std_logic_vector( 7 downto 0);        -- Shift register for Parallel data
    signal PrSv_RecvState_s             : std_logic_vector( 2 downto 0);        -- Uart receive data state
    signal PrSl_RxPalDvld_s             : std_logic;                            -- Parallel data valid
    signal PrSv_RxPalData_s             : std_logic_vector( 7 downto 0);        -- Parallel data
    signal PrSv_FrameState_s            : std_logic_vector( 3 downto 0);        -- Frame state
    signal PrSv_TimeCmdCnt_s            : std_logic_vector( 3 downto 0);        -- Comma count
    signal PrSv_TimePallData_s          : std_logic_vector(87 downto 0);        -- HMS parallel data(87:8)
    signal PrSv_DmyPallData_s           : std_logic_vector(55 downto 0);        -- Dmy parallel data(55:8)
    signal PrSv_CheckNum_s              : std_logic_vector( 1 downto 0);        -- Check_Num
    signal PrSv_RxCheckData_s           : std_logic_vector(15 downto 0);        -- Rx_Check_Data
    signal PrSl_CheckVld_s              : std_logic;                            -- Check_Vld
    signal PrSv_CheckResult_s           : std_logic_vector( 7 downto 0);        -- Check_Result
    signal PrSv_CheckData_s             : std_logic_vector(15 downto 0);        -- Check_High_Data
    signal PrSl_CheckTrig_s             : std_logic;                            -- Check_Trig
    signal PrSl_CheckResultVld_s        : std_logic;                            -- Check Result Valid
    signal PrSv_UtcTimeYear_s           : std_logic_vector( 7 downto 0);        -- UtcYear
    signal PrSv_UtcTimeMon_s            : std_logic_vector( 7 downto 0);        -- UtcMon
    signal PrSv_UtcTimeDay_s            : std_logic_vector( 7 downto 0);        -- UtcDay
    signal PrSv_UtcTimeHour_s           : std_logic_vector( 7 downto 0);        -- UtcHour
    signal PrSv_UtcTimeMin_s            : std_logic_vector( 7 downto 0);        -- UtcMin
    signal PrSv_UtcTimeSec_s            : std_logic_vector( 7 downto 0);        -- UtcSec
    signal PrSv_UtcTimeMs_s             : std_logic_vector(11 downto 0);        -- UtcMs
    signal PrSv_UtcYear_s               : std_logic_vector( 7 downto 0);        -- UtcYear
    signal PrSv_UtcMon_s                : std_logic_vector( 7 downto 0);        -- UtcMon
    signal PrSv_UtcDay_s                : std_logic_vector( 7 downto 0);        -- UtcDay
    signal PrSv_UtcHour_s               : std_logic_vector( 7 downto 0);        -- UtcHour
    signal PrSv_UtcMin_s                : std_logic_vector( 7 downto 0);        -- UtcMin
    signal PrSv_UtcSec_s                : std_logic_vector( 7 downto 0);        -- UtcSec
    signal PrSv_UtcMs_s                 : std_logic_vector(23 downto 0);        -- UtcMs
    
    -- Address
    signal PrSv_RecvNum_s               : std_logic_vector( 1 downto 0);        -- Recv_Num
    signal PrSv_RecvData_s              : std_logic_vector(15 downto 0);        -- Recv_Data
    signal PrSl_WrTrig1_s               : std_logic;                            -- WrTrig1
    signal PrSl_WrTrig2_s               : std_logic;                            -- WrTrig2
    signal PrSl_Ind_s                   : std_logic;                            -- Address_Ind
    
begin
    ----------------------------------------------------------------------------
    -- Receive serial data
    ----------------------------------------------------------------------------
    -- Latch CpSl_RxD_i
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_RxDDly1_s <= '1';
            PrSl_RxDDly2_s <= '1';
            PrSl_RxDDly3_s <= '1';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_RxDDly1_s <= CpSl_RxD_i    ;
            PrSl_RxDDly2_s <= PrSl_RxDDly1_s;
            PrSl_RxDDly3_s <= PrSl_RxDDly2_s;
        end if;
    end process;

    -- Falling edge of CpSl_RxD_i
    PrSl_RxDFallEdge_s <= (not PrSl_RxDDly2_s) and PrSl_RxDDly3_s;

    -- Baud counter
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_BaudCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RecvState_s /= "000") then
                if (PrSv_BaudCnt_s = PrSv_Baud115200_c) then -- Baud 115200
                    PrSv_BaudCnt_s <= (others => '0');
                else
                    PrSv_BaudCnt_s <= PrSv_BaudCnt_s + '1';
                end if;
            else
                PrSv_BaudCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- Data capture enable
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_CapEn_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_BaudCnt_s = PrSv_Half115200_c) then -- Baud 115200
                PrSl_CapEn_s <= '1';
            else
                PrSl_CapEn_s <= '0';
            end if;
        end if;
    end process;

    -- uart State machine
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_RecvState_s <= "000";
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_RecvState_s is
            when "000" =>
                if (PrSl_RxDFallEdge_s = '1') then
                    PrSv_RecvState_s <= "001";
                else -- hold
                end if;
            when "001" =>
                if (PrSl_CapEn_s = '1' and CpSl_RxD_i = '0') then
                    PrSv_RecvState_s <= "010";
                else -- hold
                end if;
            when "010" =>
                if (PrSl_CapEn_s = '1' and PrSv_NumCnt_s = "1000") then
                    PrSv_RecvState_s <= "100";
                else -- hold
                end if;
            when "100" =>
                if (PrSl_CapEn_s = '1' and CpSl_RxD_i = '1') then
                    PrSv_RecvState_s <= "000";
                else -- hold
                end if;
            when others =>
                PrSv_RecvState_s <= "000";
            end case;
        end if;
    end process;

    -- Counter for number of bits in a frame
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_NumCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_CapEn_s = '1') then
                if (PrSv_NumCnt_s = "1001") then
                    PrSv_NumCnt_s <= (others => '0');
                else
                    PrSv_NumCnt_s <= PrSv_NumCnt_s + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_RxShifter_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_RxShifter_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RecvState_s(1) = '1' and PrSl_CapEn_s = '1') then
                PrSv_RxShifter_s <= CpSl_Rxd_i & PrSv_RxShifter_s( 7 downto 1);
            else -- hold
            end if;
        end if;
    end process;

    ------------------------------------
    -- 8bit parallel
    ------------------------------------
    -- 8bit data valid
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_RxPalDvld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RecvState_s(2) = '1' and PrSl_CapEn_s = '1' and CpSl_RxD_i = '1') then
                PrSl_RxPalDvld_s <= '1';
            else
                PrSl_RxPalDvld_s <= '0';
            end if;
        end if;
    end process;

    -- Parallel 8bit data
    PrSv_RxPalData_s <= PrSv_RxShifter_s;

    ------------------------------------
    -- Frame head : "$GNRMC"
    -- Data : Time
    ------------------------------------
    -- Frame State machine
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_FrameState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_FrameState_s is
            when  PrSv_FrameIdle_c => -- Frame Idle
                if (PrSl_RxPalDvld_s = '1' and PrSv_RxPalData_s = PrSv_AddrHead_c) then
                    PrSv_FrameState_s <= PrSv_FrameHead_ID_c;
                else -- hold
                end if;

            when PrSv_FrameHead_ID_c => -- Data
                if (PrSl_RxPalDvld_s = '1' and PrSv_RecvNum_s = 1) then 
                    PrSv_FrameState_s <= PrSv_FrameRecvEnd_c;
                else -- hold
                end if;

            when PrSv_FrameRecvEnd_c => -- FrameEnd
                if (PrSl_RxPalDvld_s = '1') then
                    if (PrSv_RxPalData_s = PrSv_AddrEnd_c) then 
                        PrSv_FrameState_s <= PrSv_FrameCheck_c;
                    else
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else -- hold
                end if;
                
            when PrSv_FrameCheck_c => 
                PrSv_FrameState_s <= PrSv_FrameEnd_c;      
            
            when PrSv_FrameEnd_c => -- Valid_End
                PrSv_FrameState_s <= (others => '0');

            when others =>
                PrSv_FrameState_s <= (others => '0');
            end case;
        end if;
    end process;

    -- PrSv_RecvNum_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RecvNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_FrameState_s = PrSv_FrameHead_ID_c) then
                if (PrSl_RxPalDvld_s = '1') then 
                    PrSv_RecvNum_s <= PrSv_RecvNum_s + '1';
                else -- hold
                end if;
            else
                PrSv_RecvNum_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_RecvData_s                     
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RecvData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_FrameState_s = PrSv_FrameHead_ID_c) then
                case PrSv_RecvNum_s is
                    when "00" => 
                        if (PrSl_RxPalDvld_s = '1') then 
                            PrSv_RecvData_s(15 downto 8) <= PrSv_RxPalData_s;
                        else
                        end if;
                    when "01" => 
                        if (PrSl_RxPalDvld_s = '1') then 
                            PrSv_RecvData_s( 7 downto 0) <= PrSv_RxPalData_s;
                        else
                        end if;
                    when others => PrSv_RecvData_s <= PrSv_RecvData_s;
                end case;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_FrameState_s <= PrSv_FrameCheck_c
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then         
            PrSl_WrTrig1_s <= '0';
            PrSl_WrTrig2_s <= '0';
            PrSl_Ind_s     <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameCheck_c) then 
            case PrSv_RecvData_s(15 downto 12) is
                when "0000" => 
                    PrSl_WrTrig1_s <= '0';
                    PrSl_WrTrig2_s <= '0';
                    PrSl_Ind_s     <= '1';
                when "1000" => 
                    PrSl_WrTrig1_s <= '1';
                    PrSl_WrTrig2_s <= '0';
                    PrSl_Ind_s     <= '0';
                when "1100" => 
                    PrSl_WrTrig1_s <= '0';
                    PrSl_WrTrig2_s <= '1';
                    PrSl_Ind_s     <= '0';
                when others => 
                    PrSl_WrTrig1_s <= '0';
                    PrSl_WrTrig2_s <= '0';
                    PrSl_Ind_s     <= '0';
            end case;
            else
            end if;
        end if;
    end process;

    ------------------------------------
    -- OutPut
    ------------------------------------
    -- CpSl_RecvDvld_o
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_RecvDvld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameEnd_c) then
                CpSl_RecvDvld_o <= '1';
            else
                CpSl_RecvDvld_o <= '0';
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_WrTrig1_o <= '0';
            CpSl_WrTrig2_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameEnd_c) then
                CpSl_WrTrig1_o <= PrSl_WrTrig1_s;
                CpSl_WrTrig2_o <= PrSl_WrTrig2_s;
            else
                CpSl_WrTrig1_o <= '0';
                CpSl_WrTrig2_o <= '0';
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_Addr_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameEnd_c) then
                if (PrSl_Ind_s = '1') then 
                    CpSv_Addr_o <= PrSv_RecvData_s(10 downto 0);
                else
                    CpSv_Addr_o <= (others => '0');
                end if;
            else  -- hold
            end if;
        end if;
    end process;
    
    -- CpSv_RecvData_o
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_RecvData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameEnd_c) then
                CpSv_RecvData_o <= PrSv_RecvData_s(11 downto 0);
            else  -- hold
            end if;
        end if;
    end process;

----------------------------------------
-- End
----------------------------------------
end arch_M_UartTop;