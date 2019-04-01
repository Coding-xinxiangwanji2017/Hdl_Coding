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
-- 文件名称  :  M_W5300Ctrl.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

----------------------------------------
-- library Xilinx
----------------------------------------
--library unisim;
--use unisim.vcomponents.all;

----------------------------------------
-- library Altera
----------------------------------------
--library altera_mf;
--use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------
use work.pine_basic.all;

entity M_W5300Ctrl is
    generic (
        PrSl_Sim_c                      : integer := 1                           -- Simulation
    );
    port (
        --------------------------------
        -- Clock & Reset                
        --------------------------------
        clk                             : in  std_logic;                        -- single 40MHz.clock
        nrst                            : in  std_logic;                        -- active,low
        initial_done_i                  : in  std_logic;
        
	--------------------------------
        -- Tick
        --------------------------------
        tick_1us                        : in  std_logic;	                    -- tick 1us 
        tick_10us                       : in  std_logic;	                    -- tick 10us 
        tick_100us                      : in  std_logic;	                    -- tick 100us 
        tick_1ms                        : in  std_logic;	                    -- tick 1ms 
        nint_f                          : in  std_logic;	                    -- W5300_Interrupt_Active_Low

        ethernet_package_gap_cnt        : in  std_logic_vector(15 downto 0);	-- 以太网下传包间隔的包数
        ethernet_package_gap            : in  std_logic_vector(15 downto 0);	-- 以太网下传包间隔，当量1us 
        
        ethernet_nrst_ctrl              : in  std_logic;	                    -- 网口复位控制信号 
        ethernet_init_start             : in  std_logic;	                    -- 网口初始化启动标志，tick 
--        ethernet_init_done              : out std_logic;	                    -- 网口初始化完成标志，tick 
        CpSl_NetInitDone_o              : out std_logic;	                    -- NetInitDone
        CpSl_W5300Init_o                : out std_logic;	                    -- W5300 Init
        CpSl_W5300InitSucc_o            : out std_logic;                        -- W5300 TxSend Data
        
		  frame_fst_rcv                   : out std_logic;	
        rcv                             : out std_logic;	                    -- 接收完成的tick 
        rcv_data                        : out std_logic_vector(15 downto 0);	-- 接收数据
        rcv_data_len                    : out std_logic_vector(15 downto 0);	-- 接收数据长度 单位：双字节
        rw_flash_frame_done_i           : in  std_logic_vector( 1 downto 0);
		  rd_ufm_data_i                   : in  std_logic_vector(255 downto 0);
		  train_cmd_done_i                : in  std_logic_vector( 1 downto 0);
        --------------------------------
	    -- Start/Stop Send Data
	    --------------------------------
	     CpSl_UdpTxStopTrig_i            : in  std_logic;                        -- Net Stop Send Tick
        send_start                      : in  std_logic;	                    -- Net Start Send Tick  
        send_done                       : out std_logic;	                    -- Net Send done Tick
        CpSl_NetStartTrig_o             : out std_logic;                        -- NetUdp Start Trig 
        CpSl_NetRd_o                    : out std_logic;                        -- Net Read
        CpSl_NetDataVld_i               : in  std_logic;                        -- Net Recv Data Vld 
        CpSv_NetData_i                  : in  std_logic_vector(31 downto 0);    -- Net Recv Data
        
	prsv_s1dportrdata_i             : in  std_logic_vector(15 downto 0); 
	prsv_w5300siprdata_i            : in  std_logic_vector(31 downto 0); 
	sip_dport_en_i                  : in  std_logic_vector(15 downto 0); 
        
	--------------------------------
        -- Eth Receive Data
        --------------------------------
--        CpSl_StopTrig_i                 : in  std_logic;                        -- Stop Send Data
--        CpSl_WrTrig_i                   : in  std_logic;                        -- Ethernet Write Trig
--        CpSl_NetWrVld_i                 : in  std_logic;                        -- Ethernet Write Valid
--        CpSv_NetWrData_i                : in  std_logic_vector(15 downto 0);    -- Ethernet Write Data
--        CpSl_RecvSucc_i                 : in  std_logic;                        -- Receive Ethernet Data
--        CpSl_RdTrig_i                   : in  std_logic;                        -- Read Ram Trig
--        CpSv_RamData_o                  : out std_logic_vector(31 downto 0);    -- Read Ram Data
        
        --------------------------------
        -- Enthera Data
        --------------------------------
        CpSl_HeadVld_o                  : out std_logic;                        -- Recv Enther Data Vld
        CpSv_HeadData_o                 : out std_logic_vector(15 downto 0);    -- Recv Enther Data
        CpSv_S0Tx_WrsR_i                : in  std_logic_vector(15 downto 0);    -- S0Tx_WrsR_Data
        CpSv_UdpRdCnt_i                 : in  std_logic_vector(11 downto 0);    -- UDP Read Cnt

        --------------------------------
        -- Control W5300
        --------------------------------
        CpSl_WrTrig_s                   : out std_logic;	                    -- W5300_Write_Trig
        CpSl_RdTrig_s                   : out std_logic;	                    -- W5300_Read_Trig
        CpSv_W5300Add_s                 : out std_logic_vector( 9 downto 0);	-- W5300_Address
        CpSv_W5300WrData_s              : out std_logic_vector(15 downto 0);	-- W5300WrData
        CpSv_W5300RdData_s              : in  std_logic_vector(15 downto 0)	    -- W5300RdData
    );
end M_W5300Ctrl;

architecture arch_M_W5300Ctrl of M_W5300Ctrl is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- B06EBFC32670  
    -- B06EBFC4122D ---> My_Comput
    ------------------------------------
    -- Socket_S0
--    constant PrSv_S0DHarMac_c           : std_logic_vector(47 downto 0) := x"B06EBFC4122D"; -- Des_Har_Mac
    constant PrSv_S0DHarMac_c           : std_logic_vector(47 downto 0) := x"FFFFFFFFFFFF"; -- Des_Har_Mac
