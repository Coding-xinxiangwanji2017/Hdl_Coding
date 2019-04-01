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
-- 文件名称  :  M_NetWr.vhd
-- 设    计  :  xx
-- 邮    件  :  Email
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  32 bit -> 32 bit;Frame_Reaerve:4Byte
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, xx, 2018/05/17
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity M_NetWr is
    generic (
        PrSl_Sim_c                      : integer := 1                           -- Simulation
    );
    port(
        --------------------------------
        -- Clk & Reset
        --------------------------------
        clk                             : in  std_logic;                        -- Clock,Single 40MHz
        nrst                            : in  std_logic;                        -- Reset,active low
        
        --------------------------------
        -- Tick
        --------------------------------
        k_start_tick                    : in  std_logic;                        -- Enther Start 
        CpSl_1msTrig_i                  : in  std_logic;                        -- 1ms Trig

        --------------------------------
        -- APD_Temp
        --------------------------------
        CpSl_TemperDVld_i               : in  std_logic;                        -- LTC2324 Capture End
        CpSv_TemperData_i               : in  std_logic_vector(15 downto 0);    -- Temper Data

        --------------------------------
        -- UTC_Hex_Time
        --------------------------------
        CpSv_Lock_i                     : in  std_logic_vector( 1 downto 0);    -- Gps_Lock
        CpSv_UdpTimeData_i              : in  std_logic_vector(79 downto 0);    -- UTC_Hex_Time
        
        --------------------------------
        -- Enthera Data
        --------------------------------
        CpSl_HeadVld_i                  : in  std_logic;                        -- Recv Enther Data Vld
        CpSv_HeadData_i                 : in  std_logic_vector(15 downto 0);    -- Recv Enther Data
        CpSv_S0Tx_WrsR_o                : out std_logic_vector(15 downto 0);    -- S0Tx_WrsR_Data
        CpSv_UdpRdCnt_o                 : out std_logic_vector(11 downto 0);    -- UDP Read Cnt
        
        --------------------------------
        -- Frame State
        --------------------------------
        CpSl_NetSend_o                  : out std_logic;                        -- Net Start
        CpSl_StartTrig_o                : out std_logic;                        -- Enther Start
        CpSl_StopTrig_o                 : out std_logic;                        -- Enther Stop  
        CpSv_PointStyle_o               : out std_logic_vector( 1 downto 0);    -- PointStyle
        CpSv_EochCnt_o                  : out std_logic_vector( 1 downto 0);    -- Ench Cnt
        CpSl_UdpTest_o                  : out std_logic;                        -- UDP Test Module

        --------------------------------
        -- Combine Data Fifo
        --------------------------------
        CpSl_RdFifo_o                   : out std_logic;                        -- Rd Fifo 
        CpSl_FifoDataVld_i              : in  std_logic;                        -- Fifo Data Valid
        CpSv_FifoData_i                 : in  std_logic_vector(31 downto 0);    -- Fifo Data
        
        --------------------------------
        -- Send Frame Data
        --------------------------------
        CpSl_NetStartTrig_i             : in  std_logic;                        -- NetUdp Start Trig 
        CpSl_NetRd_i                    : in  std_logic;                        -- Net Read                  
        CpSl_NetDataVld_o               : out std_logic;                        -- Net Recv Data Vld 
        CpSv_NetData_o                  : out std_logic_vector(31 downto 0);    -- Net Recv Data     
        send_tick                       : out std_logic
    );
end M_NetWr;

