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
-- 文件名称  :  M_TdcGpx2.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/05/17
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
        CpSl_Clk200M_i                  : in  std_logic;                        -- Clock,Single_200MHz
                                                                       
		--------------------------------                               
		-- Start/CapEnd_Trig                                             
		--------------------------------
		CpSl_StartTrig_i				: in  std_logic;						-- Start Trig
		CpSl_TdcCapEnd_i                : in  std_logic;                        -- TdcCapEnd_Trig
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);     -- LdNum
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
        
        CpSl_SSN1_o						: out std_logic;						-- TDC_GPX2_SSN
		CpSl_SClk1_o                    : out std_logic;						-- TDC_GPX2_SCLK
		CpSl_MOSI1_o                    : out std_logic;						-- TDC_GPX2_MOSI
		CpSl_MISO1_i                    : in  std_logic;						-- TDC_GPX2_MISO
        
        --------------------------------
        -- LadarTrig
        --------------------------------
        CpSl_LadarTrig_i                : in  std_logic;                        -- Start  Trig
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
		-- Wave_OutPut
		--------------------------------
		-- Echo1
		CpSl_Echo1Vld_o                 : out std_logic;                        -- Echo1Valid
        CpSv_Echo1Wave1_o               : out std_logic_vector(18 downto 0);    -- Echo1Wave1
        CpSv_Echo1Gray1_o               : out std_logic_vector(15 downto 0);    -- Echo1Gary1
--        CpSv_Echo1Wave2_o               : out std_logic_vector(18 downto 0);    -- Echo1Wave2
--        CpSv_Echo1Gray2_o               : out std_logic_vector(15 downto 0);    -- Echo1Gary2
        
        -- Echo2
--        CpSl_Echo2Vld_o                 : out std_logic;                        -- Echo2Valid
        CpSv_Echo2Wave1_o               : out std_logic_vector(18 downto 0);    -- Echo2Wave1
        CpSv_Echo2Gray1_o               : out std_logic_vector(15 downto 0);    -- Echo2Gary1
--        CpSv_Echo2Wave2_o               : out std_logic_vector(18 downto 0);    -- Echo2Wave2
--        CpSv_Echo2Gray2_o               : out std_logic_vector(15 downto 0);    -- Echo2Gary2
        
        -- Echo3
--        CpSl_Echo3Vld_o                 : out std_logic;                        -- Echo3Valid
        CpSv_Echo3Wave1_o               : out std_logic_vector(18 downto 0);    -- Echo3Wave1
        CpSv_Echo3Gray1_o               : out std_logic_vector(15 downto 0);    -- Echo3Gary1
--        CpSv_Echo3Wave2_o               : out std_logic_vector(18 downto 0);    -- Echo3Wave2
--        CpSv_Echo3Gray2_o               : out std_logic_vector(15 downto 0);    -- Echo3Gary2
        PrSv_EchoPW20_o                 : out std_logic_vector(18 downto 0); 
		--------------------------------
		-- TDC_Debug
		--------------------------------
        CpSl_TdcDataVld_o				: out std_logic;						-- TDC_Recv_Data Valid
		CpSv_Tdc1Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data1
        CpSv_Tdc2Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data2
        CpSv_Tdc3Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data3
        CpSv_Tdc4Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data4
        CpSv_Tdc5Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data5
        CpSv_Tdc6Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data6
        CpSv_Tdc7Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data7
        CpSv_Tdc8Data_o                 : out std_logic_vector(15 downto 0);    -- TDC Recv Data8
		  
		  
        tdc1_tdc3_err  : out std_logic;
        tdc2_tdc4_err  : out std_logic;
        tdc5_tdc7_err  : out std_logic;
        tdc6_tdc8_err  : out std_logic;
        tdc_err        : out std_logic
        
    );
end M_TdcGpx2;

architecture arch_M_TdcGpx2 of M_TdcGpx2 is
	----------------------------------------------------------------------------
    -- Constant Describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- Component Describe
    ----------------------------------------------------------------------------
    -- TDC_SPI_IF
    Component M_TdcSpi is
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
		-- SPI_Start_Trig
		--------------------------------
		CpSl_StartTrig_i				: in  std_logic;						-- Start Trig
        
        --------------------------------
		-- Config End Trig
		--------------------------------
        CpSl_CfgEndTrig_o               : out std_logic;                        -- Config End Trig

		-- SPI_IF
		CpSl_SSN_o						: out std_logic;						-- TDC_GPX2_SSN
		CpSl_SClk_o						: out std_logic;						-- TDC_GPX2_SCLK
		CpSl_MOSI_o						: out std_logic;						-- TDC_GPX2_MOSI
		CpSl_MISO_i						: in  std_logic 						-- TDC_GPX2_MISO
	);
    end Component;    
    