--    constant PrSv_S0DIPRData_c          : std_logic_vector(31 downto 0) := x"C0A80A63";     -- Dst_IP_192.168.10.99
    constant PrSv_S0DIPRData_c          : std_logic_vector(31 downto 0) := x"FFFFFFFF";     -- Dst_IP_255.255.255.255
    constant PrSv_S0TX_WRSR_c           : std_logic_vector(15 downto 0) := x"0000";	        -- S0TX_WRSR

    -- Package
    constant PrSv_WrWaitCnt_c           : std_logic_vector( 3 downto 0) := x"4";            -- 4
    constant PrSv_RdWaitCnt_c           : std_logic_vector( 3 downto 0) := x"6";            -- 6
    constant PrSv_CapRdData_c           : std_logic_vector( 3 downto 0) := x"5";            -- 5
    
    ------------------------------------
    -- PC -> FPGA Fram Style                     
    ------------------------------------
    constant PrSv_Rate5Hz_c             : std_logic_vector(15 downto 0) := x"0580"; -- UDP_Head_5Hz
    constant PrSv_Rate10Hz_c            : std_logic_vector(15 downto 0) := x"1040"; -- UDP_Head_10Hz
    constant PrSv_Rate20Hz_c            : std_logic_vector(15 downto 0) := x"2020"; -- UDP_Head_20Hz
    constant PrSv_StopInd_c             : std_logic_vector(15 downto 0) := x"90EB"; -- Stop Transfer Data       

    -- Total_Length
    constant PrSv_FifoDataNum_c         : std_logic_vector(11 downto 0) := x"0FF";  -- 255   
    constant PrSv_FifoSimNum_c          : std_logic_vector(11 downto 0) := x"00F";  -- 15

    constant PrSv_UdpTxPkgNum_c         : std_logic_vector(15 downto 0) := x"0001"; -- 100 UDP Data Num
    constant PrSv_UdpTxPkgCnt_c         : std_logic_vector(15 downto 0) := x"0001"; -- Frame Cnt
    constant PrSv_UdpRxHeadTime_c       : std_logic_vector( 2 downto 0) := "100";   -- 4
    constant PrSv_UdpTotalNum_c         : std_logic_vector(15 downto 0) := x"C350"; -- 400k Point
    
    -- wait time (15ms)
    constant PrSv_wait15ms_c            : std_logic_vector(19 downto 0) := x"927C0";-- 15 ms
    constant PrSv_wait2ms_c             : std_logic_vector(19 downto 0) := x"00010";-- 2 ms
    
    -- Tx_Wait
    constant PrSv_TxWaitTime_c          : std_logic_vector(15 downto 0) := x"0FA0"; -- 100us(20Point)

    -- Tx_ack
    constant PrSv_Tcp_Ack_wsrs_c        : std_logic_vector(31 downto 0) := x"00000004"; 

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Init Comand
    ------------------------------------    
    signal PrSv_FifoDataNum_s           : std_logic_vector(11 downto 0);        -- Simulation Fifo Data Cnt
    signal PrSv_WaitRstW5300_s          : std_logic_vector( 3 downto 0);        -- wait 11 ms
    
    ------------------------------------
    -- UDP Command
    ------------------------------------
    -- Eth_Start_Trig
    signal PrSl_EthStartTrig_s          : std_logic;                            -- Eth_Start_Trig
    signal PrSl_Ethernet_nrst_ctrl_s    : std_logic;                            -- Eth_Rst_Ctrl
    signal PrSl_send_start_s            : std_logic;                            -- send_start     
    signal PrSv_S0TX_WRSR2_s            : std_logic_vector(15 downto 0);        -- S0TX_WRSR2
    
    -- ComState
    signal PrSv_ComState_s              : std_logic_vector( 4 downto 0);        -- Init Common Reg
    signal PrSv_100usCnt_s              : std_logic_vector( 1 downto 0);        -- 100us Cnt
    signal PrSl_ComWrVld_s              : std_logic;                            -- Common Write Valid
    signal PrSv_ComWrCnt_s              : std_logic_vector( 4 downto 0);        -- Common State Wr Cnt
    signal PrSl_ComRegDone_s            : std_logic;                            -- Config Common Reg Done
    
    -- SocketState
    signal PrSv_SocketState_s           : std_logic_vector( 4 downto 0);        -- Init Socket Reg
    signal PrSl_SocketWrVld_s           : std_logic;                            -- Socket Write Valid
    signal PrSv_SocketWrCnt_s           : std_logic_vector( 4 downto 0);        -- Socket State Wr Cnt
    signal PrSl_SocketRdVld_s           : std_logic;                            -- Socket Read Valid   
    signal PrSv_SocketS0_SSRData_s      : std_logic_vector(7 downto 0);         -- Socket S0 SSR State
    signal PrSv_SocketS1_SSRData_s      : std_logic_vector(7 downto 0);         -- Socket S1 SSR State
    signal PrSv_SocketRdCnt_s           : std_logic_vector(3 downto 0);         -- Socket Rd Cnt
    signal PrSl_SocketCfgDone_s         : std_logic;                            -- Socket Config Done
    
    -- UdpTxState
    signal PrSv_RxTxState_s             : std_logic_vector( 5 downto 0);        -- UDP Tx State
    signal PrSl_UdpTxFstSendVld_s       : std_logic;                            -- UDP Tx State First Send Data
    signal PrSv_UdpTxFSRBlank_s         : std_logic_vector(16 downto 0);        -- UDP Tx_FSR Blank
    signal PrSv_UdpTx_RdS0IR_s          : std_logic_vector( 4 downto 0);        -- UDP Tx_RD_S0_IR
    signal PrSv_UdpTxPackageNum_s       : std_logic_vector(15 downto 0);        -- UDP Tx UDP Package Num
    signal PrSv_UdpTxPkgCnt_s           : std_logic_vector(15 downto 0);        -- UDP Tx Frame Cnt
    signal PrSv_UdpTxFifoNum_s          : std_logic_vector(15 downto 0);        -- Send Data --> W5300
    signal PrSl_RxTxWrVld_s            : std_logic;                            -- UDP Tx State Wr
    signal PrSl_RxTxRdVld_s            : std_logic;                            -- UDP Tx State Wr
    signal PrSv_RxTxWrCnt_s            : std_logic_vector( 4 downto 0);        -- UDP Tx State Wr Cnt
    signal PrSv_RxTxRdCnt_s            : std_logic_vector( 4 downto 0);        -- UDP Tx State Rd Cnt
    signal PrSv_TxWaitTime_s            : std_logic_vector(15 downto 0);        -- UDP Tx State wait time

    -- UdpRxState
    signal PrSv_TcpRxRSRCnt_s           : std_logic_vector(16 downto 0);        -- UDP RSR_Cnt
    signal PrSv_TcpRxFifoData_s         : std_logic_vector(15 downto 0);        -- UDP_RxFifo_Data
    signal PrSv_TcpRxHeadData_s         : std_logic_vector(15 downto 0);        -- UDP RxHead Data
    signal PrSv_TcpRxPackSize_s         : std_logic_vector(15 downto 0);        -- UDP Package Size
    signal PrSv_TcpRxDataCnt_s          : std_logic_vector(15 downto 0);        -- UDP Recv Data Cnt
    signal PrSv_UdpTotalNum_s           : std_logic_vector(15 downto 0);        -- UDP Recv Total Byte
    signal PrSl_UdpRxWrVld_s            : std_logic;                            -- UDP Rx State Wr
        
    signal PrSv_Tcp_Ack_Data_s          : std_logic_vector(31 downto 0);        
    signal PrSv_Tcp_Tx_Data_s           : std_logic_vector(15 downto 0);        
    signal PrSv_TcpframeCnt_s           : std_logic_vector( 7 downto 0);        
    signal PrSv_TcpRxFstData_s          : std_logic_vector(15 downto 0);        
    signal PrSv_TcpTxDataCnt_s          : std_logic_vector(15 downto 0);        -- UDP Recv Data Cnt
    -- Test signal 
    signal PrSv_RdS0TxSRCnt_s           : std_logic_vector( 3 downto 0);        -- CpSv_S0Tx_WrsR_i Rd Cnt
    signal PrSv_RdS0SSRCnt_s            : std_logic_vector( 3 downto 0);        -- S0_SSR_Cnt
    signal PrSv_RdS1SSRCnt_s            : std_logic_vector( 3 downto 0);        -- S1_SSR_Cnt
    signal PrSl_W5300Init_s             : std_logic;                            -- W5300 Init
    signal PrSv_W5300InitCnt_s          : std_logic_vector(19 downto 0);        -- W5300 Init Cnt
    signal PrSv_W5300WaitTime_s         : std_logic_vector(19 downto 0);        -- Init Time 
    signal PrSl_W5300InitDone_s         : std_logic;                            -- W5300 Init Done

	 signal cmd_status                   : std_logic_vector(1 downto 0); 
    signal frame_nofst_rcv	             : std_logic;
    signal rw_flash_frame_done_r	       : std_logic_vector(1 downto 0); 
    signal train_cmd_done_r	          : std_logic_vector(1 downto 0); 
	 

	 
	 signal rd_flash_en    	             : std_logic;
    signal PrSv_Tcp_Ack_wsrs_s          : std_logic_vector(31 downto 0); 

	 
	 signal s1_discon_done    	          : std_logic;
	 signal s1_close_done     	          : std_logic;
	 signal s1_open_done      	          : std_logic;
	 
	signal prsv_s1dportrdata_s          : std_logic_vector(15 downto 0); 
	signal prsv_w5300siprdata_s         : std_logic_vector(31 downto 0); 
	 
	signal initial_done_d1              : std_logic;
	signal initial_done_d2              : std_logic;
	signal initial_done_trig            : std_logic;
begin
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Control W5300
    ------------------------------------
    -- S0Tx_WrsR
    PrSv_S0TX_WRSR2_s <= CpSv_S0Tx_WrsR_i;
    
    Sim_Trig : if (PrSl_Sim_c = 0) generate
        -- CpSl_HeadVld_o
        CpSl_HeadVld_o <= '1';

        -- CpSv_HeadData_o
        CpSv_HeadData_o <= x"A501";
        
        -- Init Wit time
        PrSv_W5300WaitTime_s <= PrSv_wait2ms_c;
    end generate Sim_Trig;

    -- ethernet_init_done
--    process (nrst,clk) begin 
--        if (nrst = '0') then
--            ethernet_init_done <= '0';
--        elsif rising_edge(clk) then
--            if (PrSl_Ethernet_nrst_ctrl_s = '0') then 
--                ethernet_init_done <= '0';
--            elsif (PrSv_SocketState_s = PrSv_SocketStateS0UDP_c) then 
--                ethernet_init_done <= '1';
--            end if;
--
----            if (PrSl_SocketCfgDone_s = '1') then
----                ethernet_init_done <= '1';
----            else
----                ethernet_init_done <= '0';
----            end if;
--        end if;
--    end process;

    -- CpSl_NetInitDone_o
    process (nrst,clk) begin
        if (nrst = '0') then
            CpSl_NetInitDone_o <= '0';
        elsif rising_edge(clk) then
            if (PrSl_Ethernet_nrst_ctrl_s = '0') then
                CpSl_NetInitDone_o <= '0';
            elsif (PrSl_SocketCfgDone_s = '1') then
                CpSl_NetInitDone_o <= '1';
            else -- hold
            end if;
        end if;
    end process;
    
    -- W5300_Write_Trig
    process (nrst,clk) begin
        if (nrst = '0') then
            CpSl_WrTrig_s <= '0';
        elsif rising_edge(clk) then
            if (PrSl_ComWrVld_s = '1' and PrSv_ComWrCnt_s = 0) then
                CpSl_WrTrig_s <= '1';
            elsif (PrSl_SocketWrVld_s = '1' and PrSv_SocketWrCnt_s = 0) then
                CpSl_WrTrig_s <= '1';
            elsif (PrSl_RxTxWrVld_s = '1' and PrSv_RxTxWrCnt_s = 0) then
                CpSl_WrTrig_s <= '1';