architecture arch_M_NetWr of M_NetWr is 
    ----------------------------------------------------------------------------
    -- Constant Describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- EtherNet State
    ------------------------------------
    constant PrSv_NetIdle_c             : std_logic_vector( 3 downto 0) := "0000";
    constant PrSv_NetWait_c             : std_logic_vector( 3 downto 0) := "0001";
    constant PrSv_NetWaitMonitor_c      : std_logic_vector( 3 downto 0) := "0010";
    constant PrSv_NetSeqFrameHead_c     : std_logic_vector( 3 downto 0) := "0011";
    constant PrSv_NetFrameHeadCnt_c     : std_logic_vector( 3 downto 0) := "0100";
    constant PrSv_NetFrameHead_c        : std_logic_vector( 3 downto 0) := "0101";
    constant PrSv_NetRdData_c           : std_logic_vector( 3 downto 0) := "0110";
    constant PrSv_NetRdDataCnt_c        : std_logic_vector( 3 downto 0) := "0111";
    constant PrSv_NetRdDataEnd_c        : std_logic_vector( 3 downto 0) := "1000";
    constant PrSv_FrameEnd_c            : std_logic_vector( 3 downto 0) := "1001";
    constant PrSv_FrameEndNum_c         : std_logic_vector( 3 downto 0) := "1010";
    constant PrSv_FrameEndCnt_c         : std_logic_vector( 3 downto 0) := "1011";
    constant PrSv_NetFrameCnt_c         : std_logic_vector( 3 downto 0) := "1100";
    constant PrSv_NetCmpUdpCnt_c        : std_logic_vector( 3 downto 0) := "1101";
    constant PrSv_NetEnd_c              : std_logic_vector( 3 downto 0) := "1110"; 

    ------------------------------------
    -- Constant_UDP_Package
    ------------------------------------
    -- PC -> FPGA Frame Style
    constant PrSv_Head0501_c            : std_logic_vector(15 downto 0) := x"0501"; -- UDP_Head_5Hz_Echo1_400KPoint
    constant PrSv_Head0502_c            : std_logic_vector(15 downto 0) := x"0502"; -- UDP_Head_5Hz_Echo2_400KPoint
    constant PrSv_Head0503_c            : std_logic_vector(15 downto 0) := x"0503"; -- UDP_Head_5Hz_Echo3_400KPoint
    constant PrSv_Head1001_c            : std_logic_vector(15 downto 0) := x"1001"; -- UDP_Head_10Hz_Echo1_400KPoint
    constant PrSv_Head1002_c            : std_logic_vector(15 downto 0) := x"1002"; -- UDP_Head_10Hz_Echo2_400KPoint 
    constant PrSv_Head1003_c            : std_logic_vector(15 downto 0) := x"1003"; -- UDP_Head_10Hz_Echo3_400KPoint 
    constant PrSv_Head2001_c            : std_logic_vector(15 downto 0) := x"2001"; -- UDP_Head_20Hz_Echo1_400KPoint 
    constant PrSv_Head2002_c            : std_logic_vector(15 downto 0) := x"2002"; -- UDP_Head_20Hz_Echo2_400KPoint 
    constant PrSv_Head2003_c            : std_logic_vector(15 downto 0) := x"2003"; -- UDP_Head_20Hz_Echo3_400KPoint 
    constant PrSv_HeadA50F_c            : std_logic_vector(15 downto 0) := x"A50F"; -- UDP_Head_10Hz_Echo1_200KPoint
    
    ------------------------------------
    -- FPGA -> PC Frame Style
    ------------------------------------
    -- Point
    constant PrSv_Point20K_c            : std_logic_vector(1 downto 0) := "01";     -- Point 20K
    constant PrSv_Point40K_c            : std_logic_vector(1 downto 0) := "10";     -- Point 40K
    
    -- Total_Length
    --constant PrSv_TotalLenTest_c        : std_logic_vector(15 downto 0) := x"0518"; -- Total_len_1304
    constant PrSv_TotalLenTest_c        : std_logic_vector(15 downto 0) := x"0518"; -- test_TDC_Total_len_1304
    constant PrSv_TotalLenEcho1_c       : std_logic_vector(15 downto 0) := x"0518"; -- Total_len_1304
    constant PrSv_TotalLenEcho2_c       : std_logic_vector(15 downto 0) := x"04C8"; -- Total_len_1224
    constant PrSv_TotalLenEcho3_c       : std_logic_vector(15 downto 0) := x"0518"; -- Total_len_1304
    
    -- One UDP Read Cnt
    --constant PrSv_DataCntTest_c         : std_logic_vector(11 downto 0) := x"146";  -- Data_Cnt_1304_326
    constant PrSv_DataCntTest_c         : std_logic_vector(11 downto 0) := x"146";  -- TestTDC_Data_Cnt_1304_326
    constant PrSv_DataCntEcho1_c        : std_logic_vector(11 downto 0) := x"146";  -- Data_Cnt_1304
    constant PrSv_DataCntEcho2_c        : std_logic_vector(11 downto 0) := x"132";  -- Data_Cnt_1224
    constant PrSv_DataCntEcho3_c        : std_logic_vector(11 downto 0) := x"146";  -- Data_Cnt_1304

    -- One_Frmae_UDP_Cnt
    constant PrSv_UDPCnt0501_c          : std_logic_vector(11 downto 0) := x"1F4"; -- UDP_Cnt_500
    constant PrSv_UDPCnt0502_c          : std_logic_vector(11 downto 0) := x"320"; -- UDP_Cnt_800
    constant PrSv_UDPCnt0503_c          : std_logic_vector(11 downto 0) := x"3E8"; -- UDP_Cnt_1000
    constant PrSv_UDPCnt1001_c          : std_logic_vector(11 downto 0) := x"0FA"; -- UDP_Cnt_250
    constant PrSv_UDPCnt1002_c          : std_logic_vector(11 downto 0) := x"190"; -- UDP_Cnt_400
    constant PrSv_UDPCnt1003_c          : std_logic_vector(11 downto 0) := x"1F4"; -- UDP_Cnt_500
    constant PrSv_UDPCnt2001_c          : std_logic_vector(11 downto 0) := x"07D"; -- UDP_Cnt_125
    constant PrSv_UDPCnt2002_c          : std_logic_vector(11 downto 0) := x"0C8"; -- UDP_Cnt_200
    constant PrSv_UDPCnt2003_c          : std_logic_vector(11 downto 0) := x"0FA"; -- UDP_Cnt_250
