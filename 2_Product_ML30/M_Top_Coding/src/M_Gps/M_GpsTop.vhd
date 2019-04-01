--------------------------------------------------------------------------------
-- °æ    È¨  :  ZVISION
-- ÎÄ¼þÃû³Æ  :  M_GpsTop.vhd
-- Éè    ¼Æ  :  Zhang Wenjun
-- ÓÊ    ¼þ  :  wenjun.zhang@zvision.xyz
-- Ð£    ¶Ô  :  
-- Éè¼ÆÈÕÆÚ  :  2018/05/20
-- ¹¦ÄÜ¼òÊö  :  Uart receive, transfer to parallel data
--              Receive Time command ($GPRMC);
-- °æ±¾ÐòºÅ  :  0.1
-- ÐÞ¸ÄÀúÊ·  :  1. Initial, Zhang Wenjun, 2018/05/20
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_GpsTop is
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
        CpSl_TimeDvld_o                 : out std_logic;                        -- Parallel Time data valid
        CpSv_YmdHmsData_o               : out std_logic_vector(79 downto 0)     -- Parallel Time data
    );
end M_GpsTop;

architecture arch_M_GpsTop of M_GpsTop is 
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------
    -- $GPRMC
    constant PrSv_GPSHead_ID_c          : std_logic_vector(7 downto 0) := x"24";    -- ASCII_$_24H
    constant PrSv_GPSHead_G_c           : std_logic_vector(7 downto 0) := x"47";    -- ASCII_G_47H
    constant PrSv_GPSHead_P_c           : std_logic_vector(7 downto 0) := x"50";    -- ASCII_P_50H
    constant PrSv_GPSHead_N_c           : std_logic_vector(7 downto 0) := x"4E";    -- ASCII_N_4E
    constant PrSv_GPSHead_R_c           : std_logic_vector(7 downto 0) := x"52";    -- ASCII_R_52H
    constant PrSv_GPSHead_M_c           : std_logic_vector(7 downto 0) := x"4D";    -- ASCII_M_4DH
    constant PrSv_GPSHead_C_c           : std_logic_vector(7 downto 0) := x"43";    -- ASCII_C_43H       
    constant PrSv_GpsLock_c             : std_logic_vector(7 downto 0) := x"41";    -- ASCII_A_41H
    constant PrSv_GPSHead_Cma_c         : std_logic_vector(7 downto 0) := x"2C";    -- ASCII_,_2CH(Comma)
    constant PrSv_GPSHead_Atrsk_c       : std_logic_vector(7 downto 0) := x"2A";    -- ASCII_*_2AH(Asterisk) 
    constant PrSv_GPSus_c               : std_logic_vector(15 downto 0) := x"0000"; -- GPS_us_Time 

    ------------------------------------
    -- Baud Constant
    ------------------------------------
    -- 115200
    constant PrSv_Baud9600_c            : std_logic_vector(15 downto 0) := x"015A"; -- 347
    constant PrSv_Half9600_c            : std_logic_vector(15 downto 0) := x"00AD"; -- 173
        
    -- 9600
--    constant PrSv_Baud9600_c            : std_logic_vector(15 downto 0) := x"1045"; -- 4166
--    constant PrSv_Half9600_c            : std_logic_vector(15 downto 0) := x"0823"; -- 2083

    -- 4800
--    constant PrSv_Baud9600_c            : std_logic_vector(15 downto 0) := x"208C"; -- 8333
--    constant PrSv_Half9600_c            : std_logic_vector(15 downto 0) := x"1045"; -- 4166
        
    -- Recv_Data_State
    constant PrSv_FrameIdle_c           : std_logic_vector(3 downto 0) := "0000";
    constant PrSv_FrameHead_ID_c        : std_logic_vector(3 downto 0) := "0001";
    constant PrSv_FrameHead_G_c         : std_logic_vector(3 downto 0) := "0010";
    constant PrSv_FrameHead_P_c         : std_logic_vector(3 downto 0) := "0011";
    constant PrSv_FrameHead_R_c         : std_logic_vector(3 downto 0) := "0100";
    constant PrSv_FrameHead_M_c         : std_logic_vector(3 downto 0) := "0101";
