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
    -- 文件名称  :  M_Top.vhd
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
    use ieee.std_logic_arith.all;

    -- library Xilinx
    --library unisim;
    --use unisim.vcomponents.all;

    -- library Altera
    --library altera_mf;
    --use altera_mf.all;

    entity M_Top is
        generic (
            PrSl_Sim_c                      : integer := 1;                         -- Simulation
            PrSl_DebugApd_c                 : integer := 1;                         -- Normal_APD
    --        PrSl_DebugApd_c                 : integer := 0;                         -- Debug_APD
    --        PrSl_SimTdcData_c               : std_logic := '0';    
            PrSl_SimTdcData_c               : std_logic := '1';  
            PrSv_PointCnt_c                 : std_logic_vector(7 downto 0) := x"04" -- 4
        );
        port (
            CLK_40MHz_IN                    : in    std_logic;	                    -- single clock,40MHz 
            LVRESETN                        : in    std_logic;	                    -- active low 
            
            --------------------------------
            -- Laser Driver Related Signals
            --------------------------------
            F_CapTrig                       : out   std_logic;                      -- ADLink Capture Trig
            F_START1                        : out   std_logic;
            F_START2                        : out   std_logic;
            F_START3                        : out   std_logic;
            F_GAINRST                       : out   std_logic;                      -- Control Gain
            F_RPI                           : out   std_logic;                      -- No Used

            --------------------------------
            -- AD5447 Interface
            --------------------------------
            F_DA                            : out   std_logic_vector(11 downto 0);  -- DA5447_Data
            F_DWR                           : out   std_logic;
            F_DCSAB                         : out   std_logic;                      -- X/Y Channel
            F_DCS1                          : out   std_logic;                      -- X/Y CS1
            F_DCSC                          : out   std_logic;                      -- Gain/9601Level Channel
            F_DCS2                          : out   std_logic;                      -- Gain/9601Level CS2
            
            --------------------------------
            -- I2C Interface
            -------------------------------- 
            F_SDA                           : inout std_logic;
            F_SCL                           : out   std_logic;
            
            --------------------------------
            -- GPS & PPS
            --------------------------------
            F_PPS                           : in    std_logic;                      -- GPS_PPS
            F_GPS_UART_RX                   : in    std_logic;                      -- GPS_Rx_Data
                    
            --------------------------------
            -- LTC2324_Interface
            --------------------------------
            F_CNV                           : out std_logic;
            F_SDR_DDR0                      : out std_logic;
            F_SCK_1                         : out std_logic;
            F_SD0_1                         : in  std_logic;
            F_SD1_1                         : in  std_logic;
            F_SD2_1                         : in  std_logic;
            F_SD3_1                         : in  std_logic;
            F_AD_CLKOUT_1                   : in  std_logic;  
            
            --------------------------------
            -- TDC_GPX2_Interface
            --------------------------------
            -- TDC_0
            F_FRAME1_P                      :  in  std_logic;
            F_SD1_P                         :  in  std_logic;
            F_FRAME2_P                      :  in  std_logic;
            F_SD2_P                         :  in  std_logic;
            F_FRAME3_P                      :  in  std_logic;
            F_SD3_P                         :  in  std_logic;
            F_FRAME4_P                      :  in  std_logic;
            F_SD4_P                         :  in  std_logic;
            F_LCLK_OUT_P                    :  in  std_logic;                       -- TDC_LClk_Input
            F_LCLK_IN_P                     :  out std_logic;                       -- TDC_LClk_Output
            F_DISABLE_P                     :  out std_logic;                       -- TDC_Enable
            F_REFCLK_P                      :  out std_logic;                       -- 5MHz
            F_RSTIDX_P                      :  out std_logic;                       -- Reset_Index
            F_PARITY                        :  in std_logic;
            F_INTERRUPT                     :  in  std_logic;                       -- Interrupt
            F_SSN                           :  out std_logic;
            F_SCK                           :  out std_logic;
            F_MOSI                          :  out std_logic;
            F_MISO                          :  in  std_logic;
    --        F_HV_ENABLE                     :  out std_logic;
            F_SHDN                          :  out std_logic;
            
            --------------------------------
            -- TDC_1
            --------------------------------
            F_FRAME5_P                      :  in  std_logic;                       -- TDC_STOP5
            F_SD5_P                         :  in  std_logic;                       -- TDC_SDO5
            F_FRAME6_P                      :  in  std_logic;                       -- TDC_STOP6
            F_SD6_P                         :  in  std_logic;                       -- TDC_SDO6
            F_FRAME7_P                      :  in  std_logic;                       -- TDC_STOP7
            F_SD7_P                         :  in  std_logic;                       -- TDC_SDO7
            F_FRAME8_P                      :  in  std_logic;                       -- TDC_STOP8
            F_SD8_P                         :  in  std_logic;                       -- TDC_SDO8
            F_LCLK_OUT_1P                   :  in  std_logic;                       -- TDC_Clk_Out
            F_LCLK_IN_1P                    :  out std_logic;                       -- TDC_Ckk_In
            -- F_DISABLE_1P&F_DISABLE_P in using
            --F_DISABLE_1P                    :  out std_logic;                       -- TDC_Disable
            F_REFCLK_1P                     :  out std_logic;                       -- TDC_RefClk
            F_RSTIDX_1P                     :  out std_logic;                       -- TDC_RSTIDX
            
    --        F_PARITY_1                      :  in  std_logic;                       -- TDC_Parity
    --        F_INTERRUPT_1                   :  in  std_logic;                       -- TDC_Interrupt
            F_SSN_1                         :  out std_logic;                       -- TDC_SSN_1
            F_SCK_T                         :  out std_logic;                       -- TDC_SCK_1
            F_MOSI_1                        :  out std_logic;                       -- TDC_MOSI_1
            F_MISO_1                        :  in  std_logic;                       -- TDC_MISO_1
    		  
            --------------------------------
            -- Test_IF
            --------------------------------
    --        F_Test_o						 		 : out  std_logic_vector(12 downto 0);   -- Test_IO
            CpSv_Addr_o                     : out  std_logic_vector(10 downto 0);   -- Test_IO
    		  
            --------------------------------
            -- W5300 Interface
            --------------------------------
            F_ETH_D                         : inout std_logic_vector(15 downto 0);
            F_ETH_A                         : out   std_logic_vector( 9 downto 1);
            F_ETH_WRN                       : out   std_logic;
            F_ETH_OEN                       : out   std_logic;
            F_ETH_CSN                       : out   std_logic;
            F_ETH_RSTN                      : out   std_logic;
            F_ETH_INT                       : in    std_logic
        );
    end M_Top;