--    constant PrSv_UDPCntA50F_c          : std_logic_vector(11 downto 0) := x"0FA"; -- UDP_Cnt_250
    constant PrSv_UDPCntA50F_c          : std_logic_vector(11 downto 0) := x"07D"; -- UDP_Cnt_125
--    constant PrSv_UDPCntA50F_c          : std_logic_vector(11 downto 0) := x"190"; -- TestTDC_UDPCnt_400

    -- Frame Head
    constant PrSv_FrameHeadCnt_c        : std_logic_vector( 1 downto 0) := "01";    -- Frame Head Cnt
    constant PrSv_FrameTestCnt_c        : std_logic_vector(11 downto 0) := x"140";  -- TestTDC_Echo1_320
    constant PrSv_FrameEcho1Cnt_c       : std_logic_vector(11 downto 0) := x"140";  -- Frame Echo1 320
    constant PrSv_FrameEcho2Cnt_c       : std_logic_vector(11 downto 0) := x"12C";  -- Frame Echo2 300
    constant PrSv_FrameEcho3Cnt_c       : std_logic_vector(11 downto 0) := x"140";  -- Frame Echo3 320
    constant PrSv_FrameDataEndCnt_c     : std_logic_vector( 3 downto 0) := x"5";    -- 5
    constant PrSv_Echo1_c               : std_logic_vector( 3 downto 0) := x"1";    -- Echo_Num_1
    constant PrSv_Echo2_c               : std_logic_vector( 3 downto 0) := x"2";    -- Echo_Num_2
    constant PrSv_Echo3_c               : std_logic_vector( 3 downto 0) := x"3";    -- Echo_Num_3
    constant PrSv_EchoTest_c            : std_logic_vector( 3 downto 0) := x"F";   -- Echo_Num_Test
    constant PrSv_FrameStop_c           : std_logic_vector(15 downto 0) := x"90EB"; -- Frame Stop
    constant PrSv_FrameHead1S_c         : std_logic_vector(15 downto 0) := x"AAAA"; -- 1S_Head
    constant PrSv_UDPStartHead_c        : std_logic_vector(15 downto 0) := x"BBBB"; -- UDP Frame Head
    constant PrSv_UDPHead_c             : std_logic_vector(15 downto 0) := x"CCCC"; -- UDP Head
    constant PrSv_Lock_c                : std_logic_vector( 3 downto 0) := "0001";  -- Time_lock
    constant PrSv_UnLock_c              : std_logic_vector( 3 downto 0) := "1000";  -- Time_Unlock
    constant PrSv_UdpRsv_c              : std_logic_vector(15 downto 0) := x"FFFF"; -- UDP Reserve Data

    ----------------------------------------------------------------------------
    -- Signal Describe
    ----------------------------------------------------------------------------
    -- Generate Sim Data
    signal PrSl_StartTick_s             : std_logic;                            -- Send_Tick
    signal PrSl_NetStartTrig_s          : std_logic;                            -- CpSl_NetStartTrig_i
    
    ------------------------------------
    -- signal_UDP_Package
    ------------------------------------
    signal PrSl_StartTrig_s             : std_logic;                            -- Start Trig
    signal PrSl_StartTrigDly1_s         : std_logic;                            -- Start Trig Delay 1 Clk
    signal PrSl_StartTrigDly2_s         : std_logic;                            -- Start Trig Delay 2 Clk
    signal PrSl_StopTrig_s              : std_logic;                            -- Stop  Trig
    signal PrSl_StopTrigDly1_s          : std_logic;                            -- Stop  Trig Delay 1 Clk
    signal PrSl_StopTrigDly2_s          : std_logic;                            -- Stop  Trig Delay 2 Clk 
    signal PrSv_EochCnt_s               : std_logic_vector( 1 downto 0);        -- Eoch Number
    signal PrSv_EnthHead_s              : std_logic_vector(15 downto 0);        -- Recv Enther Data
    
    signal PrSv_FrameHeadCnt_s          : std_logic_vector(15 downto 0);        -- Frame Head
    signal PrSv_FrameEchoCnt_c          : std_logic_vector(11 downto 0);        -- Frame Echo Data Cnt
    signal PrSv_FrameDataCnt_s          : std_logic_vector(11 downto 0);        -- Frame Data Cnt
    signal PrSv_FrameDataEndCnt_s       : std_logic_vector( 3 downto 0);        -- Frame Data End Cnt
    signal PrSv_FrameHead_s             : std_logic_vector(15 downto 0);        -- UDP Head
    signal PrSv_UdpCnt_s                : std_logic_vector(11 downto 0);        -- UDP Cnt
    signal PrSv_NetWrState_s            : std_logic_vector( 3 downto 0);        -- Enther State
    signal PrSv_NetWaitCnt_s            : std_logic_vector( 7 downto 0);        -- Net Wait Time 
    signal PrSv_FrameUDPCnt_s           : std_logic_vector(11 downto 0);        -- Frame UDP Cnt
    
    -- Temper
    signal PrSv_TemperData_s            : std_logic_vector(15 downto 0);        -- ApdTemper_Data