--    constant PrSv_FrameHead_C_c         : std_logic_vector(3 downto 0) := "0110";
    constant PrSv_Frame_HMS_c           : std_logic_vector(3 downto 0) := "0110";
    constant PrSv_FrameLock_c           : std_logic_vector(3 downto 0) := "0111";
    constant PrSv_FrameLoca_c           : std_logic_vector(3 downto 0) := "1000";
    constant PrSv_FrameMagnet_c         : std_logic_vector(3 downto 0) := "1001";
    constant PrSv_FrameAtrsk_c          : std_logic_vector(3 downto 0) := "1010";
    constant PrSv_FrameRecvEnd_c        : std_logic_vector(3 downto 0) := "1011";
    constant PrSv_FrameCheck_c          : std_logic_vector(3 downto 0) := "1100";
    constant PrSv_FrameEnd_c            : std_logic_vector(3 downto 0) := "1101";
    constant PrSv_UtcTime_c             : std_logic_vector(3 downto 0) := "1110";
    constant PrSv_UtcEnd_c              : std_logic_vector(3 downto 0) := "1111";

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
    signal PrSv_TimeCnt_s               : std_logic_vector( 3 downto 0);        -- Recv_TimeCnt
    signal PrSv_RecvTime_s              : std_logic_vector(63 downto 0);        -- Recv_TimeData
    signal PrSv_RecvHms_s               : std_logic_vector(47 downto 0);        -- Recv_Hour/Min/Sec
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

    -- GPS_Time_Shift
    signal PrSv_UtcYearH_s              : std_logic_vector( 7 downto 0);        -- UTC_Year
    signal PrSv_UtcYearM_s              : std_logic_vector( 4 downto 0);        -- UTC_Year
    signal PrSv_UtcYearL_s              : std_logic_vector( 3 downto 0);        -- UTC_Year
    signal PrSv_UtcMonH_s               : std_logic_vector( 7 downto 0);        -- UTC_Mon
    signal PrSv_UtcMonM_s               : std_logic_vector( 4 downto 0);        -- UTC_Mon
    signal PrSv_UtcMonL_s               : std_logic_vector( 3 downto 0);        -- UTC_Mon
    signal PrSv_UtcDayH_s               : std_logic_vector( 7 downto 0);        -- UTC_Day
    signal PrSv_UtcDayM_s               : std_logic_vector( 4 downto 0);        -- UTC_Day
    signal PrSv_UtcDayL_s               : std_logic_vector( 3 downto 0);        -- UTC_Day
    signal PrSv_UtcHourH_s              : std_logic_vector( 7 downto 0);        -- UTC_Hour
    signal PrSv_UtcHourM_s              : std_logic_vector( 4 downto 0);        -- UTC_Hour
    signal PrSv_UtcHourL_s              : std_logic_vector( 3 downto 0);        -- UTC_Hour
    signal PrSv_UtcMinH_s               : std_logic_vector( 7 downto 0);        -- UTC_Min
    signal PrSv_UtcMinM_s               : std_logic_vector( 4 downto 0);        -- UTC_Min
    signal PrSv_UtcMinL_s               : std_logic_vector( 3 downto 0);        -- UTC_Min
    signal PrSv_UtcSecH_s               : std_logic_vector( 7 downto 0);        -- UTC_Sec
    signal PrSv_UtcSecM_s               : std_logic_vector( 4 downto 0);        -- UTC_Sec
    signal PrSv_UtcSecL_s               : std_logic_vector( 3 downto 0);        -- UTC_Sec
    signal PrSv_UtcMsH1_s               : std_logic_vector(15 downto 0);        -- UTC_MS
    signal PrSv_UtcMsH2_s               : std_logic_vector( 8 downto 0);        -- UTC_MS
    signal PrSv_UtcMsH3_s               : std_logic_vector( 5 downto 0);        -- UTC_MS
    signal PrSv_UtcMsM1_s               : std_logic_vector( 6 downto 0);        -- UTC_MS
    signal PrSv_UtcMsM2_s               : std_logic_vector( 4 downto 0);        -- UTC_MS
    signal PrSv_UtcMsL_s                : std_logic_vector( 3 downto 0);        -- UTC_MS
    
    signal PrSv_UtcYear_s               : std_logic_vector( 7 downto 0);        -- UtcYear
    signal PrSv_UtcMon_s                : std_logic_vector( 7 downto 0);        -- UtcMon
    signal PrSv_UtcDay_s                : std_logic_vector( 7 downto 0);        -- UtcDay
    signal PrSv_UtcHour_s               : std_logic_vector( 7 downto 0);        -- UtcHour
    signal PrSv_UtcMin_s                : std_logic_vector( 7 downto 0);        -- UtcMin
    signal PrSv_UtcSec_s                : std_logic_vector( 7 downto 0);        -- UtcSec
    signal PrSv_UtcMs_s                 : std_logic_vector(15 downto 0);        -- UtcMs

    -- test signal 
    signal PrSv_Iime1_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time2_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time3_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time4_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time5_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time6_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time7_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time8_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time9_s                 : std_logic_vector(3 downto 0);
    signal PrSv_Time10_s                : std_logic_vector(3 downto 0);
    signal PrSv_Time11_s                : std_logic_vector(3 downto 0);
    signal PrSv_Time12_s                : std_logic_vector(3 downto 0);
    signal PrSv_Time13_s                : std_logic_vector(3 downto 0);
    signal PrSv_Time14_s                : std_logic_vector(3 downto 0);
    signal PrSv_Time15_s                : std_logic_vector(3 downto 0);
    signal PrSv_Time16_s                : std_logic_vector(7 downto 0);
    signal PrSv_Time17_s                : std_logic_vector(4 downto 0);

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
                if (PrSv_BaudCnt_s = PrSv_Baud9600_c) then -- Baud 9600
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
            if (PrSv_BaudCnt_s = PrSv_Half9600_c) then -- Baud 9600
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
            when  PrSv_FrameIdle_c => -- Frame_Idle
                if (PrSl_RxPalDvld_s = '1') then 
                    if (PrSv_RxPalData_s = PrSv_GPSHead_ID_c) then -- Frame_Head_$ 
                        PrSv_FrameState_s <= PrSv_FrameHead_ID_c;
                    else
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else -- hold
                end if;
            
            when PrSv_FrameHead_ID_c => -- Frame_Head_G
                if (PrSl_RxPalDvld_s = '1') then 
                    if (PrSv_RxPalData_s = PrSv_GPSHead_G_c) then 
                        PrSv_FrameState_s <= PrSv_FrameHead_G_c;
                    else
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else -- hold
                end if;
            
            when PrSv_FrameHead_G_c => -- Frame_Head_P
                if (PrSl_RxPalDvld_s = '1') then 
                    if(PrSv_RxPalData_s = PrSv_GPSHead_P_c) then 
                        PrSv_FrameState_s <= PrSv_FrameHead_P_c;