component M_Tdc_group is
    port (
		--------------------------------
		-- Clk & Reset
		--------------------------------
		CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
        clk_40m_i 						: in  std_logic;
		CpSl_Clk200M_i  				: in  std_logic;
        --------------------------------
		-- Ladar/CapEnd
		--------------------------------
        CpSl_Start1_i                   : in  std_logic;                        -- CpSl_Start1
        CpSl_Start2_i                   : in  std_logic;                        -- CpSl_Start2
        CpSl_Start3_i                   : in  std_logic;                        -- CpSl_Start3
        CpSl_Clk5M_i                    : in  std_logic;                        -- CpSl_Clk5M
        CpSl_RstId_i                    : in  std_logic;                        -- CpSl_RstId

        --------------------------------
        -- Image_Data
        --------------------------------
        CpSl_ImageVld_i                 : in  std_logic;                        -- Image Valid
        CpSl_FrameVld_i                 : in  std_logic;                        -- Frame Valid
        
		--------------------------------
		-- LVDS Interface
		--------------------------------		
        -- TDC0
		CpSl_RefClkP_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Frame1_i					: in  std_logic;						-- TDC_GPX2_Frame1_high
		CpSl_Frame2_i					: in  std_logic;						-- TDC_GPX2_Frame2_30%
		CpSl_Frame3_i					: in  std_logic;						-- TDC_GPX2_Frame3_high
		CpSl_Frame4_i					: in  std_logic;						-- TDC_GPX2_Frame4_30%
		CpSl_Sdo1_i	     				: in  std_logic;						-- TDC_GPX2_SDO1
		CpSl_Sdo2_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO2
		CpSl_Sdo3_i	     				: in  std_logic;						-- TDC_GPX2_SDO3
		CpSl_Sdo4_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO4
		
		CpSl_RefClk1P_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Frame5_i					: in  std_logic;						-- TDC_GPX2_Frame5_low
		CpSl_Frame6_i					: in  std_logic;						-- TDC_GPX2_Frame6_30%
		CpSl_Frame7_i					: in  std_logic;						-- TDC_GPX2_Frame7_Low
		CpSl_Frame8_i					: in  std_logic;						-- TDC_GPX2_Frame8_30%
		CpSl_Sdo5_i	     				: in  std_logic;						-- TDC_GPX2_SDO5
		CpSl_Sdo6_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO6
		CpSl_Sdo7_i	     				: in  std_logic;						-- TDC_GPX2_SDO7
		CpSl_Sdo8_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO8

        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_TdcDataVld_o				: out std_logic;						-- TDC_Recv_Data_Valid   
        CpSv_ld_num_o                   : out std_logic_vector(1 downto 0);     -- CpSv_ld_num_o
        CpSv_Tdc1Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc2Echo2_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc2Echo3_o                : out std_logic_vector(26 downto 0);    -- invalid    
        CpSv_Tdc3Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc4Echo2_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc4Echo3_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc5Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_o                : out std_logic_vector(26 downto 0)     -- TDC8_Echo3_Data
	);
    end component;

    component M_WalkError is
    generic (
        PrSl_DebugApd_c                 : integer := 1                          -- Debug_APD
    );
    port (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz
        
        --------------------------------
        -- Start Trig
        --------------------------------
        CpSl_Start1Trig_i               : in  std_logic;                        -- Start1_Trig
        CpSl_Start2Trig_i               : in  std_logic;                        -- Start2_Trig
        CpSl_Start3Trig_i               : in  std_logic;                        -- Start3_Trig
        
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
        -- Fifo_WalkError
        --------------------------------
        CpSl_WalkErrorRd_i              : in  std_logic;                        -- WalkError_RdCmd
        CpSl_WalkErrorRdVld_o           : out std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_o          : out std_logic_vector(20 downto 0)     -- WalkError_RdData
    );
    end component;

    component M_Data is 
    port (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
        CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
        
        --------------------------------
        -- Frame_Valid
        --------------------------------
        CpSl_FrameVld_i                 : in  std_logic;                        -- Frame Valid
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);   
        
        --------------------------------
        -- WalkError
        --------------------------------
        CpSl_WalkErrorRd_o              : out std_logic;                        -- WalkError_RdCmd
        CpSl_WalkErrorRdVld_i           : in  std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_i          : in  std_logic_vector(20 downto 0);    -- WalkError_RdData
        
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
        -- TDC_Data
        --------------------------------
        CpSl_TdcDVld0_i                 : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc1Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo1_Data
        CpSv_Tdc2Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo2_Data
        CpSv_Tdc2Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo3_Data    
        CpSv_Tdc3Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo1_Data
        CpSv_Tdc4Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo2_Data
        CpSv_Tdc4Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo3_Data
        
        CpSl_TdcDVld1_i			        : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc5Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo3_Data
        
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSv_EchoDVld_o                 : out std_logic;                        -- Echo_Data_Valid
        CpSv_Echo1Wave_o                : out std_logic_vector(18 downto 0);    -- Echo1_Wave
        CpSv_Echo1Gray_o                : out std_logic_vector(15 downto 0);    -- Echo1_Gray
        CpSv_Echo2Wave_o                : out std_logic_vector(18 downto 0);    -- Echo1_Wave
        CpSv_Echo2Gray_o                : out std_logic_vector(15 downto 0);    -- Echo1_Gray
        CpSv_Echo3Wave_o                : out std_logic_vector(18 downto 0);    -- Echo1_Wave
        CpSv_Echo3Gray_o                : out std_logic_vector(15 downto 0);    -- Echo1_Gray
		  
		  PrSv_EchoPW20_o                 : out std_logic_vector(18 downto 0)
    );    
    end component;
    
    ------------------------------------
    -- Distance
    ------------------------------------
