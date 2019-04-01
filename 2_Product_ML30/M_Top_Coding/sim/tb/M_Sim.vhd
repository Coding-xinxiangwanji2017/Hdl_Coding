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
-- 文件名称  :  M_Sim.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  $GNRMC,235945.000,V,4542.284737,N,12636.885076,E,0.000,0.000,110611,,E,N*29
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library unisim;
--use unisim.vcomponents.all;

--LIBRARY altera_mf;
--USE altera_mf.all; 

entity M_Sim is 
end M_Sim;

architecture arch_M_Sim of M_Sim is 
    
--    39 32 2A 4E 2C 45 2C 2C 
--    31 31 36 30 31 31 2C 30    
--    30 30 2E 30 2C 30 30 30    
--    2E 30 2C 45 2C 36 37 30    
--    35 38 38 2E 36 33 36 32    
--    31 2C 4E 2C 37 33 37 34    
--    38 32 2E 32 34 35 34 2C    
--    56 2C 30 30 30 2E 35 34             
--    39 35 33 32 2C 43 4D 52 
--    4E 47 24

    ----------------------------------------------------------------------------
    -- Constant declaration
    ----------------------------------------------------------------------------
    constant PrSl_Sim_c                 : integer := 0;
    constant PrSv_RxData_s              : std_logic_vector(750 downto 0) :=  '1'&x"39"&'0'&'1'&x"32"&'0'&'1'&x"2A"&'0'&'1'&x"4E"&'0'&'1'&x"2C"&'0'&'1'&x"45"&'0'&'1'&x"2C"&'0'&'1'&x"2C"&'0'
                                                                            &'1'&x"31"&'0'&'1'&x"31"&'0'&'1'&x"36"&'0'&'1'&x"30"&'0'&'1'&x"31"&'0'&'1'&x"31"&'0'&'1'&x"2C"&'0'&'1'&x"30"&'0'
                                                                            &'1'&x"30"&'0'&'1'&x"30"&'0'&'1'&x"2E"&'0'&'1'&x"30"&'0'&'1'&x"2C"&'0'&'1'&x"30"&'0'&'1'&x"30"&'0'&'1'&x"30"&'0'
                                                                            &'1'&x"2E"&'0'&'1'&x"30"&'0'&'1'&x"2C"&'0'&'1'&x"45"&'0'&'1'&x"2C"&'0'&'1'&x"36"&'0'&'1'&x"37"&'0'&'1'&x"30"&'0'
                                                                            &'1'&x"35"&'0'&'1'&x"38"&'0'&'1'&x"38"&'0'&'1'&x"2E"&'0'&'1'&x"36"&'0'&'1'&x"33"&'0'&'1'&x"36"&'0'&'1'&x"32"&'0'
                                                                            &'1'&x"31"&'0'&'1'&x"2C"&'0'&'1'&x"4E"&'0'&'1'&x"2C"&'0'&'1'&x"37"&'0'&'1'&x"33"&'0'&'1'&x"37"&'0'&'1'&x"34"&'0'
                                                                            &'1'&x"38"&'0'&'1'&x"32"&'0'&'1'&x"2E"&'0'&'1'&x"32"&'0'&'1'&x"34"&'0'&'1'&x"35"&'0'&'1'&x"34"&'0'&'1'&x"2C"&'0'
                                                                            &'1'&x"56"&'0'&'1'&x"2C"&'0'&'1'&x"30"&'0'&'1'&x"30"&'0'&'1'&x"30"&'0'&'1'&x"2E"&'0'&'1'&x"35"&'0'&'1'&x"34"&'0'
                                                                            &'1'&x"39"&'0'&'1'&x"35"&'0'&'1'&x"33"&'0'&'1'&x"32"&'0'&'1'&x"2C"&'0'&'1'&x"43"&'0'&'1'&x"4D"&'0'&'1'&x"52"&'0'
                                                                            &'1'&x"4E"&'0'&'1'&x"47"&'0'&'1'&x"24"&'0'&'1';    -- 751 bit
                                                                
    ----------------------------------------------------------------------------
    -- Component declaration
    ----------------------------------------------------------------------------
    component M_Top is
    generic (
        PrSl_Sim_c                      : integer := 1;                         -- Simulation
        PrSl_DebugApd_c                 : integer := 1;                         -- Normal_APD
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
    end component;
        
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

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal CLK_40MHz_IN                : std_logic;	                    -- single clock,40MHz 
    signal LVRESETN                    : std_logic;	                    -- active low 
    signal F_STOP                      : std_logic;                      -- Modified To ACK AS OEN USED BY TDC-GPX
    signal PrSl_Start1_s               : std_logic;
    signal PrSl_Start2_s               : std_logic;
    signal PrSl_Start3_s               : std_logic;
    
    signal F_GAINRST                   : std_logic;
    signal F_RPI                       : std_logic;
    signal F_DA                        : std_logic_vector(11 downto 0);
    signal F_DCSA                      : std_logic;
    signal F_DCSB                      : std_logic;
    signal F_DCSC                      : std_logic;
    signal F_DWR	                   : std_logic;
    
    --------------------------------
    -- GPS & PPS
    --------------------------------
    signal F_PPS                       : std_logic;                      -- GPS_PPS
    signal F_GPS_UART_RX               : std_logic;                      -- GPS_Rx_Data
        
    --------------------------------
    -- LTC2324_Interface
    --------------------------------
    signal F_CNV                       : std_logic;
    signal F_SDR_DDR0                  : std_logic;
    signal F_CMOS_LVDS0                : std_logic;
    signal F_SDR_DDR1                  : std_logic;
    signal F_CMOS_LVDS1                : std_logic;
    signal F_SCK_1                     : std_logic;
    signal F_SD0_1                     : std_logic;
    signal F_SD1_1                     : std_logic;
    signal F_SD2_1                     : std_logic;
    signal F_SD3_1                     : std_logic;
    signal F_SCK_P                     : std_logic;
    signal F_SDO0_P                    : std_logic;
    signal F_SDO1_P                    : std_logic;
    signal F_SDO2_P                    : std_logic;
    signal F_SDO3_P                    : std_logic;
    signal F_AD_CLKOUT_P               : std_logic;
    signal F_AD_CLKOUT_1               : std_logic;  
    signal F_AD_CLKOUT_ENABLE          : std_logic;

    --------------------------------
    -- TDC_GPX2_Interface
    --------------------------------
    signal F_CLKOUT_P                  : std_logic;         -- Not Found Input Signal 
    signal F_FRAME1_P                  : std_logic;
    signal F_SD1_P                     : std_logic;
    signal F_FRAME2_P                  : std_logic;
    signal F_SD2_P                     : std_logic;
    signal F_FRAME3_P                  : std_logic;
    signal F_SD3_P                     : std_logic;
    signal F_FRAME4_P                  : std_logic;
    signal F_SD4_P                     : std_logic;
    signal F_LCLK_OUT_P                : std_logic;                       -- GPX(Pin_18)
    signal F_LCLK_IN_P                 : std_logic;                       -- GPX(Pin_63)
    signal F_DISABLE_P                 : std_logic;
    signal F_REFCLK_P                  : std_logic;                       -- RefClk_Open
    signal F_RSTIDX_P                  : std_logic;
    signal F_PARITY                    : std_logic;
    signal F_INTERRUPT                 : std_logic;
    signal F_SSN                       : std_logic;
    signal F_SCK                       : std_logic;
    signal F_MOSI                      : std_logic;
    signal F_MISO                      : std_logic;
    signal F_LCLKIN_P                  : std_logic;                       -- open 
    signal F_HV_ENABLE                 : std_logic;
    signal F_SHDN                      : std_logic;
    signal F_SDA                       : std_logic;
    signal F_SCL                       : std_logic;
    signal CpSl_GpsPPS_i               : std_logic;                      -- GPS_PPS 
    signal CpSl_GpsRxD_i               : std_logic;                      -- GPS_Rx
    signal F_ETH_D                     : std_logic_vector(15 downto 0);
    signal F_ETH_A                     : std_logic_vector( 9 downto 1);
    signal F_ETH_WRN                   : std_logic;
    signal F_ETH_OEN                   : std_logic;
    signal F_ETH_CSN                   : std_logic;
    signal F_ETH_RSTN                  : std_logic;
    signal F_ETH_INT                   : std_logic;

    -- Sim_Tdc_Data
    signal PrSl_StartTrig_s             : std_logic;                            -- Ladar Start Trig
    signal CpSl_Clk200M_i               : std_logic;                            -- 200MHz
    signal CpSl_RefClkP_i               : std_logic;                            -- TDC_GPX2_Clk_i    
    signal CpSl_Frame1_i                : std_logic;                            -- TDC_GPX2_Frame1_lo
    signal CpSl_Frame2_i                : std_logic;                            -- TDC_GPX2_Frame2_30
    signal CpSl_Frame3_i                : std_logic;                            -- TDC_GPX2_Frame3_Lo
    signal CpSl_Frame4_i                : std_logic;                            -- TDC_GPX2_Frame4_30
    signal CpSl_Sdo1_i	                : std_logic;                            -- TDC_GPX2_SDO1         
    signal CpSl_Sdo2_i	                : std_logic;                            -- TDC_GPX2_SDO2         
    signal CpSl_Sdo3_i	                : std_logic;                            -- TDC_GPX2_SDO3         
    signal CpSl_Sdo4_i	                : std_logic;                            -- TDC_GPX2_SDO4         
    signal CpSl_Frame5_i                : std_logic;                            -- TDC_GPX2_Frame5   
    signal CpSl_Frame6_i                : std_logic;                            -- TDC_GPX2_Frame6   
    signal CpSl_Frame7_i                : std_logic;                            -- TDC_GPX2_Frame7   
    signal CpSl_Frame8_i                : std_logic;                            -- TDC_GPX2_Frame8   
    signal CpSl_Sdo5_i                  : std_logic;                            -- TDC_GPX2_SDO5     
    signal CpSl_Sdo6_i                  : std_logic;                            -- TDC_GPX2_SDO6     
    signal CpSl_Sdo7_i                  : std_logic;                            -- TDC_GPX2_SDO7     
    signal CpSl_Sdo8_i                  : std_logic;                            -- TDC_GPX2_SDO8
    

begin
    ------------------------------------
    -- Compoonent map
    ------------------------------------
    U_M_Top_0 : M_Top
    generic map (
        PrSl_Sim_c                      => PrSl_Sim_c,                          -- Simulation
        PrSl_DebugApd_c                 => 0,                                   -- Normal_APD
        PrSv_PointCnt_c                 => x"04" -- 4
    )
    port map (
        CLK_40MHz_IN                    => CLK_40MHz_IN,	                   -- single clock,40MHz 
        LVRESETN                        => LVRESETN    ,	                   -- active low 
        
        --------------------------------
        -- Laser Driver Related Signals
        --------------------------------
        F_CapTrig                       => open,                      -- ADLink Capture Trig
        F_START1                        => PrSl_Start1_s, 
        F_START2                        => PrSl_Start2_s,
        F_START3                        => PrSl_Start3_s,
        F_GAINRST                       => F_GAINRST,                     -- Control Gain
        F_RPI                           => F_RPI    ,                     -- No Used

        --------------------------------
        -- AD5447 Interface
        --------------------------------
        F_DA                            => open ,        -- DA5447_Data
        F_DWR                           => open ,       
        F_DCSAB                         => open ,        -- X/Y Channel
        F_DCS1                          => open ,        -- X/Y CS1
        F_DCSC                          => open ,        -- Gain/9601Level Channel
        F_DCS2                          => open ,        -- Gain/9601Level CS2
        
        --------------------------------
        -- I2C Interface
        -------------------------------- 
        F_SDA                           => F_SDA,
        F_SCL                           => open ,
        
        --------------------------------
        -- GPS & PPS
        --------------------------------
        F_PPS                           => F_PPS,                               -- GPS_PPS
        F_GPS_UART_RX                   => F_GPS_UART_RX,                       -- GPS_Rx_Data
                
        --------------------------------
        -- LTC2324_Interface
        --------------------------------
        F_CNV                           => open ,
        F_SDR_DDR0                      => open ,
        F_SCK_1                         => open ,
        F_SD0_1                         => F_SD0_1           , 
        F_SD1_1                         => F_SD1_1           , 
        F_SD2_1                         => F_SD2_1           , 
        F_SD3_1                         => F_SD3_1           , 
        F_AD_CLKOUT_1                   => F_AD_CLKOUT_1,
       
        --------------------------------
        -- TDC_GPX2_Interface
        --------------------------------
        -- TDC_0
        F_FRAME1_P                      => CpSl_Frame1_i        , -- in  std_logic; 
        F_SD1_P                         => CpSl_Sdo1_i          , -- in  std_logic; 
        F_FRAME2_P                      => CpSl_Frame2_i        , -- in  std_logic; 
        F_SD2_P                         => CpSl_Sdo2_i	        , -- in  std_logic; 
        F_FRAME3_P                      => CpSl_Frame3_i        , -- in  std_logic; 
        F_SD3_P                         => CpSl_Sdo3_i          , -- in  std_logic; 
        F_FRAME4_P                      => CpSl_Frame4_i	    , -- in  std_logic; 
        F_SD4_P                         => CpSl_Sdo4_i	        , -- in  std_logic; 
        F_LCLK_OUT_P                    => CpSl_RefClkP_i       , -- in  std_logic;                       -- TDC_LClk_Input
        F_LCLK_IN_P                     => open , -- :  out std_logic;                       -- TDC_LClk_Output
        F_DISABLE_P                     => open , -- :  out std_logic;                       -- TDC_Enable
        F_REFCLK_P                      => open , -- :  out std_logic;                       -- 5MHz
        F_RSTIDX_P                      => open , -- :  out std_logic;                       -- Reset_Index
        F_PARITY                        => '0' , -- :  in std_logic;
        F_INTERRUPT                     => '0', -- :  in  std_logic;                       -- Interrupt
        F_SSN                           => open , --:  out std_logic;
        F_SCK                           => open , --:  out std_logic;
        F_MOSI                          => open , --:  out std_logic;
        F_MISO                          => '0' , -- :  in  std_logic;
--        F_HV_ENABLE                     :  out std_logic;
        F_SHDN                          => open      , 
        
        --------------------------------
        -- TDC_1
        --------------------------------
        F_FRAME5_P                      => CpSl_Frame5_i        ,-- :  in  std_logic;                        -- TDC_STOP5
        F_SD5_P                         => CpSl_Sdo5_i          ,-- :  in  std_logic;                        -- TDC_SDO5
        F_FRAME6_P                      => CpSl_Frame6_i        ,-- :  in  std_logic;                        -- TDC_STOP6
        F_SD6_P                         => CpSl_Sdo6_i	        ,-- :  in  std_logic;                        -- TDC_SDO6
        F_FRAME7_P                      => CpSl_Frame7_i        ,-- :  in  std_logic;                        -- TDC_STOP7
        F_SD7_P                         => CpSl_Sdo7_i          ,-- :  in  std_logic;                        -- TDC_SDO7
        F_FRAME8_P                      => CpSl_Frame8_i	    ,-- :  in  std_logic;                        -- TDC_STOP8
        F_SD8_P                         => CpSl_Sdo8_i	        ,-- :  in  std_logic;                        -- TDC_SDO8
        F_LCLK_OUT_1P                   => CpSl_RefClkP_i       , -- :  in  std_logic;                       -- TDC_Clk_Out
        F_LCLK_IN_1P                    => open , -- :  out std_logic;                       -- TDC_Ckk_In
        -- F_DISABLE_1P&F_DISABLE_P in using
        --F_DISABLE_1P                    :  out std_logic;                       -- TDC_Disable
        F_REFCLK_1P                     => open , -- :  out std_logic;                       -- TDC_RefClk
        F_RSTIDX_1P                     => open , -- :  out std_logic;                       -- TDC_RSTIDX
        
--        F_PARITY_1                      :  in  std_logic;                       -- TDC_Parity
--        F_INTERRUPT_1                 => F_INTERRUPT ,                      -- TDC_Interrupt
        F_SSN_1                         => F_SSN       ,                    -- TDC_SSN_1
        F_SCK_T                         => F_SCK       ,                    -- TDC_SCK_1
        F_MOSI_1                        => F_MOSI      ,                    -- TDC_MOSI_1
        F_MISO_1                        => F_MISO      ,                    -- TDC_MISO_1
		  
        --------------------------------
        -- Test_IF
        --------------------------------
--        F_Test_o						 		 : out  std_logic_vector(12 downto 0);   -- Test_IO
        CpSv_Addr_o                     => open , -- : out  std_logic_vector(10 downto 0);   -- Test_IO
		  
        --------------------------------
        -- W5300 Interface
        --------------------------------
        F_ETH_D                         => F_ETH_D   ,
        F_ETH_A                         => F_ETH_A   ,
        F_ETH_WRN                       => F_ETH_WRN ,
        F_ETH_OEN                       => F_ETH_OEN ,
        F_ETH_CSN                       => F_ETH_CSN ,
        F_ETH_RSTN                      => F_ETH_RSTN,
        F_ETH_INT                       => F_ETH_INT  
    );
    
    -- Start
--    F_START1 <= PrSl_Start1_s;
    
    -- Sim_TDC_Data
    U_M_TestTdc_0 : M_TestTdc 
    port map (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_iN                     => LVRESETN         , -- std_logic;                        -- Reset_activelow
        CpSl_Clk200M_i                  => CpSl_Clk200M_i    , -- std_logic;                        -- 200MHz
        
        --------------------------------
        -- Ladar_Trig
        --------------------------------
        CpSl_Start1_i                   => PrSl_Start1_s,
        CpSl_Start2_i                   => PrSl_Start2_s,
        CpSl_Start3_i                   => PrSl_Start3_s,
        
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_RefClkP_o					=> CpSl_RefClkP_i    , -- std_logic;						-- TDC_GPX2_Clk_i
        
        -- TDC0
		CpSl_Frame1_o		            => CpSl_Frame1_i     ,-- std_logic;						-- TDC_GPX2_Frame1_low
		CpSl_Frame2_o		            => CpSl_Frame2_i     ,-- std_logic;						-- TDC_GPX2_Frame2_30%
		CpSl_Frame3_o		            => CpSl_Frame3_i     ,-- std_logic;						-- TDC_GPX2_Frame3_Low
		CpSl_Frame4_o		            => CpSl_Frame4_i     ,-- std_logic;						-- TDC_GPX2_Frame4_30%
		CpSl_Sdo1_o	     	            => CpSl_Sdo1_i	     ,-- std_logic;						-- TDC_GPX2_SDO1
		CpSl_Sdo2_o	 	                => CpSl_Sdo2_i	     ,-- std_logic;						-- TDC_GPX2_SDO2
		CpSl_Sdo3_o	     	            => CpSl_Sdo3_i	     ,-- std_logic;						-- TDC_GPX2_SDO3
		CpSl_Sdo4_o	 	                => CpSl_Sdo4_i	     ,-- std_logic;						-- TDC_GPX2_SDO4

        -- TDC1                                             
        CpSl_Frame5_o                   => CpSl_Frame5_i     ,-- std_logic;                        -- TDC_GPX2_Frame5_50%
        CpSl_Frame6_o                   => CpSl_Frame6_i     ,-- std_logic;                        -- TDC_GPX2_Frame6_90%
        CpSl_Frame7_o                   => CpSl_Frame7_i     ,-- std_logic;                        -- TDC_GPX2_Frame7_50%
        CpSl_Frame8_o                   => CpSl_Frame8_i     ,-- std_logic;                        -- TDC_GPX2_Frame8_90%
        CpSl_Sdo5_o                     => CpSl_Sdo5_i       ,-- std_logic;                        -- TDC_GPX2_SDO5
        CpSl_Sdo6_o                     => CpSl_Sdo6_i       ,-- std_logic;                        -- TDC_GPX2_SDO6
        CpSl_Sdo7_o                     => CpSl_Sdo7_i       ,-- std_logic;                        -- TDC_GPX2_SDO7
        CpSl_Sdo8_o                     => CpSl_Sdo8_i        -- std_logic                         -- TDC_GPX2_SDO8
    );
    
    
    ------------------------------------
    -- Sim Reset & Clock
    ------------------------------------
    process
    begin
        LVRESETN <= '0';
        wait for 25 ns;
        LVRESETN <= '1';
        wait;
    end process;

    process
    begin 
        CLK_40MHz_IN <= '0';
        wait for 12.5 ns;
        CLK_40MHz_IN <= '1';
        wait for 12.5 ns;
    end process;
    
    process
    begin
        CpSl_Clk200M_i <= '1';
        wait for 2.5 ns;
        CpSl_Clk200M_i <= '0';
        wait for 2.5 ns;
    end process;
    
    
    -- LTC 2324
    F_SD0_1 <= '1';
    F_SD1_1 <= '1';
    F_SD2_1 <= '1';
    F_SD3_1 <= '1';
    
    
    -- PPS 
    process
    begin 
        F_PPS <= '0';
        wait for 2000 ns;
        F_PPS <= '1';
        wait for 50 ns;
        F_PPS <= '0';
        wait;
    end process;

    F_SDA <= 'Z';
    

    -- W5300  
    F_ETH_INT <= '0';
    process
    begin
        F_ETH_D <= (others => 'Z');
        wait for 200 us;
        F_ETH_D   <= x"EB90";
        wait;
    end process;
    
    ------------------------------------
    -- Uart Declaration
    ------------------------------------    
    process
        variable i : integer range 0 to 750 := 0;
        begin
        for i in 0 to 750 loop
            F_GPS_UART_RX <= PrSv_RxData_s(i);
--            CpSl_GpsRxD_i <= PrSv_RxData_s(i);
            wait for 104166 ns;
        end loop;
        wait;
    end process;
    
end arch_M_Sim;