begin 
    ------------------------------------
    -- Generate Simulation Data
    ------------------------------------
    PrSl_NetStartTrig_s <= CpSl_NetStartTrig_i;

    Real_data : if (PrSl_Sim_c = 1) generate
        CpSl_NetSend_o <= PrSl_StartTrigDly2_s;
        
        -- CpSl_StartTrig_o
        CpSl_StartTrig_o <= '1' when (PrSl_StartTrigDly2_s = '0' and PrSl_StartTrigDly1_s = '1')
                        else '0';
    end generate Real_data;
    
    Sim_data : if (PrSl_Sim_c = 0) generate
        CpSl_NetSend_o <= PrSl_StartTrigDly2_s;
        CpSl_StartTrig_o <= PrSl_StartTrigDly2_s;
    end generate Sim_data;
    
    ------------------------------------
    -- Main 
    ------------------------------------
    -- Enthernet_Head
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_EnthHead_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (CpSl_HeadVld_i = '1' and k_start_tick = '1') then 
                PrSv_EnthHead_s <= CpSv_HeadData_i;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_StartTrig_s
    process (clk,nrst) begin
        if (nrst = '0') then
            PrSl_StartTrig_s <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_EnthHead_s /= x"0000" and k_start_tick = '1') then
                if (PrSv_EnthHead_s = PrSv_FrameStop_c) then 
                    PrSl_StartTrig_s <= '0';
                else
                    PrSl_StartTrig_s <= '1';
                end if;
            else
                PrSl_StartTrig_s <= '0';
            end if;
        end if; 
    end process;
    
    process (clk,nrst) begin 
        if (nrst = '0') then 
            PrSl_StartTrigDly1_s <= '0';
            PrSl_StartTrigDly2_s <= '0';
        elsif rising_edge(clk) then 
            PrSl_StartTrigDly1_s <= PrSl_StartTrig_s;
            PrSl_StartTrigDly2_s <= PrSl_StartTrigDly1_s;
        end if;
    end process;
    
    -- PrSl_StopTrig_s       
    process (clk,nrst) begin
        if (nrst = '0') then
            PrSl_StopTrig_s <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_EnthHead_s = PrSv_FrameStop_c) then 
                PrSl_StopTrig_s <= '1';
            else
                PrSl_StopTrig_s <= '0';
            end if;
        end if;
    end process;
    
    process (clk,nrst) begin 
        if (nrst = '0') then 
            PrSl_StopTrigDly1_s <= '0';
            PrSl_StopTrigDly2_s <= '0';
        elsif rising_edge(clk) then 
            PrSl_StopTrigDly1_s <= PrSl_StopTrig_s;
            PrSl_StopTrigDly2_s <= PrSl_StopTrigDly1_s;
        end if;
    end process;
    -- CpSl_StopTrig_o
    CpSl_StopTrig_o <= '1' when (PrSl_StopTrigDly2_s = '0' and PrSl_StopTrigDly1_s = '1')
                        else '0';
    
    -- UDP_Total_Length/Rd_Fifo_Cnt
    process (clk,nrst) begin
        if (nrst = '0') then
            CpSv_S0Tx_WrsR_o <= PrSv_TotalLenTest_c;
            CpSv_UdpRdCnt_o  <= PrSv_DataCntTest_c;
            CpSl_UdpTest_o   <= '0';
            PrSv_EochCnt_s   <= "00"; 
            PrSv_FrameEchoCnt_c <= PrSv_FrameTestCnt_c; 
            
        elsif rising_edge(clk) then
        case PrSv_EnthHead_s(3 downto 0) is
            when PrSv_EchoTest_c => -- Test Module (Ench_1)
                CpSv_S0Tx_WrsR_o <= PrSv_TotalLenTest_c;
                CpSv_UdpRdCnt_o  <= PrSv_DataCntTest_c;
                CpSl_UdpTest_o   <= '1';
                PrSv_EochCnt_s   <= "01"; 
                PrSv_FrameEchoCnt_c <= PrSv_FrameTestCnt_c; 
            
            when PrSv_Echo1_c => 
                CpSv_S0Tx_WrsR_o <= PrSv_TotalLenEcho1_c;
                CpSv_UdpRdCnt_o  <= PrSv_DataCntEcho1_c;
                CpSl_UdpTest_o   <= '0';
                PrSv_EochCnt_s   <= "01"; 
                PrSv_FrameEchoCnt_c <= PrSv_FrameEcho1Cnt_c; 
                
            when PrSv_Echo2_c => 
                CpSv_S0Tx_WrsR_o <= PrSv_TotalLenEcho2_c;
                CpSv_UdpRdCnt_o  <= PrSv_DataCntEcho2_c;
                CpSl_UdpTest_o   <= '0';
                PrSv_EochCnt_s   <= "10"; 
                PrSv_FrameEchoCnt_c <= PrSv_FrameEcho2Cnt_c; 
               
            when PrSv_Echo3_c => 
                CpSv_S0Tx_WrsR_o <= PrSv_TotalLenEcho3_c;
                CpSv_UdpRdCnt_o  <= PrSv_DataCntEcho3_c;
                CpSl_UdpTest_o   <= '0';
                PrSv_EochCnt_s   <= "11"; 
                PrSv_FrameEchoCnt_c <= PrSv_FrameEcho3Cnt_c; 

            when others => 
                CpSv_S0Tx_WrsR_o <= PrSv_TotalLenTest_c;
                CpSv_UdpRdCnt_o  <= PrSv_DataCntTest_c;
                CpSl_UdpTest_o   <= '1';
                PrSv_EochCnt_s   <= "01"; 
                PrSv_FrameEchoCnt_c <= PrSv_FrameTestCnt_c;
                
        end case;
        end if;
    end process;
    -- CpSv_EochCnt_o
    CpSv_EochCnt_o <= PrSv_EochCnt_s;
    
    -- PrSv_UdpCnt_s(Frame_UDP)
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_UdpCnt_s <= (others => '0');
            CpSv_PointStyle_o <= PrSv_Point20K_c;
        elsif rising_edge(clk) then 
        case PrSv_EnthHead_s is 
            when PrSv_Head0501_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt0501_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head0502_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt0502_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
                
            when PrSv_Head0503_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt0503_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head1001_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt1001_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head1002_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt1002_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head1003_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt1003_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head2001_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt2001_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head2002_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt2002_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_Head2003_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCnt2003_c;
                CpSv_PointStyle_o <= PrSv_Point40K_c;
            
            when PrSv_HeadA50F_c => 
                PrSv_UdpCnt_s <= PrSv_UDPCntA50F_c;
                CpSv_PointStyle_o <= PrSv_Point20K_c;
                
            when others => 
                PrSv_UdpCnt_s <= PrSv_UDPCntA50F_c;
                CpSv_PointStyle_o <= PrSv_Point20K_c;
        end case;
        end if;
    end process;

    ------------------------------------
    -- Write Data to Net
    ------------------------------------
    -- PrSl_StartTick_s
    PrSl_StartTick_s <= PrSl_StartTrig_s and k_start_tick; 

    -- PrSv_NetWrState_s
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_NetWrState_s <= (others => '0');
        elsif rising_edge(clk) then
            case PrSv_NetWrState_s is
                when PrSv_NetIdle_c =>  -- Idle
                    if (PrSl_StartTick_s = '1') then 
                        PrSv_NetWrState_s <= PrSv_NetWait_c;