--    Component M_TdcDistance is
--    port (
--    	--------------------------------
--    	-- Clk & Reset
--    	--------------------------------
--    	CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
--    	CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
--    
--    	--------------------------------
--    	-- TDC_Distance
--    	--------------------------------
--    	CpSl_TdcDataVld_i				: in  std_logic;						-- TDC_Recv_Data Valid
--    	CpSv_TdcData_i					: in  std_logic_vector(47 downto 0);	-- TDC Recv Data
--        
--        --------------------------------
--    	-- TDC_Distance
--    	--------------------------------
--    	CpSl_TdcDisVld_o	 			: out std_logic;						-- TDC_Recv_Data Valid
--    	CpSv_TdcDisD_o					: out std_logic_vector(47 downto 0) 	-- TDC Recv Data
--    );
--    end Component;

    ----------------------------------------------------------------------------
    -- Signal Describe
    ----------------------------------------------------------------------------
    signal PrSl_TdcDataVld_s	        : std_logic;						    -- TDC_Recv_Data Valid
    signal PrSv_TdcData_s		        : std_logic_vector(47 downto 0);        -- TDC Recv Data
    signal PrSv_Tdc2Data_s              : std_logic_vector(47 downto 0);        -- TDC Recv Data2                                                       
    signal PrSv_Tdc4Data_s              : std_logic_vector(47 downto 0);        -- TDC Recv Data4       
    signal PrSl_CfgEndTrig_s            : std_logic;                            -- SPI Config End Trig
    
    -- Gray
    signal PrSv_PulseGray_s             : std_logic_vector(15 downto 0);        -- PulseGray

    -- TDC0_Data      
    signal PrSv_ld_num_s                : std_logic_vector(1 downto 0);         
    signal PrSv_TdcDataVld_s            : std_logic;						    -- TDC_Recv_Data_Valid0
    signal PrSv_Tdc1Echo1_s             : std_logic_vector(26 downto 0);        -- TDC1_Echo1_Data    
    signal PrSv_Tdc1Echo2_s             : std_logic_vector(26 downto 0);        -- TDC1_Echo2_Data    
    signal PrSv_Tdc1Echo3_s             : std_logic_vector(26 downto 0);        -- TDC1_Echo3_Data    
    signal PrSv_Tdc2Echo1_s             : std_logic_vector(26 downto 0);        -- TDC2_Echo1_Data    
    signal PrSv_Tdc2Echo2_s             : std_logic_vector(26 downto 0);        -- TDC2_Echo2_Data    
    signal PrSv_Tdc2Echo3_s             : std_logic_vector(26 downto 0);        -- TDC2_Echo3_Data    
    signal PrSv_Tdc3Echo1_s             : std_logic_vector(26 downto 0);        -- TDC3_Echo1_Data    
    signal PrSv_Tdc3Echo2_s             : std_logic_vector(26 downto 0);        -- TDC3_Echo2_Data    
    signal PrSv_Tdc3Echo3_s             : std_logic_vector(26 downto 0);        -- TDC3_Echo3_Data    
    signal PrSv_Tdc4Echo1_s             : std_logic_vector(26 downto 0);        -- TDC4_Echo1_Data    
    signal PrSv_Tdc4Echo2_s             : std_logic_vector(26 downto 0);        -- TDC4_Echo2_Data    
    signal PrSv_Tdc4Echo3_s             : std_logic_vector(26 downto 0);        -- TDC4_Echo3_Data
                                                                                
    -- TDC1_Data                                                                
    signal PrSv_Tdc5Echo1_s             : std_logic_vector(26 downto 0);        -- TDC5_Echo1_Data    
    signal PrSv_Tdc5Echo2_s             : std_logic_vector(26 downto 0);        -- TDC5_Echo2_Data    
    signal PrSv_Tdc5Echo3_s             : std_logic_vector(26 downto 0);        -- TDC5_Echo3_Data    
    signal PrSv_Tdc6Echo1_s             : std_logic_vector(26 downto 0);        -- TDC6_Echo1_Data    
    signal PrSv_Tdc6Echo2_s             : std_logic_vector(26 downto 0);        -- TDC6_Echo2_Data    
    signal PrSv_Tdc6Echo3_s             : std_logic_vector(26 downto 0);        -- TDC6_Echo3_Data    
    signal PrSv_Tdc7Echo1_s             : std_logic_vector(26 downto 0);        -- TDC7_Echo1_Data    
    signal PrSv_Tdc7Echo2_s             : std_logic_vector(26 downto 0);        -- TDC7_Echo2_Data    
    signal PrSv_Tdc7Echo3_s             : std_logic_vector(26 downto 0);        -- TDC7_Echo3_Data    
    signal PrSv_Tdc8Echo1_s             : std_logic_vector(26 downto 0);        -- TDC8_Echo1_Data    
    signal PrSv_Tdc8Echo2_s             : std_logic_vector(26 downto 0);        -- TDC8_Echo2_Data    
    signal PrSv_Tdc8Echo3_s             : std_logic_vector(26 downto 0);        -- TDC8_Echo3_Data 

    signal PrSv_Tdc1Echo1             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc1Echo2             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc1Echo3             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc2Echo1             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc2Echo2             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc2Echo3             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc3Echo1             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc3Echo2             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc3Echo3             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc4Echo1             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc4Echo2             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc4Echo3             : std_logic_vector(21 downto 0); 
    signal PrSv_Tdc5Echo1             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc5Echo2             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc5Echo3             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc6Echo1             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc6Echo2             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc6Echo3             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc7Echo1             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc7Echo2             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc7Echo3             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc8Echo1             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc8Echo2             : std_logic_vector(21 downto 0);
    signal PrSv_Tdc8Echo3             : std_logic_vector(21 downto 0);

    signal PrSl_VldD_s                  : std_logic;                            -- vallid_data 
    signal PrSl_Echo1Vld_s              :  std_logic;                           -- Echo1_Valid 
    signal PrSv_Echo1Num_s              :  std_logic_vector( 2 downto 0);       -- Echo1_Num   
    signal PrSl_Echo2Vld_s              :  std_logic;                           -- Echo2_Valid 
    signal PrSv_Echo2Num_s              :  std_logic_vector( 2 downto 0);       -- Echo2_Num   
    signal PrSl_Echo3Vld_s              :  std_logic;                           -- Echo3_Valid 
    signal PrSv_Echo3Num_s              :  std_logic_vector( 2 downto 0);       -- Echo3_Num   
    signal PrSv_AddrEcho1_s             :  std_logic_vector( 4 downto 0);       -- Addr_Echo1  
    signal PrSv_AddrEcho2_s             :  std_logic_vector( 4 downto 0);       -- Addr_Echo2  
    signal PrSv_AddrEcho3_s             :  std_logic_vector( 4 downto 0);       -- Addr_Echo3  

    signal PrSv_Data0_s                 :  std_logic_vector(21 downto 0);       -- Data0          
    signal PrSv_Data1_s                 :  std_logic_vector(21 downto 0);       -- Data1          
    signal PrSv_Data2_s                 :  std_logic_vector(21 downto 0);       -- Data2          
    signal PrSv_Data3_s                 :  std_logic_vector(21 downto 0);       -- Data3          
    signal PrSv_Data4_s                 :  std_logic_vector(21 downto 0);       -- Data4          
    signal PrSv_Data5_s                 :  std_logic_vector(21 downto 0);       -- Data5          
    signal PrSv_Data6_s                 :  std_logic_vector(21 downto 0);       -- Data6          
    signal PrSv_Data7_s                 :  std_logic_vector(21 downto 0);       -- Data7          
    signal PrSv_Data8_s                 :  std_logic_vector(21 downto 0);       -- Data8          
    signal PrSv_Data9_s                 :  std_logic_vector(21 downto 0);       -- Data9          
    signal PrSv_Data10_s                :  std_logic_vector(21 downto 0);       -- Data10         
    signal PrSv_Data11_s                :  std_logic_vector(21 downto 0);       -- Data11         
    signal PrSv_Data12_s                :  std_logic_vector(21 downto 0);       -- Data12         
    signal PrSv_Data13_s                :  std_logic_vector(21 downto 0);       -- Data13         
    signal PrSv_Data14_s                :  std_logic_vector(21 downto 0);       -- Data14         
    signal PrSv_Data15_s                :  std_logic_vector(21 downto 0);       -- Data15         
    signal PrSv_Data16_s                :  std_logic_vector(21 downto 0);       -- Data16         
    signal PrSv_Data17_s                :  std_logic_vector(21 downto 0);       -- Data17         
    signal PrSv_Data18_s                :  std_logic_vector(21 downto 0);       -- Data18         
    signal PrSv_Data19_s                :  std_logic_vector(21 downto 0);       -- Data19         
    signal PrSv_Data20_s                :  std_logic_vector(21 downto 0);       -- Data20         
    signal PrSv_Data21_s                :  std_logic_vector(21 downto 0);       -- Data21         
    signal PrSv_Data22_s                :  std_logic_vector(21 downto 0);       -- Data22         
    signal PrSv_Data23_s                :  std_logic_vector(21 downto 0);       -- Data23         

    -- Wave_Num
    signal PrSv_Num0_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num0
    signal PrSv_Num1_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num1
    signal PrSv_Num2_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num2
    signal PrSv_Num3_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num3
    signal PrSv_Num4_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num4
    signal PrSv_Num5_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num5
    signal PrSv_Num6_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num6
    signal PrSv_Num7_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num7
    signal PrSv_Num8_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num8
    signal PrSv_Num9_s                  : std_logic_vector( 4 downto 0);        -- Wave_Num9
    signal PrSv_Num10_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num10
    signal PrSv_Num11_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num11
    signal PrSv_Num12_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num12
    signal PrSv_Num13_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num13
    signal PrSv_Num14_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num14
    signal PrSv_Num15_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num15
    signal PrSv_Num16_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num16
    signal PrSv_Num17_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num17
    signal PrSv_Num18_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num18
    signal PrSv_Num19_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num19
    signal PrSv_Num20_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num20
    signal PrSv_Num21_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num21
    signal PrSv_Num22_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num22
    signal PrSv_Num23_s                 : std_logic_vector( 4 downto 0);        -- Wave_Num23

    -- M_WalkError
    signal PrSl_WalkErrorRd_s           : std_logic;                            -- WalkError_RdCmd
    signal PrSl_WalkErrorRdVld_s        : std_logic;                            -- WalkError_RdVld
    signal PrSv_WalkErrorRdData_s       : std_logic_vector(20 downto 0);        -- WalkError_RdData
        