--            elsif (PrSl_UdpRxWrVld_s = '1' and PrSv_UdpRxWrCnt_s = 0) then
--                CpSl_WrTrig_s <= '1';
            else
                CpSl_WrTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- W5300_Read_Trig
    process (nrst,clk) begin
        if (nrst = '0') then
            CpSl_RdTrig_s <= '0';
        elsif rising_edge(clk) then
            if (PrSl_SocketRdVld_s = '1' and PrSv_SocketRdCnt_s = 0) then
                CpSl_RdTrig_s <= '1';
            elsif (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = 0) then
                CpSl_RdTrig_s <= '1';
            else
                CpSl_RdTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- CpSv_W5300Add_s
    process (nrst,clk) begin
        if (nrst = '0') then
            CpSv_W5300Add_s <= (others => '0');
        elsif rising_edge(clk) then
            -- Common_Reg
            if (PrSl_ComWrVld_s = '1' and PrSv_ComWrCnt_s = 0) then
                if (PrSv_ComState_s = PrSv_ComStateRstW5300_c) then 
                    CpSv_W5300Add_s <= W5300_MR(9 downto 0); 
                elsif (PrSv_ComState_s = PrSv_ComStateMR_c) then
                    CpSv_W5300Add_s <= W5300_MR(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateIR_c) then 
                    CpSv_W5300Add_s <= W5300_IR(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateIMR_c) then 
                    CpSv_W5300Add_s <= W5300_IMR(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateShaReg_c) then
                    CpSv_W5300Add_s <= W5300_SHAR(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateShaReg2_c) then 
                     CpSv_W5300Add_s <= W5300_SHAR2(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateShaReg4_c) then 
                    CpSv_W5300Add_s <= W5300_SHAR4(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateGAR_c) then 
                    CpSv_W5300Add_s <= W5300_GAR(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateGAR2_c) then
                    CpSv_W5300Add_s <= W5300_GAR2(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateSUBR_c) then 
                     CpSv_W5300Add_s <= W5300_SUBR(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateSUBR2_c) then
                    CpSv_W5300Add_s <= W5300_SUBR2(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateSIPR_c) then 
                     CpSv_W5300Add_s <= W5300_SIPR(9 downto 0);  
                elsif (PrSv_ComState_s = PrSv_ComStateSIPR2_c) then 
                     CpSv_W5300Add_s <= W5300_SIPR2(9 downto 0);     
                elsif (PrSv_ComState_s = PrSv_ComStateTMS01R_c) then 
                     CpSv_W5300Add_s <= W5300_TMS01R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateTMS23R_c) then
                    CpSv_W5300Add_s <= W5300_TMS23R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateTMS45R_c) then 
                     CpSv_W5300Add_s <= W5300_TMS45R(9 downto 0);  
                elsif (PrSv_ComState_s = PrSv_ComStateTMS67R_c) then 
                     CpSv_W5300Add_s <= W5300_TMS67R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateRMS01R_c) then 
                     CpSv_W5300Add_s <= W5300_RMS01R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateRMS23R_c) then
                    CpSv_W5300Add_s <= W5300_RMS23R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateRMS45R_c) then 
                     CpSv_W5300Add_s <= W5300_RMS45R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateRMS67R_c) then 
                     CpSv_W5300Add_s <= W5300_RMS67R(9 downto 0);
                elsif (PrSv_ComState_s = PrSv_ComStateMTYPER_c) then 
                     CpSv_W5300Add_s <= W5300_MTYPER(9 downto 0);
                else -- hold
                end if;
            
            -- Socket_Reg
            elsif (PrSl_SocketWrVld_s = '1' and PrSv_SocketWrCnt_s = 0) then    
                if (PrSv_SocketState_s = PrSv_SocketStateS0MR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_MR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0IMR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_IMR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0IR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_IR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0PortReg_c) then 
                    CpSv_W5300Add_s <= W5300_S0_PORTR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0CR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_CR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1MR_c) then 
                    CpSv_W5300Add_s <= W5300_S1_MR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1IMR_c) then 
                    CpSv_W5300Add_s <= W5300_S1_IMR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1IR_c) then 
                    CpSv_W5300Add_s <= W5300_S1_IR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1PortReg_c) then 
                    CpSv_W5300Add_s <= W5300_S1_PORTR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1DPortReg_c) then 
                    CpSv_W5300Add_s <= W5300_S1_DPORTR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1CR_OPEN_c or
					        PrSv_SocketState_s = PrSv_SocketStateS1CR_LISTEN_c) then 
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
                else -- hold
                end if;
                    
            -- Read_Socket_Reg
            elsif (PrSl_SocketRdVld_s = '1' and PrSv_SocketRdCnt_s = 0) then 
                if (PrSv_SocketState_s = PrSv_SocketStateS0SSR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_SSR(9 downto 0);
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1SSR_c) then 
                    CpSv_W5300Add_s <= W5300_S1_SSR(9 downto 0);
					 else -- hold
                end if;

		   	-- RxTxWr  
            elsif (PrSl_RxTxWrVld_s = '1' and PrSv_RxTxWrCnt_s = 0) then      
                if(PrSv_RxTxState_s = PrSv_TcpRxS1CR_OPEN_c)then
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpRxS1CR_LISTEN_c) then 
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpRxS1CRRecv_c) then 
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr_c) then 
                    CpSv_W5300Add_s <= W5300_S1_TX_WRSR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr2_c) then 
                    CpSv_W5300Add_s <= W5300_S1_TX_WRSR2(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpTxS1Wfifor_c) then 
                    CpSv_W5300Add_s <= W5300_S1_TX_FIFOR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpS1CRSend_c) then 
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpRxS1Close_c) then 
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpRxS1discon_c) then 
                    CpSv_W5300Add_s <= W5300_S1_CR(9 downto 0);
						  
					 elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DHAR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_DHAR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DHAR2_c) then
                    CpSv_W5300Add_s <= W5300_S0_DHAR2(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DHAR4_c) then 
                    CpSv_W5300Add_s <= W5300_S0_DHAR4(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DPortR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_DPORTR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DIPR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_DIPR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DIPR2_c) then 
                    CpSv_W5300Add_s <= W5300_S0_DIPR2(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFifo_c) then
                    CpSv_W5300Add_s <= W5300_S0_TX_FIFOR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFifo2_c) then 
                    CpSv_W5300Add_s <= W5300_S0_TX_FIFOR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxWRSR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_TX_WRSR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxWRSR2_c) then 
                    CpSv_W5300Add_s <= W5300_S0_TX_WRSR2(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0CRSend_c) then 
                    CpSv_W5300Add_s <= W5300_S0_CR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxClrS0IR_c) then
                    CpSv_W5300Add_s <= W5300_S0_IR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0SendClose_c) then
                    CpSv_W5300Add_s <= W5300_S0_CR(9 downto 0);
                else -- hold
                end if;

            -- RxTxRd
            elsif (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = 0) then 
                if (PrSv_RxTxState_s = PrSv_TcpRxS1SSR_c) then
                    CpSv_W5300Add_s <= W5300_S1_SSR(9 downto 0);
					 elsif (PrSv_RxTxState_s = PrSv_TcpRxS1RxRSR_c) then
                    CpSv_W5300Add_s <= W5300_S1_RX_RSR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_TcpRxS1RxRSR2_c) then
                    CpSv_W5300Add_s <= W5300_S1_RX_RSR2(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_TcpRxHeadCnt_c or PrSv_RxTxState_s = PrSv_TcpRxData_c) then 
                    CpSv_W5300Add_s <= W5300_S1_RX_FIFOR(9 downto 0);    
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFSR_c) then 
                    CpSv_W5300Add_s <= W5300_S0_TX_FSR(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFSR2_c) then 
                    CpSv_W5300Add_s <= W5300_S0_TX_FSR2(9 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxRdS0IR_c) then
                    CpSv_W5300Add_s <= W5300_S0_IR(9 downto 0);
                else -- hold
                end if;
            end if;
        end if;
    end process;
	 
	 

    -- CpSv_W5300WrData_s
    process (nrst,clk) begin---发出的数据格式及数据
        if (nrst = '0') then
            CpSv_W5300WrData_s <= (others => '0');
        elsif rising_edge(clk) then
            -- Wr_Common_Reg_Data
            if (PrSl_ComWrVld_s = '1' and PrSv_ComWrCnt_s = 0) then
                if (PrSv_ComState_s = PrSv_ComStateRstW5300_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300MRRst_c; 
                elsif (PrSv_ComState_s = PrSv_ComStateMR_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300MRData_c;
                elsif (PrSv_ComState_s = PrSv_ComStateIR_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300IRData_c;
                elsif (PrSv_ComState_s = PrSv_ComStateIMR_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300IMRData_c;
                elsif (PrSv_ComState_s = PrSv_ComStateShaReg_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300ShaRData_c(47 downto 32);
                elsif (PrSv_ComState_s = PrSv_ComStateShaReg2_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300ShaRData_c(31 downto 16);
                elsif (PrSv_ComState_s = PrSv_ComStateShaReg4_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300ShaRData_c(15 downto  0);
                elsif (PrSv_ComState_s = PrSv_ComStateGAR_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300GaRData_c(31 downto 16);
                elsif (PrSv_ComState_s = PrSv_ComStateGAR2_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300GaRData_c(15 downto  0);
                elsif (PrSv_ComState_s = PrSv_ComStateSUBR_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300SubRData_c(31 downto 16);
                elsif (PrSv_ComState_s = PrSv_ComStateSUBR2_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300SubRData_c(15 downto  0);
                elsif (PrSv_ComState_s = PrSv_ComStateSIPR_c) then 
                    --CpSv_W5300WrData_s <= PrSv_W5300SiPRData_c(31 downto 16);  
                    CpSv_W5300WrData_s <= prsv_w5300siprdata_s(15 downto  0);  
                elsif (PrSv_ComState_s = PrSv_ComStateSIPR2_c) then 
                    --CpSv_W5300WrData_s <= PrSv_W5300SiPRData_c(15 downto  0);     
                    CpSv_W5300WrData_s <= prsv_w5300siprdata_s(31 downto 16);     
                elsif (PrSv_ComState_s = PrSv_ComStateTMS01R_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300TMS01Data_c;
                elsif (PrSv_ComState_s = PrSv_ComStateTMS23R_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300TMS23Data_c;
                elsif (PrSv_ComState_s = PrSv_ComStateTMS45R_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300TMS45Data_c;  
                elsif (PrSv_ComState_s = PrSv_ComStateTMS67R_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300TMS67Data_c;
                elsif (PrSv_ComState_s = PrSv_ComStateRMS01R_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300RMS01Data_c;
                elsif (PrSv_ComState_s = PrSv_ComStateRMS23R_c) then
                    CpSv_W5300WrData_s <= PrSv_W5300RMS23Data_c;
                elsif (PrSv_ComState_s = PrSv_ComStateRMS45R_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300RMS45Data_c;  
                elsif (PrSv_ComState_s = PrSv_ComStateRMS67R_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300RMS67Data_c;  
                elsif (PrSv_ComState_s = PrSv_ComStateMTYPER_c) then 
                    CpSv_W5300WrData_s <= PrSv_W5300MTypeData_c;
                else -- hold
                end if;
                
            -- Wr_Socket_Reg_Data
            elsif (PrSl_SocketWrVld_s = '1' and PrSv_SocketWrCnt_s = 0) then
                if (PrSv_SocketState_s = PrSv_SocketStateS0MR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0MR_UDP_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0IMR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0IMRData_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0IR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0IRData_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0PortReg_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0PortR_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS0CR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0CR_Open_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1MR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1MR_TCP_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1IMR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1IMRData_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1IR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1IRData_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1PortReg_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1PortR_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1DPortReg_c) then 
                    CpSv_W5300WrData_s <= prsv_s1dportrdata_s;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1CR_OPEN_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_Open_c;
                elsif (PrSv_SocketState_s = PrSv_SocketStateS1CR_LISTEN_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_listen_c;
                else -- hold
                end if;

				-- Wr_UDP_Tx_Data
            elsif (PrSl_RxTxWrVld_s = '1' and PrSv_RxTxWrCnt_s = 0) then        
                if (PrSv_RxTxState_s = PrSv_TcpRxS1CR_OPEN_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_Open_c;
                elsif (PrSv_RxTxState_s = PrSv_TcpRxS1CR_LISTEN_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_listen_c;
                elsif (PrSv_RxTxState_s = PrSv_TcpRxS1CRRecv_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_Recv_c;
                elsif (PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr_c) then 
                    CpSv_W5300WrData_s <= PrSv_Tcp_Ack_wsrs_s(31 downto 16);
                elsif (PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr2_c) then 
                    CpSv_W5300WrData_s <= PrSv_Tcp_Ack_wsrs_s(15 downto 0);
                elsif (PrSv_RxTxState_s = PrSv_TcpTxS1Wfifor_c) then 
                    CpSv_W5300WrData_s <= PrSv_Tcp_Tx_Data_s;
                elsif (PrSv_RxTxState_s = PrSv_TcpS1CRSend_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_Send_c;
                elsif (PrSv_RxTxState_s = PrSv_TcpRxS1Close_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_Close_c;
                elsif (PrSv_RxTxState_s = PrSv_TcpRxS1discon_c) then 
                    CpSv_W5300WrData_s <= PrSv_S1CR_discon_c;
                
					 elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DHAR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0DHarMac_c(47 downto 32);
					 elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DHAR2_c) then
                    CpSv_W5300WrData_s <= PrSv_S0DHarMac_c(31 downto 16);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DHAR4_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0DHarMac_c(15 downto  0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DPortR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0DPortRData_c;
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DIPR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0DIPRData_c(31 downto 16);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0DIPR2_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0DIPRData_c(15 downto  0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFifo_c) then
                    CpSv_W5300WrData_s <= CpSv_NetData_i(31 downto 16);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFifo2_c) then
                    CpSv_W5300WrData_s <= CpSv_NetData_i(15 downto  0);
                elsif (PrSv_RxTxState_s = PrSv_UdpTxWRSR_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0TX_WRSR_c;
                elsif (PrSv_RxTxState_s = PrSv_UdpTxWRSR2_c) then 
                    CpSv_W5300WrData_s <= PrSv_S0TX_WRSR2_s;
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0CRSend_c) then  -- Send Mac
                    CpSv_W5300WrData_s <= PrSv_S0CR_SendMac_c;
                elsif (PrSv_RxTxState_s = PrSv_UdpTxClrS0IR_c) then 
                    CpSv_W5300WrData_s <= PrSv_ClrS0IRData_c;
                elsif (PrSv_RxTxState_s = PrSv_UdpTxS0SendClose_c) then
                    CpSv_W5300WrData_s <= PrSv_S0CR_Close_c;
                else -- hold
                end if;

--            -- Wr_UDP_Rx_Data
--            elsif (PrSl_UdpRxWrVld_s = '1' and PrSv_UdpRxWrCnt_s = 0) then 
--                -- UDP_Rx    
--                if (PrSv_RxTxState_s = ) then 
--                elsif () then 
--                else -- hold
--                end if;
            else -- hold
            end if;
        end if;
    end process;
	 
	 

	 prsv_s1dportrdata_s  <= prsv_s1dportrdata_i when (sip_dport_en_i = x"0000") else x"0BB8";
	 --prsv_w5300siprdata_s <= prsv_w5300siprdata_i when (sip_dport_en_i = x"0000") else x"0A6CC0A8"; -- 192.168.10.108
	 prsv_w5300siprdata_s <= prsv_w5300siprdata_i when (sip_dport_en_i = x"0000") else x"0A6BC0A8"; -- 192.168.10.107
    ------------------------------------
    -- Init Area 
    ------------------------------------
    -- PrSv_W5300InitCnt_s
    process (nrst,clk) begin 
        if (nrst = '0') then 
            PrSv_W5300InitCnt_s <= PrSv_W5300WaitTime_s;
        elsif rising_edge(clk) then 
            if (PrSl_W5300Init_s = '1') then
                PrSv_W5300InitCnt_s <= (others => '0');
            elsif (PrSv_W5300InitCnt_s = PrSv_W5300WaitTime_s) then   -- PrSv_wait15ms_c
                PrSv_W5300InitCnt_s <= PrSv_W5300WaitTime_s;
            else
                PrSv_W5300InitCnt_s <= PrSv_W5300InitCnt_s + '1';
            end if;
        end if;
    end process;
    
    -- PrSl_W5300InitDone_s
    process (nrst,clk) begin 
        if (nrst = '0') then 
            PrSl_W5300InitDone_s <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_W5300InitCnt_s = PrSv_W5300WaitTime_s - 2) then
                PrSl_W5300InitDone_s <= '1';
            else
                PrSl_W5300InitDone_s <= '0';
            end if;
        end if;
    end process;
	 
    process (nrst,clk) begin 
        if (nrst = '0') then 
            initial_done_d1 <= '0';
            initial_done_d2 <= '0';
        elsif rising_edge(clk) then 
            initial_done_d1 <= initial_done_i;
            initial_done_d2 <= initial_done_d1;
        end if;
    end process;	 
    
	 initial_done_trig <= '1' when (initial_done_d2 = '0' and initial_done_d1 = '1') else '0';
	 
    ------------------------------------
    -- Init Common Reg
    ------------------------------------
    PrSl_EthStartTrig_s       <= ethernet_init_start;
    PrSl_Ethernet_nrst_ctrl_s <= ethernet_nrst_ctrl;

    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_ComState_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_Ethernet_nrst_ctrl_s = '0') then
                PrSv_ComState_s <= (others => '0');
            else
            case PrSv_ComState_s is
                when PrSv_ComStateIdle_c => -- W5300 Init Done  
                    --if (PrSl_EthStartTrig_s = '1') then 
                    if (initial_done_trig = '1') then 
                        PrSv_ComState_s <= PrSv_ComStateRstW5300_c;
                    elsif (PrSl_W5300InitDone_s = '1' and initial_done_i = '1') then 
                        PrSv_ComState_s <= PrSv_ComStateRstW5300_c;
                    else -- hold
                    end if;

                when PrSv_ComStateRstW5300_c => -- Reset_W5300   
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComState200us_c;
                    else -- hold
                    end if;
                     
                when PrSv_ComState200us_c => -- wait 200us
                    if (PrSv_100usCnt_s = 2) then
                        PrSv_ComState_s <= PrSv_ComStateMR_c;
                    else -- hold
                    end if;
                when PrSv_ComStateMR_c => -- Config MR
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateIR_c;
                    else -- hold
                    end if;
                when PrSv_ComStateIR_c => -- Config IR
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateIMR_c;
                    else -- hold
                    end if;
                when PrSv_ComStateIMR_c => -- Config IMR
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_ComState_s <= PrSv_ComStateShaReg_c;
                    else -- hold
                    end if;
                when PrSv_ComStateShaReg_c => -- ShaReg(MAC)
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateShaReg2_c;
                    else -- hold
                    end if;
                when PrSv_ComStateShaReg2_c => -- ShaReg2(MAC)
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateShaReg4_c;
                    else -- hold
                    end if;
                when PrSv_ComStateShaReg4_c => -- ShaReg4(MAC)
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateGAR_c;
                    else -- hold
                    end if;
                when PrSv_ComStateGAR_c => -- GAR
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateGAR2_c;
                    else -- hold
                    end if;
                when PrSv_ComStateGAR2_c => -- GAR2
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateSUBR_c;
                    else -- hold
                    end if;
                when PrSv_ComStateSUBR_c => -- SUBR
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateSUBR2_c;
                    else -- hold
                    end if;
                when PrSv_ComStateSUBR2_c => -- SUBR2
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateSIPR_c;
                    else -- hold
                    end if;
                when PrSv_ComStateSIPR_c => -- SIPR
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateSIPR2_c;
                    else -- hold
                    end if;
                when PrSv_ComStateSIPR2_c => -- SIPR2
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateTMS01R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateTMS01R_c => -- Config TMS01R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateTMS23R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateTMS23R_c => -- Config TMS23R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateTMS45R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateTMS45R_c => -- Config TMS45R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateTMS67R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateTMS67R_c => -- Config TMS67R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateRMS01R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateRMS01R_c => -- Config RMS01R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateRMS23R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateRMS23R_c => -- Config RMS23R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateRMS45R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateRMS45R_c => -- Config RMS45R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateRMS67R_c;
                    else -- hold
                    end if;
                when PrSv_ComStateRMS67R_c => -- Config RMS67R
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateMTYPER_c;
                    else -- hold
                    end if;
                when PrSv_ComStateMTYPER_c => -- Config MTYPER
                    if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_ComState_s <= PrSv_ComStateEnd_c;
                    else -- hold
                    end if;
                
                when PrSv_ComStateEnd_c => -- Config Done
                    PrSv_ComState_s <= (others => '0');
                when others => PrSv_ComState_s <= (others => '0');
                end case;
            end if;
        end if;
    end process;

    -- PrSv_100usCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then 
            PrSv_100usCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_ComState_s = PrSv_ComState200us_c) then
                if (tick_100us = '1') then 
                    PrSv_100usCnt_s <= PrSv_100usCnt_s + '1';
                else -- hold
                end if;
            else
                PrSv_100usCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSl_ComWrVld_s
    process (nrst,clk) begin 
        if (nrst = '0') then 
            PrSl_ComWrVld_s <= '0';
        elsif rising_edge(clk) then
            if (PrSv_ComState_s = PrSv_ComStateRstW5300_c) then
                if (PrSv_ComWrCnt_s = 0) then
                    PrSl_ComWrVld_s <= '1';  
                elsif (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then
                    PrSl_ComWrVld_s <= '0'; 
                else -- hold
                end if;
            elsif (PrSv_ComState_s = PrSv_ComStateMR_c) then 
                PrSl_ComWrVld_s <= '1';
            elsif (PrSv_ComState_s = PrSv_ComStateMTYPER_c and PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then 
                PrSl_ComWrVld_s <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_ComWrCnt_s
    process (nrst,clk) begin 
        if (nrst = '0') then
            PrSv_ComWrCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_ComWrVld_s = '1') then
                if (PrSv_ComWrCnt_s = PrSv_WrWaitCnt_c) then
                    PrSv_ComWrCnt_s <= (others => '0');
                else
                    PrSv_ComWrCnt_s <= PrSv_ComWrCnt_s + '1';
                end if;
            else
                PrSv_ComWrCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSl_ComRegDone_s
    PrSl_ComRegDone_s <= '1' when (PrSv_ComState_s = PrSv_ComStateEnd_c) else '0';

    ------------------------------------
    -- Init Socket Reg
    ------------------------------------
    --------Socket0---------------------
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_SocketState_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_Ethernet_nrst_ctrl_s = '0') then
                PrSv_SocketState_s <= (others => '0');
            else
                case PrSv_SocketState_s is
                when PrSv_SocketStateIdle_c => -- Config Common Reg Done
                    if (PrSl_ComRegDone_s = '1') then
                        PrSv_SocketState_s <= PrSv_SocketStateS0MR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0MR_c => -- Wr_S0_MR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS0IMR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0IMR_c => -- Wr_S0_IMR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS0IR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0IR_c => -- Wr_S0_IR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS0PortReg_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0PortReg_c => -- Wr_S0_ProtReg
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS0CR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0CR_c => -- Wr_S0_CR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS0SSR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0SSR_c => -- Rd_S0_SSR
                    if (PrSv_SocketRdCnt_s = PrSv_RdWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS0UDP_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS0UDP_c => -- UDP Module Success
                    if (PrSv_SocketS0_SSRData_s = PrSv_S0SSR_UDP_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1MR_c;
                    elsif (PrSv_RdS0SSRCnt_s = x"F") then   -- PrSv_RdS0TxSRCnt_s
                        PrSv_SocketState_s <= (others => '0');
                    else 
                        PrSv_SocketState_s <= PrSv_SocketStateS0SSR_c;
                    end if;
						  
                when PrSv_SocketStateS1MR_c => -- Wr_S1_MR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1IMR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS1IMR_c => -- Wr_S1_IMR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1IR_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS1IR_c => -- Wr_S1_IR
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1PortReg_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS1PortReg_c => -- Wr_S1_ProtReg
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1DPortReg_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS1DPortReg_c => -- Wr_S1_ProtReg
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateEnd_c;
                    else -- hold
                    end if;
                when PrSv_SocketStateS1CR_OPEN_c => -- Wr_S1_CR_OPEN
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1SSR_c;
                    else -- hold
                    end if;						  
                when PrSv_SocketStateS1CR_LISTEN_c => -- Wr_S0_CR_LISTEN
                    if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1SSR_c;
                    else -- hold
                    end if;						  
                when PrSv_SocketStateS1SSR_c => -- Wr_S1_SSR
                    if (PrSv_SocketRdCnt_s = PrSv_RdWaitCnt_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1TCP_c;
                    else -- hold
                    end if;						  
                when PrSv_SocketStateS1TCP_c => -- TCP Module Success
                    if (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_INIT_c) then 
                        PrSv_SocketState_s <= PrSv_SocketStateS1CR_LISTEN_c;
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_LISTEN_c) then   --
                        PrSv_SocketState_s <= PrSv_SocketStateS1SSR_c; --test
                        --PrSv_SocketState_s <= PrSv_SocketStateEnd_c;
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_ESTABLISHED_c) then   --
                        PrSv_SocketState_s <= PrSv_SocketStateEnd_c;
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSED_c) then   -- PrSv_RdS1TxSRCnt_s
                        PrSv_SocketState_s <= PrSv_SocketStateS1MR_c;
                    --elsif (PrSv_RdS1SSRCnt_s = x"F") then   -- PrSv_RdS1TxSRCnt_s
                    --    PrSv_SocketState_s <= PrSv_SocketStateS1MR_c;
                    else 
                        PrSv_SocketState_s <= PrSv_SocketStateS1SSR_c;
                    end if;
						  
                when PrSv_SocketStateEnd_c => -- End
                    PrSv_SocketState_s <= (others => '0');
                when others => PrSv_SocketState_s <= (others => '0');
                end case;
            end if;
        end if;
    end process;
    
	 PrSl_SocketWrVld_s <= '1' when (PrSv_SocketState_s = PrSv_SocketStateS0MR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS0IMR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS0IR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS0PortReg_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS0CR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1MR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1IMR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1MR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1IR_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1PortReg_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1DPortReg_c or 
				                        PrSv_SocketState_s = PrSv_SocketStateS1CR_OPEN_c or 
					                     PrSv_SocketState_s = PrSv_SocketStateS1CR_LISTEN_c)  else '0';
	 
	 
	 
    -- PrSv_SocketWrCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_SocketWrCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_SocketWrVld_s = '1') then
                if (PrSv_SocketWrCnt_s = PrSv_WrWaitCnt_c) then
                    PrSv_SocketWrCnt_s <= (others => '0');
                else
                    PrSv_SocketWrCnt_s <= PrSv_SocketWrCnt_s + '1';
                end if;
            else
                PrSv_SocketWrCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSl_SocketRdVld_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSl_SocketRdVld_s <= '0';
        elsif rising_edge(clk) then
            if (PrSv_SocketState_s = PrSv_SocketStateS0SSR_c or
				    PrSv_SocketState_s = PrSv_SocketStateS1SSR_c) then
                if (PrSv_SocketRdCnt_s = 0) then 
                    PrSl_SocketRdVld_s <= '1'; 
                elsif (PrSv_SocketRdCnt_s = PrSv_RdWaitCnt_c) then 
                    PrSl_SocketRdVld_s <= '0'; 
                else -- hold
                end if;
            else
                PrSl_SocketRdVld_s <= '0'; 
            end if;
        end if;
    end process;
    
    -- PrSv_SocketRdCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_SocketRdCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_SocketRdVld_s = '1') then
                if (PrSv_SocketRdCnt_s = PrSv_RdWaitCnt_c) then 
                    PrSv_SocketRdCnt_s <= (others => '0');
                else 
                    PrSv_SocketRdCnt_s <= PrSv_SocketRdCnt_s + '1';
                end if;
            else
                PrSv_SocketRdCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_SocketS0_SSRData_s
    Real_Socket : if (PrSl_Sim_c = 1) generate
    process (nrst,clk) begin 
        if (nrst = '0') then
            PrSv_SocketS0_SSRData_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_SocketState_s = PrSv_SocketStateS0SSR_c) then 
                if (PrSl_SocketRdVld_s = '1' and PrSv_SocketRdCnt_s = PrSv_CapRdData_c) then
                    PrSv_SocketS0_SSRData_s <= CpSv_W5300RdData_s(7 downto 0);
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;
	 end generate Real_Socket;
	 
	     process (nrst,clk) begin 
        if (nrst = '0') then
            PrSv_SocketS1_SSRData_s <= (others => '0');
        elsif rising_edge(clk) then
            if ((PrSv_RxTxState_s = PrSv_TcpRxS1SSR_c and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) or 
				    (PrSv_SocketState_s = PrSv_SocketStateS1SSR_c and PrSv_SocketRdCnt_s = PrSv_RdWaitCnt_c))then 
                PrSv_SocketS1_SSRData_s <= CpSv_W5300RdData_s(7 downto 0);
            else -- hold
            end if;
        end if;
    end process;
    

    
    sim_Socket : if (PrSl_Sim_c = 0) generate
        PrSv_SocketS0_SSRData_s <= x"22";
        --PrSv_SocketS1_SSRData_s <= x"22";
    end generate sim_Socket;
    
    -- PrSl_SocketCfgDone_s
    PrSl_SocketCfgDone_s <= '1' when (PrSv_SocketState_s = PrSv_SocketStateEnd_c) else '0';
    
    ------------------------------------
    -- UDP Tx State Simulation 
    ------------------------------------
    -- PrSv_FifoDataNum_s
    PrSv_FifoDataNum_s <= CpSv_UdpRdCnt_i;
    PrSl_send_start_s  <= send_start;
	 
    FifoNum_SimCnt : if (PrSl_Sim_c = 0) generate
--        PrSv_FifoDataNum_s <= PrSv_FifoSimNum_c;
--        PrSl_send_start_s <= '1';

        -- PrSv_UdpTx_RdS0IR_s
        PrSv_UdpTx_RdS0IR_s <= "10000";
    end generate FifoNum_SimCnt;
    
    FifoNum_Cnt : if (PrSl_Sim_c = 1) generate
        -- PrSl_send_start_s
--        PrSl_send_start_s <= send_start;
        
        -- PrSv_UdpTx_RdS0IR_s
        process (nrst,clk) begin 
            if (nrst = '0') then
                PrSv_UdpTx_RdS0IR_s <= (others => '0');
            elsif rising_edge(clk) then
                if (PrSv_RxTxState_s = PrSv_UdpTxRdS0IR_c) then 
                    if (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then 
                        PrSv_UdpTx_RdS0IR_s <= CpSv_W5300RdData_s(4 downto 0);
                    else -- hold
                    end if;
                else -- hold
                end if;
            end if;
        end process;
    end generate FifoNum_Cnt;
    
    -- PrSv_UdpTxFSRBlank_s
        process (nrst,clk) begin 
            if (nrst = '0') then
                PrSv_UdpTxFSRBlank_s <= (others => '0');
            elsif rising_edge(clk) then
                if (PrSv_RxTxState_s = PrSv_UdpTxFSR_c) then 
                    if (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then 
                        PrSv_UdpTxFSRBlank_s(16) <= CpSv_W5300RdData_s(0);
                    else -- hold
                    end if;
                elsif (PrSv_RxTxState_s = PrSv_UdpTxFSR2_c) then 
                    if (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then 
                        PrSv_UdpTxFSRBlank_s(15 downto 0) <= CpSv_W5300RdData_s;
                    else -- hold
                    end if;
                else -- hold
                end if;
            end if;
        end process;
    
    ------------------------------------
    -- UDP Tx State 
    ------------------------------------
    -- 先判断下发数据接收完成，然后开始上传数据
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_RxTxState_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_Ethernet_nrst_ctrl_s = '0') then
                PrSv_RxTxState_s <= (others => '0');
            else
                case PrSv_RxTxState_s is
                when PrSv_RxTxIdle_c => -- Idle
                    if (PrSl_SocketCfgDone_s = '1') then
                        PrSv_RxTxState_s <= PrSv_TcpRxS1CR_OPEN_c;
                    else -- hold
                    end if;
                when PrSv_TcpRxS1CR_OPEN_c => -- Wr_S1_CR_OPEN
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
                    else -- hold
                    end if;						  
                when PrSv_TcpRxS1CR_LISTEN_c => -- Wr_S1_CR_LISTEN
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
                    else -- hold
                    end if;						  
						  
                when PrSv_TcpRxS1SSR_c => -- Wr_S1_SSR
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxS1TCP_c;
                    else -- hold
                    end if;						  
                when PrSv_TcpRxS1TCP_c => -- TCP Module Success
                    if (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_INIT_c) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxS1CR_LISTEN_c;
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_ESTABLISHED_c) then          
						      PrSv_RxTxState_s <= PrSv_TcpRxStart_c; 
					     elsif(rw_flash_frame_done_r(1) = '1' or train_cmd_done_r(1) = '1') then --send tcp
                        PrSv_RxTxState_s <= PrSv_TcpTxS1wWrsr_c;
						  elsif(PrSl_send_start_s = '1') then                                     --send udp 
						      PrSv_RxTxState_s <= PrSv_UdpTxStart_c; -- to transmit
--                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSE_WAIT_c) then
--						      PrSv_RxTxState_s <= PrSv_TcpRxS1Close_c; 
--                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSED_c) then
--						      PrSv_RxTxState_s <= PrSv_TcpRxS1CR_OPEN_c; 
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSE_WAIT_c and s1_discon_done = '0') then
						      PrSv_RxTxState_s <= PrSv_TcpRxS1discon_c; 						  
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSE_WAIT_c and s1_discon_done = '1') then
						      PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c; 						  
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSED_c and s1_open_done = '1' and s1_close_done = '1') then
						      PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c; 						  
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSED_c and s1_open_done = '0' and s1_close_done = '1') then
						      PrSv_RxTxState_s <= PrSv_TcpRxS1CR_OPEN_c; 						  
                    elsif (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_CLOSED_c and s1_open_done = '0' and s1_close_done = '0') then
						      PrSv_RxTxState_s <= PrSv_TcpRxS1Close_c; 						  
						  else
						      PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
						      --PrSv_RxTxState_s <= PrSv_TcpRxS1CR_OPEN_c;
						  end if;
						  
		          when PrSv_TcpRxS1Close_c => 
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
						  else
						  end if;						  

		          when PrSv_TcpRxS1discon_c => 
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
						  else
						  end if;						  

						  
						  
                when PrSv_TcpRxStart_c => -- Start
                    PrSv_RxTxState_s <= PrSv_TcpRxS1RxRSR_c;
                
                when PrSv_TcpRxS1RxRSR_c => -- Read_S0_Rx_RSR
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxS1RxRSR2_c;
                    else -- hold
                    end if;
                when PrSv_TcpRxS1RxRSR2_c => -- Read_S0_Rx_RSR2
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpRxRSRCnt_c;
                    else -- hold
                    end if;
                when PrSv_TcpRxRSRCnt_c => -- RSRCnt
                    if (PrSv_TcpRxRSRCnt_s /= 0) then                                       --rec  tcp
                        PrSv_RxTxState_s <= PrSv_TcpRxHeadCnt_c;
					     elsif(rw_flash_frame_done_r(1) = '1' or train_cmd_done_r(1) = '1') then --send tcp
                        PrSv_RxTxState_s <= PrSv_TcpTxS1wWrsr_c;
						  elsif(PrSl_send_start_s = '1') then                                     --send udp
						      PrSv_RxTxState_s <= PrSv_UdpTxStart_c;-- to transmit
						  else
						      PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
                    end if;
                    
                when PrSv_TcpRxHeadCnt_c => -- Read_UDP_Head
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxHeadData_c;
                    else -- hold
                    end if;
                when PrSv_TcpRxHeadData_c => -- Read_UDP_Data
                    if (PrSv_TcpRxHeadData_s /= 0) then 
                        PrSv_RxTxState_s <= PrSv_TcpRxData_c;
                    else
                        PrSv_RxTxState_s <= PrSv_TcpRxS1RxRSR_c;
                    end if;
                when PrSv_TcpRxData_c => -- Read_Data
                    if (PrSv_TcpRxDataCnt_s = PrSv_TcpRxPackSize_s and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpRxS1CRRecv_c;
                    else -- hold
                    end if; 
		          when PrSv_TcpRxS1CRRecv_c => 
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
						  else
						  end if;						  
--					 when PrSv_wait_proc_done_c =>
--					     if(rw_flash_frame_done_i(1) = '1' or train_cmd_done_i(1) = '1') then
--                        PrSv_RxTxState_s <= PrSv_TcpTxS1wWrsr_c;
--						  else
--						  end if;						  
                when PrSv_TcpTxS1wWrsr_c => -- tx ack frame
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpTxS1wWrsr2_c;
						  else
						  end if;                
                when PrSv_TcpTxS1wWrsr2_c => -- tx ack frame
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c ) then
                        PrSv_RxTxState_s <= PrSv_TcpTxS1Wfifor_c;
						  else
						  end if;                
					 when PrSv_TcpTxS1Wfifor_c => -- tx ack frame
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c and PrSv_TcpTxDataCnt_s >= (PrSv_Tcp_Ack_wsrs_s(16 downto 1) - 1)) then
                        PrSv_RxTxState_s <= PrSv_TcpS1CRSend_c;
						  else
						  end if;
		          when PrSv_TcpS1CRSend_c => 
					     if(PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
						  else
						  end if;						  
						  

						  

--------------------------------------------------------------
--------------------tx data state-----------------------------		
--------------------------------------------------------------
                when PrSv_UdpTxStart_c => -- Start
                    PrSv_RxTxState_s <= PrSv_UdpTxS0DHAR_c;

                when PrSv_UdpTxWait_c => -- wait time 
                    if (PrSv_TxWaitTime_s = PrSv_TxWaitTime_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxS0DHAR_c;
                    else -- hold 
                    end if;
                
                when PrSv_UdpTxS0DHAR_c => -- Wr_S0DHAR
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxS0DHAR2_c;
                    else -- hold
                    end if;
                when PrSv_UdpTxS0DHAR2_c => -- Wr_S0DHAR2
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxS0DHAR4_c;
                    else -- hold
                    end if;
                when PrSv_UdpTxS0DHAR4_c => -- Wr_S0DHAR4
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxS0DPortR_c;
                    else -- hold
                    end if;
                when PrSv_UdpTxS0DPortR_c => -- Wr_S0DPortR
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxS0DIPR_c;
                    else -- hold
                    end if;
                when PrSv_UdpTxS0DIPR_c => -- Wr_S0DIPR
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_UdpTxS0DIPR2_c;
                    else -- hold
                    end if; 
                when PrSv_UdpTxS0DIPR2_c => -- Wr_S0DIPR2
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxFSR_c;
                    else -- hold
                    end if;

                when PrSv_UdpTxFSR_c => -- Read_Tx_FSR
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxFSR2_c;
                    else -- hold
                    end if;

                when PrSv_UdpTxFSR2_c => -- Read_Tx_FSR2
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_UdpTxFstSend_c;
                    else -- hold
                    end if;

                when PrSv_UdpTxFstSend_c => -- First_Send
                    if (PrSl_UdpTxFstSendVld_s = '1') then
                        PrSv_RxTxState_s <= PrSv_UdpTxRdFifo_c;
                    else
                        PrSv_RxTxState_s <= PrSv_UdpCmpTxFSR_c;
                    end if;

                when PrSv_UdpCmpTxFSR_c => -- Compare_TxFSR_Blank
                    if (PrSv_RdS0TxSRCnt_s = x"F") then 
                         PrSv_RxTxState_s <= (others => '0');
                    elsif (PrSv_UdpTxFSRBlank_s >= Img_Package_Size) then -- Img_Package_Size
                        PrSv_RxTxState_s <= PrSv_UdpTxRdFifo_c;
                    else
                        PrSv_RxTxState_s <= PrSv_UdpTxFSR_c;
                    end if;

                when PrSv_UdpTxRdFifo_c => -- RdFifo_Start
                    PrSv_RxTxState_s <= PrSv_UdpTxRecvData_c;
                
                when PrSv_UdpTxRecvData_c => -- Recv Fifo Data
                    if (CpSl_NetDataVld_i = '1') then
                        PrSv_RxTxState_s <= PrSv_UdpTxFifo_c;
                    else -- hold
                    end if;
                
                when PrSv_UdpTxFifo_c => -- Wr_W5300_TxFifo_High16_bits
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_UdpTxFifo2_c;
                    else -- hold
                    end if;

                when PrSv_UdpTxFifo2_c => -- Wr_W5300_TxFifo_Low16_bits
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        if (PrSv_UdpTxFifoNum_s = PrSv_FifoDataNum_s) then 
                            PrSv_RxTxState_s <= PrSv_UdpTxPackageNum_c;
                        else
                            PrSv_RxTxState_s <= PrSv_UdpTxRdFifo_c;
                        end if;
                    else -- hold
                    end if;

                when PrSv_UdpTxPackageNum_c => -- PackageNum "UDP Data Num"
                    PrSv_RxTxState_s <= PrSv_UdpTxWRSR_c;

                when PrSv_UdpTxWRSR_c => -- Wr_WRSR
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxWRSR2_c;
                    else -- hold
                    end if;

                when PrSv_UdpTxWRSR2_c => -- Wr_WRSR2
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_UdpTxS0CRSend_c;
                    else -- hold
                    end if;

                when PrSv_UdpTxS0CRSend_c => -- Wr_S0_CR_Send 
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxRdS0IR_c;
                    else -- hold
                    end if; 

                when PrSv_UdpTxRdS0IR_c => -- Rd_S0IR
                    if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then
                        PrSv_RxTxState_s <= PrSv_UdpTxClrS0IR_c;
                    else -- hold
                    end if;
                when PrSv_UdpTxClrS0IR_c => -- Wr_Clear_S0IR
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxSendOk_c;
                    else -- hold
                    end if; 
                
                when PrSv_UdpTxSendOk_c => -- Compare S0_SendOk
--                    if (PrSv_UdpTx_RdS0IR_s(4) = '1') then
                    if (PrSv_UdpTx_RdS0IR_s(4) = '1' or PrSv_UdpTx_RdS0IR_s(3) = '0') then
                        PrSv_RxTxState_s <= PrSv_UdpTxPackageCnt_c;
                    else
                        PrSv_RxTxState_s <= PrSv_UdpTxRdS0IR_c;
                    end if;

                when PrSv_UdpTxPackageCnt_c => -- 1_Frame
                    PrSv_RxTxState_s <= PrSv_UdpTxPackageEnd_c;

                when PrSv_UdpTxPackageEnd_c => -- Package_End
                    if (PrSv_UdpTxPkgCnt_s = PrSv_UdpTxPkgCnt_c) then
                        PrSv_RxTxState_s <= PrSv_UdpTxStopTrig_c;
                    else
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
                    end if; 
                    
                when PrSv_UdpTxStopTrig_c => -- StopTrig
                    if (CpSl_UdpTxStopTrig_i = '1') then
                        PrSv_RxTxState_s <= PrSv_UdpTxS0SendClose_c;
                    else
                        PrSv_RxTxState_s <= PrSv_TcpRxS1SSR_c;
                    end if; 

                when PrSv_UdpTxS0SendClose_c => -- Wr_S0SendClose
                    if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                        PrSv_RxTxState_s <= PrSv_UdpTxStop_c;
                    else -- hold
                    end if; 
                
                when PrSv_UdpTxStop_c => -- Stop
                    PrSv_RxTxState_s <= (others => '0');
                
                when others => PrSv_RxTxState_s <= (others => '0');            
                end case;
            end if;
        end if;
    end process;


	 
    -- s1_discon_done
    process (nrst,clk) begin
        if (nrst = '0') then
            s1_discon_done <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxS1discon_c) then 
                s1_discon_done <= '1';
            elsif (PrSv_RxTxState_s = PrSv_TcpRxS1TCP_c and 
				      (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_INIT_c or
				       PrSv_SocketS1_SSRData_s = PrSv_S1SSR_ESTABLISHED_c)) then
                s1_discon_done <= '0';
            else
            end if;
        end if;
    end process;					
	 

    -- s1_close_done
    process (nrst,clk) begin
        if (nrst = '0') then
            s1_close_done <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxS1Close_c) then 
                s1_close_done <= '1';
            elsif (PrSv_RxTxState_s = PrSv_TcpRxS1TCP_c and 
				      (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_INIT_c or
				       PrSv_SocketS1_SSRData_s = PrSv_S1SSR_ESTABLISHED_c)) then
                s1_close_done <= '0';
            else
            end if;
        end if;
    end process;					
	 
    -- s1_open_done
    process (nrst,clk) begin
        if (nrst = '0') then
            s1_open_done <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxS1CR_OPEN_c) then 
                s1_open_done <= '1';
            elsif (PrSv_RxTxState_s = PrSv_TcpRxS1TCP_c and 
				      (PrSv_SocketS1_SSRData_s = PrSv_S1SSR_INIT_c or
				       PrSv_SocketS1_SSRData_s = PrSv_S1SSR_ESTABLISHED_c)) then
                s1_open_done <= '0';
            else
            end if;
        end if;
    end process;								
								
				
  	 ------------------------------------
    -- Test Area
    ------------------------------------
    -- PrSv_RdS0SSRCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_RdS0SSRCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_SocketState_s = PrSv_SocketStateIdle_c) then 
                PrSv_RdS0SSRCnt_s <= (others => '0');
            elsif (PrSv_SocketState_s = PrSv_SocketStateS0SSR_c and PrSv_SocketRdCnt_s = PrSv_CapRdData_c) then
                PrSv_RdS0SSRCnt_s <= PrSv_RdS0SSRCnt_s + '1';
            else
            end if;
        end if;
    end process;
	 
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_RdS1SSRCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_SocketState_s = PrSv_SocketStateS1MR_c) then 
                PrSv_RdS1SSRCnt_s <= (others => '0');
            elsif (PrSv_SocketState_s = PrSv_SocketStateS1SSR_c and PrSv_SocketRdCnt_s = PrSv_CapRdData_c) then
                PrSv_RdS1SSRCnt_s <= PrSv_RdS1SSRCnt_s + '1';
            else
            end if;
        end if;
    end process;
    
    -- PrSv_RdS0TxSRCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_RdS0TxSRCnt_s <= (others => '0');
        elsif rising_edge(clk) then            
            if (PrSv_RxTxState_s = PrSv_UdpTxStart_c) then 
                PrSv_RdS0TxSRCnt_s <= (others => '0');
            elsif (PrSv_RxTxState_s = PrSv_UdpTxFSR_c and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then
                PrSv_RdS0TxSRCnt_s <= PrSv_RdS0TxSRCnt_s + '1';
            elsif (PrSv_RxTxState_s = PrSv_UdpTxRdFifo_c) then 
                PrSv_RdS0TxSRCnt_s <= (others => '0');
            else
            end if;
        end if;
    end process;

    -- PrSl_W5300Init_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSl_W5300Init_s <= '0';
        elsif rising_edge(clk) then
            if (PrSv_SocketState_s = PrSv_SocketStateS0UDP_c and PrSv_RdS0SSRCnt_s = x"F") then
                PrSl_W5300Init_s <= '1';
            elsif (PrSv_RxTxState_s = PrSv_UdpCmpTxFSR_c and PrSv_RdS0TxSRCnt_s = x"F") then
                PrSl_W5300Init_s <= '1';
            else
                PrSl_W5300Init_s <= '0';
            end if;
        end if;
    end process;
    -- CpSl_W5300Init_o
    CpSl_W5300Init_o <= PrSl_W5300Init_s;
        
    ------------------------------------
    -- Coding
    ------------------------------------
    -- CpSl_NetStartTrig_o
    process (nrst,clk) begin
        if (nrst = '0') then
            CpSl_NetStartTrig_o <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_UdpTxS0DIPR2_c) then 
--            if (PrSv_RxTxState_s = PrSv_UdpTxFstSend_c) then
                CpSl_NetStartTrig_o <= '1';
            else
                CpSl_NetStartTrig_o <= '0';
            end if;
        end if;
    end process;
    
    -- PrSl_UdpTxFstSendVld_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSl_UdpTxFstSendVld_s <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_UdpTxStart_c) then
                PrSl_UdpTxFstSendVld_s <= '1';
            elsif (PrSv_RxTxState_s = PrSv_UdpTxRdFifo_c) then
                PrSl_UdpTxFstSendVld_s <= '0';
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_TxWaitTime_s
    process (nrst,clk) begin 
        if (nrst = '0') then 
            PrSv_TxWaitTime_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_UdpTxWait_c) then
                PrSv_TxWaitTime_s <= PrSv_TxWaitTime_s + '1';
            else
                PrSv_TxWaitTime_s <= (others => '0');
            end if;
        end if;
    end process;

    PrSl_RxTxWrVld_s <= '1' when (PrSv_RxTxState_s = PrSv_TcpRxS1CR_OPEN_c or
	                               PrSv_RxTxState_s = PrSv_TcpRxS1CR_LISTEN_c or
	                               PrSv_RxTxState_s = PrSv_TcpRxS1CRRecv_c or
	                               PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr_c or
	                               PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr2_c or
	                               PrSv_RxTxState_s = PrSv_TcpTxS1Wfifor_c or
	                               PrSv_RxTxState_s = PrSv_TcpS1CRSend_c or
	                               PrSv_RxTxState_s = PrSv_TcpRxS1Close_c or
											 PrSv_RxTxState_s = PrSv_TcpRxS1discon_c or
											 
	                               PrSv_RxTxState_s = PrSv_UdpTxS0DHAR_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxS0DIPR2_c or
											 PrSv_RxTxState_s = PrSv_UdpTxS0DHAR2_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxS0DHAR4_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxS0DPortR_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxS0DIPR_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxFifo_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxFifo2_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxWRSR_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxWRSR2_c or  
	                               PrSv_RxTxState_s = PrSv_UdpTxS0CRSend_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxClrS0IR_c or
	                               PrSv_RxTxState_s = PrSv_UdpTxS0SendClose_c) else '0';

    -- PrSv_RxTxWrCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_RxTxWrCnt_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (PrSl_RxTxWrVld_s = '1') then 
                if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then 
                    PrSv_RxTxWrCnt_s <= (others => '0');
                else
                    PrSv_RxTxWrCnt_s <= PrSv_RxTxWrCnt_s + '1';
                end if;
            else
                PrSv_RxTxWrCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- CpSl_NetRd_o
    process (nrst,clk) begin
        if (nrst = '0') then
            CpSl_NetRd_o <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_RxTxState_s = PrSv_UdpTxRdFifo_c) then 
                CpSl_NetRd_o <= '1';
            else 
                CpSl_NetRd_o <= '0';
            end if;
        end if;
    end process;

    -- CpSl_W5300InitSucc_o
    process (nrst,clk) begin 
        if (nrst = '0') then
            CpSl_W5300InitSucc_o <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_RxTxState_s = PrSv_RxTxIdle_c) then 
                CpSl_W5300InitSucc_o <= '0';
            elsif (PrSv_RxTxState_s = PrSv_TcpRxS1SSR_c) then
                CpSl_W5300InitSucc_o <= '1';
            else -- hold
            end if;
        end if;
    end process;

    -- send_done
    process (nrst,clk) begin
        if (nrst = '0') then
            send_done <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_RxTxState_s = PrSv_UdpTxStopTrig_c) then 
                send_done <= '1';
            else 
                send_done <= '0';
            end if;
        end if;
    end process;
    
    -- PrSv_UdpTxFifoNum_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_UdpTxFifoNum_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_UdpTxStart_c) then 
                PrSv_UdpTxFifoNum_s <= (others => '0');
            elsif (PrSv_RxTxState_s = PrSv_UdpTxRdFifo_c) then
                PrSv_UdpTxFifoNum_s <= PrSv_UdpTxFifoNum_s + '1';
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_UdpTxPkgCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_UdpTxPkgCnt_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (PrSv_RxTxState_s = PrSv_UdpTxPackageCnt_c) then
                PrSv_UdpTxPkgCnt_s <= PrSv_UdpTxPkgCnt_s + '1';
            elsif (PrSv_RxTxState_s = PrSv_UdpTxStopTrig_c) then 
                PrSv_UdpTxPkgCnt_s <= (others => '0');
            else -- hold
            end if;
        end if;
    end process;

    ------------------------------------
    -- UDP Rx State 
    ------------------------------------
    -- 接收重新开始的控制命令


    Real_Trig : if (PrSl_Sim_c = 1) generate
    -- CpSl_HeadVld_o
    process (nrst,clk) begin 
        if (nrst = '0') then
            CpSl_HeadVld_o <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c) then
                if (PrSv_TcpRxDataCnt_s = 1 and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then
                    CpSl_HeadVld_o <= '1';
                else
                    CpSl_HeadVld_o <= '0';
                end if;
            else
                CpSl_HeadVld_o <= '0';
            end if;
        end if;
    end process;

    -- CpSv_HeadData_o
    process (nrst,clk) begin 
        if (nrst = '0') then
            CpSv_HeadData_o <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c) then
                if (PrSv_TcpRxDataCnt_s = 1 and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then
                    CpSv_HeadData_o <= CpSv_W5300RdData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_W5300WaitTime_s
    PrSv_W5300WaitTime_s <= PrSv_wait15ms_c;
    
    end generate Real_Trig;
	 
	 PrSl_RxTxRdVld_s <= '1' when (PrSv_RxTxState_s = PrSv_TcpRxS1SSR_c or
	                                PrSv_RxTxState_s = PrSv_TcpRxS1RxRSR_c  or
	                                PrSv_RxTxState_s = PrSv_TcpRxS1RxRSR2_c or
											  PrSv_RxTxState_s = PrSv_TcpRxHeadCnt_c or
											  PrSv_RxTxState_s = PrSv_TcpRxData_c or

											  PrSv_RxTxState_s = PrSv_UdpTxFSR_c or
											  PrSv_RxTxState_s = PrSv_UdpTxFSR2_c or
											  PrSv_RxTxState_s = PrSv_UdpTxRdS0IR_c) else '0';
											  
											  

    -- PrSv_RxTxRdCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_RxTxRdCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSl_RxTxRdVld_s = '1') then
                if (PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then
                    PrSv_RxTxRdCnt_s <= (others => '0');
                else
                    PrSv_RxTxRdCnt_s <= PrSv_RxTxRdCnt_s + '1';
                end if;
            else
                PrSv_RxTxRdCnt_s <= (others => '0');
            end if;
        end if;
    end process;

--    Real_UdpRxCmpCmd : if (PrSl_Sim_c = 1) generate
    -- PrSv_TcpRxRSRCnt_s
    process (nrst,clk) begin 
        if (nrst = '0') then
            PrSv_TcpRxRSRCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxS1RxRSR_c) then 
                if (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then
                    PrSv_TcpRxRSRCnt_s(16) <= CpSv_W5300RdData_s(0);
                else -- hold
                end if;
            elsif (PrSv_RxTxState_s = PrSv_TcpRxS1RxRSR2_c) then
                if (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then
                    PrSv_TcpRxRSRCnt_s(15 downto 0) <= CpSv_W5300RdData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;
--    end generate Real_UdpRxCmpCmd;
    
--    sim_UdpRxCmpCmd : if (PrSl_Sim_c = 0) generate
--        PrSv_TcpRxRSRCnt_s <= '0'&x"0101";
--    end generate sim_UdpRxCmpCmd;
    
    -- PrSv_TcpRxFifoData_s
    process (nrst,clk) begin 
        if (nrst = '0') then
            PrSv_TcpRxFifoData_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxHeadCnt_c or PrSv_RxTxState_s = PrSv_TcpRxData_c) then 
                if (PrSl_RxTxRdVld_s = '1' and PrSv_RxTxRdCnt_s = PrSv_CapRdData_c) then
                    PrSv_TcpRxFifoData_s <= CpSv_W5300RdData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_TcpRxHeadData_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_TcpRxHeadData_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxHeadCnt_c and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then -- PrSv_CapRdData_c
                PrSv_TcpRxHeadData_s <= PrSv_TcpRxFifoData_s;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_TcpRxPackSize_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_TcpRxPackSize_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxHeadData_c) then
                PrSv_TcpRxPackSize_s <= ('0' & PrSv_TcpRxHeadData_s(15 downto 1)) + PrSv_TcpRxHeadData_s(0); -- if PrSv_TcpRxHeadData_s is odd , packsize = PrSv_TcpRxHeadData_s + 1,else packsize = PrSv_TcpRxHeadData_s
            else -- hold
            end if;
        end if;
    end process;
    
--    Sim_UPDSize : if (PrSl_Sim_c = 0) generate
--        PrSv_TcpRxPackSize_s <= "0000"&x"003";
--    end generate Sim_UPDSize;

    -- PrSv_TcpRxDataCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_TcpRxDataCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c) then 
                if (PrSv_RxTxRdCnt_s = 0) then
                    PrSv_TcpRxDataCnt_s <= PrSv_TcpRxDataCnt_s + '1';
                else -- hold
                end if;
            else
                PrSv_TcpRxDataCnt_s <= (others => '0');
            end if;
        end if;
    end process;

	 -- PrSv_TcpRxDataCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_TcpRxFstData_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_TcpRxDataCnt_s = 1 and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                case(PrSv_TcpRxFifoData_s(15 downto 8)) is
					     when x"90" =>  PrSv_TcpRxFstData_s <= x"210A";  -- asc code: ! -n
					     when x"AA" =>  PrSv_TcpRxFstData_s <= x"310A";  -- asc code: 1 -n
					     when x"BA" =>  PrSv_TcpRxFstData_s <= x"410A";  -- asc code: A -n
					     when x"BB" =>  PrSv_TcpRxFstData_s <= x"420A";  -- asc code: A -n
					     when x"BC" =>  PrSv_TcpRxFstData_s <= x"430A";  -- asc code: A -n
					     when others => PrSv_TcpRxFstData_s <= (others => '0');
                end case;
				end if;
        end if;
    end process;	     

	 -- rd_flash_en
    process (nrst,clk) begin
        if (nrst = '0') then
            rd_flash_en <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_TcpRxDataCnt_s = 1 and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                if(PrSv_TcpRxFifoData_s(15 downto 8) = x"BC") then
                    rd_flash_en <= '1';
					 else 
						  rd_flash_en <= '0';
					 end if;
				end if;
        end if;
    end process;	     

    process (nrst,clk) begin
        if (nrst = '0') then
            rw_flash_frame_done_r <= "00";
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr_c) then 
                rw_flash_frame_done_r <= "00";
				elsif(rw_flash_frame_done_i(1) = '1') then	
			       rw_flash_frame_done_r <= rw_flash_frame_done_i;	
				end if;
        end if;
    end process;	     

    process (nrst,clk) begin
        if (nrst = '0') then
            train_cmd_done_r <= "00";
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpTxS1wWrsr_c) then 
                train_cmd_done_r <= "00";
				elsif(train_cmd_done_i(1) = '1') then	
			       train_cmd_done_r <= train_cmd_done_i;	
				end if;
        end if;
    end process;	     
	 
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_Tcp_Ack_wsrs_s <= (others => '0');
        elsif rising_edge(clk) then
            if ((rw_flash_frame_done_i(1) = '1' or train_cmd_done_i(1) = '1') and rd_flash_en = '1') then 
                PrSv_Tcp_Ack_wsrs_s <= x"000000" & x"24";
				elsif ((rw_flash_frame_done_i(1) = '1' or train_cmd_done_i(1) = '1') and rd_flash_en = '0') then 
					 PrSv_Tcp_Ack_wsrs_s <= PrSv_Tcp_Ack_wsrs_c;
				end if;
        end if;
    end process;	     

	 -- PrSv_TcpframeCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_TcpframeCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_TcpRxDataCnt_s = PrSv_TcpRxPackSize_s and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                PrSv_TcpframeCnt_s <= PrSv_TcpframeCnt_s + 1;
            else
            end if;
        end if;
    end process;

    -- PrSv_TcpTxDataCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_TcpTxDataCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpTxS1Wfifor_c) then 
                if (PrSv_RxTxWrCnt_s = PrSv_WrWaitCnt_c) then
                    PrSv_TcpTxDataCnt_s <= PrSv_TcpTxDataCnt_s + '1';
                else -- hold
                end if;
            else
                PrSv_TcpTxDataCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_TcpTxDataCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            cmd_status <= (others => '0');
        elsif rising_edge(clk) then
            if (rw_flash_frame_done_i(1) = '1') then 
                cmd_status <= rw_flash_frame_done_i;
            elsif (train_cmd_done_i(1) = '1') then
				    cmd_status <= train_cmd_done_i;
            end if;
        end if;
    end process;

	 PrSv_Tcp_Ack_Data_s <= PrSv_TcpframeCnt_s & "000000" & cmd_status & PrSv_TcpRxFstData_s;

    -- PrSv_Tcp_Tx_Data_s
    process (PrSv_RxTxState_s,PrSv_TcpTxDataCnt_s) begin
            if (PrSv_RxTxState_s = PrSv_TcpTxS1Wfifor_c and rd_flash_en = '0') then 
                case PrSv_TcpTxDataCnt_s is
                    when x"0000" => PrSv_Tcp_Tx_Data_s <= PrSv_Tcp_Ack_Data_s(15 downto 0);
                    when x"0001" => PrSv_Tcp_Tx_Data_s <= PrSv_Tcp_Ack_Data_s(31 downto 16);
                    when others  => PrSv_Tcp_Tx_Data_s <= (others => '0');
                end case;
            elsif (PrSv_RxTxState_s = PrSv_TcpTxS1Wfifor_c and rd_flash_en = '1') then 
                case PrSv_TcpTxDataCnt_s is
                    when x"0000" => PrSv_Tcp_Tx_Data_s <= PrSv_Tcp_Ack_Data_s(15 downto 0);
                    when x"0001" => PrSv_Tcp_Tx_Data_s <= PrSv_Tcp_Ack_Data_s(31 downto 16);
                    when x"0002" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(255 downto 240);
                    when x"0003" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(239 downto 224);
                    when x"0004" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(223 downto 208);
                    when x"0005" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(207 downto 192);
                    when x"0006" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(191 downto 176);
                    when x"0007" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(175 downto 160);
                    when x"0008" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(159 downto 144);
                    when x"0009" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(143 downto 128);
                    when x"000a" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(127 downto 112);
                    when x"000b" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i(111 downto  96);
                    when x"000c" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i( 95 downto  80);
                    when x"000d" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i( 79 downto  64);
                    when x"000e" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i( 63 downto  48);
                    when x"000f" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i( 47 downto  32);
                    when x"0010" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i( 31 downto  16);
                    when x"0011" => PrSv_Tcp_Tx_Data_s <= rd_ufm_data_i( 15 downto   0);
                    when others  => PrSv_Tcp_Tx_Data_s <= (others => '0');
                end case;
				else
                PrSv_Tcp_Tx_Data_s <= (others => '0');
            end if;
    end process;    
	 
    process (nrst,clk) begin
        if (nrst = '0') then
            frame_nofst_rcv <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxHeadData_c) then 
                frame_nofst_rcv <= '0';
            elsif(PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then
                frame_nofst_rcv <= '1';
            end if;
        end if;
    end process;
	 
    process (nrst,clk) begin
        if (nrst = '0') then
            frame_fst_rcv <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c and frame_nofst_rcv = '0') then 
                frame_fst_rcv <= '1';
            else 
                frame_fst_rcv <= '0';
            end if;
        end if;
    end process;
	 
    process (nrst,clk) begin
        if (nrst = '0') then
            rcv <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                rcv <= '1';
            else 
                rcv <= '0';
            end if;
        end if;
    end process;
    
    -- rcv_data
    process (nrst,clk) begin
        if (nrst = '0') then
            rcv_data <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxData_c and PrSv_RxTxRdCnt_s = PrSv_RdWaitCnt_c) then 
                rcv_data <= CpSv_W5300RdData_s;
            else -- hold
            end if;  
        end if;
    end process;
    
    -- rcv_data_len
    process (nrst,clk) begin
        if (nrst = '0') then
            rcv_data_len <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RxTxState_s = PrSv_TcpRxHeadData_c) then 
                rcv_data_len <= PrSv_TcpRxHeadData_s;
            else -- hold
            end if;  
        end if;
    end process;


----------------------------------------
-- End
----------------------------------------
end arch_M_W5300Ctrl;