--                    elsif (PrSv_RxPalData_s = PrSv_GPSHead_N_c) then 
--                        PrSv_FrameState_s <= PrSv_FrameHead_P_c;
                    else
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else
                end if;

            when PrSv_FrameHead_P_c => -- Frame_Head_R
                if (PrSl_RxPalDvld_s = '1') then 
                    if( PrSv_RxPalData_s = PrSv_GPSHead_R_c) then 
                        PrSv_FrameState_s <= PrSv_FrameHead_R_c;
                    else 
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else -- hold
                end if;
                    
            when PrSv_FrameHead_R_c => -- Frame_Head_M
                if (PrSl_RxPalDvld_s = '1') then 
                    if (PrSv_RxPalData_s = PrSv_GPSHead_M_c) then 
                        PrSv_FrameState_s <= PrSv_FrameHead_M_c;
                    else 
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else -- hold
                end if;
            
            when PrSv_FrameHead_M_c => -- Frame_Head_C
                if (PrSl_RxPalDvld_s = '1') then 
                    if( PrSv_RxPalData_s = PrSv_GPSHead_C_c) then
                        PrSv_FrameState_s <= PrSv_Frame_HMS_c;
                    else 
                        PrSv_FrameState_s <= (others => '0');
                    end if;
                else -- hold
                end if;
                    
            when PrSv_Frame_HMS_c => -- Frame_Hour&Min&Sec
                if (PrSv_TimeCnt_s = 8) then
                    PrSv_FrameState_s <= PrSv_FrameLock_c;
                else -- hold
                end if;                    
            
            when PrSv_FrameLock_c => -- Frame_Lock_"A"
                if (PrSl_RxPalDvld_s = '1') then                    
                    if (PrSv_RxPalData_s = PrSv_GpsLock_c) then 
                        PrSv_FrameState_s <= PrSv_FrameLoca_c;
                    else
                        PrSv_FrameState_s <= PrSv_FrameIdle_c;
                    end if;
                else -- hold
                end if;
            
            when PrSv_FrameLoca_c => -- Frame_Location_','
                if (PrSv_TimeCmdCnt_s = 9) then 
                    PrSv_FrameState_s <= PrSv_FrameMagnet_c;
                else -- hold
                end if;
            
            when PrSv_FrameMagnet_c => -- Frame_Magnetic
                if (PrSl_RxPalDvld_s = '1') then
                    PrSv_FrameState_s <= PrSv_FrameAtrsk_c;
                else -- hold
                end if;
                
            when PrSv_FrameAtrsk_c => -- Frame_'*'
                if (PrSl_RxPalDvld_s = '1' and PrSv_RxPalData_s = PrSv_GPSHead_Atrsk_c) then 
                    PrSv_FrameState_s <= PrSv_FrameRecvEnd_c;
                else -- hold
                end if;

            when PrSv_FrameRecvEnd_c => -- Recv_Check_Data
                if (PrSv_CheckNum_s = 2) then
                    PrSv_FrameState_s <= PrSv_FrameCheck_c;
                else -- hold
                end if;
                
            when PrSv_FrameCheck_c => -- Frame_Check
                if (PrSl_CheckResultVld_s = '1') then
                    PrSv_FrameState_s <= PrSv_FrameEnd_c;
                else
                    PrSv_FrameState_s <= (others => '0');
                end if;

            when PrSv_FrameEnd_c => -- FrameEnd
                PrSv_FrameState_s <= PrSv_UtcTime_c;
                    
            when PrSv_UtcTime_c => -- UTC_Time
                PrSv_FrameState_s <= PrSv_UtcEnd_c;
            
            when PrSv_UtcEnd_c => -- UTC_Hex
                PrSv_FrameState_s <= (others => '0');
                    
            when others =>
                PrSv_FrameState_s <= (others => '0');
            end case;
        end if;
    end process;
    
    ------------------------------------
    -- Frame_Hour & Min & Sec
    ------------------------------------
    -- PrSv_TimeCnt_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_TimeCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_Frame_HMS_c) then 
                if (PrSl_RxPalDvld_s = '1') then
                    PrSv_TimeCnt_s <= PrSv_TimeCnt_s + '1';
                else -- hold
                end if;
            else
                PrSv_TimeCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_RecvTime_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
             PrSv_RecvTime_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameIdle_c) then 
                PrSv_RecvTime_s <= (others => '0');
            elsif (PrSv_FrameState_s = PrSv_Frame_HMS_c) then 
                if (PrSl_RxPalDvld_s = '1') then
                    PrSv_RecvTime_s <= PrSv_RecvTime_s(55 downto 0) & PrSv_RxPalData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_RecvHms_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_RecvHms_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameIdle_c) then 
                PrSv_RecvHms_s <= (others => '0');
            elsif (PrSv_FrameState_s = PrSv_FrameLock_c) then
                PrSv_RecvHms_s <= PrSv_RecvTime_s(55 downto 8);
            else  -- hold
            end if; 
        end if; 
    end process;
    