--                        PrSv_NetWrState_s <= PrSv_NetWaitMonitor_c
                    else -- hold
                    end if;

--                when PrSv_NetWait_c => -- wait 5us for Initial 
--                    -- (Test This Value Depends On the Speed Of Ethernet)
--                    if (PrSv_NetWaitCnt_s = X"C8") then
--                        PrSv_NetWrState_s <= PrSv_NetWaitMonitor_c;
--                    else -- hold
--                    end if;
                    PrSv_NetWrState_s <= PrSv_NetWaitMonitor_c;

                when PrSv_NetWaitMonitor_c =>
                    if (PrSl_NetStartTrig_s = '1') then
                        PrSv_NetWrState_s <= PrSv_NetSeqFrameHead_c;
                    else -- hold
                    end if;

                when PrSv_NetSeqFrameHead_c => -- seq Frame Head
                    if (CpSl_NetRd_i = '1') then
                        PrSv_NetWrState_s <= PrSv_NetFrameHead_c;
                    else -- hold
                    end if;
                
                when PrSv_NetFrameHead_c => -- Frame Head
                    PrSv_NetWrState_s <= PrSv_NetFrameHeadCnt_c;

                when PrSv_NetFrameHeadCnt_c => -- Frame Head Cnt
                    if (PrSv_FrameHeadCnt_s = PrSv_FrameHeadCnt_c) then
                        PrSv_NetWrState_s <= PrSv_NetRdData_c;
                    else
                        PrSv_NetWrState_s <= PrSv_NetSeqFrameHead_c;
                    end if;
                
                when PrSv_NetRdData_c => -- Rd Fifo Data
                    if (CpSl_NetRd_i = '1') then
                        PrSv_NetWrState_s <= PrSv_NetRdDataCnt_c;
                    else
                    end if;

                when PrSv_NetRdDataCnt_c => -- Rd Data Cnt
                    if (CpSl_FifoDataVld_i = '1') then
                        PrSv_NetWrState_s <= PrSv_NetRdDataEnd_c;
                    else -- hold
                    end if;
                
                when PrSv_NetRdDataEnd_c => -- Frame_Data
                    if (PrSv_FrameDataCnt_s = PrSv_FrameEchoCnt_c) then
                        PrSv_NetWrState_s <= PrSv_FrameEnd_c;
                    else
                        PrSv_NetWrState_s <= PrSv_NetRdData_c;
                    end if;
                
                when PrSv_FrameEnd_c => -- Frame End
                    if (CpSl_NetRd_i = '1') then
                        PrSv_NetWrState_s <= PrSv_FrameEndNum_c;
                    else
                    end if;
                
                when PrSv_FrameEndNum_c => -- Frame End Num
                    PrSv_NetWrState_s <= PrSv_FrameEndCnt_c;

                when PrSv_FrameEndCnt_c => -- Frame End Cnt
                    if (PrSv_FrameDataEndCnt_s = PrSv_FrameDataEndCnt_c) then
                        PrSv_NetWrState_s <= PrSv_NetFrameCnt_c;
                    else
                        PrSv_NetWrState_s <= PrSv_FrameEnd_c;
                    end if;

                when PrSv_NetFrameCnt_c => -- Send UDP Cnt
                    PrSv_NetWrState_s <= PrSv_NetCmpUdpCnt_c;
                
                when PrSv_NetCmpUdpCnt_c => -- Compare UDP Cnt
                    if (PrSv_FrameUDPCnt_s = PrSv_UdpCnt_s) then
                        PrSv_NetWrState_s <= PrSv_NetEnd_c;
                    else
                        PrSv_NetWrState_s <= PrSv_NetWaitMonitor_c;
                    end if;

                when PrSv_NetEnd_c => -- Frame End
                    PrSv_NetWrState_s <= (others => '0');
                when others => PrSv_NetWrState_s <= (others => '0');
            end case;
        end if; 
    end process;

    -- PrSv_NetWaitCnt_s
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_NetWaitCnt_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (PrSv_NetWrState_s = PrSv_NetWait_c) then
                if (PrSv_NetWaitCnt_s = x"C8") then
                    PrSv_NetWaitCnt_s <= (others => '0');
                else
                    PrSv_NetWaitCnt_s <= PrSv_NetWaitCnt_s + '1';
                end if;
            else 
                PrSv_NetWaitCnt_s <= (others => '0'); 
            end if;
        end if;
    end process;
    
    -- PrSv_FrameHeadCnt_s
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_FrameHeadCnt_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (PrSv_NetWrState_s = PrSv_NetFrameHead_c) then 
                PrSv_FrameHeadCnt_s <= PrSv_FrameHeadCnt_s + '1';
            elsif (PrSv_NetWrState_s = PrSv_NetRdData_c) then 
                PrSv_FrameHeadCnt_s <= (others => '0');
            else
            end if;
        end if;
    end process;
    
    -- PrSv_FrameDataCnt_s
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_FrameDataCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_NetWrState_s = PrSv_NetRdDataCnt_c) then 
                if (CpSl_FifoDataVld_i = '1') then
                    PrSv_FrameDataCnt_s <= PrSv_FrameDataCnt_s + '1';
                else -- hold
                end if;
            elsif (PrSv_NetWrState_s = PrSv_FrameEnd_c) then 
                PrSv_FrameDataCnt_s <= (others => '0');
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_FrameDataEndCnt_s
    process (clk,nrst) begin
        if (nrst = '0') then 
            PrSv_FrameDataEndCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_NetWrState_s = PrSv_FrameEndNum_c) then 
                PrSv_FrameDataEndCnt_s <= PrSv_FrameDataEndCnt_s + '1';
            elsif (PrSv_NetWrState_s = PrSv_NetFrameCnt_c) then 
                PrSv_FrameDataEndCnt_s <= (others => '0');
            else -- hold
            end if;
        end if;
    end process;
    
    -- CpSl_RdFifo_o
    process (clk,nrst) begin 
        if (nrst = '0') then 
            CpSl_RdFifo_o <= '0';
        elsif rising_edge(clk) then
            if (PrSv_NetWrState_s = PrSv_NetRdData_c) then
                if (CpSl_NetRd_i = '1') then 
                    CpSl_RdFifo_o <= '1';
                else 
                    CpSl_RdFifo_o <= '0';
                end if;
            else 
                CpSl_RdFifo_o <= '0';
            end if;
        end if;
    end process;

    -- CpSl_NetDataVld_o
    process (clk,nrst) begin
        if (nrst = '0') then
            CpSl_NetDataVld_o <= '0';
        elsif rising_edge(clk) then
            if (PrSv_NetWrState_s = PrSv_NetFrameHead_c) then
                CpSl_NetDataVld_o <= '1';
            elsif (PrSv_NetWrState_s = PrSv_NetRdDataCnt_c) then
                if (CpSl_FifoDataVld_i = '1') then 
                    CpSl_NetDataVld_o <= '1';
                else 
                    CpSl_NetDataVld_o <= '0';
                end if;
            elsif (PrSv_NetWrState_s = PrSv_FrameEndNum_c) then 
                CpSl_NetDataVld_o <= '1';
            else
                CpSl_NetDataVld_o <= '0';
            end if;
        end if;
    end process;
    
    ------------------------------------
    -- PrSv_FrameHead_s
    ------------------------------------
    process (clk,nrst) begin
        if (nrst = '0') then
            PrSv_FrameHead_s <= PrSv_FrameHead1S_c;
        elsif rising_edge(clk) then
            if (PrSv_FrameUDPCnt_s = 0) then
               PrSv_FrameHead_s <= PrSv_FrameHead1S_c;
            else
                PrSv_FrameHead_s <= PrSv_UDPHead_c;
            end if;
        end if;
    end process;
    
    ----------------------------------
    -- PrSv_TemperData_s
    ----------------------------------
    process (clk,nrst) begin
        if (nrst = '0') then
            PrSv_TemperData_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (CpSl_TemperDVld_i = '1') then
                PrSv_TemperData_s <= CpSv_TemperData_i;
            else -- hold
            end if;
        end if;
    end process;

    ------------------------------------
    -- CpSv_NetData_o
    process (clk,nrst) begin
        if (nrst = '0') then
            CpSv_NetData_o <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_NetWrState_s = PrSv_NetFrameHead_c) then
                -- Head UDPCnt
                CpSv_NetData_o <= PrSv_FrameHead_s & PrSv_EochCnt_s & CpSv_Lock_i & PrSv_FrameUDPCnt_s;

                -- Head Constant 