begin
	------------------------------------------------------------
	-- Component Map
	------------------------------------------------------------
    M_TdcSpi_0 : M_TdcSpi
    generic map (
		PrSl_Sim_c                      => PrSl_Sim_c                           -- integer := 1                           -- Simulation
	)
    port map (
		--------------------------------
		-- Clk & Reset
		--------------------------------
		CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
		CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz

		--------------------------------
		-- Start_Trig
		--------------------------------
		CpSl_StartTrig_i				=> CpSl_StartTrig_i                     , -- in  std_logic;						-- Start Trig

        --------------------------------
		-- Config End Trig
		--------------------------------
        CpSl_CfgEndTrig_o               => PrSl_CfgEndTrig_s                    , -- out std_logic;                        -- Config End Trig

		-- SPI_IF
		CpSl_SSN_o						=> CpSl_SSN_o	                        , -- out std_logic;						-- TDC_GPX2_SSN
		CpSl_SClk_o						=> CpSl_SClk_o                          , -- out std_logic;						-- TDC_GPX2_SCLK
		CpSl_MOSI_o						=> CpSl_MOSI_o                          , -- out std_logic;						-- TDC_GPX2_MOSI
		CpSl_MISO_i						=> CpSl_MISO_i                            -- in  std_logic 						-- TDC_GPX2_MISO
	);
    
    M_TdcSpi_1 : M_TdcSpi
    generic map (
		PrSl_Sim_c                      => PrSl_Sim_c                           -- integer := 1                           -- Simulation
	)
    port map (
		--------------------------------
		-- Clk & Reset
		--------------------------------
		CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
		CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz

		--------------------------------
		-- Start_Trig
		--------------------------------
		CpSl_StartTrig_i				=> CpSl_StartTrig_i                     , -- in  std_logic;						-- Start Trig

        --------------------------------
		-- Config End Trig
		--------------------------------
        CpSl_CfgEndTrig_o               => open                                 , -- out std_logic;                        -- Config End Trig

		-- SPI_IF
		CpSl_SSN_o						=> CpSl_SSN1_o	                        , -- out std_logic;						-- TDC_GPX2_SSN
		CpSl_SClk_o						=> CpSl_SClk1_o                         , -- out std_logic;						-- TDC_GPX2_SCLK
		CpSl_MOSI_o						=> CpSl_MOSI1_o                         , -- out std_logic;						-- TDC_GPX2_MOSI
		CpSl_MISO_i						=> CpSl_MISO1_i                           -- in  std_logic 						-- TDC_GPX2_MISO
	);

    M_Tdc_group_u : M_Tdc_group
    port map(
        CpSl_Rst_i                      =>  CpSl_Rst_i				    ,
        clk_40m_i                       =>  CpSl_Clk_i                  ,--40Mhz clock
        CpSl_Clk200M_i                  =>  CpSl_Clk200M_i              ,
        CpSl_Start1_i                   =>  CpSl_Start1_i               ,
        CpSl_Start2_i                   =>  CpSl_Start2_i               ,
        CpSl_Start3_i                   =>  CpSl_Start3_i               ,
        CpSl_Clk5M_i                    =>  CpSl_Clk5M_i                ,
        CpSl_RstId_i                    =>  CpSl_RstId_i                ,
        CpSl_ImageVld_i                 =>  CpSl_ImageVld_i             ,
        CpSl_FrameVld_i                 =>  CpSl_FrameVld_i             ,
		CpSl_RefClkP_i			        =>  CpSl_RefClkP_i		        ,
		CpSl_Frame1_i				    =>  CpSl_Frame1_i			    ,
		CpSl_Frame2_i				    =>  CpSl_Frame2_i			    ,
		CpSl_Frame3_i				    =>  CpSl_Frame3_i			    ,
		CpSl_Frame4_i				    =>  CpSl_Frame4_i			    ,
		CpSl_Sdo1_i	     		        =>  CpSl_Sdo1_i	                ,
		CpSl_Sdo2_i	 	    	        =>  CpSl_Sdo2_i	 	            ,
		CpSl_Sdo3_i	     		        =>  CpSl_Sdo3_i	                ,
		CpSl_Sdo4_i	 	    	        =>  CpSl_Sdo4_i	 	            ,
		CpSl_RefClk1P_i			        =>  CpSl_RefClk1P_i		        ,
		CpSl_Frame5_i				    =>  CpSl_Frame5_i			    ,
		CpSl_Frame6_i				    =>  CpSl_Frame6_i			    ,
		CpSl_Frame7_i				    =>  CpSl_Frame7_i			    ,
		CpSl_Frame8_i				    =>  CpSl_Frame8_i			    ,
		CpSl_Sdo5_i	     		        =>  CpSl_Sdo5_i	                ,
		CpSl_Sdo6_i	 	    	        =>  CpSl_Sdo6_i	 	            ,
		CpSl_Sdo7_i	     		        =>  CpSl_Sdo7_i	                ,
		CpSl_Sdo8_i	 	    	        =>  CpSl_Sdo8_i	 	            ,
        CpSl_TdcDataVld_o		        =>  PrSv_TdcDataVld_s           ,
        CpSv_ld_num_o                   =>  PrSv_ld_num_s               ,
        CpSv_Tdc1Echo1_o                =>  PrSv_Tdc1Echo1_s            ,
        CpSv_Tdc1Echo2_o                =>  PrSv_Tdc1Echo2_s            ,
        CpSv_Tdc1Echo3_o                =>  PrSv_Tdc1Echo3_s            ,
        CpSv_Tdc2Echo1_o                =>  PrSv_Tdc2Echo1_s            ,
        CpSv_Tdc2Echo2_o                =>  PrSv_Tdc2Echo2_s            ,
        CpSv_Tdc2Echo3_o                =>  PrSv_Tdc2Echo3_s            ,
        CpSv_Tdc3Echo1_o                =>  PrSv_Tdc3Echo1_s            ,
        CpSv_Tdc3Echo2_o                =>  PrSv_Tdc3Echo2_s            ,
        CpSv_Tdc3Echo3_o                =>  PrSv_Tdc3Echo3_s            ,    
        CpSv_Tdc4Echo1_o                =>  PrSv_Tdc4Echo1_s            ,
        CpSv_Tdc4Echo2_o                =>  PrSv_Tdc4Echo2_s            ,
        CpSv_Tdc4Echo3_o                =>  PrSv_Tdc4Echo3_s            ,
        CpSv_Tdc5Echo1_o                =>  PrSv_Tdc5Echo1_s            ,
        CpSv_Tdc5Echo2_o                =>  PrSv_Tdc5Echo2_s            ,
        CpSv_Tdc5Echo3_o                =>  PrSv_Tdc5Echo3_s            ,
        CpSv_Tdc6Echo1_o                =>  PrSv_Tdc6Echo1_s            ,
        CpSv_Tdc6Echo2_o                =>  PrSv_Tdc6Echo2_s            ,
        CpSv_Tdc6Echo3_o                =>  PrSv_Tdc6Echo3_s            ,    
        CpSv_Tdc7Echo1_o                =>  PrSv_Tdc7Echo1_s            ,
        CpSv_Tdc7Echo2_o                =>  PrSv_Tdc7Echo2_s            ,
        CpSv_Tdc7Echo3_o                =>  PrSv_Tdc7Echo3_s            ,    
        CpSv_Tdc8Echo1_o                =>  PrSv_Tdc8Echo1_s            ,
        CpSv_Tdc8Echo2_o                =>  PrSv_Tdc8Echo2_s            ,
        CpSv_Tdc8Echo3_o                =>  PrSv_Tdc8Echo3_s   
	);

    U_M_WalkError_0 : M_WalkError
    generic map (
        PrSl_DebugApd_c                 => 1                                    -- Debug_APD
    )
    port map (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     => CpSl_Rst_i                           , -- in  std_logic;                        -- active,low
        CpSl_Clk_i                      => CpSl_Clk_i                           , -- in  std_logic;                        -- single 40MHz
        
        --------------------------------
        -- Start Trig
        --------------------------------
        CpSl_Start1Trig_i               => CpSl_Start1_i                        , -- in  std_logic;                        -- Start1_Trig
        CpSl_Start2Trig_i               => CpSl_Start2_i                        , -- in  std_logic;                        -- Start2_Trig
        CpSl_Start3Trig_i               => CpSl_Start3_i                        , -- in  std_logic;                        -- Start3_Trig
        
        --------------------------------
        -- Apd_Address/Num
        --------------------------------
        CpSl_ApdNumVld_i                => CpSl_ApdNumVld_i                     , -- in  std_logic;                        -- ADP_NumVld
        CpSv_ApdNum_i                   => CpSv_ApdNum_i                        , -- in  std_logic_vector( 6 downto 0);    -- ADP_Num   
        CpSl_ApdAddr_i                  => CpSl_ApdAddr_i                       , -- in  std_logic_vector(10 downto 0);    -- APD_Address
        
        --------------------------------
        -- Apd_Channel_Dly(Num : 96)
        --------------------------------
        CpSl_ApdDlyEn_i                 => CpSl_ApdDlyEn_i                      , -- in  std_logic;                        -- ADP_ApdChannel_DlyEn
        CpSv_ApdDlyData_i               => CpSv_ApdDlyData_i                    , -- in  std_logic_vector(31 downto 0);    -- ADP_ApdChannel_DlyData  
        CpSv_ApdDlyAddr_i               => CpSv_ApdDlyAddr_i                    , -- in  std_logic_vector(18 downto 0);    -- ADP_ApdChannel_DlyAddress
        
        --------------------------------
        -- Fifo_WalkError
        --------------------------------
        CpSl_WalkErrorRd_i              => PrSl_WalkErrorRd_s                   , -- in  std_logic;                        -- WalkError_RdCmd
        CpSl_WalkErrorRdVld_o           => PrSl_WalkErrorRdVld_s                , -- out std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_o          => PrSv_WalkErrorRdData_s                 -- out std_logic_vector(20 downto 0)     -- WalkError_RdData
    );

    U_M_Data_0 : M_Data
    port map (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
        CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz
        
        --------------------------------
        -- Frame_Valid
        --------------------------------
        CpSl_FrameVld_i                 => CpSl_FrameVld_i                      , -- in  std_logic;                        -- Frame Valid
        CpSv_LdNum_i                    => PrSv_ld_num_s                        , -- in  std_logic_vector(1 downto 0);   
        
        --------------------------------
        -- WalkError
        --------------------------------
        CpSl_WalkErrorRd_o              => PrSl_WalkErrorRd_s                   , -- out std_logic;                        -- WalkError_RdCmd
        CpSl_WalkErrorRdVld_i           => PrSl_WalkErrorRdVld_s                , -- in  std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_i          => PrSv_WalkErrorRdData_s               , -- in  std_logic_vector(20 downto 0)     -- WalkError_RdData
        
        --------------------------------
        -- PC->FPGA_Constant
        --------------------------------
        CpSl_GrayEn_i                   => CpSl_GrayEn_i                        , -- in  std_logic;                        -- Gray_En  
        CpSv_GrayData_i                 => CpSv_GrayData_i                      , -- in  std_logic_vector(31 downto 0);    -- Gray_Data
        CpSv_GrayAddr_i                 => CpSv_GrayAddr_i                      , -- in  std_logic_vector(18 downto 0);    -- Gray_Addr

        CpSl_DistEn_i                   => CpSl_DistEn_i                        , -- in  std_logic;                        -- Dist_En
        CpSv_DistData_i                 => CpSv_DistData_i                      , -- in  std_logic_vector(31 downto 0);    -- Dist_Data
        CpSv_DistAddr_i                 => CpSv_DistAddr_i                      , -- in  std_logic_vector(18 downto 0);    -- Dist_Addr
        
        CpSl_GroupRd_o                  => CpSl_GroupRd_o                       , -- out std_logic;                        -- Group_Rd
        CpSl_GroupRdData_i              => CpSl_GroupRdData_i                   , -- in  std_logic_vector(13 downto 0);    -- Group_RdData
            
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_TdcDVld0_i                 => PrSv_TdcDataVld_s                 , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc1Echo1_i                => PrSv_Tdc1Echo1                    , -- in  std_logic_vector(21 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_i                => PrSv_Tdc1Echo2                    , -- in  std_logic_vector(21 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_i                => PrSv_Tdc1Echo3                    , -- in  std_logic_vector(21 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_i                => PrSv_Tdc2Echo1                    , -- in  std_logic_vector(21 downto 0);    -- TDC2_Echo1_Data
        CpSv_Tdc2Echo2_i                => PrSv_Tdc2Echo2                    , -- in  std_logic_vector(21 downto 0);    -- TDC2_Echo2_Data
        CpSv_Tdc2Echo3_i                => PrSv_Tdc2Echo3                    , -- in  std_logic_vector(21 downto 0);    -- TDC2_Echo3_Data    
        CpSv_Tdc3Echo1_i                => PrSv_Tdc3Echo1                    , -- in  std_logic_vector(21 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_i                => PrSv_Tdc3Echo2                    , -- in  std_logic_vector(21 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_i                => PrSv_Tdc3Echo3                    , -- in  std_logic_vector(21 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_i                => PrSv_Tdc4Echo1                    , -- in  std_logic_vector(21 downto 0);    -- TDC4_Echo1_Data
        CpSv_Tdc4Echo2_i                => PrSv_Tdc4Echo2                    , -- in  std_logic_vector(21 downto 0);    -- TDC4_Echo2_Data
        CpSv_Tdc4Echo3_i                => PrSv_Tdc4Echo3                    , -- in  std_logic_vector(21 downto 0);    -- TDC4_Echo3_Data
                                                                                 
        CpSl_TdcDVld1_i                 => PrSv_TdcDataVld_s                  , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc5Echo1_i                => PrSv_Tdc5Echo1                     , -- in  std_logic_vector(21 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_i                => PrSv_Tdc5Echo2                     , -- in  std_logic_vector(21 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_i                => PrSv_Tdc5Echo3                     , -- in  std_logic_vector(21 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_i                => PrSv_Tdc6Echo1                     , -- in  std_logic_vector(21 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_i                => PrSv_Tdc6Echo2                     , -- in  std_logic_vector(21 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_i                => PrSv_Tdc6Echo3                     , -- in  std_logic_vector(21 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_i                => PrSv_Tdc7Echo1                     , -- in  std_logic_vector(21 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_i                => PrSv_Tdc7Echo2                     , -- in  std_logic_vector(21 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_i                => PrSv_Tdc7Echo3                     , -- in  std_logic_vector(21 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_i                => PrSv_Tdc8Echo1                     , -- in  std_logic_vector(21 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_i                => PrSv_Tdc8Echo2                     , -- in  std_logic_vector(21 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_i                => PrSv_Tdc8Echo3                     , -- in  std_logic_vector(21 downto 0);    -- TDC8_Echo3_Data
                                           
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSv_EchoDVld_o                 => CpSl_Echo1Vld_o                      , -- out std_logic;                        -- Echo_Data_Valid
        CpSv_Echo1Wave_o                => CpSv_Echo1Wave1_o                    , -- out std_logic_vector(18 downto 0);    -- Echo1_Wave
        CpSv_Echo1Gray_o                => CpSv_Echo1Gray1_o                    , -- out std_logic_vector(15 downto 0);    -- Echo1_Gray
        CpSv_Echo2Wave_o                => CpSv_Echo2Wave1_o                    , -- out std_logic_vector(18 downto 0);    -- Echo2_Wave
        CpSv_Echo2Gray_o                => CpSv_Echo2Gray1_o                    , -- out std_logic_vector(15 downto 0);    -- Echo2_Gray
        CpSv_Echo3Wave_o                => CpSv_Echo3Wave1_o                    , -- out std_logic_vector(18 downto 0);    -- Echo3_Wave
        CpSv_Echo3Gray_o                => CpSv_Echo3Gray1_o                    , -- out std_logic_vector(15 downto 0)     -- Echo3_Gray
		  
		  PrSv_EchoPW20_o                 => PrSv_EchoPW20_o
    );

                         
PrSv_Tdc1Echo1 <= PrSv_Tdc1Echo1_s(26 downto 24) & PrSv_Tdc1Echo1_s(18 downto 0) ;
PrSv_Tdc1Echo2 <= PrSv_Tdc1Echo2_s(26 downto 24) & PrSv_Tdc1Echo2_s(18 downto 0) ;
PrSv_Tdc1Echo3 <= PrSv_Tdc1Echo3_s(26 downto 24) & PrSv_Tdc1Echo3_s(18 downto 0) ;
PrSv_Tdc2Echo1 <= PrSv_Tdc2Echo1_s(26 downto 24) & PrSv_Tdc2Echo1_s(18 downto 0) ;
PrSv_Tdc2Echo2 <= PrSv_Tdc2Echo2_s(26 downto 24) & PrSv_Tdc2Echo2_s(18 downto 0) ;
PrSv_Tdc2Echo3 <= PrSv_Tdc2Echo3_s(26 downto 24) & PrSv_Tdc2Echo3_s(18 downto 0) ;
PrSv_Tdc3Echo1 <= PrSv_Tdc3Echo1_s(26 downto 24) & PrSv_Tdc3Echo1_s(18 downto 0) ;
PrSv_Tdc3Echo2 <= PrSv_Tdc3Echo2_s(26 downto 24) & PrSv_Tdc3Echo2_s(18 downto 0) ;
PrSv_Tdc3Echo3 <= PrSv_Tdc3Echo3_s(26 downto 24) & PrSv_Tdc3Echo3_s(18 downto 0) ;
PrSv_Tdc4Echo1 <= PrSv_Tdc4Echo1_s(26 downto 24) & PrSv_Tdc4Echo1_s(18 downto 0) ;
PrSv_Tdc4Echo2 <= PrSv_Tdc4Echo2_s(26 downto 24) & PrSv_Tdc4Echo2_s(18 downto 0) ;
PrSv_Tdc4Echo3 <= PrSv_Tdc4Echo3_s(26 downto 24) & PrSv_Tdc4Echo3_s(18 downto 0) ;
PrSv_Tdc5Echo1 <= PrSv_Tdc5Echo1_s(26 downto 24) & PrSv_Tdc5Echo1_s(18 downto 0) ;                    
PrSv_Tdc5Echo2 <= PrSv_Tdc5Echo2_s(26 downto 24) & PrSv_Tdc5Echo2_s(18 downto 0) ;                        
PrSv_Tdc5Echo3 <= PrSv_Tdc5Echo3_s(26 downto 24) & PrSv_Tdc5Echo3_s(18 downto 0) ;                        
PrSv_Tdc6Echo1 <= PrSv_Tdc6Echo1_s(26 downto 24) & PrSv_Tdc6Echo1_s(18 downto 0) ;                        
PrSv_Tdc6Echo2 <= PrSv_Tdc6Echo2_s(26 downto 24) & PrSv_Tdc6Echo2_s(18 downto 0) ;                        
PrSv_Tdc6Echo3 <= PrSv_Tdc6Echo3_s(26 downto 24) & PrSv_Tdc6Echo3_s(18 downto 0) ;                        
PrSv_Tdc7Echo1 <= PrSv_Tdc7Echo1_s(26 downto 24) & PrSv_Tdc7Echo1_s(18 downto 0) ;                        
PrSv_Tdc7Echo2 <= PrSv_Tdc7Echo2_s(26 downto 24) & PrSv_Tdc7Echo2_s(18 downto 0) ;                        
PrSv_Tdc7Echo3 <= PrSv_Tdc7Echo3_s(26 downto 24) & PrSv_Tdc7Echo3_s(18 downto 0) ;                        
PrSv_Tdc8Echo1 <= PrSv_Tdc8Echo1_s(26 downto 24) & PrSv_Tdc8Echo1_s(18 downto 0) ;                        
PrSv_Tdc8Echo2 <= PrSv_Tdc8Echo2_s(26 downto 24) & PrSv_Tdc8Echo2_s(18 downto 0) ;                        
PrSv_Tdc8Echo3 <= PrSv_Tdc8Echo3_s(26 downto 24) & PrSv_Tdc8Echo3_s(18 downto 0) ;                        
                         
                         
    ------------------------------------
    -- Distance
    ------------------------------------
--    U_M_TdcDistance_0 : M_TdcDistance
--    port map (
--    	--------------------------------
--    	-- Clk & Reset
--    	--------------------------------
--    	CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
--    	CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz
--    
--    	--------------------------------
--    	-- TDC_Distance
--    	--------------------------------
--    	CpSl_TdcDataVld_i				=> PrSl_TdcDataVld_s                    , -- in  std_logic;						-- TDC_Recv_Data Valid
--    	CpSv_TdcData_i					=> PrSv_TdcData_s	                    , -- in  std_logic_vector(47 downto 0);	-- TDC Recv Data
--        
--        --------------------------------
--    	-- TDC_Distance
--    	--------------------------------
--    	CpSl_TdcDisVld_o	 			=> open, -- CpSl_TdcDataVld_o	                , -- out std_logic;						-- TDC_Recv_Data Valid
--    	CpSv_TdcDisD_o					=> open  -- CpSv_TdcData_o		                  -- out std_logic_vector(47 downto 0) 	-- TDC Recv Data
--    );

    -- OutPut
    CpSl_TdcDataVld_o <= PrSv_TdcDataVld_s; -- & PrSl_TdcDVld1_s;
    CpSv_Tdc1Data_o   <= PrSv_Tdc1Echo1_s(15 downto 0);
    CpSv_Tdc2Data_o   <= PrSv_Tdc2Echo1_s(15 downto 0);
    CpSv_Tdc3Data_o   <= PrSv_Tdc3Echo1_s(15 downto 0);
    CpSv_Tdc4Data_o   <= PrSv_Tdc4Echo1_s(15 downto 0);
    CpSv_Tdc5Data_o   <= PrSv_Tdc5Echo1_s(15 downto 0);
    CpSv_Tdc6Data_o   <= PrSv_Tdc6Echo1_s(15 downto 0);
    CpSv_Tdc7Data_o   <= PrSv_Tdc7Echo1_s(15 downto 0);
    CpSv_Tdc8Data_o   <= PrSv_Tdc8Echo1_s(15 downto 0);
	 
----------------------------------------------------------------------------
-- End Describe
----------------------------------------------------------------------------
end arch_M_TdcGpx2;