--    -- HHmmss.ms
--    process (CpSl_Rst_iN, CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_TimePallData_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_FrameState_s = PrSv_FrameHead_C_c and PrSv_TimeCmdCnt_s = 1) then
--                if (PrSl_RxPalDvld_s = '1') then
--                    PrSv_TimePallData_s <= PrSv_TimePallData_s(79 downto 0) & PrSv_RxPalData_s;
--                else -- hold
--                end if;
--            else -- hold
--            end if;
--        end if;
--    end process;

    -- ',' Count
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_TimeCmdCnt_s <= (others => '0');
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSv_FrameState_s = PrSv_FrameLoca_c) then
                if (PrSl_RxPalDvld_s = '1' and PrSv_RxPalData_s = PrSv_GPSHead_Cma_c) then
                    PrSv_TimeCmdCnt_s <= PrSv_TimeCmdCnt_s + '1';
                else -- hold
                end if;
            else
               PrSv_TimeCmdCnt_s <= (others => '0'); 
            end if;
        end if;
    end process;
    
    -- PrSv_DmyPallData_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_DmyPallData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameIdle_c) then 
                PrSv_DmyPallData_s <= (others => '0');
            elsif (PrSv_FrameState_s = PrSv_FrameLoca_c and PrSv_TimeCmdCnt_s = 7) then
                if (PrSl_RxPalDvld_s = '1') then
                    PrSv_DmyPallData_s <= PrSv_DmyPallData_s(47 downto 0) & PrSv_RxPalData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;
        
    -- PrSv_CheckNum_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_CheckNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameRecvEnd_c) then
                if (PrSl_RxPalDvld_s = '1') then
                    PrSv_CheckNum_s <= PrSv_CheckNum_s + '1';
                else 
                end if;
            else
                PrSv_CheckNum_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_RxCheckData_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_RxCheckData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameIdle_c) then
                PrSv_RxCheckData_s <= (others => '0');
            elsif (PrSv_FrameState_s = PrSv_FrameRecvEnd_c) then
                if (PrSl_RxPalDvld_s = '1' and PrSv_CheckNum_s = 0) then 
                    PrSv_RxCheckData_s(15 downto 8) <= PrSv_RxPalData_s;
                elsif (PrSl_RxPalDvld_s = '1' and PrSv_CheckNum_s = 1) then
                    PrSv_RxCheckData_s(7 downto 0) <= PrSv_RxPalData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSl_CheckVld_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_CheckVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameHead_ID_c) then 
                PrSl_CheckVld_s <= '1';
            elsif (PrSv_FrameState_s = PrSv_FrameAtrsk_c) then 
                PrSl_CheckVld_s <= '0';
            end if;
        end if;
    end process;
    
    -- PrSv_CheckResult_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_CheckResult_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameIdle_c) then
                PrSv_CheckResult_s <= (others => '0');
            elsif (PrSl_CheckVld_s = '1') then 
                if (PrSl_RxPalDvld_s = '1') then
                    PrSv_CheckResult_s <= PrSv_CheckResult_s xor PrSv_RxPalData_s;
                else -- hold;
                end if;
            else
                PrSv_CheckResult_s <= PrSv_CheckResult_s;
            end if;
        end if;
    end process;
    
    -- PrSv_CheckData_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_CheckData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameRecvEnd_c and PrSl_RxPalDvld_s = '1' and PrSv_CheckNum_s = 0) then 
                case PrSv_CheckResult_s(7 downto 4) is
                    when x"0" => PrSv_CheckData_s(15 downto 8) <= x"30";
                    when x"1" => PrSv_CheckData_s(15 downto 8) <= x"31";
                    when x"2" => PrSv_CheckData_s(15 downto 8) <= x"32";
                    when x"3" => PrSv_CheckData_s(15 downto 8) <= x"33";
                    when x"4" => PrSv_CheckData_s(15 downto 8) <= x"34";
                    when x"5" => PrSv_CheckData_s(15 downto 8) <= x"35";
                    when x"6" => PrSv_CheckData_s(15 downto 8) <= x"36";
                    when x"7" => PrSv_CheckData_s(15 downto 8) <= x"37";
                    when x"8" => PrSv_CheckData_s(15 downto 8) <= x"38";
                    when x"9" => PrSv_CheckData_s(15 downto 8) <= x"39";
                    when x"a" => PrSv_CheckData_s(15 downto 8) <= x"41";
                    when x"b" => PrSv_CheckData_s(15 downto 8) <= x"42";
                    when x"c" => PrSv_CheckData_s(15 downto 8) <= x"43";
                    when x"d" => PrSv_CheckData_s(15 downto 8) <= x"44";
                    when x"e" => PrSv_CheckData_s(15 downto 8) <= x"45";
                    when x"f" => PrSv_CheckData_s(15 downto 8) <= x"46";
                    when others => PrSv_CheckData_s(15 downto 8) <= (others => '0');
                end case;
            else 
            end if;
                
            if (PrSv_FrameState_s = PrSv_FrameRecvEnd_c and PrSl_RxPalDvld_s = '1' and PrSv_CheckNum_s = 0) then 
                case PrSv_CheckResult_s(3 downto 0) is
                    when x"0" => PrSv_CheckData_s(7 downto 0) <= x"30";
                    when x"1" => PrSv_CheckData_s(7 downto 0) <= x"31";
                    when x"2" => PrSv_CheckData_s(7 downto 0) <= x"32";
                    when x"3" => PrSv_CheckData_s(7 downto 0) <= x"33";
                    when x"4" => PrSv_CheckData_s(7 downto 0) <= x"34";
                    when x"5" => PrSv_CheckData_s(7 downto 0) <= x"35";
                    when x"6" => PrSv_CheckData_s(7 downto 0) <= x"36";
                    when x"7" => PrSv_CheckData_s(7 downto 0) <= x"37";
                    when x"8" => PrSv_CheckData_s(7 downto 0) <= x"38";
                    when x"9" => PrSv_CheckData_s(7 downto 0) <= x"39";
                    when x"a" => PrSv_CheckData_s(7 downto 0) <= x"41";
                    when x"b" => PrSv_CheckData_s(7 downto 0) <= x"42";
                    when x"c" => PrSv_CheckData_s(7 downto 0) <= x"43";
                    when x"d" => PrSv_CheckData_s(7 downto 0) <= x"44";
                    when x"e" => PrSv_CheckData_s(7 downto 0) <= x"45";
                    when x"f" => PrSv_CheckData_s(7 downto 0) <= x"46";
                    when others => PrSv_CheckData_s(7 downto 0) <= (others => '0');
                end case;
            else 
            end if;
        end if;    
    end process;
    
    -- PrSl_CheckTrig_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_CheckTrig_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_FrameState_s = PrSv_FrameRecvEnd_c and PrSl_RxPalDvld_s = '1' and PrSv_CheckNum_s = 1) then 
                PrSl_CheckTrig_s <= '1';
            else 
                PrSl_CheckTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- PrSl_CheckResultVld_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_CheckResultVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_CheckTrig_s = '1' and PrSv_RxCheckData_s = PrSv_CheckData_s) then 
                PrSl_CheckResultVld_s <= '1';
            elsif (PrSv_FrameState_s = PrSv_FrameIdle_c) then
                PrSl_CheckResultVld_s <= '0';
            else -- hold
            end if; 
        end if;
    end process;

    --------------------------------
    -- Capture UTC Time
    --------------------------------
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcYearH_s    <= (others => '0');
            PrSv_UtcYearM_s    <= (others => '0');
            PrSv_UtcYearL_s    <= (others => '0');
            PrSv_UtcMonH_s     <= (others => '0');
            PrSv_UtcMonM_s     <= (others => '0');
            PrSv_UtcMonL_s     <= (others => '0');
            PrSv_UtcDayH_s     <= (others => '0');
            PrSv_UtcDayM_s     <= (others => '0');
            PrSv_UtcDayL_s     <= (others => '0');
            PrSv_UtcHourH_s    <= (others => '0');
            PrSv_UtcHourM_s    <= (others => '0');
            PrSv_UtcHourL_s    <= (others => '0');
            PrSv_UtcMinH_s     <= (others => '0');
            PrSv_UtcMinM_s     <= (others => '0');
            PrSv_UtcMinL_s     <= (others => '0');
            PrSv_UtcSecH_s     <= (others => '0');
            PrSv_UtcSecM_s     <= (others => '0');
            PrSv_UtcSecL_s     <= (others => '0');
            PrSv_UtcMsH1_s     <= (others => '0');
            PrSv_UtcMsH2_s     <= (others => '0');
            PrSv_UtcMsH3_s     <= (others => '0');
            PrSv_UtcMsM1_s     <= (others => '0');
            PrSv_UtcMsM2_s     <= (others => '0');
            PrSv_UtcMsL_s      <= (others => '0');

        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameEnd_c) then
                ------------------------
                -- GPRMC
                ------------------------
                -- Year/Mon/Day
                PrSv_UtcYearH_s <= '0' & PrSv_DmyPallData_s(19 downto 16) & "000";
                PrSv_UtcYearM_s <= PrSv_DmyPallData_s(19 downto 16) & '0';
                PrSv_UtcYearL_s <= PrSv_DmyPallData_s(11 downto  8);
                PrSv_UtcMonH_s  <= '0' & PrSv_DmyPallData_s(35 downto 32) & "000";
                PrSv_UtcMonM_s  <= PrSv_DmyPallData_s(35 downto 32) & '0';
                PrSv_UtcMonL_s  <= PrSv_DmyPallData_s(27 downto 24);
                PrSv_UtcDayH_s  <= '0' & PrSv_DmyPallData_s(51 downto 48) & "000";
                PrSv_UtcDayM_s  <= PrSv_DmyPallData_s(51 downto 48) & "0";
                PrSv_UtcDayL_s  <= PrSv_DmyPallData_s(43 downto 40);
                
                -- Hour/Min/Sec
                PrSv_UtcHourH_s <= '0' & PrSv_RecvHms_s(43 downto 40) & "000";
                PrSv_UtcHourM_s <= PrSv_RecvHms_s(43 downto 40) & '0';
                PrSv_UtcHourL_s <= PrSv_RecvHms_s(35 downto 32);
                PrSv_UtcMinH_s  <= '0' & PrSv_RecvHms_s(27 downto 24) & "000";
                PrSv_UtcMinM_s  <=  PrSv_RecvHms_s(27 downto 24) & '0';
                PrSv_UtcMinL_s  <=  PrSv_RecvHms_s(19 downto 16); 
                PrSv_UtcSecH_s  <= '0' & PrSv_RecvHms_s(11 downto  8) & "000";
                PrSv_UtcSecM_s  <= PrSv_RecvHms_s(11 downto  8) & '0';
                PrSv_UtcSecL_s  <= PrSv_RecvHms_s( 3 downto  0); 
                
                -- ms
                PrSv_UtcMsH1_s  <= (others => '0');
                PrSv_UtcMsH2_s  <= (others => '0');
                PrSv_UtcMsH3_s  <= (others => '0');
                PrSv_UtcMsM1_s  <= (others => '0');
                PrSv_UtcMsM2_s  <= (others => '0');
                PrSv_UtcMsL_s   <= (others => '0');
                
                -- GNRMC