--                CpSv_NetData_o <= PrSv_FrameHead_s & PrSv_EochCnt_s & CpSv_Lock_i & PrSv_UdpCnt_s;
            elsif (PrSv_NetWrState_s = PrSv_NetRdDataCnt_c) then
                if (CpSl_FifoDataVld_i = '1') then 
                    CpSv_NetData_o <= CpSv_FifoData_i;
                else
                end if;
            elsif (PrSv_NetWrState_s = PrSv_FrameEndNum_c) then 
                if (PrSv_FrameDataEndCnt_s = 0) then
                    CpSv_NetData_o <= CpSv_UdpTimeData_i(79 downto 48);
                elsif (PrSv_FrameDataEndCnt_s = 1) then 
                    CpSv_NetData_o <= CpSv_UdpTimeData_i(47 downto 16);
                elsif (PrSv_FrameDataEndCnt_s = 2) then
                    --CpSv_NetData_o <= CpSv_UdpTimeData_i(15 downto  0) & PrSv_UdpRsv_c;
                    CpSv_NetData_o <= CpSv_UdpTimeData_i(15 downto  0) & PrSv_TemperData_s;
                elsif (PrSv_FrameDataEndCnt_s = 3) then 
                    CpSv_NetData_o <= PrSv_UdpRsv_c & PrSv_UdpRsv_c;
                elsif (PrSv_FrameDataEndCnt_s = 4) then
                    CpSv_NetData_o <= PrSv_UdpRsv_c & PrSv_UdpRsv_c;
                else 
                end if;   
            else
            end if;
        end if;
    end process;

    -- PrSv_FrameUDPCnt_s
    process (clk,nrst) begin
        if (nrst = '0') then
            PrSv_FrameUDPCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_NetWrState_s = PrSv_NetFrameCnt_c) then 
                PrSv_FrameUDPCnt_s <= PrSv_FrameUDPCnt_s + '1';
            elsif (PrSv_NetWrState_s = PrSv_NetEnd_c) then
                PrSv_FrameUDPCnt_s <= (others => '0');
            else -- hold
            end if;
        end if;
    end process;

    -- send_tick
    process (clk,nrst) begin
        if(nrst = '0')then
            send_tick <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_NetWrState_s = PrSv_NetEnd_c) then
                send_tick <= '1';
            else 
                send_tick <= '0';
            end if;        
        end if;
    end process;
    
------------------------------------
-- End
------------------------------------
end arch_M_NetWr;