architecture arch_M_Top of M_Top is
    ------------------------------------
    -- Component Describe
    ------------------------------------
    component counter_shdn is
    port(
        clk                             :   in std_logic;	-- 40MHz 
        clk_1ms_tick                    :   in std_logic;
        nrst                            :   in std_logic;
        shdn                            :  out std_logic
    );
    end component;
    
    -- Clock    
    component M_Clock is
    port (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
        sft_rst_fpga_i                  : in  std_logic;
        
	-------------------------------- 
        -- Clock&Lock
        --------------------------------
        CpSl_Clk200M_o                  : out std_logic;                        -- Clock 200MHz
        CpSl_Clk80M_o                   : out std_logic;                        -- Clock 80MHz
        CpSl_Clk40M_o                   : out std_logic;                        -- Clock 40MHz
--        CpSl_Clk5M_o                    : out std_logic;                        -- Clock 5MHz
        CpSl_ClkLocked_o                : out std_logic                         -- Clock Locked
    );
    end component;

        component M_TrigCtrl is
        generic (
            PrSl_DebugApd_c                 : integer := 1                          -- Debug_APD
        );
        port (
            -------------------------------- 
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- active,low
            CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
            
            --------------------------------
            -- Start/Stop Trig
            --------------------------------
            CpSl_StartTrig_i                : in  std_logic;                        -- Start Trig
            CpSl_StopTrig_i                 : in  std_logic;                        -- Stop Trig
            CpSv_PointStyle_i               : in  std_logic_vector(1 downto 0);     -- Point Number Style
            CpSl_NetStopTrig_o              : out std_logic;                        -- Net Stop Trig(memscan as Trig????????)
            -------------------------------- 
            -- TDC_RefClk
            --------------------------------
            CpSl_Clk5M_o                    : out std_logic;                        -- 5MHz
            CpSl_1usTrig_o                  : out std_logic;                        -- ius
            
            --------------------------------
            -- Start1/Start2/RPI Trig
            --------------------------------
            start1_close_en_i               : in  std_logic;    -- start1 close enable
            start2_close_en_i               : in  std_logic;    -- start2 close enable
            start3_close_en_i               : in  std_logic;    -- start3 close enable
            CpSl_CapTrig_o                  : out std_logic;                        -- ADLink Capture Trig
            CpSl_Start1_o                   : out std_logic;                        -- Start1 Trig
            CpSl_Start2_o                   : out std_logic;                        -- Start2 Trig
            CpSl_Start3_o                   : out std_logic;                        -- Start3 Trig
            CpSl_LadarTrig_o                : out std_logic;                        -- Ladar Start Trig
            CpSl_Rpi_o                      : out std_logic;                        -- PRI
            CpSl_GainRst_o                  : out std_logic;                        -- Gain Control
            
            --------------------------------
            -- Apd/LD_Num
            -- TDC_CapEnd
            --------------------------------
            CpSl_apd_slt_en_o               : out std_logic;                        -- APD_Enable
            ld_num_o                        : out std_logic_vector(1 downto 0);     -- LD_Num
            CpSl_TdcLdnum_o                 : out std_logic_vector(1 downto 0);     -- Ctrl_Tdc_LD_Num
            CpSl_TdcCapEnd_o                : out std_logic;                        -- TdcCapEnd_Trig
            CpSl_ApdVld_o                   : out std_logic;                        -- APD_Valid
            CpSl_MemXYVld_i                 : in  std_logic;
            
            --------------------------------
            -- TDC_RstId/Disable
            --------------------------------
            CpSl_TdcDisable_o               : out std_logic;                        -- TDC_GPX2_Disable
            CpSl_RstId_o                    : out std_logic;                        -- TDC_RstId
            CpSl_RstId1_o                   : out std_logic;                        -- TDC_RstId1

        -------------------------------- 
        -- Begin Trig
        --------------------------------
        CpSl_UdpCycleEnd_o              : out std_logic;                        -- UDP Cycle End
        CpSl_Ltc2324Trig_o              : out std_logic;                        -- ADC Start Trig
        CpSl_Ltc2324EndTrig_i           : in  std_logic;                        -- ADC End Trig
        CpSl_FrameEndTrig_i             : in  std_logic;                        -- Frame End Trig
        CpSl_MemoryRdTrig_o             : out std_logic;                        -- Memory start Trig
        CpSl_MemoryAddTrig_o            : out std_logic                         -- Memory Add Trig 
    );
    end component;
    
    component M_RomCtrl is
    generic (
        PrSl_Sim_c                      : integer := 1                          -- Simulation
    );
    port (
        --------------------------------
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
        
        test_mode_i                     : in  std_logic; 
		  CpSv_vxData_i                   : in  std_logic_vector(11 downto 0);         
        CpSv_vyData_i                   : in  std_logic_vector(11 downto 0);         
		  CpSv_Mems_noscan_i              : in  std_logic; 
        --------------------------------
        -- Rom Start Trig
        --------------------------------
        CpSl_FrameEndTrig_o             : out std_logic;                        -- Frame End Trig
        CpSl_MemoryAddTrig_i            : in  std_logic;                        -- Memory Add Trig     
        CpSl_MemoryRdTrig_i             : in  std_logic;                        -- Memory start Trig
        
		send_trig_point_num_i           : in  std_logic_vector(15 downto 0);
		send_trig_close_i               : in  std_logic;
		CpSl_CapTrig_o                  : out std_logic;
        
		  --------------------------------
        -- Head/Ench Number/LdNum
        --------------------------------
        CpSv_EochCnt_i                  : in  std_logic_vector( 1 downto 0);    -- Ench Cnt
        CpSl_UdpTest_i                  : in  std_logic;                        -- UDP Test Module
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);     -- LD_Num
        
        --------------------------------
        -- TrigCycle
        --------------------------------
        CpSl_UdpCycleEnd_i              : in  std_logic;                        -- UDP Cycle End
        
        --------------------------------
        -- LTC2324 Data
        --------------------------------
        CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Valid
        CpSv_MemxData_i                 : in  std_logic_vector(15 downto 0);    -- Mem x Data 
        CpSv_MemyData_i                 : in  std_logic_vector(15 downto 0);    -- Mem Y Data
        CpSv_MemTemp_i                  : in  std_logic_vector(15 downto 0);    -- Mem Temp
        
        --------------------------------
        -- TDC_GPX2 Data
        --------------------------------
        -- TDC_Wave/Gray
        CpSl_EchoDVld_i                 : in  std_logic;                        -- TDC_Data_Valid    
        CpSv_EchoWave_i                 : in  std_logic_vector(18 downto 0);    -- TDC_Data_Wave     
        CpSv_EchoGray_i                 : in  std_logic_vector(15 downto 0);    -- TDC_Data_Gray  
        
		  PrSv_EchoPW20_i                 : in  std_logic_vector(18 downto 0);
		  
        CpSl_ApdNumVld_i                : in  std_logic;                        -- ADP_NumVld
        CpSv_ApdNum_i                   : in  std_logic_vector( 6 downto 0);    -- ADP_Num   
        
		  --------------------------------
        -- Group_Rd
        --------------------------------
        CpSl_GroupRd_i                  : in  std_logic;                        -- Group_Rd
        CpSl_GroupRdData_o              : out std_logic_vector(13 downto 0);    -- Group_RdData
		  
		  -- TDC_Debug
        CpSl_TdcDataVld_i               : in  std_logic;                        -- TDC_Recv_Data Valid
        CpSv_TdcData_i                  : in  std_logic_vector(15 downto 0);    -- TDC Recv Data1
        CpSv_Tdc2Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data2
        CpSv_Tdc3Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data3
        CpSv_Tdc4Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data4
        CpSv_Tdc5Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data5
        CpSv_Tdc6Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data6
        CpSv_Tdc7Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data7
        CpSv_Tdc8Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data8
        
        --------------------------------                
        -- Test_MemX|Y
        --------------------------------
        CpSl_MemXYVld_o                 : out std_logic;                         -- Memxy_Valid
        
        --------------------------------
        -- MEMSCAN X/Y Data
        --------------------------------
        CpSl_MemTrig_o                  : out std_logic;                        -- Memscan Trig
        CpSv_MemXData_o                 : out std_logic_vector(11 downto 0);    -- Memscan_X Data       
        CpSv_MemYData_o                 : out std_logic_vector(11 downto 0);    -- Memscan_Y Data
            
        --------------------------------
        -- Fifo Interface
        --------------------------------
        CpSl_RdFifo_i                   : in  std_logic;                        -- Fifo Read
        CpSl_FifoDataVld_o              : out std_logic;                        -- Fifo Data Valid
        CpSv_FifoData_o                 : out std_logic_vector(31 downto 0);    -- Fifo Data
		  
		  --------------------------------
		  -- 5300ctrl
		  --------------------------------
        CpSv_pck_lenth_i                : in  std_logic_vector(15 downto 0);    -- CpSv_S0Tx_WrsR
		  CpSl_start_send_o               : out std_logic                    ;
		  
 	     wr_memx_ram_en_i                : in std_logic;
		  wr_memx_ram_data_i              : in std_logic_vector(31 downto 0);
		  wr_memx_ram_addr_i              : in std_logic_vector(18 downto 0);		  
 	     wr_memy_ram_en_i                : in std_logic;
		  wr_memy_ram_data_i              : in std_logic_vector(31 downto 0);
		  wr_memy_ram_addr_i              : in std_logic_vector(18 downto 0)

        );
        end component;
        
        component adc_ltc2324_16_controller is
        port(
            clk                             :   in std_logic;	 
            nrst                            :   in std_logic;
            start_tick                      :   in std_logic;
            sck_out                         :  out std_logic;
            sck_in                          :   in std_logic;
            sdi0                            :   in std_logic;
            sdi1                            :   in std_logic;
            sdi2                            :   in std_logic;
            sdi3                            :   in std_logic;
            end_tick                        :  out std_logic;
            
            CpSl_CapApdTrig_i               :  in  std_logic;
            CpSl_CapApdVld_o                :  out std_logic;
            ad_data0                        :  out std_logic_vector(15 downto 0);
            ad_data1                        :  out std_logic_vector(15 downto 0);
            ad_data2                        :  out std_logic_vector(15 downto 0);
            ad_data3                        :  out std_logic_vector(15 downto 0);
            covn                            :  out std_logic 
        );
        end component;
        
        component M_VolApd is
        generic (
            PrSl_Sim_c                      : integer := 1                          -- Simulation
        );
        port (
            -------------------------------- 
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- active,low
            CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
            
            --------------------------------
            -- ApdVol/Temper
            --------------------------------
            CpSl_CapApdTrig_o               : out std_logic;                        -- Cap_ApdTirg
            CpSl_CapApdVld_i                : in  std_logic;                        -- Apd_CapVolVld
            CpSv_CpdApdVol_i                : in  std_logic_vector(15 downto 0);    -- APd_CapVol
    
            CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Capture End
            CpSv_TemperData_i               : in  std_logic_vector(15 downto 0);    -- Temper Data
            
            --------------------------------
            -- from Flash
            --------------------------------
            wr_av_ram_en_i                  : in std_logic;
            wr_av_ram_data_i                : in std_logic_vector(31 downto 0);
            wr_av_ram_addr_i                : in std_logic_vector(18 downto 0);
            
            -- 16bit(Real_12bit) * 227
            wr_capav_ram_en_i               : in std_logic;
            wr_capav_ram_data_i             : in std_logic_vector(31 downto 0);
            wr_capav_ram_addr_i             : in std_logic_vector(18 downto 0);
            
            --------------------------------
            -- Voltage
            --------------------------------
            CpSl_WrTrig_o                   : out std_logic;                        -- Write_APDVol
            CpSl_VolDataTrig_o              : out std_logic;                        -- Voltaga Valid
            CpSv_VolData_o                  : out std_logic_vector(11 downto 0)     -- Voltage Data
        );
        end component;
            
        component M_apd_slt is
        generic (
            PrSl_Sim_c                      : integer := 1                           -- Simulation
        );
        port (
            --------------------------------
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- active,low
            Clk_40m_i                       : in  std_logic;                        -- single 40MHz.clock
            
            --------------------------------
            -- Rom Start Trig
            --------------------------------
            CpSl_ApdNumVld_o                : out std_logic;                        -- ADP_NumVld
            CpSv_ApdNum_o                   : out std_logic_vector(6 downto 0);     -- ADP_Num
            CpSl_apd_slt_en_i               : in  std_logic;                        -- Memory Add Trig
            ld_num_i                        : in  std_logic_vector(1 downto 0) ;		  
            CpSl_ApdVld_i                   : in  std_logic;                        -- Apd_Vld
            CpSv_Addr_o                     : out std_logic_vector(10 downto 0);    -- Test_IO
    		  
     	     wr_as_ram_en_i                  : in std_logic;
    		  wr_as_ram_data_i                : in std_logic_vector(31 downto 0);
    		  wr_as_ram_addr_i                : in std_logic_vector(18 downto 0)

        );
        end component;
            
        -- Gray AGC
        component M_VolAgc is
        generic (
            PrSl_Sim_c                      : integer := 1;                         -- Simulation
            PrSv_PointCnt_c                 : std_logic_vector(7 downto 0) := x"04" -- 4
        );
        port (
            -------------------------------- 
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- active,low
            CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
            
            --------------------------------
            -- Rom_Start_Trig
            --------------------------------
            CpSl_StartTrig_i                : in  std_logic;                        -- Config AD7547
            
            --------------------------------
            -- Temper
            --------------------------------
            CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Capture End
            CpSv_GrayData_i                 : in  std_logic_vector(15 downto 0);    -- Gray Data

            --------------------------------
            -- Voltage
            --------------------------------
            CpSv_Gain_o                     : out std_logic_vector(15 downto 0);    -- Real Gain      
            CpSl_ImageVld_o                 : out std_logic;                        -- Image Valid
            CpSl_FrameVld_o                 : out std_logic;                        -- Frame Valid
            CpSl_VolAgcTrig_o               : out std_logic;                        -- Voltaga Agc Valid
            CpSv_VolAgcData_o               : out std_logic_vector(11 downto 0)     -- Voltage Agc Data
        );
        end component;

        component da_controller_7547 is
        port (
            nrst                            : in  std_logic;
            clk                             : in  std_logic;
            da_mems_start_tick              : in  std_logic;
            agc_da_start_tick               : in  std_logic; 
            da_datax                        : in  std_logic_vector(11 downto 0);
            da_datay                        : in  std_logic_vector(11 downto 0);
            da_data_agc                     : in  std_logic_vector(11 downto 0);
            
            da_data                         : out std_logic_vector(11 downto 0);
            da_wr                           : out std_logic;
            da_sab                          : out std_logic;
            da_cs1                          : out std_logic;
            da_sc                           : out std_logic;
            da_cs2                          : out std_logic;
            da_finish                       : out std_logic
        );
        end component;

        -- W5300
        component M_W5300If is
        port (
        	 clk                            : in    std_logic;
        	 nrst                           : in    std_logic;
        	 inter_wr                       : in    std_logic;	
        	 inter_rd                       : in    std_logic;	
        	 inter_addr                     : in    std_logic_vector( 9 downto 0);	
        	 inter_data_in                  : in    std_logic_vector(15 downto 0);	 
        	 inter_data_out                 : out   std_logic_vector(15 downto 0);	
        	 nwr                            : out   std_logic;	
        	 nrd                            : out   std_logic;	
        	 ncs                            : out   std_logic;	
        	 addr                           : out   std_logic_vector( 9 downto 0);
        	 data                           : inout std_logic_vector(15 downto 0)
        );
        end component;
            
        component state_control_top is
        generic (
            PrSl_Sim_c                      : integer := 1                          -- Simulation
        );
        port (
            nrst                            : in  std_logic;
            clk                             : in  std_logic;
            clk_125k_tick                   : in  std_logic;
            clk_1ms_tick                    : in  std_logic;
            start_tick                      : in  std_logic;
            soft_reset_tick                 : in  std_logic;
            mem_dax                         : in  std_logic_vector(11 downto 0);
            mem_day                         : in  std_logic_vector(11 downto 0);
            mem_dastart                     : in  std_logic;
            laser_rpi_start_start           : out std_logic;
            pic_tdc_procedure_start         : out std_logic;
            w5300_nrst_ctrl                 : out std_logic;
            w5300_init_start                : out std_logic;
    --        w5300_init_finish               : in  std_logic;
            w5300_init_result               : in  std_logic;
            CpSl_W5300InitSucc_i            : in  std_logic;
    		  initial_done_i                  : in  std_logic;
            da_datax                        : out std_logic_vector(11 downto 0);
            da_datay                        : out std_logic_vector(11 downto 0);
            da_start                        : out std_logic;
            da_finish                       : in  std_logic 
        );
        end component;

        component v_filter_2 is
        generic(
            constant RESET_VALID            : std_logic := '0';		
            constant RESET_VALUE            : std_logic := '0';		
            constant SCALER_SIZE            : integer := 8;
            constant SYNC_COUNT             : integer := 2
        );
        port( 
            rst                             : in  std_logic;
            clk                             : in  std_logic;
            clk_filter                      : in  std_logic;
            scaler                          : in  std_logic_vector(SCALER_SIZE - 1 downto 0);
            signal_in                       : in  std_logic;
            signal_out                      : out std_logic
        );
        end component;

    component M_W5300Ctrl is
    generic (
        PrSl_Sim_c                      : integer := 1                           -- Simulation
    );
    port(
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
            CpSl_NetInitDone_o              : out std_logic;	                    -- NetInitDone
            CpSl_W5300Init_o                : out std_logic;	                    -- W5300 Init
            CpSl_W5300InitSucc_o            : out std_logic;                        -- W5300 Tx Send Data
            
    		  frame_fst_rcv                   : out std_logic;
            rcv                             : out std_logic;	                    -- 接收完成的tick 
            rcv_data                        : out std_logic_vector(15 downto 0);	-- 接收数据
            rcv_data_len                    : out std_logic_vector(15 downto 0);	-- 接收数据长度
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
        end component;	
    	
        component ctrlCycle_simple
        generic (
            constant  RstValidValue	        : std_logic:='0';	
            constant  DATAWIDTH	            : integer range 1 to 16 := 8;
            constant  RST_DIV	            : integer range 1 to 65535 := 9 --n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
        ); 
        port (
            nrst                            : in  std_logic;
            clk                             : in  std_logic;
            enable                          : in  std_logic;   	--	'1' is enable
            clk_tick                        : out std_logic
        );
        end component;
        
        component delay_nrst is
        generic (
            constant TIME_CNT               : integer := 4	-- 复位延迟时间长度
        );
        port (
            clk                             : in  std_logic;
            nrst                            : in  std_logic;
            nrst_ctrl                       : in  std_logic;	-- '0'有效 
            tick_cnt                        : in  std_logic;	-- 计时时钟 
            CpSl_W5300Init_i                : in  std_logic;	                    -- W5300 Init
            --------------------------------
            -- nrst与nrst_ctrl均无效
            -- d_nrst延迟[tick_cnt*(TIME_CNT-1)+clk,tick_cnt*TIME_CNT+2*clk]   
            --------------------------------
            d_nrst                          : out std_logic
        );
        end component;
    	 
        component M_Net_ds_ctrl is
        port (
            --------------------------------
            -- Reset and clock
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
            CpSl_Clk_i                      : in  std_logic;                        -- 40MHz Clock,single

            --------------------------------
            -- downstream Interface
            --------------------------------
    		  frame_fst_rcv_i                 : in  std_logic;
            PrSl_RxPalDvld_i                : in  std_logic;                        -- Parallel data valid
            PrSv_RxPalData_i                : in  std_logic_vector(15 downto 0);    -- Parallel data
            rcv_data_len_i                  : in  std_logic_vector(15 downto 0);    -- Parallel data length
            --------------------------------
            -- Parallel Time Indicator
            --------------------------------
            CpSl_WrTrig1_o                  : out std_logic;                        -- Wr_Trig1
            CpSl_WrTrig2_o                  : out std_logic;                        -- Wr_Trig2  
            vx_trig_o                       : out std_logic;                        -- Wr_Trig2  
            vy_trig_o                       : out std_logic;                        -- Wr_Trig2  
            CpSv_Addr_o                     : out std_logic_vector(10 downto 0);    -- Parallel Time data
            CpSv_WrVthData_o                : out std_logic_vector(11 downto 0);  
    		  PrSl_WrVthTrig_o                : out std_logic;
    		  start1_close_en_o               : out std_logic;    -- start1 enable
            start2_close_en_o               : out std_logic;    -- start2 enable
            start3_close_en_o               : out std_logic;    -- start3 enable
    		  CpSv_vxData_o                   : out std_logic_vector(11 downto 0);
    		  CpSv_vyData_o                   : out std_logic_vector(11 downto 0);
            CpSv_Mems_noscan_o              : out std_logic;
    		  test_mode_o                     : out std_logic;
    		  train_cmd_done                  : out std_logic_vector( 1 downto 0);
    		  send_trig_point_num_o           : out std_logic_vector(15 downto 0); 
		  send_trig_close_o               : out std_logic;
		  sft_rst_fpga_o                  : out std_logic;
    		  
            op_flash_cmd_en_o               : out std_logic;
            op_flash_cmd_o                  : out std_logic_vector(31 downto 0);
            wr_flash_frame_req_o            : out std_logic;
            wr_flash_frame_len_o            : out std_logic_vector(15 downto 0);
            wr_flash_frame_addr_o           : out std_logic_vector(18 downto 0);
            wr_ufm_en_o                     : out std_logic;
            wr_ufm_data_o                   : out std_logic_vector(15 downto 0);
            rw_flash_frame_done_i           : in  std_logic_vector( 1 downto 0)
    		      );
        end component;

        component ocf_ctrl is
        generic (
            PrSl_Sim_c                      : integer := 1                           -- Simulation
        );
        port (
            --------------------------------
            -- Reset and clock
            --------------------------------
            rst_n_i                    : in  std_logic;                        -- Reset, active low
            clk_i                      : in  std_logic;                        -- 40MHz Clock,single
            
            test_mode_i                     : in  std_logic; 
            op_flash_cmd_en_i               : in  std_logic;
            op_flash_cmd_i                  : in  std_logic_vector(31 downto 0);
            wr_flash_frame_req              : in  std_logic;
            wr_flash_frame_len              : in  std_logic_vector(15 downto 0);
            wr_flash_frame_addr             : in  std_logic_vector(18 downto 0);
            wr_ufm_en_i                     : in  std_logic;
            wr_ufm_data_i                   : in  std_logic_vector(15 downto 0);
            rw_flash_frame_done             : out std_logic_vector( 1 downto 0);
            rd_ufm_data_o                   : out std_logic_vector(255 downto 0);
            prsv_s1dportrdata_o             : out std_logic_vector(15 downto 0); 
            prsv_w5300siprdata_o            : out std_logic_vector(31 downto 0); 
            sip_dport_en_o                  : out std_logic_vector(15 downto 0); 
            
	    -----------<<open>>---------
            wr_reg_ram_en_o                 : out std_logic;
            wr_reg_ram_data_o               : out std_logic_vector(31 downto 0);
            wr_reg_ram_addr_o               : out std_logic_vector(18 downto 0);
            -----------<<open>>---------
            
            wr_memx_ram_en_o                : out std_logic;                     
            wr_memx_ram_data_o              : out std_logic_vector(31 downto 0); 
            wr_memx_ram_addr_o              : out std_logic_vector(18 downto 0);   
             
            wr_memy_ram_en_o                : out std_logic;                       
            wr_memy_ram_data_o              : out std_logic_vector(31 downto 0);   
            wr_memy_ram_addr_o              : out std_logic_vector(18 downto 0);   
            
            wr_as_ram_en_o                  : out std_logic;
            wr_as_ram_data_o                : out std_logic_vector(31 downto 0);
            wr_as_ram_addr_o                : out std_logic_vector(18 downto 0);
            
            wr_av_ram_en_o                  : out std_logic;
            wr_av_ram_data_o                : out std_logic_vector(31 downto 0);
            wr_av_ram_addr_o                : out std_logic_vector(18 downto 0);
            
            -- Gray_Ratio
            wr_gc_ram_en_o                  : out std_logic;
            wr_gc_ram_data_o                : out std_logic_vector(31 downto 0);
            wr_gc_ram_addr_o                : out std_logic_vector(18 downto 0);

            -- Distance_Constant
            wr_cc_ram_en_o                  : out std_logic;
            wr_cc_ram_data_o                : out std_logic_vector(31 downto 0);
            wr_cc_ram_addr_o                : out std_logic_vector(18 downto 0);

            --------------------------------
            -- Apd_Channel_Dly(Num : 96)
            --------------------------------
            wr_ApdDly_ram_en_o              : out std_logic;
            wr_ApdDly_ram_data_o            : out std_logic_vector(31 downto 0);
            wr_ApdDly_ram_addr_o            : out std_logic_vector(18 downto 0);

            -- 16bit(Real_12bit) * 227
            wr_capav_ram_en_o               : out std_logic;
            wr_capav_ram_data_o             : out std_logic_vector(31 downto 0);
            wr_capav_ram_addr_o             : out std_logic_vector(18 downto 0);

            initial_done_o                  : out std_logic  
        );
        end component;

        component M_NetWr is
        generic (
            PrSl_Sim_c                      : integer := 1                           -- Simulation
        );
        port (
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
        end component;

        component M_I2C is
        port (
            --------------------------------
            -- Reset&Clock
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- Reset,low active
            CpSl_Clk_i                      : in  std_logic;                        -- Clock,Single 40M

            --------------------------------
            -- APD/Vth_Rd/Wr_Trig
            --------------------------------
            CpSl_ApdRdTrig_i                : in  std_logic;                        -- APD_Read_Trig
            CpSl_ApdWrTrig_i                : in  std_logic;                        -- APD_Write_Trig
            CpSl_VthRdTrig_i                : in  std_logic;                        -- Vth_Read_Trig
            CpSl_VthWrTrig_i                : in  std_logic;                        -- Vth_Write_Trig
            
            --------------------------------
            -- LTC2631
            --------------------------------
            CpSl_WrTrig1_i                  : in  std_logic;                        -- Wr_Trig1
            CpSl_WrTrig2_i                  : in  std_logic;                        -- Wr_Trig2
            
            --------------------------------
            -- Vth/APD_Interface
            --------------------------------
            CpSl_ApdChannel_i               : in  std_logic;                        -- AD5242_ApdChannnel
            CpSv_ApdWrData_i                : in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
            CpSv_ApdRdData_o                : out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
            CpSl_VthChannel_i               : in  std_logic;                        -- AD5242_VthChannnel
            CpSv_VthWrData_i                : in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
            CpSv_VthRdData_o                : out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
            CpSl_Finish_o                   : out std_logic;                        -- I2C_Finish
            
            --------------------------------
            -- LTC2631_Interface
            --------------------------------
            CpSv_WrVthData_i                : in  std_logic_vector(11 downto 0);    -- Write_VthData
            CpSv_WrTrigData_i               : in  std_logic_vector(11 downto 0);    -- WriteData
            
            --------------------------------
            -- I2C_Interface
            --------------------------------
            CpSl_Scl_o                      : out std_logic;                        -- AD5242_Scl
            CpSl_Sda_io                     : inout std_logic                       -- AD5242_Sda
        );
        end component;

        component M_GpsTop is 
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
        end component;

        component M_CtrlTime is
        port (
            --------------------------------
            -- Reset & Clock
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
            CpSl_Clk_i                      : in  std_logic;                        -- 40MHz Clock,single
            
            --------------------------------
            -- GPS_Time
            --------------------------------
            CpSl_TimeDvld_i                 : in  std_logic;                        -- Parallel Time data valid
            CpSv_YmdHmsData_i               : in  std_logic_vector(79 downto 0);    -- Parallel HMS data
            CpSl_GpsPPS_i                   : in  std_logic;                        -- GPS_PPS

            --------------------------------
            -- Out_Time
            --------------------------------
            CpSv_Lock_o                     : out std_logic_vector( 1 downto 0);    -- GPS Locked State
            CpSv_UdpTimeData_o              : out std_logic_vector(79 downto 0)     -- UDP Time Data
        );
        end component;

        component M_TdcGpx2 is 
        generic (
    		PrSl_Sim_c                      : integer := 1                           -- Simulation
    	);
    	port (
    		--------------------------------
    		-- Clk & Reset
    		--------------------------------
    		CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
    		CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
            CpSl_Clk200M_i                  : in  std_logic;                        -- Clock,Single_200MHz  
    		
    		--------------------------------
    		-- Start/CapEnd_Trig
    		--------------------------------
    		CpSl_StartTrig_i				: in  std_logic;						-- Start Trig
            CpSl_TdcCapEnd_i                : in  std_logic;                        -- TdcCapEnd_Trig
            CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);   
            CpSl_Start1_i                   : in  std_logic;                        -- CpSl_Start1
            CpSl_Start2_i                   : in  std_logic;                        -- CpSl_Start2
            CpSl_Start3_i                   : in  std_logic;                        -- CpSl_Start3
            CpSl_Clk5M_i                    : in  std_logic;                        -- CpSl_Clk5M
            CpSl_RstId_i                    : in  std_logic;                        -- CpSl_RstId
            CpSl_RstId1_i                   : in  std_logic;                        -- CpSl_RstId
            --------------------------------
    		-- SPI_IF
    		--------------------------------
    		CpSl_SSN_o						: out std_logic;						-- TDC_GPX2_SSN
    		CpSl_SClk_o						: out std_logic;						-- TDC_GPX2_SCLK
    		CpSl_MOSI_o						: out std_logic;						-- TDC_GPX2_MOSI
    		CpSl_MISO_i						: in  std_logic;						-- TDC_GPX2_MISO
            
            CpSl_SSN1_o                     : out std_logic;						-- TDC_GPX2_SSN
    		CpSl_SClk1_o                    : out std_logic;						-- TDC_GPX2_SCLK
    		CpSl_MOSI1_o                    : out std_logic;						-- TDC_GPX2_MOSI
    		CpSl_MISO1_i                    : in  std_logic;						-- TDC_GPX2_MISO
            
            --------------------------------
            -- Ladar_Signal
            --------------------------------
            CpSl_LadarTrig_i                : in  std_logic;                        -- Ladar Start Trig
            CpSl_TestPulse_o                : out std_logic;                        -- TDC_GPX2_Test_Pulse
            
            --------------------------------
            -- Image_Data
            --------------------------------
            CpSl_ImageVld_i                 : in  std_logic;                        -- Image Valid
            CpSl_FrameVld_i                 : in  std_logic;                        -- Frame Valid
            
            --------------------------------
            -- Apd_Address/Num
            --------------------------------
            CpSl_ApdNumVld_i                : in  std_logic;                        -- ADP_NumVld
            CpSv_ApdNum_i                   : in  std_logic_vector( 6 downto 0);    -- ADP_Num   
            CpSl_ApdAddr_i                  : in  std_logic_vector(10 downto 0);    -- APD_Address  
            
            --------------------------------
            -- Apd_Channel_Dly(Num : 96)
            --------------------------------
            CpSl_ApdDlyEn_i                 : in  std_logic;                        -- ADP_ApdChannel_DlyEn
            CpSv_ApdDlyData_i               : in  std_logic_vector(31 downto 0);    -- ADP_ApdChannel_DlyData  
            CpSv_ApdDlyAddr_i               : in  std_logic_vector(18 downto 0);    -- ADP_ApdChannel_DlyAddress
            
            --------------------------------
    		-- LVDS_Interface
    		--------------------------------
    		-- TDC0
    		CpSl_RefClkP_i					: in  std_logic;						-- TDC_GPX2_Clk_i
    		CpSl_Intertupt_i				: in  std_logic;						-- TDC_GPX2_Interrupt
            CpSl_Frame1_i					: in  std_logic;						-- TDC_GPX2_Frame1
    		CpSl_Frame2_i					: in  std_logic;						-- TDC_GPX2_Frame2
    		CpSl_Frame3_i					: in  std_logic;						-- TDC_GPX2_Frame3
    		CpSl_Frame4_i					: in  std_logic;						-- TDC_GPX2_Frame4
    		CpSl_Sdo1_i	     				: in  std_logic;						-- TDC_GPX2_SDO1
    		CpSl_Sdo2_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO2
    		CpSl_Sdo3_i	     				: in  std_logic;						-- TDC_GPX2_SDO3
    		CpSl_Sdo4_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO4
    		
    		-- TDC1
    		CpSl_RefClk1P_i					: in  std_logic;						-- TDC_GPX2_Clk_i
            CpSl_Frame5_i					: in  std_logic;						-- TDC_GPX2_Frame5
    		CpSl_Frame6_i					: in  std_logic;						-- TDC_GPX2_Frame6
    		CpSl_Frame7_i					: in  std_logic;						-- TDC_GPX2_Frame7
    		CpSl_Frame8_i					: in  std_logic;						-- TDC_GPX2_Frame8
    		CpSl_Sdo5_i	     				: in  std_logic;						-- TDC_GPX2_SDO5
    		CpSl_Sdo6_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO6
    		CpSl_Sdo7_i	     				: in  std_logic;						-- TDC_GPX2_SDO7
    		CpSl_Sdo8_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO8
            
            --------------------------------
    		-- PC->FPGA_Constant
    		--------------------------------
    	    CpSl_GrayEn_i                   : in  std_logic;                        -- Gray_En  
    	    CpSv_GrayData_i                 : in  std_logic_vector(31 downto 0);    -- Gray_Data
    	    CpSv_GrayAddr_i                 : in  std_logic_vector(18 downto 0);    -- Gray_Addr

    		CpSl_DistEn_i                   : in  std_logic;                        -- Dist_En
    	    CpSv_DistData_i                 : in  std_logic_vector(31 downto 0);    -- Dist_Data
    	    CpSv_DistAddr_i                 : in  std_logic_vector(18 downto 0);    -- Dist_Addr
    		
            CpSl_GroupRd_o                  : out std_logic;                        -- Group_Rd
            CpSl_GroupRdData_i              : in  std_logic_vector(13 downto 0);    -- Group_RdData

            --------------------------------
    		-- Wave/Gray_OutPut
    		--------------------------------
    		CpSl_Echo1Vld_o                 : out std_logic;                        -- Echo1Valid
            CpSv_Echo1Wave1_o               : out std_logic_vector(18 downto 0);    -- Echo1Wave1
            CpSv_Echo1Gray1_o               : out std_logic_vector(15 downto 0);    -- Echo1Gary1
            CpSv_Echo2Wave1_o               : out std_logic_vector(18 downto 0);    -- Echo2Wave1
            CpSv_Echo2Gray1_o               : out std_logic_vector(15 downto 0);    -- Echo2Gary1
            CpSv_Echo3Wave1_o               : out std_logic_vector(18 downto 0);    -- Echo3Wave1
            CpSv_Echo3Gray1_o               : out std_logic_vector(15 downto 0);    -- Echo3Gary1
            PrSv_EchoPW20_o                 : out std_logic_vector(18 downto 0);
    		--------------------------------
    		-- TDC_Debug
    		--------------------------------
            CpSl_TdcDataVld_o               : out std_logic;                        -- TDC_Recv_Data Valid
            CpSv_Tdc1Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data1
            CpSv_Tdc2Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data2
            CpSv_Tdc3Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data3
            CpSv_Tdc4Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data4
            CpSv_Tdc5Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data5
            CpSv_Tdc6Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data6
            CpSv_Tdc7Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data7
            CpSv_Tdc8Data_o                 : out std_logic_vector(15 downto 0)     -- TDC Recv Data8
    	);
        end component;
            
        ------------------------------------
        -- Generate_TdcSimData
        ------------------------------------
        component M_TestTdc
        port (
            --------------------------------
            -- Clock & Reset
            --------------------------------
            CpSl_Rst_iN                     : in  std_logic;                        -- Reset_activelow
            CpSl_Clk200M_i                  : in  std_logic;                        -- 200MHz
            
            --------------------------------
            -- Ladar_Trig
            --------------------------------
            CpSl_Start1_i                   : in  std_logic;
            CpSl_Start2_i                   : in  std_logic;
            CpSl_Start3_i                   : in  std_logic;
            
            --------------------------------
            -- TDC_Data
            --------------------------------
            CpSl_RefClkP_o					: out std_logic;						-- TDC_GPX2_Clk_i
            
            -- TDC0
    		CpSl_Frame1_o					: out std_logic;						-- TDC_GPX2_Frame1_low
    		CpSl_Frame2_o					: out std_logic;						-- TDC_GPX2_Frame2_30%
    		CpSl_Frame3_o					: out std_logic;						-- TDC_GPX2_Frame3_Low
    		CpSl_Frame4_o					: out std_logic;						-- TDC_GPX2_Frame4_30%
    		CpSl_Sdo1_o	     				: out std_logic;						-- TDC_GPX2_SDO1
    		CpSl_Sdo2_o	 	    		    : out std_logic;						-- TDC_GPX2_SDO2
    		CpSl_Sdo3_o	     				: out std_logic;						-- TDC_GPX2_SDO3
    		CpSl_Sdo4_o	 	    		    : out std_logic;						-- TDC_GPX2_SDO4

            -- TDC1
            CpSl_Frame5_o                   : out std_logic;                        -- TDC_GPX2_Frame5_50%
            CpSl_Frame6_o                   : out std_logic;                        -- TDC_GPX2_Frame6_90%
            CpSl_Frame7_o                   : out std_logic;                        -- TDC_GPX2_Frame7_50%
            CpSl_Frame8_o                   : out std_logic;                        -- TDC_GPX2_Frame8_90%
            CpSl_Sdo5_o                     : out std_logic;                        -- TDC_GPX2_SDO5
            CpSl_Sdo6_o                     : out std_logic;                        -- TDC_GPX2_SDO6
            CpSl_Sdo7_o                     : out std_logic;                        -- TDC_GPX2_SDO7
            CpSl_Sdo8_o                     : out std_logic                         -- TDC_GPX2_SDO8
        );
        end component;

        ------------------------------------
        -- signal describe
        ------------------------------------
        signal c_clk_1ms_tick               : std_logic;
        signal c_clk_10us_tick              : std_logic;
        signal c_clk_100us_tick             : std_logic;
        signal c_mem_dax                    : std_logic_vector(11 downto 0);
        signal c_mem_day                    : std_logic_vector(11 downto 0);
        signal c_mem_dastart                : std_logic;
        signal c_laser_rpi_start_start      : std_logic;
        signal c_pic_tdc_procedure_start    : std_logic;
        signal c_w5300_init_start           : std_logic;
        signal c_da_datax                   : std_logic_vector(11 downto 0);
        signal c_da_datay                   : std_logic_vector(11 downto 0);
        signal c_da_start                   : std_logic;
        signal c_da_finish                  : std_logic;
        signal c_rpiplus                    : std_logic;
        signal c_1us_tick                   : std_logic;
        signal c_w5300_nrst_ctrl            : std_logic;
        signal c_w5300_nrst                 : std_logic;
        signal c_nint_f                     : std_logic;
        signal c_w5300_init_result          : std_logic;
        signal PrSl_W5300InitSucc_s         : std_logic;
    	 signal frame_fst_rcv_s              : std_logic;
        signal c_rcv_tick                   : std_logic;
        signal c_rcv_data                   : std_logic_vector(15 downto 0);
        signal c_rcv_data_len               : std_logic_vector(15 downto 0);
        signal c_rcv_frame_end              : std_logic;
        signal c_fifo_rd                    : std_logic;
        signal c_fifo_data                  : std_logic_vector(31 downto 0);
        signal c_fifo_empty                 : std_logic;
        signal c_send_start_tick            : std_logic;
        signal c_send_done_tick             : std_logic;
        signal c_inter_wr                   : std_logic;
        signal c_inter_rd                   : std_logic;
        signal c_inter_ncs                  : std_logic;
        signal c_inter_addr                 : std_logic_vector( 9 downto 0);
        signal c_inter_data_wr              : std_logic_vector(15 downto 0);
        signal c_inter_data_rd              : std_logic_vector(15 downto 0);
        signal c_eth_addr                   : std_logic_vector( 9 downto 0);    
            
        ------------------------------------
        -- Signal Describe 
        ------------------------------------ 
        -- Clock
        signal PrSl_Clk200M_s               : std_logic;                            -- Clock 200MHz 
        signal PrSl_Clk80M_s                : std_logic;                            -- Clock 80MHz
        signal PrSl_Clk40M_s                : std_logic;                            -- Clock 40MHz 
        signal PrSl_Clk5M_s                 : std_logic;                            -- Clock 5MHz
        signal PrSl_ClkLocked_s             : std_logic;                            -- Clock Locked  

        -- M_TrigCtrl
        signal PrSl_StopTrig_s              : std_logic;                            -- PC Stop Trig
        signal PrSl_NetStopTrig_s           : std_logic;                            -- Net Stop Trig
        signal PrSl_FrameEndTrig_s          : std_logic;                            -- Frame End Trig
        signal PrSv_PointStyle_s            : std_logic_vector( 1 downto 0);        -- Point Number Style
        signal PrSl_Ltc2423Trig_s           : std_logic;                            -- ADC Start Trig      
        signal PrSl_UdpCycleEnd_s           : std_logic;                            -- UDP Cycle End
        signal PrSl_1usTrig_s               : std_logic;                            -- ius
        signal PrSl_LadarTrig_s             : std_logic;                            -- Start Trig
        signal PrSl_apd_slt_en_s            : std_logic;                            -- APD_Enable    
        signal ld_num_s                     : std_logic_vector(1 downto 0);         -- LD_Num        
        signal PrSl_TdcLdnum_s              : std_logic_vector(1 downto 0);         -- Ctrl_Tdc_LD_Num
        signal PrSl_TdcCapEnd_s             : std_logic;                            -- TdcCapEnd_Trig
        signal PrSl_ApdVld_s                : std_logic;                            -- APD_Valid
        signal PrSv_Addr_s                  : std_logic_vector(10 downto 0);        -- ADP_Address
        signal PrSl_MemXYVld_s              : std_logic;

        -- M_RomCtrl
        signal PrSl_MemoryRdTrig_s          : std_logic;                            -- Memory start Trig   
        signal PrSl_MemoryAddTrig_s         : std_logic;                            -- Memory Add Trig     
        signal PrSv_EochCnt_s               : std_logic_vector( 1 downto 0);        -- Ench Cnt
        signal PrSl_UdpTest_s               : std_logic;                            -- UDP Test Module
        signal PrSl_RdFifo_s                : std_logic;                            -- Fifo Read
        signal PrSl_FifoDataVld_S           : std_logic;                            -- Fifo Data Valid 
        signal PrSv_FifoData_s              : std_logic_vector(31 downto 0);        -- Fifo Data
        signal c_ad_ready                   : std_logic;                            -- LTC2324 Valid 
        signal c_gray_temp                  : std_logic_vector(15 downto 0);        -- Mem Gray 
        
        signal PrSl_CapApdTrig_s            : std_logic;                            -- Cap_ApdTirg
        signal PrSl_CpdApdVld_s             : std_logic;                            -- Cap_ApdVld
        signal PrSv_CpdApdVol_s             : std_logic_vector(15 downto 0);        -- Cap_ApdVol

        signal c_temper_temp                : std_logic_vector(15 downto 0);        -- Mem Temper
        signal c_memx_temp                  : std_logic_vector(15 downto 0);        -- Mem x Data 
        signal c_memy_temp                  : std_logic_vector(15 downto 0);        -- Mem Y Data
        
        -- M_I2C
        signal PrSl_VolDataTrig_s           : std_logic;                            -- APD Voltage Data Trig
        signal PrSv_VolData_s               : std_logic_vector(11 downto 0);        -- APD Voltage Data
        signal PrSl_WrTrig_s                : std_logic;                            -- Write 5242_Data
        signal PrSl_WrTrig1_s               : std_logic;                            -- Write_LTC2631_Data
        signal PrSl_WrTrig2_s               : std_logic;                            -- Write_LTC2631_Data
        signal CpSv_WrVthData_s             : std_logic_vector(11 downto 0);        -- LTC2631_Data
        signal PrSl_WrVthTrig_s             : std_logic;
    	signal PrSv_RecvData_s              : std_logic_vector(11 downto 0);        -- LTC2631_Data

        signal CpSv_vxData_s              : std_logic_vector(11 downto 0);        -- LTC2631_Data
        signal CpSv_vyData_s              : std_logic_vector(11 downto 0);        -- LTC2631_Data

        signal vx_trig_s                    : std_logic;                            -- write_vx
        signal vy_trig_s                    : std_logic;                            -- write_vy
    	 signal start1_close_en_s            : std_logic;
    	 signal start2_close_en_s            : std_logic;
    	 signal start3_close_en_s            : std_logic;
        signal cfg_apd_Addr_s               : std_logic_vector(10 downto 0);
    	 signal test_mode_s                  : std_logic;
        -- M_VolAgc
        signal PrSv_AgcDataVld_s            : std_logic;
        signal PrSv_AgcData_s               : std_logic_vector(11 downto 0);
        
        -- M_NetWr
        signal PrSl_NetSend_s               : std_logic;                            -- Net Start
        signal PrSl_StartTrig_s             : std_logic;                            -- Start Trig(?????????????)
        signal PrSl_HeadVld_s               : std_logic;                            -- Recv Enther Data Vld
        signal PrSv_HeadData_s              : std_logic_vector(15 downto 0);        -- Recv Enther Data    
        signal PrSl_S0Tx_WrsRVld_s          : std_logic;                            -- S0Tx_WrsR_Vls       
        signal PrSv_S0Tx_WrsR_s             : std_logic_vector(15 downto 0);        -- S0Tx_WrsR_Data  
        signal PrSv_UdpRdCnt_s              : std_logic_vector(11 downto 0);        -- UDP Read Cnt
        signal CpSl_start_send_s            : std_logic;
        -- M_W5300Ctrl
        signal PrSl_NetStartTrig_s          : std_logic;                            -- NetUdp Start Trig
        signal PrSl_NetRd_s                 : std_logic;                            -- Net Read
        signal PrSl_NetDataVld_s            : std_logic;                            -- Net Recv Data Vld 
        signal PrSl_NetData_s               : std_logic_vector(31 downto 0);        -- Net Recv Data
        signal PrSl_W5300Init_s             : std_logic;	                          -- W5300 Init
        
        signal prsv_w5300siprdata_s         : std_logic_vector(31 downto 0); 
        signal prsv_s1dportrdata_s          : std_logic_vector(15 downto 0); 
	signal sip_dport_en_s               : std_logic_vector(15 downto 0); 

        -- GPS
        signal PrSl_TimeDvld_s              : std_logic;                            -- Parallel Time data valid
        signal PrSv_YmdHmsData_s            : std_logic_vector(79 downto 0);        -- Parallel Ymd_Hms data
        
        -- M_CtrlTime
        signal PrSv_UdpTimeData_s           : std_logic_vector(79 downto 0);        -- UDP Time Data   
        signal PrSv_Lock_s                  : std_logic_vector( 1 downto 0);        -- GPS Locked State
        
        -- M_TdcGpx2
        signal PrSl_TdcDataVld_s            : std_logic;                            -- TDC_RecvData_Valid
        signal PrSv_Tdc1Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame1_Data
        signal PrSv_Tdc2Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame2_Data
        signal PrSv_Tdc3Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame3_Data
        signal PrSv_Tdc4Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame4_Data
        signal PrSv_Tdc5Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame5_Data
        signal PrSv_Tdc6Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame6_Data
        signal PrSv_Tdc7Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame7_Data
        signal PrSv_Tdc8Data_s              : std_logic_vector(15 downto 0);        -- TDC_RecvFrame8_Data
        signal PrSl_TestPulse_s             : std_logic;                            -- Generate TestPuls    
        signal PrSv_Gain_s                  : std_logic_vector(15 downto 0);        -- Image Gain--此信号暂未使用上
        signal PrSl_ImageVld_s              : std_logic;                            -- Image Valid
        signal PrSl_FrameVld_s              : std_logic;                            -- Frame Valid
        signal PrSl_Echo1Vld_s              : std_logic;                            -- Echo1Valid
        signal PrSv_Echo1Wave1_s            : std_logic_vector(18 downto 0);        -- Echo1Wave1
        signal PrSv_Echo1Gray1_s            : std_logic_vector(15 downto 0);        -- Echo1Gary1
        signal PrSv_Echo2Wave1_s            : std_logic_vector(18 downto 0);        -- Echo2Wave1
        signal PrSv_Echo2Gray1_s            : std_logic_vector(15 downto 0);        -- Echo2Gary1
        signal PrSv_Echo3Wave1_s            : std_logic_vector(18 downto 0);        -- Echo3Wave1
        signal PrSv_Echo3Gray1_s            : std_logic_vector(15 downto 0);        -- Echo3Gary1
        signal PrSl_GroupRd_s               : std_logic;                            -- Group_Rd
        signal PrSl_GroupRdData_s           : std_logic_vector(13 downto 0);        -- Group_RdDataData

        signal PrSv_EchoPW20_s              : std_logic_vector(18 downto 0);
        
        -- M_apd_slt
        signal PrSl_ApdNumVld_s             : std_logic;                            -- ADP_NumVld 
        signal PrSv_ApdNum_s                : std_logic_vector(6 downto 0);         -- ADP_Num    

        ------------------------------------
        -- Generate_TDC_SimData
        ------------------------------------
        signal PrSl_Choice_TdcData_s        : std_logic;
		  
		  attribute keep : string;
		  attribute keep of PrSl_Choice_TdcData_s: signal is "true";
		
        
        signal PrSl_RefClkP_s               : std_logic;
        signal PrSl_RefClkP1_s              : std_logic;
        signal CpSl_RstId_s                 : std_logic;
        signal CpSl_RstId1_s                : std_logic;
        signal PrSl_Frame1_s                : std_logic;
        signal PrSl_Frame2_s                : std_logic;
        signal PrSl_Frame3_s                : std_logic;
        signal PrSl_Frame4_s                : std_logic;
        signal PrSl_Sdo1_s	                : std_logic; 
        signal PrSl_Sdo2_s	                : std_logic; 
        signal PrSl_Sdo3_s	                : std_logic; 
        signal PrSl_Sdo4_s	                : std_logic; 
        signal PrSl_Frame5_s                : std_logic;
        signal PrSl_Frame6_s                : std_logic;
        signal PrSl_Frame7_s                : std_logic;
        signal PrSl_Frame8_s                : std_logic;
        signal PrSl_Sdo5_s                  : std_logic;
        signal PrSl_Sdo6_s                  : std_logic;
        signal PrSl_Sdo7_s                  : std_logic;
        signal PrSl_Sdo8_s                  : std_logic;
        signal PrSl_Start1_s                : std_logic;
        signal PrSl_Start2_s                : std_logic;
        signal PrSl_Start3_s                : std_logic;
        signal PrSl_SimRefClkP_s            : std_logic;                        -- TDC_SimClk
        signal PrSl_SimFrame1_s             : std_logic;						-- TDC_GPX2_Frame1_low
        signal PrSl_SimFrame2_s             : std_logic;						-- TDC_GPX2_Frame2_30%
        signal PrSl_SimFrame3_s             : std_logic;						-- TDC_GPX2_Frame3_Low
        signal PrSl_SimFrame4_s             : std_logic;						-- TDC_GPX2_Frame4_30%
        signal PrSl_SimSdo1_s               : std_logic;						-- TDC_GPX2_SDO1      
        signal PrSl_SimSdo2_s               : std_logic;						-- TDC_GPX2_SDO2      
        signal PrSl_SimSdo3_s               : std_logic;						-- TDC_GPX2_SDO3      
        signal PrSl_SimSdo4_s               : std_logic;						-- TDC_GPX2_SDO4      
        signal PrSl_SimFrame5_s             : std_logic;                        -- TDC_GPX2_Frame5_50%
        signal PrSl_SimFrame6_s             : std_logic;                        -- TDC_GPX2_Frame6_90%
        signal PrSl_SimFrame7_s             : std_logic;                        -- TDC_GPX2_Frame7_50%
        signal PrSl_SimFrame8_s             : std_logic;                        -- TDC_GPX2_Frame8_90%
        signal PrSl_SimSdo5_s               : std_logic;                        -- TDC_GPX2_SDO5      
        signal PrSl_SimSdo6_s               : std_logic;                        -- TDC_GPX2_SDO6      
        signal PrSl_SimSdo7_s               : std_logic;                        -- TDC_GPX2_SDO7      
        signal PrSl_SimSdo8_s               : std_logic;                        -- TDC_GPX2_SDO8      
    	 
    	 signal wr_reg_ram_en_s             : std_logic;                     
    	 signal wr_reg_ram_data_s           : std_logic_vector(31 downto 0); 
    	 signal wr_reg_ram_addr_s           : std_logic_vector(18 downto 0);   
    		     
    	 signal wr_memx_ram_en_s            : std_logic;                     
    	 signal wr_memx_ram_data_s          : std_logic_vector(31 downto 0); 
    	 signal wr_memx_ram_addr_s          : std_logic_vector(18 downto 0);   
    		     
    	 signal wr_memy_ram_en_s            : std_logic;                       
    	 signal wr_memy_ram_data_s          : std_logic_vector(31 downto 0);   
    	 signal wr_memy_ram_addr_s          : std_logic_vector(18 downto 0);   

    	 signal wr_as_ram_en_s               : std_logic;
    	 signal wr_as_ram_data_s             : std_logic_vector(31 downto 0);
    	 signal wr_as_ram_addr_s             : std_logic_vector(18 downto 0);

    	 signal wr_av_ram_en_s               : std_logic;
    	 signal wr_av_ram_data_s             : std_logic_vector(31 downto 0);
    	 signal wr_av_ram_addr_s             : std_logic_vector(18 downto 0);

    	 signal wr_gc_ram_en_s              : std_logic;                       
    	 signal wr_gc_ram_data_s            : std_logic_vector(31 downto 0);   
    	 signal wr_gc_ram_addr_s            : std_logic_vector(18 downto 0);   

    	 signal wr_cc_ram_en_s              : std_logic;                       
    	 signal wr_cc_ram_data_s            : std_logic_vector(31 downto 0);   
    	 signal wr_cc_ram_addr_s            : std_logic_vector(18 downto 0);   

        signal wr_ApdDly_ram_en_s           : std_logic;
        signal wr_ApdDly_ram_data_s         : std_logic_vector(31 downto 0);
        signal wr_ApdDly_ram_addr_s         : std_logic_vector(18 downto 0);

        signal wr_capav_ram_en_s            : std_logic;
        signal wr_capav_ram_data_s          : std_logic_vector(31 downto 0);
        signal wr_capav_ram_addr_s          : std_logic_vector(18 downto 0);

        signal op_flash_cmd_en_s               : std_logic;
        signal op_flash_cmd_s                  : std_logic_vector(31 downto 0);
        signal wr_flash_frame_req_s            : std_logic;
        signal wr_flash_frame_len_s            : std_logic_vector(15 downto 0);
        signal wr_flash_frame_addr_s           : std_logic_vector(18 downto 0);
        signal wr_ufm_en_s                     : std_logic;
        signal wr_ufm_data_s                   : std_logic_vector(15 downto 0);
        signal rw_flash_frame_done_s           : std_logic_vector( 1 downto 0);
        signal rd_ufm_data_s                   : std_logic_vector(255 downto 0);
        signal train_cmd_done_s                : std_logic_vector( 1 downto 0);
        signal initial_done_s                  : std_logic;                       
        
        signal CpSv_Mems_noscan_s              : std_logic;
        signal send_trig_point_num_s           : std_logic_vector(15 downto 0); 	 
        signal send_trig_close_s               : std_logic;
	signal sft_rst_fpga_s                  : std_logic; 
    	 
    begin
        ----------------------------------------------------------------------------
        -- component map
        ----------------------------------------------------------------------------
        counter_shdn_uut : counter_shdn
        port map (
            clk                             => PrSl_Clk40M_s,
            clk_1ms_tick                    => c_clk_1ms_tick,
            nrst                            => PrSl_ClkLocked_s,
            shdn                            => F_SHDN
        );

    ------------------------------------ 
    -- c0 : 200MHz
    -- c1 : 80MHz
    -- c2 : 40MHz
    ------------------------------------
    U_M_Clock_0 : M_Clock
    port map (
        -------------------------------- 
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_iN                     => LVRESETN                             , -- active,low
        CpSl_Clk_i                      => CLK_40MHz_IN                         , -- single 40MHz.clock
        sft_rst_fpga_i                  => sft_rst_fpga_s,
        
	--------------------------------                                         
        -- Clock&Lock                                                           
        --------------------------------                                       
        CpSl_Clk200M_o                  => PrSl_Clk200M_s                       , -- Clock 200MHz
        CpSl_Clk80M_o                   => PrSl_Clk80M_s                        , -- Clock 80MHz
        CpSl_Clk40M_o                   => PrSl_Clk40M_s                        , -- Clock 40MHz
--        CpSl_Clk5M_o                    => PrSl_Clk5M_s                         , -- out std_logic;                        -- Clock 5MHz
        CpSl_ClkLocked_o                => PrSl_ClkLocked_s                       -- Clock Locked
    );
    ------------------------------------
    -- F_LCLK_IN_P/F_LCLK_IN_1P
    -- F_REFCLK_P/F_REFCLK_1P
    ------------------------------------
    F_LCLK_IN_P  <= PrSl_Clk200M_s;
    F_LCLK_IN_1P <= PrSl_Clk200M_s;
    F_REFCLK_P   <= PrSl_Clk5M_s;
    F_REFCLK_1P  <= PrSl_Clk5M_s;

        U_M_TrigCtrl_0 :  M_TrigCtrl
        generic map (
            PrSl_DebugApd_c                 => PrSl_DebugApd_c                        -- integer := 1;                         -- Debug_APD
        )
        port map (
            --------------------------------
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- active,low
            CpSl_Clk_i                      => PrSl_Clk200M_s                       , -- in  std_logic;                        -- single 200MHz.clock

            --------------------------------                          
            -- Start/Stop Trig
            --------------------------------
            CpSl_StartTrig_i                => c_laser_rpi_start_start              , -- in  std_logic;                        -- Start Trig
            -- Init FPGA
            CpSl_StopTrig_i                 => PrSl_StopTrig_s                      , -- in  std_logic;                        -- Stop Trig
            CpSv_PointStyle_i               => PrSv_PointStyle_s                    , -- in  std_logic_vector(1 downto 0);     -- Point Number Style
            CpSl_NetStopTrig_o              => PrSl_NetStopTrig_s                   , -- out std_logic;                        -- Net Stop Trig

            -------------------------------- 
            -- TDC_RefClk
            --------------------------------
            CpSl_Clk5M_o                    => PrSl_Clk5M_s                         , -- out std_logic;                        -- 5MHz
            CpSl_1usTrig_o                  => PrSl_1usTrig_s                       , -- out std_logic;                        -- ius
            
            --------------------------------
            -- Start1/Start2/RPI Trig
            --------------------------------
            start1_close_en_i               => start1_close_en_s,
            start2_close_en_i               => start2_close_en_s,
            start3_close_en_i               => start3_close_en_s,

            CpSl_CapTrig_o                  => open                                 , -- out std_logic;                        -- ADLink Capture Trig
            CpSl_Start1_o                   => PrSl_Start1_s                        , -- out std_logic;                        -- Start1 Trig
            CpSl_Start2_o                   => PrSl_Start2_s                        , -- out std_logic;                        -- Start2 Trig
            CpSl_Start3_o                   => PrSl_Start3_s                        , -- out std_logic;                        -- Start3 Trig
            CpSl_LadarTrig_o                => PrSl_LadarTrig_s                     , -- out std_logic;                        -- Start  Trig
            CpSl_Rpi_o                      => F_RPI                                , -- out std_logic;                        -- PRI 
            CpSl_GainRst_o                  => F_GAINRST                            , -- out std_logic;                        -- Gain Control
            
            --------------------------------
            -- Apd/LD_Num
            -- TDC_CapEnd
            --------------------------------
            CpSl_apd_slt_en_o               => PrSl_apd_slt_en_s                    , -- out std_logic;                        -- APD_Enable
            ld_num_o                        => ld_num_s                             , -- out std_logic_vector(1 downto 0);     -- LD_Num
            CpSl_TdcLdnum_o                 => PrSl_TdcLdnum_s                      , -- out std_logic_vector(1 downto 0);     -- Ctrl_Tdc_LD_Num
            CpSl_TdcCapEnd_o                => PrSl_TdcCapEnd_s                     , -- out std_logic;                        -- TdcCapEnd_Trig
            CpSl_ApdVld_o                   => PrSl_ApdVld_s                        , -- out std_logic;                        -- APD_Valid
            CpSl_MemXYVld_i                 => PrSl_MemXYVld_s                      , 
            
            --------------------------------
            -- TDC_RstId/Disable
            --------------------------------
            CpSl_TdcDisable_o               => F_DISABLE_P                          , -- out std_logic;                     -- TDC_GPX2_Disable
            CpSl_RstId_o                    => CpSl_RstId_s                         , -- out std_logic;                        -- TDC_RstId
            CpSl_RstId1_o                   => CpSl_RstId1_s                        , -- out std_logic;                        -- TDC_RSTIDX

            --------------------------------
            -- Begin Trig
            --------------------------------
            CpSl_UdpCycleEnd_o              => PrSl_UdpCycleEnd_s                   , -- out std_logic;                        -- UDP Cycle End
            CpSl_Ltc2324Trig_o              => PrSl_Ltc2423Trig_s                   , -- out std_logic;                        -- ADC Start Trig
            CpSl_Ltc2324EndTrig_i           => c_ad_ready                           , -- in  std_logic;                        -- ADC End Trig
            CpSl_FrameEndTrig_i             => PrSl_FrameEndTrig_s                  , -- in  std_logic;                        -- Frame End Trig
            CpSl_MemoryRdTrig_o             => PrSl_MemoryRdTrig_s                  , -- out std_logic;                        -- Memory start Trig
            CpSl_MemoryAddTrig_o            => PrSl_MemoryAddTrig_s                   -- out std_logic                         -- Memory Add Trig 
        );
        F_RSTIDX_P <= CpSl_RstId_s;
        F_RSTIDX_1P <= CpSl_RstId1_s;
    	 
        U_M_RomCtrl_0 : M_RomCtrl
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c                             -- Simulation
        )
        port map (
            --------------------------------
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- active,low
            CpSl_Clk_i                      => PrSl_Clk40M_s                        , -- in  std_logic;                        -- single 40MHz.clock
                                                            
            --------------------------------                
            -- Rom Start Trig                               
            --------------------------------
    		test_mode_i                     => test_mode_s                          ,
    		CpSv_vxData_i                   => CpSv_vxData_s                        , 
    		CpSv_vyData_i                   => CpSv_vyData_s                        , 
            CpSv_Mems_noscan_i              => CpSv_Mems_noscan_s                   ,  

            CpSl_FrameEndTrig_o             => PrSl_FrameEndTrig_s                  , -- out std_logic;                        -- Frame End Trig
            CpSl_MemoryAddTrig_i            => PrSl_MemoryAddTrig_s                 , -- in  std_logic                         -- Memory Add Trig     
            CpSl_MemoryRdTrig_i             => PrSl_MemoryRdTrig_s                  , -- in  std_logic                         -- Memory start Trig
            
            send_trig_point_num_i           => send_trig_point_num_s                ,  
	    send_trig_close_i               => send_trig_close_s                    ,
            CpSl_CapTrig_o                  => F_CapTrig                            ,                                             
            
	    --------------------------------                
            -- Head/Ench Number/LDNum                                
            --------------------------------                
            CpSv_EochCnt_i                  => PrSv_EochCnt_s                       , -- in  std_logic_vector(1 downto 0);     -- Ench Cnt
            CpSl_UdpTest_i                  => PrSl_UdpTest_s                       , -- in  std_logic;                        -- UDP Test Module
            CpSv_LdNum_i                    => PrSl_TdcLdnum_s, -- ld_num_s                             , -- in  std_logic_vector(1 downto 0);     -- LD_Num
            
            --------------------------------
            -- TrigCycle
            --------------------------------
            CpSl_UdpCycleEnd_i              => PrSl_UdpCycleEnd_s                   , -- in  std_logic;                        -- UDP Cycle End
            
            --------------------------------                
            -- LTC2324 Data                                 
            --------------------------------                
            CpSl_EndTrig_i                  => c_ad_ready                           , -- in  std_logic;                        -- LTC2324 Valid
            CpSv_MemxData_i                 => c_memx_temp                          , -- in  std_logic_vector(15 downto 0);    -- Mem x Data 
            CpSv_MemyData_i                 => c_memy_temp                          , -- in  std_logic_vector(15 downto 0);    -- Mem Y Data
            CpSv_MemTemp_i                  => c_temper_temp                        , -- in  std_logic_vector(15 downto 0);    -- Mem Temp
            
            --------------------------------                
            -- TDC_GPX2 Data                                
            --------------------------------
            -- TDC_Wave/Gray
            CpSl_EchoDVld_i                 => PrSl_Echo1Vld_s                      , -- in  std_logic;                        -- TDC_Data_Valid    
            CpSv_EchoWave_i                 => PrSv_Echo1Wave1_s                    , -- in  std_logic_vector(18 downto 0);    -- TDC_Data_Wave     
            CpSv_EchoGray_i                 => PrSv_Echo1Gray1_s                    , -- in  std_logic_vector(15 downto 0);    -- TDC_Data_Gray  
    --        PrSv_Echo2Wave1_s                    , -- in std_logic_vector(18 downto 0);    -- Echo2Wave1
    --        PrSv_Echo2Gray1_s                    , -- in std_logic_vector(15 downto 0);    -- Echo2Gary1
    --        PrSv_Echo3Wave1_s                    , -- in std_logic_vector(18 downto 0);    -- Echo3Wave1
    --        PrSv_Echo3Gray1_s                    , -- in std_logic_vector(15 downto 0);    -- Echo3Gary1
            PrSv_EchoPW20_i                 => PrSv_EchoPW20_s                      , 
    		  
            CpSl_ApdNumVld_i                => PrSl_ApdNumVld_s                     , -- std_logic;                            -- ADP_NumVld
            CpSv_ApdNum_i                   => PrSv_ApdNum_s                        , -- std_logic_vector(6 downto 0);         -- ADP_Num   

            --------------------------------
            -- Group_Rd
            --------------------------------
            CpSl_GroupRd_i                  => PrSl_GroupRd_s                       , -- in  std_logic;                        -- Group_Rd
            CpSl_GroupRdData_o              => PrSl_GroupRdData_s                   , -- out std_logic;                        -- Group_RdData

            -- Tdc_Debug
            CpSl_TdcDataVld_i               => PrSl_TdcDataVld_s                    , -- in  std_logic;                        -- TDC_Recv_Data Valid
            CpSv_TdcData_i                  => PrSv_Tdc1Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data1
            CpSv_Tdc2Data_i                 => PrSv_Tdc2Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data2
            CpSv_Tdc3Data_i                 => PrSv_Tdc3Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data3
            CpSv_Tdc4Data_i                 => PrSv_Tdc4Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data4
            CpSv_Tdc5Data_i                 => PrSv_Tdc5Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data5
            CpSv_Tdc6Data_i                 => PrSv_Tdc6Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data6
            CpSv_Tdc7Data_i                 => PrSv_Tdc7Data_s                      , -- in  std_logic_vector(47 downto 0);    -- TDC Recv Data7
            CpSv_Tdc8Data_i                 => PrSv_Tdc8Data_s                      , -- in  std_logic_vector(47 downto 0)     -- TDC Recv Data8
            
            --------------------------------                
            -- Test_MemX|Y
            --------------------------------
            CpSl_MemXYVld_o                 => PrSl_MemXYVld_s                      , -- in std_logic;                         -- Memxy_Valid
            
            --------------------------------                
            -- MEMSCAN X/Y Data
            --------------------------------
            CpSl_MemTrig_o                  => c_mem_dastart                        , -- out std_logic;                        -- Memscan Trig
            CpSv_MemXData_o                 => c_mem_dax                            , -- out std_logic_vector(11 downto 0);    -- Memscan_X Data       
            CpSv_MemYData_o                 => c_mem_day                            , -- out std_logic_vector(11 downto 0);    -- Memscan_Y Data

            --------------------------------
            -- Fifo Interface
            --------------------------------
            CpSl_RdFifo_i                   => PrSl_RdFifo_s                        , -- in  std_logic;                        -- Fifo Read 
            CpSl_FifoDataVld_o              => PrSl_FifoDataVld_S                   , -- out std_logic;                        -- Fifo Data Valid
            CpSv_FifoData_o                 => PrSv_FifoData_s                      , -- out std_logic_vector(31 downto 0);    -- Fifo Data
            
            --------------------------------
            -- 5300ctrl Interface
            --------------------------------
    		  CpSv_pck_lenth_i                => PrSv_S0Tx_WrsR_s                     ,
    		  CpSl_start_send_o               => CpSl_start_send_s                    ,
    		  
    		  wr_memx_ram_en_i          => wr_memx_ram_en_s,                  
    		  wr_memx_ram_data_i        => wr_memx_ram_data_s,
    		  wr_memx_ram_addr_i        => wr_memx_ram_addr_s,
    		     
    		  wr_memy_ram_en_i          => wr_memy_ram_en_s,             
    		  wr_memy_ram_data_i        => wr_memy_ram_data_s,
    		  wr_memy_ram_addr_i        => wr_memy_ram_addr_s
        );
        
        adc_ltc2324_16_controller_uut : adc_ltc2324_16_controller
        port map(
            clk                             => PrSl_Clk80M_s,
            nrst                            => PrSl_ClkLocked_s,
            start_tick                      => PrSl_Ltc2423Trig_s,
            sck_out                         => F_SCK_1,
            sck_in                          => F_AD_CLKOUT_1,
            sdi0                            => F_SD0_1,
            sdi1                            => F_SD1_1,
            sdi2                            => F_SD2_1,
            sdi3                            => F_SD3_1,
            end_tick                        => c_ad_ready,
            
            CpSl_CapApdTrig_i               => PrSl_CapApdTrig_s    , -- Cap_ApdTirg  
            CpSl_CapApdVld_o                => PrSl_CpdApdVld_s     , -- Cap_ApdVld   
            ad_data0                        => PrSv_CpdApdVol_s     , -- Cap_ApdVol
            ad_data1                        => c_temper_temp,         -- Volatge Calculation
            ad_data2                        => c_memx_temp,
            ad_data3                        => c_memy_temp,
            covn                            => F_CNV 
        );

        U_M_VolApd_0 : M_VolApd
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c                             -- integer := 1                          -- Simulation
        )
        port map (
            -------------------------------- 
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- active,low
            CpSl_Clk_i                      => PrSl_Clk40M_s                        , -- in  std_logic;                        -- single 40MHz.clock
            
            --------------------------------
            -- ApdVol/Temper
            --------------------------------
            CpSl_CapApdTrig_o               => PrSl_CapApdTrig_s                    , -- out std_logic;                        -- Cap_ApdTirg
            CpSl_CapApdVld_i                => PrSl_CpdApdVld_s                     , -- in  std_logic;                        -- Apd_CapVolVld
            CpSv_CpdApdVol_i                => PrSv_CpdApdVol_s                     , -- in  std_logic_vector(15 downto 0);    -- APd_CapVol
    
            CpSl_EndTrig_i                  => c_ad_ready                           , -- in  std_logic;                        -- LTC2324 Capture End
            CpSv_TemperData_i               => c_temper_temp                        , -- in  std_logic_vector(15 downto 0);    -- Temper Data
            
            --------------------------------
            -- from Flash
            --------------------------------
            wr_av_ram_en_i                  => wr_av_ram_en_s                       , -- in std_logic;
            wr_av_ram_data_i                => wr_av_ram_data_s                     , -- in std_logic_vector(31 downto 0);
            wr_av_ram_addr_i                => wr_av_ram_addr_s                     , -- in std_logic_vector(18 downto 0);
            
            -- 16bit(Real_12bit) * 227
            wr_capav_ram_en_i               => wr_capav_ram_en_s                    , -- in std_logic;
            wr_capav_ram_data_i             => wr_capav_ram_data_s                  , -- in std_logic_vector(31 downto 0);
            wr_capav_ram_addr_i             => wr_capav_ram_addr_s                  , -- in std_logic_vector(18 downto 0);

            --------------------------------
            -- Voltage
            --------------------------------
            CpSl_WrTrig_o                   => PrSl_WrTrig_s                        , -- out std_logic;                        -- Write 5242_data
            CpSl_VolDataTrig_o              => PrSl_VolDataTrig_s                   , -- out std_logic;                        -- Voltaga Valid
            CpSv_VolData_o                  => PrSv_VolData_s                         -- out std_logic_vector(11 downto 0)     -- Voltage Data
        );
        
        U_M_apd_slt : M_apd_slt 
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c                             -- Simulation
        )
        port map(
            --------------------------------
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     =>  PrSl_ClkLocked_s                    , -- active,low
            Clk_40m_i                       =>  PrSl_Clk40M_s                       , -- single 40MHz.clock
             
            --------------------------------
            -- Rom Start Trig
            --------------------------------
            CpSl_ApdNumVld_o                => PrSl_ApdNumVld_s                     , -- out std_logic;                        -- ADP_NumVld
            CpSv_ApdNum_o                   => PrSv_ApdNum_s                        , -- out std_logic_vector(6 downto 0);     -- ADP_Num
            CpSl_apd_slt_en_i               => PrSl_apd_slt_en_s                    , -- Memory Add Trig
            ld_num_i                        => ld_num_s                             , -- Ld_Num 
            CpSl_ApdVld_i                   => PrSl_ApdVld_s                        , -- in  std_logic;                        -- APD_Valid
            CpSv_Addr_o                     => PrSv_Addr_s                          ,

    		wr_as_ram_en_i                  => wr_as_ram_en_s                       ,
    		wr_as_ram_data_i                => wr_as_ram_data_s                     ,
    		wr_as_ram_addr_i                => wr_as_ram_addr_s
        );
        -- CpSv_Addr_o
        CpSv_Addr_o <= cfg_apd_Addr_s when (test_mode_s = '1') else PrSv_Addr_s;
        
    --    CpSv_Addr_o <= "001" & x"68";
            
        U_M_I2C_0 : M_I2C
        port map (
            --------------------------------
            -- Reset&Clock
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- Reset,low active
            CpSl_Clk_i                      => PrSl_Clk40M_s                        , -- in  std_logic;                        -- Clock,Single 40M

            --------------------------------
            -- APD/Vth_Rd/Wr_Trig
            --------------------------------
            CpSl_ApdRdTrig_i                => '0'                                  , -- in  std_logic;                        -- APD_Read_Trig
            CpSl_ApdWrTrig_i                => '0'                                  , -- in  std_logic;                        -- APD_Write_Trig
            CpSl_VthRdTrig_i                => '0'                                  , -- in  std_logic;                        -- Vth_Read_Trig
            CpSl_VthWrTrig_i                => '0'                                  , -- in  std_logic;                        -- Vth_Write_Trig
            
            --------------------------------
            -- LTC2631
            --------------------------------
            CpSl_WrTrig1_i                  => PrSl_WrVthTrig_s   , -- PrSl_WrTrig1_s                       , -- in  std_logic;                        -- Wr_Trig1
            CpSl_WrTrig2_i                  => PrSl_WrTrig_s    , -- PrSl_WrTrig2_s                       , -- in  std_logic;                        -- Wr_Trig2
                                                                                     
            --------------------------------                                         
            -- Vth/APD_Interface                                                     
            --------------------------------                                         
            CpSl_ApdChannel_i               => PrSl_VolDataTrig_s                   , -- in  std_logic;                        -- AD5242_ApdChannnel
            CpSv_ApdWrData_i                => x"00"                                , -- in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
            CpSv_ApdRdData_o                => open                                 , -- out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
            CpSl_VthChannel_i               => '0'                                  , -- in  std_logic;                        -- AD5242_VthChannnel
            CpSv_VthWrData_i                => x"00"                                , -- in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
            CpSv_VthRdData_o                => open                                 , -- out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
            CpSl_Finish_o                   => open                                 , -- out std_logic;                        -- I2C_Finish
                                                                                     
            --------------------------------                                         
            -- LTC2631_Interface                                                     
            --------------------------------
            CpSv_WrVthData_i                => CpSv_WrVthData_s, -- x"266"         , -- in  std_logic_vector(11 downto 0);    -- Write_VthData                                 
            CpSv_WrTrigData_i               => PrSv_VolData_s                       , -- in  std_logic_vector(11 downto 0);    -- Write_APD_Data
            
            --------------------------------
            -- I2C_Interface
            --------------------------------
            CpSl_Scl_o                      => F_SCL                                , -- out std_logic;                        -- AD5242_Scl
            CpSl_Sda_io                     => F_SDA                                  -- inout std_logic                       -- AD5242_Sda
        );
        
        U_M_VolAgc_0 : M_VolAgc
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c,                            -- Simulation
            PrSv_PointCnt_c                 => PrSv_PointCnt_c
        )
        port map (
            -------------------------------- 
            -- Clock & Reset                
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- active,low
            CpSl_Clk_i                      => PrSl_Clk40M_s                        , -- in  std_logic;                        -- single 40MHz.clock
            
            --------------------------------
            -- Rom_Start_Trig
            --------------------------------
            CpSl_StartTrig_i                => PrSl_1usTrig_s                       , -- in  std_logic;                        -- Config AD7547
            
            --------------------------------
            -- Temper
            --------------------------------
            CpSl_EndTrig_i                  => c_ad_ready                           , -- in  std_logic;                        -- LTC2324 Capture End
            CpSv_GrayData_i                 => c_gray_temp                          , -- in  std_logic_vector(15 downto 0);    -- Gray Data

            --------------------------------
            -- Voltage
            --------------------------------
            CpSv_Gain_o                     => PrSv_Gain_s                          , -- out std_logic_vector(15 downto 0);    -- Image Gain
            CpSl_ImageVld_o                 => PrSl_ImageVld_s                      , -- out std_logic;                        -- Image Valid
            CpSl_FrameVld_o                 => PrSl_FrameVld_s                      , -- out std_logic;                        -- Frame Valid
            CpSl_VolAgcTrig_o               => PrSv_AgcDataVld_s                    , -- out std_logic;                        -- Voltaga Agc Valid
            CpSv_VolAgcData_o               => PrSv_AgcData_s                         -- out std_logic_vector(11 downto 0)     -- Voltage Agc Data
        );
        
        -- Need Gray Calculation 
        da_controller_7547_uut : da_controller_7547
        port map (
            nrst                            => PrSl_ClkLocked_s                     , --  in std_logic;
            clk                             => PrSl_Clk40M_s                        , --  in std_logic;
            da_mems_start_tick              => c_da_start                           , --  in std_logic;   -- Enthernet Recv Stop Cmd                 
            agc_da_start_tick               => PrSv_AgcDataVld_s                    , --  in std_logic;                       
            da_datax                        => c_da_datax                           , --  in std_logic_vector(11 downto 0);      
            da_datay                        => c_da_datay                           , --  in std_logic_vector(11 downto 0);
            da_data_agc                     => PrSv_AgcData_s                       , --  in std_logic_vector(11 downto 0);
                                                                                    
            da_data                         => F_DA                                 , -- out std_logic_vector(11 downto 0);
            da_wr                           => F_DWR                                , -- out std_logic;
            da_sab                          => F_DCSAB                              , -- out std_logic;
            da_cs1                          => F_DCS1                               , -- out std_logic;
            da_sc                           => F_DCSC                               , -- out std_logic;
            da_cs2                          => F_DCS2                               , -- out std_logic;
            da_finish                       => c_da_finish                            -- out std_logic    -- Enthernet Recv Stop Cmd  
        );
    	 
        ocf_ctrl_u : ocf_ctrl 
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c
        )
        port map(
            --------------------------------
            -- Reset and clock
            --------------------------------
            rst_n_i                    => PrSl_ClkLocked_s,                        -- Reset, active low
            clk_i                      => PrSl_Clk40M_s,                           -- 40MHz Clock,single

    		  
    		  test_mode_i                => test_mode_s,
            op_flash_cmd_en_i          => op_flash_cmd_en_s,
            op_flash_cmd_i             => op_flash_cmd_s,
            wr_flash_frame_req         => wr_flash_frame_req_s,
            wr_flash_frame_len         => wr_flash_frame_len_s,
            wr_flash_frame_addr        => wr_flash_frame_addr_s,
            wr_ufm_en_i                => wr_ufm_en_s,
            wr_ufm_data_i              => wr_ufm_data_s,  
            rw_flash_frame_done        => rw_flash_frame_done_s,
    		  rd_ufm_data_o              => rd_ufm_data_s,
    		  
    		  prsv_s1dportrdata_o        => prsv_s1dportrdata_s,
    		  prsv_w5300siprdata_o       => prsv_w5300siprdata_s,
    		  
    		  wr_reg_ram_en_o            => wr_reg_ram_en_s,
    		  wr_reg_ram_data_o          => wr_reg_ram_data_s,
    		  wr_reg_ram_addr_o          => wr_reg_ram_addr_s,

    		  wr_as_ram_en_o             => wr_as_ram_en_s,
    		  wr_as_ram_data_o           => wr_as_ram_data_s,
    		  wr_as_ram_addr_o           => wr_as_ram_addr_s,

    		  wr_av_ram_en_o             => wr_av_ram_en_s,
    		  wr_av_ram_data_o           => wr_av_ram_data_s,
    		  wr_av_ram_addr_o           => wr_av_ram_addr_s,

    		  wr_memx_ram_en_o          => wr_memx_ram_en_s,                  
    		  wr_memx_ram_data_o        => wr_memx_ram_data_s,
    		  wr_memx_ram_addr_o        => wr_memx_ram_addr_s,
    		     
    		  wr_memy_ram_en_o          => wr_memy_ram_en_s,             
    		  wr_memy_ram_data_o        => wr_memy_ram_data_s,
    		  wr_memy_ram_addr_o        => wr_memy_ram_addr_s,

    		  wr_gc_ram_en_o            => wr_gc_ram_en_s,             
    		  wr_gc_ram_data_o          => wr_gc_ram_data_s,
    		  wr_gc_ram_addr_o          => wr_gc_ram_addr_s,
    		    
    		  wr_cc_ram_en_o            => wr_cc_ram_en_s,             
    		  wr_cc_ram_data_o          => wr_cc_ram_data_s,
    		  wr_cc_ram_addr_o          => wr_cc_ram_addr_s,

              wr_ApdDly_ram_en_o        => wr_ApdDly_ram_en_s                       ,
              wr_ApdDly_ram_data_o      => wr_ApdDly_ram_data_s                     ,
              wr_ApdDly_ram_addr_o      => wr_ApdDly_ram_addr_s                     ,

              -- 16bit(Real_12bit) * 227
              wr_capav_ram_en_o         => wr_capav_ram_en_s                        , --- out std_logic;
              wr_capav_ram_data_o       => wr_capav_ram_data_s                      , --- out std_logic_vector(31 downto 0);
              wr_capav_ram_addr_o       => wr_capav_ram_addr_s                      , --- out std_logic_vector(18 downto 0);

              initial_done_o            => initial_done_s
        );
    		  
        U_M_Net_ds_ctrl : M_Net_ds_ctrl 
        port map(
            --------------------------------
            -- Reset and clock
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s,                    -- Reset, active low
            CpSl_Clk_i                      => PrSl_Clk40M_s,                       -- 40MHz Clock,single

            --------------------------------
            -- downstream Interface
            --------------------------------
    		  frame_fst_rcv_i                 => frame_fst_rcv_s,
            PrSl_RxPalDvld_i                => c_rcv_tick,                          -- Parallel data valid
            PrSv_RxPalData_i                => c_rcv_data,                          -- Parallel data
            rcv_data_len_i                  => c_rcv_data_len,                      -- Parallel data lenth
            --------------------------------
            -- Parallel Time Indicator
            --------------------------------
            CpSl_WrTrig1_o                  => PrSl_WrTrig1_s                       , -- out std_logic;                        -- Wr_Trig1        
            CpSl_WrTrig2_o                  => PrSl_WrTrig2_s                       , -- out std_logic;                        -- Wr_Trig2
            CpSv_Addr_o                     => cfg_apd_Addr_s                       , -- out std_logic_vector(10 downto 0)     -- Parallel Time data
            CpSv_WrVthData_o                => CpSv_WrVthData_s,
    		  PrSl_WrVthTrig_o                => PrSl_WrVthTrig_s,
    		  start1_close_en_o               => start1_close_en_s,
            start2_close_en_o               => start2_close_en_s,
            start3_close_en_o               => start3_close_en_s,
            CpSv_vxData_o                   => CpSv_vxData_s                      , 
            CpSv_vyData_o                   => CpSv_vyData_s                      , 
            CpSv_Mems_noscan_o              => CpSv_Mems_noscan_s                   ,
    		  test_mode_o                     => test_mode_s                          ,
    		  train_cmd_done                  => train_cmd_done_s,
    		  send_trig_point_num_o           => send_trig_point_num_s,
		  send_trig_close_o               => send_trig_close_s,
		  sft_rst_fpga_o                  => sft_rst_fpga_s,
    		  
            op_flash_cmd_en_o               => op_flash_cmd_en_s,
            op_flash_cmd_o                  => op_flash_cmd_s,
            wr_flash_frame_req_o            => wr_flash_frame_req_s,
            wr_flash_frame_len_o            => wr_flash_frame_len_s,
            wr_flash_frame_addr_o           => wr_flash_frame_addr_s,
            wr_ufm_en_o                     => wr_ufm_en_s,
            wr_ufm_data_o                   => wr_ufm_data_s,
            rw_flash_frame_done_i           => rw_flash_frame_done_s
        );
    	
        U_M_NetWr_0 : M_NetWr
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c
        )
        port map (
            --------------------------------
            -- Clk & Reset
            --------------------------------
            clk                             => PrSl_Clk40M_s,                       -- Clock single,40MHz
            nrst                            => PrSl_ClkLocked_s,                    -- Reset,active low
            
            --------------------------------
            -- Tick
            --------------------------------
            k_start_tick                    => c_w5300_init_result,                 -- in  std_logic;                      -- W5300 Init Done
            CpSl_1msTrig_i                  => c_clk_1ms_tick,                      -- in  std_logic;                      -- 1ms Trig
            
            --------------------------------
            -- APD_Temp
            --------------------------------
            CpSl_TemperDVld_i               => c_ad_ready                           , -- in  std_logic;                        -- LTC2324 Capture End
            CpSv_TemperData_i               => c_temper_temp                        , -- in  std_logic_vector(15 downto 0);    -- Temper Data

            --------------------------------
            -- UTC_Hex_Time
            --------------------------------
            CpSv_Lock_i                     => PrSv_Lock_s                          , -- in  std_logic_vector( 1 downto 0);    -- Gps_Lock
            CpSv_UdpTimeData_i              => PrSv_UdpTimeData_s                   , -- in  std_logic_vector(79 downto 0);   -- UTC_Hex_Time
            
            --------------------------------
            -- Enthera Data
            --------------------------------
            CpSl_HeadVld_i                  => '1',-- PrSl_HeadVld_s                       , -- in  std_logic;                       -- Recv Enther Data Vld
            CpSv_HeadData_i                 => x"A50F",-- PrSv_HeadData_s                      , -- in  std_logic_vector(15 downto 0);   -- Recv Enther Data
            CpSv_S0Tx_WrsR_o                => PrSv_S0Tx_WrsR_s                     , -- out std_logic_vector(15 downto 0);   -- S0Tx_WrsR_Data
            CpSv_UdpRdCnt_o                 => PrSv_UdpRdCnt_s                      , -- out std_logic_vector(11 downto 0);    -- UDP Read Cnt
            
            --------------------------------
            -- Frame State
            --------------------------------
            CpSl_NetSend_o                  => PrSl_NetSend_s                       , -- out std_logic;                        -- Net Start
            CpSl_StartTrig_o                => PrSl_StartTrig_s                     , -- out std_logic;                        -- Enther Start
            CpSl_StopTrig_o                 => PrSl_StopTrig_s                      , -- out std_logic;                        -- Enther Stop  
            CpSv_PointStyle_o               => PrSv_PointStyle_s                    , -- out std_logic_vector( 1 downto 0);    -- PointStyle
            CpSv_EochCnt_o                  => PrSv_EochCnt_s                       , -- out std_logic_vector( 1 downto 0);    -- Ench Cnt
            CpSl_UdpTest_o                  => PrSl_UdpTest_s                       , -- out std_logic;                        -- UDP Test Module
            
            --------------------------------
            -- Combine Data Fifo
            --------------------------------
            CpSl_RdFifo_o                   => PrSl_RdFifo_s                        , -- out std_logic;                        -- Fifo Read 
            CpSl_FifoDataVld_i              => PrSl_FifoDataVld_S                   , -- in  std_logic;                        -- Fifo Data Valid
            CpSv_FifoData_i                 => PrSv_FifoData_s                      , -- in  std_logic;                        -- Fifo Data 
            
            --------------------------------
            -- Send Frame Data
            --------------------------------
            CpSl_NetStartTrig_i             => PrSl_NetStartTrig_s                  , -- in  std_logic;                        -- NetUdp Start Trig 
            CpSl_NetRd_i                    => PrSl_NetRd_s                         , -- out std_logic;                        -- Net Read                  
            CpSl_NetDataVld_o               => PrSl_NetDataVld_s                    , -- in  std_logic;                        -- Net Recv Data Vld 
            CpSv_NetData_o                  => PrSl_NetData_s                       , -- in  std_logic_vector(31 downto 0);    -- Net Recv Data     
            send_tick                       => c_send_start_tick                      -- out std_logic                     
        );
        
        U_W5300_DELAY_NRST : delay_nrst
        generic map (
            TIME_CNT                        => 10
        )                                                                           
        port map (                                                                  
    	    clk                             => PrSl_Clk40M_s,                        
    	    nrst                            => PrSl_ClkLocked_s,                              
    	    nrst_ctrl                       => c_w5300_nrst_ctrl,
    	    CpSl_W5300Init_i                => PrSl_W5300Init_s, -- : in  std_logic;	                    -- W5300 Init

    	    tick_cnt                        => c_clk_10us_tick, -- c_1us_tick,
    	    d_nrst                          => c_w5300_nrst	        
        );

        U_M_W5300Ctrl_0 : M_W5300Ctrl
        generic map (
            PrSl_Sim_c                      => PrSl_Sim_c
        )
        port map (
            --------------------------------
            -- Clock & Reset                
            --------------------------------
    	    clk                             => PrSl_Clk40M_s,
    	    nrst                            => PrSl_ClkLocked_s,
		 initial_done_i                  => initial_done_s,
    	    --------------------------------
            -- Tick
            --------------------------------
    	    tick_1us                        => c_1us_tick, 
    	    tick_10us                       => c_clk_10us_tick,
    	    tick_100us                      => c_clk_100us_tick,	                
    	    tick_1ms                        => c_clk_1ms_tick, 
    	    nint_f                          => c_nint_f,
    	    
    	    ethernet_package_gap_cnt        => X"FFFF",                         	
            ethernet_package_gap            => X"0000",       	                   
    	    
    	    ethernet_nrst_ctrl              => c_w5300_nrst_ctrl,
    	    ethernet_init_start             => c_w5300_init_start,
    	    CpSl_NetInitDone_o              => c_w5300_init_result,
    	    CpSl_W5300Init_o                => PrSl_W5300Init_s                     , -- out std_logic;	                    -- W5300 Init
    	    CpSl_W5300InitSucc_o            => PrSl_W5300InitSucc_s                 , -- out std_logic;                     -- W5300 Send Data
    --	    ethernet_init_done              => c_w5300_init_finish,
    --	    ethernet_init_result            => c_w5300_init_result,
    	    
    		 frame_fst_rcv                   => frame_fst_rcv_s,
    	    rcv                             => c_rcv_tick,
    	    rcv_data                        => c_rcv_data,     
    	    rcv_data_len                    => c_rcv_data_len,     
           rw_flash_frame_done_i           => rw_flash_frame_done_s,
    		 rd_ufm_data_i                   => rd_ufm_data_s,
    		 train_cmd_done_i                => train_cmd_done_s,
    	    -------------------------------- 
    	    -- Start Send Data
    	    --------------------------------
    	    CpSl_UdpTxStopTrig_i            => PrSl_NetStopTrig_s,
    	    send_start                      => CpSl_start_send_s                     , -- in  std_logic;                        -- Net Start
    	    send_done                       => c_send_done_tick, 
    	    CpSl_NetStartTrig_o             => PrSl_NetStartTrig_s                  , -- out std_logic;                        -- NetUdp Start Trig
    	    CpSl_NetRd_o                    => PrSl_NetRd_s                         , -- out std_logic;                        -- Net Read
            CpSl_NetDataVld_i               => PrSl_NetDataVld_s                    , -- in  std_logic;                        -- Net Recv Data Vld 
            CpSv_NetData_i                  => PrSl_NetData_s                       , --来自M_NetWr模块-- in  std_logic_vector(31 downto 0);    -- Net Recv Data
    	    
    		 prsv_s1dportrdata_i             => prsv_s1dportrdata_s,
    		 prsv_w5300siprdata_i            => prsv_w5300siprdata_s,
		 sip_dport_en_i                  => sip_dport_en_s,
    	    --------------------------------
            -- Enthera Data
            --------------------------------
            CpSl_HeadVld_o                  => PrSl_HeadVld_s,                      -- out std_logic;                        -- Recv Enther Data Vld
            CpSv_HeadData_o                 => PrSv_HeadData_s,                     -- out std_logic_vector(15 downto 0);    -- Recv Enther Data
            CpSv_S0Tx_WrsR_i                => PrSv_S0Tx_WrsR_s,                    --来自M_NetWr模块 in  std_logic_vector(15 downto 0);    -- S0Tx_WrsR_Data
            CpSv_UdpRdCnt_i                 => PrSv_UdpRdCnt_s,                     -- in  std_logic_vector(11 downto 0);    -- UDP Read Cnt

            --------------------------------
            -- Control W5300
            --------------------------------
            CpSl_WrTrig_s                   => c_inter_wr,	                        -- W5300_Write_Trig
            CpSl_RdTrig_s                   => c_inter_rd,	                        -- W5300_Read_Trig
            CpSv_W5300Add_s                 => c_inter_addr,		                -- W5300_Address
            CpSv_W5300WrData_s              => c_inter_data_wr,		                -- W5300WrData
            CpSv_W5300RdData_s              => c_inter_data_rd	                    -- W5300RdData
        );	
    	
        U_M_W5300If_0 : M_W5300If
        port map(
            clk                             => PrSl_Clk40M_s,                        -- Clock single,40MHz
            nrst                            => PrSl_ClkLocked_s,                              -- Reset,active low
            inter_wr                        => c_inter_wr,	                        -- write Trig
            inter_rd                        => c_inter_rd,	                        -- Read Trig
            inter_addr                      => c_inter_addr,                        -- Address
            inter_data_in                   => c_inter_data_wr,	                    -- Reg_Data_In
            inter_data_out                  => c_inter_data_rd,                     -- time_distance_conversion
            nwr                             => F_ETH_WRN,                           -- WR
            nrd                             => F_ETH_OEN,                           -- Rd
            ncs                             => F_ETH_CSN,                           -- CS_N
            addr                            => c_eth_addr,	                        -- Enther Address (9:1)
            data                            => F_ETH_D	                            -- Enther Data
        );

        state_control_top_uut : state_control_top
        generic map(
            PrSl_Sim_c                      => PrSl_Sim_c                           -- integer := 1                          -- Simulation
        )
        port map (
            nrst                            => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            clk_125k_tick                   => c_rpiplus,                           -- in  std_logic;
            clk_1ms_tick                    => c_clk_1ms_tick,                      -- in  std_logic;
            start_tick                      => PrSl_NetSend_s, -- PrSl_StartTrig_s,                    -- in  std_logic;   -- UDP_Recv_Data_Start
            soft_reset_tick                 => PrSl_StopTrig_s,                     -- in  std_logic;
            mem_dax                         => c_mem_dax,                           -- in  std_logic_vector(11 downto 0);
            mem_day                         => c_mem_day,                           -- in  std_logic_vector(11 downto 0);
            mem_dastart                     => c_mem_dastart,                       -- in  std_logic;                    
            laser_rpi_start_start           => c_laser_rpi_start_start,             -- out std_logic;                    
            pic_tdc_procedure_start         => c_pic_tdc_procedure_start,           -- out std_logic;                    
            w5300_nrst_ctrl                 => c_w5300_nrst_ctrl,                   -- out std_logic;                    
            w5300_init_start                => c_w5300_init_start,                  -- out std_logic;                    
    --        w5300_init_finish               => c_w5300_init_finish,                 -- in  std_logic;                    
            w5300_init_result               => c_w5300_init_result,                 -- in  std_logic;                    
            CpSl_W5300InitSucc_i            => PrSl_W5300InitSucc_s                 , -- in  std_logic;
    		  initial_done_i                  => initial_done_s,
    		  da_datax                        => c_da_datax,                          -- out std_logic_vector(11 downto 0);
            da_datay                        => c_da_datay,                          -- out std_logic_vector(11 downto 0);
            da_start                        => c_da_start,                          -- out std_logic;                    
            da_finish                       => c_da_finish                          -- in  std_logic;                    
        ); 
        
        U_ET_NINT_FILTER : v_filter_2
        generic map (
    	    RESET_VALID                     => '0',
    	    RESET_VALUE                     => '1',
    	    SCALER_SIZE                     => 2,
    	    SYNC_COUNT                      => 2
    	)
        port map(
            rst                             => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            clk_filter                      => '1',
            scaler                          => "10",
            signal_in                       => F_ETH_INT,
            signal_out                      => c_nint_f
        );

        -- Generate 1ms
        ctrlCycle_simple0_uut : ctrlCycle_simple
        generic map( 
            RstValidValue                   => '0',	
            DATAWIDTH	                    => 16,
            RST_DIV	                        => 39999
        ) 
        port map(
            nrst                            => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            enable                          => '1',   	
            clk_tick                        => c_clk_1ms_tick
        );
        
        -- Generate 1us
        ctrlCycle_simple1_uut : ctrlCycle_simple
        generic map ( 
            RstValidValue                   => '0',	
            DATAWIDTH	                    => 16,
            RST_DIV	                        => 39			
        ) 
        port map(
            nrst                            => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            enable                          => '1',   	
            clk_tick                        => c_1us_tick
        );
          
        -- Generate 10us
        ctrlCycle_simple2_uut : ctrlCycle_simple
        generic map ( 
            RstValidValue                   => '0',	
            DATAWIDTH	                    => 16,
            RST_DIV	                        => 399			
        ) 
        port map (
            nrst                            => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            enable                          => '1',   	
            clk_tick                        => c_clk_10us_tick
        );

        -- Generate 100us
        ctrlCycle_simple3_uut : ctrlCycle_simple
        generic map( 
            RstValidValue                   => '0',	
            DATAWIDTH	                    => 16,
            RST_DIV	                        => 3999			
        ) 
        port map(
            nrst                            => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            enable                          => '1',   	
            clk_tick                        => c_clk_100us_tick
        );
        
        -- Generate 8us
        ctrlCycle_simple4_uut : ctrlCycle_simple
        generic map ( 
            RstValidValue                   => '0',	
            DATAWIDTH	                    => 16,
            RST_DIV	                        => 319			
        ) 
        port map (
            nrst                            => PrSl_ClkLocked_s,
            clk                             => PrSl_Clk40M_s,
            enable                          => '1',   	
            clk_tick                        => c_rpiplus
        );

        U_M_GpsTop_0 : M_GpsTop
        port map (
            --------------------------------
            -- Reset and clock
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- Reset, active low
            CpSl_Clk_i                      => PrSl_Clk40M_s                        , -- 40MHz Clock,single

            --------------------------------
            -- Uart Receive Interface
            --------------------------------
            CpSl_RxD_i                      => F_GPS_UART_RX                        , -- Receive GPS Data

            --------------------------------
            -- Parallel Time Indicator
            --------------------------------
            CpSl_TimeDvld_o                 => PrSl_TimeDvld_s                      , -- Parallel Time data valid
            CpSv_YmdHmsData_o               => PrSv_YmdHmsData_s                      -- Parallel Time data
        );

        U_M_CtrlTime_0 : M_CtrlTime
        port map (
            --------------------------------
            -- Reset & Clock
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- Reset, active low
            CpSl_Clk_i                      => PrSl_Clk40M_s                        , -- in  std_logic;                        -- 40MHz Clock,single
            
            --------------------------------
            -- GPS_Time
            --------------------------------
            CpSl_TimeDvld_i                 => PrSl_TimeDvld_s                      , -- in  std_logic;                        -- Parallel Time data valid
            CpSv_YmdHmsData_i               => PrSv_YmdHmsData_s                    , -- in  std_logic_vector(79 downto 0);    -- Parallel HMS data
            CpSl_GpsPPS_i                   => F_PPS                                , -- in  std_logic;                        -- GPS_PPS

            --------------------------------
            -- Out_Time
            --------------------------------
            CpSv_Lock_o                     => PrSv_Lock_s                          , -- out std_logic_vector( 1 downto 0);    -- GPS Locked State
            CpSv_UdpTimeData_o              => PrSv_UdpTimeData_s                     -- out std_logic_vector(79 downto 0)     -- UDP Time Data
        );

        U_M_TdcGpx2_0 : M_TdcGpx2
        generic map (
    		PrSl_Sim_c                      => PrSl_Sim_c                           -- Simulation
    	)
        port map (
    		--------------------------------
    		-- Clk & Reset
    		--------------------------------
    		CpSl_Rst_i						=> PrSl_ClkLocked_s                     , -- in  std_logic;						-- Reset,Active_low
    		CpSl_Clk_i						=> PrSl_Clk40M_s                        , -- in  std_logic;						-- Clock,Single_40Mhz
            CpSl_Clk200M_i                  => PrSl_Clk200M_s                       , -- in  std_logic;                        -- Clock,Single_200MHz                                                                 
    		
    		--------------------------------                               
    		-- Start/CapEnd_Trig                                                  
    		--------------------------------                               
    		CpSl_StartTrig_i				=> c_pic_tdc_procedure_start            , -- in  std_logic;						-- Start Trig
            CpSl_TdcCapEnd_i                => PrSl_TdcCapEnd_s                     , -- out std_logic;                        -- TdcCapEnd_Trig
            CpSv_LdNum_i                    => PrSl_TdcLdnum_s                      , -- in  std_logic_vector(1 downto 0);   
            CpSl_Start1_i                   => PrSl_Start1_s                        ,-- CpSl_Start1
            CpSl_Start2_i                   => PrSl_Start2_s                        ,-- CpSl_Start2
            CpSl_Start3_i                   => PrSl_Start3_s                        ,-- CpSl_Start3
            CpSl_Clk5M_i                    => PrSl_Clk5M_s                         ,-- CpSl_Clk5M
            CpSl_RstId_i                    => CpSl_RstId_s                         ,-- CpSl_RstId
            CpSl_RstId1_i                   => CpSl_RstId1_s                        ,-- CpSl_RstId1
            --------------------------------
    		-- SPI_IF                       
    		--------------------------------                               
    		CpSl_SSN_o						=> F_SSN                                , -- out std_logic;						-- TDC_GPX2_SSN
    		CpSl_SClk_o						=> F_SCK                                , -- out std_logic;						-- TDC_GPX2_SCLK
    		CpSl_MOSI_o						=> F_MOSI                               , -- out std_logic;						-- TDC_GPX2_MOSI
    		CpSl_MISO_i						=> F_MISO                               , -- in  std_logic;						-- TDC_GPX2_MISO
            
            CpSl_SSN1_o						=> F_SSN_1                              , -- out std_logic;						-- TDC_GPX2_SSN
    		CpSl_SClk1_o                    => F_SCK_T                              , -- out std_logic;						-- TDC_GPX2_SCLK
    		CpSl_MOSI1_o                    => F_MOSI_1                             , -- out std_logic;						-- TDC_GPX2_MOSI
    		CpSl_MISO1_i                    => F_MISO_1                             , -- in  std_logic;						-- TDC_GPX2_MISO
            
            --------------------------------
            -- Disable Signal
            --------------------------------
            CpSl_LadarTrig_i                => PrSl_LadarTrig_s                     , -- in  std_logic;                     -- Start  Trig
            CpSl_TestPulse_o                => PrSl_TestPulse_s                     , -- out std_logic;                        -- TDC_GPX2_Test_Pulse
            
            --------------------------------
            -- Image_Data
            --------------------------------
            CpSl_ImageVld_i                 => PrSl_ImageVld_s                      , -- in  std_logic;                        -- Image Valid
            CpSl_FrameVld_i                 => PrSl_FrameVld_s                      , -- in  std_logic;                        -- Frame Valid

            --------------------------------
            -- Apd_Address/Num
            --------------------------------
            CpSl_ApdNumVld_i                => PrSl_ApdNumVld_s                     , -- in  std_logic;                        -- ADP_NumVld
            CpSv_ApdNum_i                   => PrSv_ApdNum_s                        , -- in  std_logic_vector( 6 downto 0);    -- ADP_Num   
            CpSl_ApdAddr_i                  => PrSv_Addr_s                          , -- in  std_logic_vector(10 downto 0);    -- APD_Address  
    
            --------------------------------
            -- Apd_Channel_Dly(Num : 96)
            --------------------------------
            CpSl_ApdDlyEn_i                 => wr_ApdDly_ram_en_s                   , -- in  std_logic;                        -- ADP_ApdChannel_DlyEn
            CpSv_ApdDlyData_i               => wr_ApdDly_ram_data_s                 , -- in  std_logic_vector(31 downto 0);    -- ADP_ApdChannel_DlyData  
            CpSv_ApdDlyAddr_i               => wr_ApdDly_ram_addr_s                 , -- in  std_logic_vector(18 downto 0);    -- ADP_ApdChannel_DlyAddress

    		--------------------------------
    		-- LVDS_Interface
    		--------------------------------                      
    		-- TDC0
    		CpSl_RefClkP_i					=> PrSl_RefClkP_s                       , -- in  std_logic;						-- TDC_GPX2_Clk_i
    		CpSl_Intertupt_i				=> F_INTERRUPT                          , -- in  std_logic;						-- TDC_GPX2_Interrupt
            CpSl_Frame1_i					=> PrSl_Frame1_s                        , -- in  std_logic;						-- TDC_GPX2_Frame1
    		CpSl_Frame2_i					=> PrSl_Frame2_s                        , -- in  std_logic;						-- TDC_GPX2_Frame2
    		CpSl_Frame3_i					=> PrSl_Frame3_s                        , -- in  std_logic;						-- TDC_GPX2_Frame3
    		CpSl_Frame4_i					=> PrSl_Frame4_s                        , -- in  std_logic;						-- TDC_GPX2_Frame4
    		CpSl_Sdo1_i	     				=> PrSl_Sdo1_s	                        , -- in  std_logic;						-- TDC_GPX2_SDO1
    		CpSl_Sdo2_i	 	    		    => PrSl_Sdo2_s	                        , -- in  std_logic;						-- TDC_GPX2_SDO2
    		CpSl_Sdo3_i	     				=> PrSl_Sdo3_s	                        , -- in  std_logic;						-- TDC_GPX2_SDO3
    		CpSl_Sdo4_i	 	    		    => PrSl_Sdo4_s	                        , -- in  std_logic;						-- TDC_GPX2_SDO4
    		
    		-- TDC1
    		CpSl_RefClk1P_i					=> PrSl_RefClkP1_s                      , -- in  std_logic;						-- TDC_GPX2_Clk_i
            CpSl_Frame5_i					=> PrSl_Frame5_s                        , -- in  std_logic;						-- TDC_GPX2_Frame5
    		CpSl_Frame6_i					=> PrSl_Frame6_s                        , -- in  std_logic;						-- TDC_GPX2_Frame6
    		CpSl_Frame7_i					=> PrSl_Frame7_s                        , -- in  std_logic;						-- TDC_GPX2_Frame7
    		CpSl_Frame8_i					=> PrSl_Frame8_s                        , -- in  std_logic;						-- TDC_GPX2_Frame8
    		CpSl_Sdo5_i	     				=> PrSl_Sdo5_s                          , -- in  std_logic;						-- TDC_GPX2_SDO5
    		CpSl_Sdo6_i	 	    		    => PrSl_Sdo6_s                          , -- in  std_logic;						-- TDC_GPX2_SDO6
    		CpSl_Sdo7_i	     				=> PrSl_Sdo7_s                          , -- in  std_logic;						-- TDC_GPX2_SDO7
    		CpSl_Sdo8_i	 	    		    => PrSl_Sdo8_s                          , -- in  std_logic;						-- TDC_GPX2_SDO8
            
            --------------------------------                                                    
    		-- PC->FPGA_Constant                                                                
    		--------------------------------                                                    
            CpSl_GrayEn_i                   => wr_gc_ram_en_s                       , -- in  std_logic;                        -- Gray_En  
            CpSv_GrayData_i                 => wr_gc_ram_data_s                     , -- in  std_logic_vector(31 downto 0);    -- Gray_Data
            CpSv_GrayAddr_i                 => wr_gc_ram_addr_s                     , -- in  std_logic_vector(18 downto 0);    -- Gray_Addr

            CpSl_DistEn_i                   => wr_cc_ram_en_s                       , -- in  std_logic;                        -- Dist_En  
            CpSv_DistData_i                 => wr_cc_ram_data_s                     , -- in  std_logic_vector(31 downto 0);    -- Dist_Data
            CpSv_DistAddr_i                 => wr_cc_ram_addr_s                     , -- in  std_logic_vector(18 downto 0);    -- Dist_Addr        

            CpSl_GroupRd_o                  => PrSl_GroupRd_s                       , -- out std_logic;                        -- Group_Rd
            CpSl_GroupRdData_i              => PrSl_GroupRdData_s                   , -- in  std_logic;                        -- Group_RdData

    		--------------------------------
    		-- Wave/Gray_OutPut
    		--------------------------------
    		CpSl_Echo1Vld_o                 => PrSl_Echo1Vld_s                      , -- out std_logic;                        -- Echo1Valid
            CpSv_Echo1Wave1_o               => PrSv_Echo1Wave1_s                    , -- out std_logic_vector(18 downto 0);    -- Echo1Wave1
            CpSv_Echo1Gray1_o               => PrSv_Echo1Gray1_s                    , -- out std_logic_vector(15 downto 0);    -- Echo1Gary1
            CpSv_Echo2Wave1_o               => PrSv_Echo2Wave1_s                    , -- out std_logic_vector(18 downto 0);    -- Echo2Wave1
            CpSv_Echo2Gray1_o               => PrSv_Echo2Gray1_s                    , -- out std_logic_vector(15 downto 0);    -- Echo2Gary1
            CpSv_Echo3Wave1_o               => PrSv_Echo3Wave1_s                    , -- out std_logic_vector(18 downto 0);    -- Echo3Wave1
            CpSv_Echo3Gray1_o               => PrSv_Echo3Gray1_s                    , -- out std_logic_vector(15 downto 0);    -- Echo3Gary1
            PrSv_EchoPW20_o                 => PrSv_EchoPW20_s                      , 
    		--------------------------------
    		-- TDC_Debug
    		--------------------------------
            CpSl_TdcDataVld_o               => PrSl_TdcDataVld_s                   , -- out std_logic;                        -- TDC_Recv_Data Valid
            CpSv_Tdc1Data_o                 => PrSv_Tdc1Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data1
            CpSv_Tdc2Data_o                 => PrSv_Tdc2Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data2
            CpSv_Tdc3Data_o                 => PrSv_Tdc3Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data3
            CpSv_Tdc4Data_o                 => PrSv_Tdc4Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data4
            CpSv_Tdc5Data_o                 => PrSv_Tdc5Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data5
            CpSv_Tdc6Data_o                 => PrSv_Tdc6Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data6
            CpSv_Tdc7Data_o                 => PrSv_Tdc7Data_s                     , -- out std_logic_vector(47 downto 0);    -- TDC Recv Data7
            CpSv_Tdc8Data_o                 => PrSv_Tdc8Data_s                       -- out std_logic_vector(47 downto 0)     -- TDC Recv Data8
        );
        
        ------------------------------------
        -- Generate_TdcSimData
        ------------------------------------
        U_M_TestTdc_0 : M_TestTdc
        port map (
            --------------------------------
            -- Clock & Reset
            --------------------------------
            CpSl_Rst_iN                     => PrSl_ClkLocked_s                     , -- in  std_logic;                        -- Reset_activelow
            CpSl_Clk200M_i                  => F_LCLK_OUT_P                         , -- in  std_logic;                        -- 200MHz
            
            --------------------------------
            -- Ladar_Trig
            --------------------------------
            CpSl_Start1_i                   => PrSl_Start1_s                        , -- in  std_logic;
            CpSl_Start2_i                   => PrSl_Start2_s                        , -- in  std_logic;
            CpSl_Start3_i                   => PrSl_Start3_s                        , -- in  std_logic;
            
            --------------------------------
            -- TDC_Data
            --------------------------------
            CpSl_RefClkP_o					=> PrSl_SimRefClkP_s                    , -- out std_logic;						-- TDC_GPX2_Clk_i
            
            -- TDC0
    		CpSl_Frame1_o					=> PrSl_SimFrame1_s                     , -- out std_logic;						-- TDC_GPX2_Frame1_low
    		CpSl_Frame2_o					=> PrSl_SimFrame2_s                     , -- out std_logic;						-- TDC_GPX2_Frame2_30%
    		CpSl_Frame3_o					=> PrSl_SimFrame3_s                     , -- out std_logic;						-- TDC_GPX2_Frame3_Low
    		CpSl_Frame4_o					=> PrSl_SimFrame4_s                     , -- out std_logic;						-- TDC_GPX2_Frame4_30%
    		CpSl_Sdo1_o	     				=> PrSl_SimSdo1_s                       , -- out std_logic;						-- TDC_GPX2_SDO1
    		CpSl_Sdo2_o	 	    		    => PrSl_SimSdo2_s                       , -- out std_logic;						-- TDC_GPX2_SDO2
    		CpSl_Sdo3_o	     				=> PrSl_SimSdo3_s                       , -- out std_logic;						-- TDC_GPX2_SDO3
    		CpSl_Sdo4_o	 	    		    => PrSl_SimSdo4_s                       , -- out std_logic;						-- TDC_GPX2_SDO4
            CpSl_Frame5_o                   => PrSl_SimFrame5_s                     , -- out std_logic;                     -- TDC_GPX2_Frame5_50%
            CpSl_Frame6_o                   => PrSl_SimFrame6_s                     , -- out std_logic;                     -- TDC_GPX2_Frame6_90%
            CpSl_Frame7_o                   => PrSl_SimFrame7_s                     , -- out std_logic;                     -- TDC_GPX2_Frame7_50%
            CpSl_Frame8_o                   => PrSl_SimFrame8_s                     , -- out std_logic;                     -- TDC_GPX2_Frame8_90%
            CpSl_Sdo5_o                     => PrSl_SimSdo5_s                       , -- out std_logic;                     -- TDC_GPX2_SDO5
            CpSl_Sdo6_o                     => PrSl_SimSdo6_s                       , -- out std_logic;                     -- TDC_GPX2_SDO6
            CpSl_Sdo7_o                     => PrSl_SimSdo7_s                       , -- out std_logic;                     -- TDC_GPX2_SDO7
            CpSl_Sdo8_o                     => PrSl_SimSdo8_s                         -- out std_logic                      -- TDC_GPX2_SDO8
        );
        
        ------------------------------------
        -- Choice_Tdc_Data
        ------------------------------------     
        -- Choice_Data
    --    PrSl_Choice_TdcData_s <= '0';
        PrSl_Choice_TdcData_s <= PrSl_SimTdcData_c;
        
        PrSl_RefClkP_s  <= F_LCLK_OUT_P  when (PrSl_Choice_TdcData_s = '1') else PrSl_SimRefClkP_s;
        PrSl_RefClkP1_s <= F_LCLK_OUT_1P when (PrSl_Choice_TdcData_s = '1') else PrSl_SimRefClkP_s;
        PrSl_Frame1_s   <= F_FRAME1_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame1_s; 
        PrSl_Frame2_s   <= F_FRAME2_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame2_s; 
        PrSl_Frame3_s   <= F_FRAME3_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame3_s; 
        PrSl_Frame4_s   <= F_FRAME4_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame4_s; 
        PrSl_Sdo1_s	    <= F_SD1_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo1_s  ; 
        PrSl_Sdo2_s	    <= F_SD2_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo2_s  ; 
        PrSl_Sdo3_s	    <= F_SD3_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo3_s  ; 
        PrSl_Sdo4_s	    <= F_SD4_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo4_s  ; 
        PrSl_Frame5_s   <= F_FRAME5_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame5_s; 
        PrSl_Frame6_s   <= F_FRAME6_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame6_s; 
        PrSl_Frame7_s   <= F_FRAME7_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame7_s; 
        PrSl_Frame8_s   <= F_FRAME8_P    when (PrSl_Choice_TdcData_s = '1') else PrSl_SimFrame8_s; 
        PrSl_Sdo5_s     <= F_SD5_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo5_s  ; 
        PrSl_Sdo6_s     <= F_SD6_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo6_s  ; 
        PrSl_Sdo7_s     <= F_SD7_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo7_s  ; 
        PrSl_Sdo8_s     <= F_SD8_P       when (PrSl_Choice_TdcData_s = '1') else PrSl_SimSdo8_s  ; 
        
        
        ------------------------------------        
        -- OutPut Signal 
        ------------------------------------
        F_START1 <= PrSl_Start1_s;
        F_START2 <= PrSl_Start2_s;
        F_START3 <= PrSl_Start3_s;
    	F_ETH_RSTN  <= c_w5300_nrst;
    	F_ETH_A     <= c_eth_addr(9 downto 1);
        F_SDR_DDR0  <= '0';
    	
    ----------------------------------------
    -- End
    ----------------------------------------
    end arch_M_Top;