--                PrSv_UtcYearH_s <= '0' & PrSv_DmyPallData_s(19 downto 16) & "000";
--                PrSv_UtcYearM_s <= PrSv_DmyPallData_s(19 downto 16) & '0';
--                PrSv_UtcYearL_s <= PrSv_DmyPallData_s(11 downto  8);
--                PrSv_UtcMonH_s  <= '0' & PrSv_DmyPallData_s(35 downto 32) & "000";
--                PrSv_UtcMonM_s  <= PrSv_DmyPallData_s(35 downto 32) & '0';
--                PrSv_UtcMonL_s  <= PrSv_DmyPallData_s(27 downto 24);
--                PrSv_UtcDayH_s  <= '0' & PrSv_DmyPallData_s(51 downto 48) & "000";
--                PrSv_UtcDayM_s  <= PrSv_DmyPallData_s(51 downto 48) & "0";
--                PrSv_UtcDayL_s  <= PrSv_DmyPallData_s(43 downto 40);
--                PrSv_UtcHourH_s <= '0' & PrSv_TimePallData_s(83 downto 80) & "000";
--                PrSv_UtcHourM_s <= PrSv_TimePallData_s(83 downto 80) & '0';
--                PrSv_UtcHourL_s <= PrSv_TimePallData_s(75 downto 72);
--                PrSv_UtcMinH_s  <= '0' & PrSv_TimePallData_s(67 downto 64) & "000";
--                PrSv_UtcMinM_s  <=  PrSv_TimePallData_s(67 downto 64) & '0';
--                PrSv_UtcMinL_s  <=  PrSv_TimePallData_s(59 downto 56); 
--                PrSv_UtcSecH_s  <= '0' & PrSv_TimePallData_s(51 downto 48) & "000";
--                PrSv_UtcSecM_s  <= PrSv_TimePallData_s(51 downto 48) & '0';
--                PrSv_UtcSecL_s  <= PrSv_TimePallData_s(43 downto 40); 
--                PrSv_UtcMsH1_s  <= "000000" & PrSv_TimePallData_s(27 downto 24) & "000000";
--                PrSv_UtcMsH2_s  <= PrSv_TimePallData_s(27 downto 24) & "00000";
--                PrSv_UtcMsH3_s  <= PrSv_TimePallData_s(27 downto 24) & "00";
--                PrSv_UtcMsM1_s  <= PrSv_TimePallData_s(19 downto 16) & "000";
--                PrSv_UtcMsM2_s  <= PrSv_TimePallData_s(19 downto 16) & "0";
--                PrSv_UtcMsL_s   <= PrSv_TimePallData_s(11 downto 8);

            else
            end if;
        end if;
    end process;
    
    -- UTCTime_Hex
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcYear_s <= (others => '0');
            PrSv_UtcMon_s  <= (others => '0');
            PrSv_UtcDay_s  <= (others => '0');
            PrSv_UtcHour_s <= (others => '0');
            PrSv_UtcMin_s  <= (others => '0');
            PrSv_UtcSec_s  <= (others => '0');
            PrSv_UtcMs_s   <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_UtcTime_c) then
                PrSv_UtcYear_s <= PrSv_UtcYearH_s + PrSv_UtcYearM_s + PrSv_UtcYearL_s;
                PrSv_UtcMon_s  <= PrSv_UtcMonH_s + PrSv_UtcMonM_s + PrSv_UtcMonL_s;
                PrSv_UtcDay_s  <= PrSv_UtcDayH_s + PrSv_UtcDayM_s + PrSv_UtcDayL_s;
                PrSv_UtcHour_s <= PrSv_UtcHourH_s + PrSv_UtcHourM_s + PrSv_UtcHourL_s;
                PrSv_UtcMin_s  <= PrSv_UtcMinH_s + PrSv_UtcMinM_s + PrSv_UtcMinL_s;
                PrSv_UtcSec_s  <= PrSv_UtcSecH_s + PrSv_UtcSecM_s + PrSv_UtcSecL_s;
                PrSv_UtcMs_s   <= PrSv_UtcMsH1_s + PrSv_UtcMsH2_s + PrSv_UtcMsH3_s 
                                    + PrSv_UtcMsM1_s + PrSv_UtcMsM2_s + PrSv_UtcMsL_s;
            else -- hold
            end if;
        end if;
    end process;
    
    --------------------------------
    -- Time output
    --------------------------------
    -- CpSl_TimeDvld_o
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_TimeDvld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_UtcEnd_c) then 
                CpSl_TimeDvld_o <= '1';
            else
                CpSl_TimeDvld_o <= '0';
            end if;
        end if;
    end process;

    -- CpSv_YmdHmsData_o
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_YmdHmsData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_UtcEnd_c) then
                CpSv_YmdHmsData_o <= PrSv_UtcYear_s & PrSv_UtcMon_s & PrSv_UtcDay_s 
                                    & PrSv_UtcHour_s & PrSv_UtcMin_s & PrSv_UtcSec_s 
                                    & PrSv_UtcMs_s & PrSv_GPSus_c;
            else  -- hold
            end if;
        end if;
    end process;

    --process (CpSl_Rst_iN, CpSl_Clk_i) begin
    --    if (CpSl_Rst_iN = '0') then
    --        CpSl_TimeDvld_o <= '0';
    --        CpSv_YmdHmsData_o <= (others => '0');
    --    elsif rising_edge(CpSl_Clk_i) then
    --        if (PrSv_FrameState_s = PrSv_UtcEnd_c) then
    --            CpSl_TimeDvld_o <= '1';
    --            CpSv_YmdHmsData_o <= PrSv_UtcYear_s & PrSv_UtcMon_s & PrSv_UtcDay_s 
--                                    & PrSv_UtcHour_s & PrSv_UtcMin_s & PrSv_UtcSec_s & PrSv_UtcMs_s & PrSv_GPSus_c;
    --        else
    --            CpSl_TimeDvld_o <= '0';
    --            CpSv_YmdHmsData_o <= PrSv_UtcYear_s & PrSv_UtcMon_s & PrSv_UtcDay_s
--                                        & PrSv_UtcHour_s & PrSv_UtcMin_s & PrSv_UtcSec_s & PrSv_UtcMs_s & PrSv_GPSus_c;
    --        end if;
    --    end if;
    --end process;
    
--    process (CpSl_Rst_iN, CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            CpSl_TimeDvld_o <= '0';
--            CpSv_HmsData_o <= (others => '0');
--            CpSv_DmyData_o <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_FrameState_s = PrSv_FrameEnd_c) then
--                CpSl_TimeDvld_o <= '1';
--                CpSv_HmsData_o <= PrSv_TimePallData_s(87 downto 8);
--                CpSv_DmyData_o <= PrSv_DmyPallData_s(55 downto 8);
--            else
--                CpSl_TimeDvld_o <= '0';
--                CpSv_HmsData_o <= PrSv_TimePallData_s(87 downto 8);
--                CpSv_DmyData_o <= PrSv_DmyPallData_s(55 downto 8);
--            end if;
--        end if;
--    end process;

----------------------------------------
-- End
----------------------------------------
end arch_M_GpsTop;