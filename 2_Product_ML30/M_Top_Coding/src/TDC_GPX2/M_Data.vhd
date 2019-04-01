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
-- ��    Ȩ  :  ZVISION
-- �ļ�����  :  M_SeqData.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/12/24
-- ���ܼ���  :  
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang wenjun, 2018/12/24
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_Data is
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
        PrSv_EchoPW20_o                 : out std_logic_vector(18 downto 0);
		
        M_data_full_detect              : out std_logic
    );
end M_Data;

architecture arch_M_Data of M_Data is 
    ------------------------------------
    -- Constant_Describe
    ------------------------------------
    component M_DistConst is
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
        -- PC->FPGA_Constant
        --------------------------------
        CpSl_GrayEn_i                   : in  std_logic;                        -- Gray_En  
        CpSv_GrayData_i                 : in  std_logic_vector(31 downto 0);    -- Gray_Data
        CpSv_GrayAddr_i                 : in  std_logic_vector(18 downto 0);    -- Gray_Addr
        
        CpSl_DistEn_i                   : in  std_logic;                        -- Dist_En
        CpSv_DistData_i                 : in  std_logic_vector(31 downto 0);    -- Dist_Data
        CpSv_DistAddr_i                 : in  std_logic_vector(18 downto 0);    -- Dist_Addr
        
        CpSl_GroupRdData_i              : in  std_logic_vector(14 downto 0);    -- Group_RdData

        --------------------------------
        -- LdNum
        --------------------------------
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);

        --------------------------------
        -- Gray_Ratio_Cmd
        --------------------------------
        CpSl_GrayRd_i                   : in  std_logic;                        -- Gray_RatioRd    
        CpSl_GrayDataVld_o              : out std_logic;                        -- Gray_RatioRdData_Vld
        CpSv_GrayData_o                 : out std_logic_vector(15 downto 0);    -- Gray_RatioRdData
        
        --------------------------------
        -- Distance_Constant
        --------------------------------
        -- Start1
        CpSv_Start1_W20_min1_o          : out std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W20_max1_o          : out std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W20_a1_o            : out std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W20_b1_o            : out std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W20_min2_o          : out std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W20_max2_o          : out std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W20_a2_o            : out std_logic_vector(15 downto 0);    -- Start1_a2
        CpSv_Start1_W20_b2_o            : out std_logic_vector(15 downto 0);    -- Start1_b2
        CpSv_Start1_W20_min3_o          : out std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W20_max3_o          : out std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W20_a3_o            : out std_logic_vector(15 downto 0);    -- Start1_a3
        CpSv_Start1_W20_b3_o            : out std_logic_vector(15 downto 0);    -- Start1_b3
        CpSv_Start1_W50_min1_o          : out std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W50_max1_o          : out std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W50_a1_o            : out std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W50_b1_o            : out std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W50_min2_o          : out std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W50_max2_o          : out std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W50_a2_o            : out std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W50_b2_o            : out std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W50_min3_o          : out std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W50_max3_o          : out std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W50_a3_o            : out std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W50_b3_o            : out std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W50_min4_o          : out std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W50_max4_o          : out std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W50_a4_o            : out std_logic_vector(15 downto 0);    -- Start1_a4
        CpSv_Start1_W50_b4_o            : out std_logic_vector(15 downto 0);    -- Start1_b4    
        CpSv_Start1_W50_min5_o          : out std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W50_max5_o          : out std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W50_a5_o            : out std_logic_vector(15 downto 0);    -- Start1_a5
        CpSv_Start1_W50_b5_o            : out std_logic_vector(15 downto 0);    -- Start1_b5    
        CpSv_Start1_W90_min1_o          : out std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W90_max1_o          : out std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W90_a1_o            : out std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W90_b1_o            : out std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W90_min2_o          : out std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W90_max2_o          : out std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W90_a2_o            : out std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W90_b2_o            : out std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W90_min3_o          : out std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W90_max3_o          : out std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W90_a3_o            : out std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W90_b3_o            : out std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W90_min4_o          : out std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W90_max4_o          : out std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W90_a4_o            : out std_logic_vector(15 downto 0);    -- Start1_a4  
        CpSv_Start1_W90_b4_o            : out std_logic_vector(15 downto 0);    -- Start1_b4   
        CpSv_Start1_W90_min5_o          : out std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W90_max5_o          : out std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W90_a5_o            : out std_logic_vector(15 downto 0);    -- Start1_a5  
        CpSv_Start1_W90_b5_o            : out std_logic_vector(15 downto 0);    -- Start1_b5     
        
        -- Start2
        CpSv_Start2_W20_min1_o          : out std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W20_max1_o          : out std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W20_a1_o            : out std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W20_b1_o            : out std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W20_min2_o          : out std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W20_max2_o          : out std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W20_a2_o            : out std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W20_b2_o            : out std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W20_min3_o          : out std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W20_max3_o          : out std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W20_a3_o            : out std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W20_b3_o            : out std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min1_o          : out std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W50_max1_o          : out std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W50_a1_o            : out std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W50_b1_o            : out std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W50_min2_o          : out std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W50_max2_o          : out std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W50_a2_o            : out std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W50_b2_o            : out std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W50_min3_o          : out std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W50_max3_o          : out std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W50_a3_o            : out std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W50_b3_o            : out std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min4_o          : out std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W50_max4_o          : out std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W50_a4_o            : out std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W50_b4_o            : out std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W50_min5_o          : out std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W50_max5_o          : out std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W50_a5_o            : out std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W50_b5_o            : out std_logic_vector(15 downto 0);    -- Start2_b5     
        CpSv_Start2_W90_min1_o          : out std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W90_max1_o          : out std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W90_a1_o            : out std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W90_b1_o            : out std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W90_min2_o          : out std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W90_max2_o          : out std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W90_a2_o            : out std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W90_b2_o            : out std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W90_min3_o          : out std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W90_max3_o          : out std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W90_a3_o            : out std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W90_b3_o            : out std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W90_min4_o          : out std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W90_max4_o          : out std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W90_a4_o            : out std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W90_b4_o            : out std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W90_min5_o          : out std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W90_max5_o          : out std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W90_a5_o            : out std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W90_b5_o            : out std_logic_vector(15 downto 0);    -- Start2_b5     
            
        -- Start3
        CpSv_Start3_W20_min1_o          : out std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W20_max1_o          : out std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W20_a1_o            : out std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W20_b1_o            : out std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W20_min2_o          : out std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W20_max2_o          : out std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W20_a2_o            : out std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W20_b2_o            : out std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W20_min3_o          : out std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W20_max3_o          : out std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W20_a3_o            : out std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W20_b3_o            : out std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min1_o          : out std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W50_max1_o          : out std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W50_a1_o            : out std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W50_b1_o            : out std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W50_min2_o          : out std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W50_max2_o          : out std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W50_a2_o            : out std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W50_b2_o            : out std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W50_min3_o          : out std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W50_max3_o          : out std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W50_a3_o            : out std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W50_b3_o            : out std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min4_o          : out std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W50_max4_o          : out std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W50_a4_o            : out std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W50_b4_o            : out std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W50_min5_o          : out std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W50_max5_o          : out std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W50_a5_o            : out std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W50_b5_o            : out std_logic_vector(15 downto 0);    -- Start3_b5     
        CpSv_Start3_W90_min1_o          : out std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W90_max1_o          : out std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W90_a1_o            : out std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W90_b1_o            : out std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W90_min2_o          : out std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W90_max2_o          : out std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W90_a2_o            : out std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W90_b2_o            : out std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W90_min3_o          : out std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W90_max3_o          : out std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W90_a3_o            : out std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W90_b3_o            : out std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W90_min4_o          : out std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W90_max4_o          : out std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W90_a4_o            : out std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W90_b4_o            : out std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W90_min5_o          : out std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W90_max5_o          : out std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W90_a5_o            : out std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W90_b5_o            : out std_logic_vector(15 downto 0)     -- Start3_b5          
    );
    end component;
    
    component M_SeqData is 
    port (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
        CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
        
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
        -- Seq_Data
        --------------------------------
        CpSl_DVld_o                     : out std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Echo1D1_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data1
        CpSv_Echo1D2_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data2
        CpSv_Echo1D3_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data3
        CpSv_Echo1D4_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data4
        CpSv_Echo1D5_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data5
        CpSv_Echo1D6_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data6
        CpSv_Echo1D7_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data7
        CpSv_Echo1D8_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data8
        CpSv_Echo1ID_o                  : out std_logic_vector( 2 downto 0);    -- Echo1_ID
        CpSv_Echo2D1_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data1
        CpSv_Echo2D2_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data2
        CpSv_Echo2D3_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data3
        CpSv_Echo2D4_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data4
        CpSv_Echo2D5_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data5
        CpSv_Echo2D6_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data6
        CpSv_Echo2D7_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data7
        CpSv_Echo2D8_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data8
        CpSv_Echo2ID_o                  : out std_logic_vector( 2 downto 0);    -- Echo2_ID
        CpSv_Echo3D1_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data1
        CpSv_Echo3D2_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data2
        CpSv_Echo3D3_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data3
        CpSv_Echo3D4_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data4
        CpSv_Echo3D5_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data5
        CpSv_Echo3D6_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data6
        CpSv_Echo3D7_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data7
        CpSv_Echo3D8_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data8
        CpSv_Echo3ID_o                  : out std_logic_vector( 2 downto 0)     -- Echo3_ID
    );
    end component;
	 
	 component M_Fifo is 
	 port (
	 
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (136 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		    : OUT STD_LOGIC_VECTOR (136 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)    
	 );
	 end component;
    
    component M_WaveData is
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
        CpSl_WalkErrorRdVld_i           : in  std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_i          : in  std_logic_vector(20 downto 0);    -- WalkError_RdData
        
        --------------------------------                                                    
        -- Gray_Ratio                                                              
        --------------------------------
        CpSl_GrayDataVld_i              : in  std_logic;                        -- Gray_RatioRdData_Vld
        CpSv_GrayData_i                 : in  std_logic_vector(15 downto 0);    -- Gray_RatioRdData

        --------------------------------
        -- Distance_Constant
        --------------------------------
        -- Start1
        CpSv_Start1_W20_min1_i          : in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W20_max1_i          : in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W20_a1_i            : in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W20_b1_i            : in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W20_min2_i          : in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W20_max2_i          : in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W20_a2_i            : in  std_logic_vector(15 downto 0);    -- Start1_a2
        CpSv_Start1_W20_b2_i            : in  std_logic_vector(15 downto 0);    -- Start1_b2
        CpSv_Start1_W20_min3_i          : in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W20_max3_i          : in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W20_a3_i            : in  std_logic_vector(15 downto 0);    -- Start1_a3
        CpSv_Start1_W20_b3_i            : in  std_logic_vector(15 downto 0);    -- Start1_b3
        CpSv_Start1_W50_min1_i          : in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W50_max1_i          : in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W50_a1_i            : in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W50_b1_i            : in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W50_min2_i          : in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W50_max2_i          : in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W50_a2_i            : in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W50_b2_i            : in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W50_min3_i          : in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W50_max3_i          : in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W50_a3_i            : in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W50_b3_i            : in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W50_min4_i          : in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W50_max4_i          : in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W50_a4_i            : in  std_logic_vector(15 downto 0);    -- Start1_a4
        CpSv_Start1_W50_b4_i            : in  std_logic_vector(15 downto 0);    -- Start1_b4    
        CpSv_Start1_W50_min5_i          : in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W50_max5_i          : in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W50_a5_i            : in  std_logic_vector(15 downto 0);    -- Start1_a5
        CpSv_Start1_W50_b5_i            : in  std_logic_vector(15 downto 0);    -- Start1_b5    
        CpSv_Start1_W90_min1_i          : in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W90_max1_i          : in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W90_a1_i            : in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W90_b1_i            : in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W90_min2_i          : in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W90_max2_i          : in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W90_a2_i            : in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W90_b2_i            : in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W90_min3_i          : in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W90_max3_i          : in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W90_a3_i            : in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W90_b3_i            : in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W90_min4_i          : in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W90_max4_i          : in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W90_a4_i            : in  std_logic_vector(15 downto 0);    -- Start1_a4  
        CpSv_Start1_W90_b4_i            : in  std_logic_vector(15 downto 0);    -- Start1_b4   
        CpSv_Start1_W90_min5_i          : in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W90_max5_i          : in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W90_a5_i            : in  std_logic_vector(15 downto 0);    -- Start1_a5  
        CpSv_Start1_W90_b5_i            : in  std_logic_vector(15 downto 0);    -- Start1_b5     
                                         
        -- Start2                        
        CpSv_Start2_W20_min1_i          : in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W20_max1_i          : in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W20_a1_i            : in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W20_b1_i            : in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W20_min2_i          : in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W20_max2_i          : in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W20_a2_i            : in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W20_b2_i            : in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W20_min3_i          : in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W20_max3_i          : in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W20_a3_i            : in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W20_b3_i            : in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min1_i          : in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W50_max1_i          : in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W50_a1_i            : in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W50_b1_i            : in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W50_min2_i          : in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W50_max2_i          : in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W50_a2_i            : in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W50_b2_i            : in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W50_min3_i          : in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W50_max3_i          : in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W50_a3_i            : in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W50_b3_i            : in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min4_i          : in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W50_max4_i          : in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W50_a4_i            : in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W50_b4_i            : in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W50_min5_i          : in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W50_max5_i          : in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W50_a5_i            : in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W50_b5_i            : in  std_logic_vector(15 downto 0);    -- Start2_b5     
        CpSv_Start2_W90_min1_i          : in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W90_max1_i          : in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W90_a1_i            : in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W90_b1_i            : in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W90_min2_i          : in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W90_max2_i          : in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W90_a2_i            : in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W90_b2_i            : in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W90_min3_i          : in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W90_max3_i          : in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W90_a3_i            : in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W90_b3_i            : in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W90_min4_i          : in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W90_max4_i          : in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W90_a4_i            : in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W90_b4_i            : in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W90_min5_i          : in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W90_max5_i          : in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W90_a5_i            : in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W90_b5_i            : in  std_logic_vector(15 downto 0);    -- Start2_b5     
                                          
        -- Start3                         
        CpSv_Start3_W20_min1_i         : in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W20_max1_i         : in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W20_a1_i           : in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W20_b1_i           : in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W20_min2_i         : in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W20_max2_i         : in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W20_a2_i           : in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W20_b2_i           : in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W20_min3_i         : in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W20_max3_i         : in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W20_a3_i           : in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W20_b3_i           : in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min1_i         : in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W50_max1_i         : in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W50_a1_i           : in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W50_b1_i           : in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W50_min2_i         : in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W50_max2_i         : in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W50_a2_i           : in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W50_b2_i           : in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W50_min3_i         : in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W50_max3_i         : in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W50_a3_i           : in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W50_b3_i           : in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min4_i         : in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W50_max4_i         : in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W50_a4_i           : in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W50_b4_i           : in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W50_min5_i         : in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W50_max5_i         : in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W50_a5_i           : in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W50_b5_i           : in  std_logic_vector(15 downto 0);    -- Start3_b5     
        CpSv_Start3_W90_min1_i         : in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W90_max1_i         : in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W90_a1_i           : in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W90_b1_i           : in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W90_min2_i         : in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W90_max2_i         : in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W90_a2_i           : in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W90_b2_i           : in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W90_min3_i         : in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W90_max3_i         : in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W90_a3_i           : in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W90_b3_i           : in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W90_min4_i         : in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W90_max4_i         : in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W90_a4_i           : in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W90_b4_i           : in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W90_min5_i         : in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W90_max5_i         : in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W90_a5_i           : in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W90_b5_i           : in  std_logic_vector(15 downto 0);    -- Start3_b5 
        
        --------------------------------
        -- TDC_Input_Data
        --------------------------------
        CpSl_DVld_i                     : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_EchoD1_i                   : in  std_logic_vector(18 downto 0);    -- TDC1_Echo1_Data
        CpSv_EchoD2_i                   : in  std_logic_vector(18 downto 0);    -- TDC1_Echo2_Data
        CpSv_EchoD3_i                   : in  std_logic_vector(18 downto 0);    -- TDC1_Echo3_Data
        CpSv_EchoD4_i                   : in  std_logic_vector(18 downto 0);    -- TDC2_Echo1_Data
        CpSv_EchoD5_i                   : in  std_logic_vector(18 downto 0);    -- TDC2_Echo2_Data
        CpSv_EchoD6_i                   : in  std_logic_vector(18 downto 0);    -- TDC2_Echo3_Data    
        CpSv_EchoD7_i                   : in  std_logic_vector(18 downto 0);    -- TDC3_Echo1_Data
        CpSv_EchoD8_i                   : in  std_logic_vector(18 downto 0);    -- TDC3_Echo2_Data
        CpSv_Echo1ID_i                  : in  std_logic_vector( 2 downto 0);    -- Echo1_ID   

        --------------------------------
        -- Wave_Data
        --------------------------------
        CpSv_CompData_o                 : out std_logic_vector(53 downto 0);    -- Compare_EchoData
        CpSl_EchoVld_o                  : out std_logic;                        -- EchoValid
        CpSv_EchoWave_o                 : out std_logic_vector(18 downto 0);    -- EchoWave
        CpSv_EchoGray_o                 : out std_logic_vector(15 downto 0);    -- EchoGray
		  
        PrSv_EchoPW20_o                 : out std_logic_vector(18 downto 0)
    );
    end component;
        
    component M_CompWave is 
    port (
        --------------------------------
    	-- Clk & Reset
    	--------------------------------
    	CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
    	CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
    	
    	--------------------------------
    	-- Compare_Data_InPut
    	--------------------------------
    	CpSv_Comp1Data_i                : in  std_logic_vector(53 downto 0);    -- Compare_EchoData 
    	CpSv_Comp2Data_i                : in  std_logic_vector(53 downto 0);    -- Compare_EchoData 
    	CpSv_Comp3Data_i                : in  std_logic_vector(53 downto 0);    -- Compare_EchoData 
    	
    	--------------------------------
    	-- Check_Data_InPut
    	--------------------------------
    	CpSl_Echo1DVld_i                : in  std_logic;                        -- Echo1_DataValid
    	CpSv_Echo1Wave_i                : in  std_logic_vector(18 downto 0);    -- Echo1_Wave
    	CpSv_Echo1Gray_i                : in  std_logic_vector(15 downto 0);    -- Echo1_Gray
    	CpSl_Echo2DVld_i                : in  std_logic;                        -- Echo2_DataValid
    	CpSv_Echo2Wave_i                : in  std_logic_vector(18 downto 0);    -- Echo2_Wave
    	CpSv_Echo2Gray_i                : in  std_logic_vector(15 downto 0);    -- Echo2_Gray
    	CpSl_Echo3DVld_i                : in  std_logic;                        -- Echo3_DataValid
    	CpSv_Echo3Wave_i                : in  std_logic_vector(18 downto 0);    -- Echo3_Wave
    	CpSv_Echo3Gray_i                : in  std_logic_vector(15 downto 0);    -- Echo3_Gray

    	--------------------------------
    	-- Check_Data_OutPut
    	--------------------------------
    	CpSl_CheckDVld_o                : out std_logic;                        -- Check_DataValid
    	CpSv_CheckWave_o                : out std_logic_vector(18 downto 0);    -- Check
    	CpSv_CheckGray_o                : out std_logic_vector(15 downto 0)     -- Check_Gray
    );
    end component;    
    
    ------------------------------------
    -- Signal_Describe
    ------------------------------------
    -- EchoData
    signal PrSl_DVld_s                  : std_logic;                            -- Tdc_DataValid
    signal PrSv_Echo1D1_s               : std_logic_vector(18 downto 0);        -- Echo1D1
    signal PrSv_Echo1D2_s               : std_logic_vector(18 downto 0);        -- Echo1D2
    signal PrSv_Echo1D3_s               : std_logic_vector(18 downto 0);        -- Echo1D3
    signal PrSv_Echo1D4_s               : std_logic_vector(18 downto 0);        -- Echo1D4
    signal PrSv_Echo1D5_s               : std_logic_vector(18 downto 0);        -- Echo1D5
    signal PrSv_Echo1D6_s               : std_logic_vector(18 downto 0);        -- Echo1D6
    signal PrSv_Echo1ID_s               : std_logic_vector( 2 downto 0);        -- Echo1ID

    signal PrSv_Echo2D1_s               : std_logic_vector(18 downto 0);        -- Echo2D1
    signal PrSv_Echo2D2_s               : std_logic_vector(18 downto 0);        -- Echo2D2
    signal PrSv_Echo2D3_s               : std_logic_vector(18 downto 0);        -- Echo2D3
    signal PrSv_Echo2D4_s               : std_logic_vector(18 downto 0);        -- Echo2D4
    signal PrSv_Echo2D5_s               : std_logic_vector(18 downto 0);        -- Echo2D5
    signal PrSv_Echo2D6_s               : std_logic_vector(18 downto 0);        -- Echo2D6
    signal PrSv_Echo2ID_s               : std_logic_vector( 2 downto 0);        -- Echo2ID

    signal PrSv_Echo3D1_s               : std_logic_vector(18 downto 0);        -- Echo3D1
    signal PrSv_Echo3D2_s               : std_logic_vector(18 downto 0);        -- Echo3D2
    signal PrSv_Echo3D3_s               : std_logic_vector(18 downto 0);        -- Echo3D3
    signal PrSv_Echo3D4_s               : std_logic_vector(18 downto 0);        -- Echo3D4
    signal PrSv_Echo3D5_s               : std_logic_vector(18 downto 0);        -- Echo3D5
    signal PrSv_Echo3D6_s               : std_logic_vector(18 downto 0);        -- Echo3D6
    signal PrSv_Echo3ID_s               : std_logic_vector( 2 downto 0);        -- Echo3ID
    
    signal PrSl_Echo1Vld_s              : std_logic;                            -- Echo1_Vld
    signal PrSv_Echo1Wave_s             : std_logic_vector(18 downto 0);        -- Echo1_Wave
    signal PrSv_Echo1Gray_s             : std_logic_vector(15 downto 0);        -- Echo1_Gray
    signal PrSl_Echo2Vld_s              : std_logic;                            -- EchoValid
    signal PrSv_Echo2Wave_s             : std_logic_vector(18 downto 0);        -- Echo2_Wave
    signal PrSv_Echo2Gray_s             : std_logic_vector(15 downto 0);        -- Echo2_Gray
    signal PrSl_Echo3Vld_s              : std_logic;                            -- EchoValid
    signal PrSv_Echo3Wave_s             : std_logic_vector(18 downto 0);        -- Echo3_Wave
    signal PrSv_Echo3Gray_s             : std_logic_vector(15 downto 0);        -- Echo3_Gray
    
    -- M_CompWave
    signal PrSv_Comp1Data_s             : std_logic_vector(53 downto 0);        -- Compare_EchoData
    signal PrSv_Comp2Data_s             : std_logic_vector(53 downto 0);        -- Compare_EchoData
    signal PrSv_Comp3Data_s             : std_logic_vector(53 downto 0);        -- Compare_EchoData
    signal PrSl_CheckDVld_s             : std_logic;                            -- Check_DataValid
    signal PrSv_CheckWave_s             : std_logic_vector(18 downto 0);        -- Check          
    signal PrSv_CheckGray_s             : std_logic_vector(15 downto 0);        -- Check_Gray     
    
    -- LcdNum
    signal PrSl_TdcLdnum_s              : std_logic_vector(1 downto 0); 
    
    -- M_Fifo
    signal PrSv_GroupEcho1_Data        : STD_LOGIC_VECTOR (136 DOWNTO 0);
    signal PrSv_GroupEcho1_RdData      : STD_LOGIC_VECTOR (136 DOWNTO 0);
    signal PrSv_GroupEcho2_Data        : STD_LOGIC_VECTOR (136 DOWNTO 0);
    signal PrSv_GroupEcho2_RdData      : STD_LOGIC_VECTOR (136 DOWNTO 0);
    signal PrSv_GroupEcho3_Data        : STD_LOGIC_VECTOR (136 DOWNTO 0);
    signal PrSv_GroupEcho3_RdData      : STD_LOGIC_VECTOR (136 DOWNTO 0);

    signal PrSl_GroupEcho1_Rd           : std_logic;
    signal PrSl_GroupEcho1_RdEmpty      : std_logic;
    signal PrSl_GroupEcho1_RdEmptyDly   : std_logic;
    signal PrSl_GroupEcho1_RdDly  	    : std_logic;
    signal PrSl_Enable_s         	    : std_logic;
    signal PrSl_EnableDly1_s     	    : std_logic;
    signal M_data_full                  : std_logic;
    
    -- Gray_RatioData
    signal PrSl_GrayDataVld_s           : std_logic;                        -- Gray_RatioRdData_Vld
    signal PrSv_GrayData_s              : std_logic_vector(15 downto 0);
    
    -- Distance_Constant
    signal PrSv_Start1_W20_min1_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_max1_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_a1_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_b1_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_min2_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_max2_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_a2_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_b2_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_min3_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_max3_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_a3_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W20_b3_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_min1_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_max1_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_a1_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_b1_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_min2_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_max2_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_a2_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_b2_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_min3_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_max3_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_a3_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_b3_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_min4_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_max4_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_a4_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_b4_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_min5_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_max5_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_a5_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W50_b5_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_min1_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_max1_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_a1_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_b1_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_min2_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_max2_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_a2_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_b2_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_min3_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_max3_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_a3_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_b3_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_min4_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_max4_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_a4_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_b4_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_min5_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_max5_s       : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_a5_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start1_W90_b5_s         : std_logic_vector(15 downto 0);       -- Start1
    signal PrSv_Start2_W20_min1_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_max1_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_a1_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_b1_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_min2_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_max2_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_a2_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_b2_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_min3_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_max3_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_a3_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W20_b3_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_min1_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_max1_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_a1_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_b1_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_min2_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_max2_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_a2_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_b2_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_min3_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_max3_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_a3_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_b3_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_min4_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_max4_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_a4_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_b4_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_min5_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_max5_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_a5_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W50_b5_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_min1_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_max1_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_a1_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_b1_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_min2_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_max2_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_a2_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_b2_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_min3_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_max3_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_a3_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_b3_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_min4_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_max4_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_a4_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_b4_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_min5_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_max5_s       : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_a5_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start2_W90_b5_s         : std_logic_vector(15 downto 0);       -- Start2
    signal PrSv_Start3_W20_min1_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_max1_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_a1_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_b1_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_min2_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_max2_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_a2_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_b2_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_min3_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_max3_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_a3_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W20_b3_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_min1_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_max1_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_a1_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_b1_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_min2_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_max2_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_a2_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_b2_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_min3_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_max3_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_a3_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_b3_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_min4_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_max4_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_a4_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_b4_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_min5_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_max5_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_a5_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W50_b5_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_min1_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_max1_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_a1_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_b1_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_min2_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_max2_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_a2_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_b2_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_min3_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_max3_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_a3_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_b3_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_min4_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_max4_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_a4_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_b4_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_min5_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_max5_s       : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_a5_s         : std_logic_vector(15 downto 0);       -- Start3
    signal PrSv_Start3_W90_b5_s         : std_logic_vector(15 downto 0);       -- Start3
	 
	 
	 signal CpSl_GroupRdData_i_cm			 :	std_logic_vector(14 downto 0);

    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
	 
	 
begin
	
    ----------------------------------------------------------------------------
    -- Component_Map
    ---------------------------------------------------------------------------
	 CpSl_GroupRdData_i_cm	<= '0' & CpSl_GroupRdData_i;
    U_M_DistConst_0 : M_DistConst
    generic map (
        PrSl_Sim_c                      => 1                                    -- Simulation
    )
    port map (
        --------------------------------
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     => CpSl_Rst_i                           , -- in  std_logic;                        -- active,low
        CpSl_Clk_i                      => CpSl_Clk_i                           , -- in  std_logic;                        -- single 40MHz.clock
        
        --------------------------------
        -- PC->FPGA_Constant
        --------------------------------
        CpSl_GrayEn_i                   => CpSl_GrayEn_i                        , -- in  std_logic;                        -- Gray_En  
        CpSv_GrayData_i                 => CpSv_GrayData_i                      , -- in  std_logic_vector(31 downto 0);    -- Gray_Data
        CpSv_GrayAddr_i                 => CpSv_GrayAddr_i                      , -- in  std_logic_vector(18 downto 0);    -- Gray_Addr
        
        CpSl_DistEn_i                   => CpSl_DistEn_i                        , -- in  std_logic;                        -- Dist_En
        CpSv_DistData_i                 => CpSv_DistData_i                      , -- in  std_logic_vector(31 downto 0);    -- Dist_Data
        CpSv_DistAddr_i                 => CpSv_DistAddr_i                      , -- in  std_logic_vector(18 downto 0);    -- Dist_Addr
        
        CpSl_GroupRdData_i              => CpSl_GroupRdData_i_cm                , -- in  std_logic_vector(13 downto 0);    -- Group_RdData
        
        --------------------------------
        -- LdNum
        --------------------------------
        CpSv_LdNum_i                    => PrSv_GroupEcho1_RdData(1 downto 0)   , -- in  std_logic_vector(1 downto 0);

        --------------------------------
        -- Gray_Ratio_Cmd
        --------------------------------
        CpSl_GrayRd_i                   => PrSl_GroupEcho1_RdDly                , -- in  std_logic;                        -- Gray_RatioRd
        CpSl_GrayDataVld_o              => PrSl_GrayDataVld_s                   , -- out std_logic;                        -- Gray_RatioRdData_Vld
        CpSv_GrayData_o                 => PrSv_GrayData_s                      , -- out std_logic_vector(15 downto 0);    -- Gray_RatioRdData
        
        --------------------------------
        -- Distance_Constant
        --------------------------------
        -- Start1
        CpSv_Start1_W20_min1_o          => PrSv_Start1_W20_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W20_max1_o          => PrSv_Start1_W20_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W20_a1_o            => PrSv_Start1_W20_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W20_b1_o            => PrSv_Start1_W20_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W20_min2_o          => PrSv_Start1_W20_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W20_max2_o          => PrSv_Start1_W20_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W20_a2_o            => PrSv_Start1_W20_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a2
        CpSv_Start1_W20_b2_o            => PrSv_Start1_W20_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b2
        CpSv_Start1_W20_min3_o          => PrSv_Start1_W20_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W20_max3_o          => PrSv_Start1_W20_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W20_a3_o            => PrSv_Start1_W20_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a3
        CpSv_Start1_W20_b3_o            => PrSv_Start1_W20_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b3
        CpSv_Start1_W50_min1_o          => PrSv_Start1_W50_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W50_max1_o          => PrSv_Start1_W50_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W50_a1_o            => PrSv_Start1_W50_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W50_b1_o            => PrSv_Start1_W50_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W50_min2_o          => PrSv_Start1_W50_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W50_max2_o          => PrSv_Start1_W50_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W50_a2_o            => PrSv_Start1_W50_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W50_b2_o            => PrSv_Start1_W50_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W50_min3_o          => PrSv_Start1_W50_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W50_max3_o          => PrSv_Start1_W50_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W50_a3_o            => PrSv_Start1_W50_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W50_b3_o            => PrSv_Start1_W50_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W50_min4_o          => PrSv_Start1_W50_min4_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W50_max4_o          => PrSv_Start1_W50_max4_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W50_a4_o            => PrSv_Start1_W50_a4_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a4
        CpSv_Start1_W50_b4_o            => PrSv_Start1_W50_b4_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b4    
        CpSv_Start1_W50_min5_o          => PrSv_Start1_W50_min5_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W50_max5_o          => PrSv_Start1_W50_max5_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W50_a5_o            => PrSv_Start1_W50_a5_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a5
        CpSv_Start1_W50_b5_o            => PrSv_Start1_W50_b5_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b5    
        CpSv_Start1_W90_min1_o          => PrSv_Start1_W90_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W90_max1_o          => PrSv_Start1_W90_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W90_a1_o            => PrSv_Start1_W90_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W90_b1_o            => PrSv_Start1_W90_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W90_min2_o          => PrSv_Start1_W90_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W90_max2_o          => PrSv_Start1_W90_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W90_a2_o            => PrSv_Start1_W90_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W90_b2_o            => PrSv_Start1_W90_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W90_min3_o          => PrSv_Start1_W90_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W90_max3_o          => PrSv_Start1_W90_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W90_a3_o            => PrSv_Start1_W90_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W90_b3_o            => PrSv_Start1_W90_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W90_min4_o          => PrSv_Start1_W90_min4_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W90_max4_o          => PrSv_Start1_W90_max4_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W90_a4_o            => PrSv_Start1_W90_a4_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a4  
        CpSv_Start1_W90_b4_o            => PrSv_Start1_W90_b4_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b4   
        CpSv_Start1_W90_min5_o          => PrSv_Start1_W90_min5_s               , -- out std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W90_max5_o          => PrSv_Start1_W90_max5_s               , -- out std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W90_a5_o            => PrSv_Start1_W90_a5_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_a5  
        CpSv_Start1_W90_b5_o            => PrSv_Start1_W90_b5_s                 , -- out std_logic_vector(15 downto 0);    -- Start1_b5     
                                                                 
        -- Start2                      
        CpSv_Start2_W20_min1_o          => PrSv_Start2_W20_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W20_max1_o          => PrSv_Start2_W20_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W20_a1_o            => PrSv_Start2_W20_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W20_b1_o            => PrSv_Start2_W20_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W20_min2_o          => PrSv_Start2_W20_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W20_max2_o          => PrSv_Start2_W20_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W20_a2_o            => PrSv_Start2_W20_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W20_b2_o            => PrSv_Start2_W20_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W20_min3_o          => PrSv_Start2_W20_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W20_max3_o          => PrSv_Start2_W20_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W20_a3_o            => PrSv_Start2_W20_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W20_b3_o            => PrSv_Start2_W20_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min1_o          => PrSv_Start2_W50_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W50_max1_o          => PrSv_Start2_W50_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W50_a1_o            => PrSv_Start2_W50_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W50_b1_o            => PrSv_Start2_W50_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W50_min2_o          => PrSv_Start2_W50_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W50_max2_o          => PrSv_Start2_W50_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W50_a2_o            => PrSv_Start2_W50_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W50_b2_o            => PrSv_Start2_W50_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W50_min3_o          => PrSv_Start2_W50_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W50_max3_o          => PrSv_Start2_W50_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W50_a3_o            => PrSv_Start2_W50_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W50_b3_o            => PrSv_Start2_W50_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min4_o          => PrSv_Start2_W50_min4_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W50_max4_o          => PrSv_Start2_W50_max4_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W50_a4_o            => PrSv_Start2_W50_a4_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W50_b4_o            => PrSv_Start2_W50_b4_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W50_min5_o          => PrSv_Start2_W50_min5_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W50_max5_o          => PrSv_Start2_W50_max5_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W50_a5_o            => PrSv_Start2_W50_a5_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W50_b5_o            => PrSv_Start2_W50_b5_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b5     
        CpSv_Start2_W90_min1_o          => PrSv_Start2_W90_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W90_max1_o          => PrSv_Start2_W90_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W90_a1_o            => PrSv_Start2_W90_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W90_b1_o            => PrSv_Start2_W90_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W90_min2_o          => PrSv_Start2_W90_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W90_max2_o          => PrSv_Start2_W90_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W90_a2_o            => PrSv_Start2_W90_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W90_b2_o            => PrSv_Start2_W90_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W90_min3_o          => PrSv_Start2_W90_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W90_max3_o          => PrSv_Start2_W90_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W90_a3_o            => PrSv_Start2_W90_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W90_b3_o            => PrSv_Start2_W90_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W90_min4_o          => PrSv_Start2_W90_min4_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W90_max4_o          => PrSv_Start2_W90_max4_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W90_a4_o            => PrSv_Start2_W90_a4_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W90_b4_o            => PrSv_Start2_W90_b4_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W90_min5_o          => PrSv_Start2_W90_min5_s               , -- out std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W90_max5_o          => PrSv_Start2_W90_max5_s               , -- out std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W90_a5_o            => PrSv_Start2_W90_a5_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W90_b5_o            => PrSv_Start2_W90_b5_s                 , -- out std_logic_vector(15 downto 0);    -- Start2_b5     
                                                                               
        -- Start3                                                                
        CpSv_Start3_W20_min1_o          => PrSv_Start3_W20_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W20_max1_o          => PrSv_Start3_W20_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W20_a1_o            => PrSv_Start3_W20_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W20_b1_o            => PrSv_Start3_W20_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W20_min2_o          => PrSv_Start3_W20_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W20_max2_o          => PrSv_Start3_W20_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W20_a2_o            => PrSv_Start3_W20_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W20_b2_o            => PrSv_Start3_W20_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W20_min3_o          => PrSv_Start3_W20_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W20_max3_o          => PrSv_Start3_W20_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W20_a3_o            => PrSv_Start3_W20_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W20_b3_o            => PrSv_Start3_W20_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min1_o          => PrSv_Start3_W50_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W50_max1_o          => PrSv_Start3_W50_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W50_a1_o            => PrSv_Start3_W50_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W50_b1_o            => PrSv_Start3_W50_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W50_min2_o          => PrSv_Start3_W50_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W50_max2_o          => PrSv_Start3_W50_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W50_a2_o            => PrSv_Start3_W50_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W50_b2_o            => PrSv_Start3_W50_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W50_min3_o          => PrSv_Start3_W50_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W50_max3_o          => PrSv_Start3_W50_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W50_a3_o            => PrSv_Start3_W50_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W50_b3_o            => PrSv_Start3_W50_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min4_o          => PrSv_Start3_W50_min4_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W50_max4_o          => PrSv_Start3_W50_max4_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W50_a4_o            => PrSv_Start3_W50_a4_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W50_b4_o            => PrSv_Start3_W50_b4_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W50_min5_o          => PrSv_Start3_W50_min5_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W50_max5_o          => PrSv_Start3_W50_max5_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W50_a5_o            => PrSv_Start3_W50_a5_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W50_b5_o            => PrSv_Start3_W50_b5_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b5     
        CpSv_Start3_W90_min1_o          => PrSv_Start3_W90_min1_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W90_max1_o          => PrSv_Start3_W90_max1_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W90_a1_o            => PrSv_Start3_W90_a1_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W90_b1_o            => PrSv_Start3_W90_b1_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W90_min2_o          => PrSv_Start3_W90_min2_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W90_max2_o          => PrSv_Start3_W90_max2_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W90_a2_o            => PrSv_Start3_W90_a2_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W90_b2_o            => PrSv_Start3_W90_b2_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W90_min3_o          => PrSv_Start3_W90_min3_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W90_max3_o          => PrSv_Start3_W90_max3_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W90_a3_o            => PrSv_Start3_W90_a3_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W90_b3_o            => PrSv_Start3_W90_b3_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W90_min4_o          => PrSv_Start3_W90_min4_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W90_max4_o          => PrSv_Start3_W90_max4_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W90_a4_o            => PrSv_Start3_W90_a4_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W90_b4_o            => PrSv_Start3_W90_b4_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W90_min5_o          => PrSv_Start3_W90_min5_s               , -- out std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W90_max5_o          => PrSv_Start3_W90_max5_s               , -- out std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W90_a5_o            => PrSv_Start3_W90_a5_s                 , -- out std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W90_b5_o            => PrSv_Start3_W90_b5_s                   -- out std_logic_vector(15 downto 0)     -- Start3_b5          
    );
    
    U_M_SeqData_0 : M_SeqData
    port map (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
        CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz
        
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_TdcDVld0_i                 => CpSl_TdcDVld0_i                      , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc1Echo1_i                => CpSv_Tdc1Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_i                => CpSv_Tdc1Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_i                => CpSv_Tdc1Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_i                => CpSv_Tdc2Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC2_Echo1_Data
        CpSv_Tdc2Echo2_i                => CpSv_Tdc2Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC2_Echo2_Data
        CpSv_Tdc2Echo3_i                => CpSv_Tdc2Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC2_Echo3_Data    
        CpSv_Tdc3Echo1_i                => CpSv_Tdc3Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_i                => CpSv_Tdc3Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_i                => CpSv_Tdc3Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_i                => CpSv_Tdc4Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC4_Echo1_Data
        CpSv_Tdc4Echo2_i                => CpSv_Tdc4Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC4_Echo2_Data
        CpSv_Tdc4Echo3_i                => CpSv_Tdc4Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC4_Echo3_Data

        CpSl_TdcDVld1_i			        => CpSl_TdcDVld1_i	                    , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc5Echo1_i                => CpSv_Tdc5Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_i                => CpSv_Tdc5Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_i                => CpSv_Tdc5Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_i                => CpSv_Tdc6Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_i                => CpSv_Tdc6Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_i                => CpSv_Tdc6Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_i                => CpSv_Tdc7Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_i                => CpSv_Tdc7Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_i                => CpSv_Tdc7Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_i                => CpSv_Tdc8Echo1_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_i                => CpSv_Tdc8Echo2_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_i                => CpSv_Tdc8Echo3_i                     , -- in  std_logic_vector(21 downto 0);    -- TDC8_Echo3_Data

        --------------------------------
        -- Seq_Data
        --------------------------------
        CpSl_DVld_o                     => PrSl_DVld_s                          , -- out std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Echo1D1_o                  => PrSv_Echo1D1_s                       , -- out std_logic_vector(18 downto 0);    -- Echo1_Data1
        CpSv_Echo1D2_o                  => PrSv_Echo1D2_s                       , -- out std_logic_vector(18 downto 0);    -- Echo1_Data2
        CpSv_Echo1D3_o                  => PrSv_Echo1D3_s                       , -- out std_logic_vector(18 downto 0);    -- Echo1_Data3
        CpSv_Echo1D4_o                  => PrSv_Echo1D4_s                       , -- out std_logic_vector(18 downto 0);    -- Echo1_Data4
        CpSv_Echo1D5_o                  => PrSv_Echo1D5_s                       , -- out std_logic_vector(18 downto 0);    -- Echo1_Data5
        CpSv_Echo1D6_o                  => PrSv_Echo1D6_s                       , -- out std_logic_vector(18 downto 0);    -- Echo1_Data6
        CpSv_Echo1D7_o                  => open                                 , -- out std_logic_vector(18 downto 0);    -- Echo1_Data7
        CpSv_Echo1D8_o                  => open                                 , -- out std_logic_vector(18 downto 0);    -- Echo1_Data8
        CpSv_Echo1ID_o                  => PrSv_Echo1ID_s                       , -- out std_logic_vector( 2 downto 0);    -- Echo1_ID
        CpSv_Echo2D1_o                  => PrSv_Echo2D1_s                       , -- out std_logic_vector(18 downto 0);    -- Echo2_Data1
        CpSv_Echo2D2_o                  => PrSv_Echo2D2_s                       , -- out std_logic_vector(18 downto 0);    -- Echo2_Data2
        CpSv_Echo2D3_o                  => PrSv_Echo2D3_s                       , -- out std_logic_vector(18 downto 0);    -- Echo2_Data3
        CpSv_Echo2D4_o                  => PrSv_Echo2D4_s                       , -- out std_logic_vector(18 downto 0);    -- Echo2_Data4
        CpSv_Echo2D5_o                  => PrSv_Echo2D5_s                       , -- out std_logic_vector(18 downto 0);    -- Echo2_Data5
        CpSv_Echo2D6_o                  => PrSv_Echo2D6_s                       , -- out std_logic_vector(18 downto 0);    -- Echo2_Data6
        CpSv_Echo2D7_o                  => open                                 , -- out std_logic_vector(18 downto 0);    -- Echo2_Data7
        CpSv_Echo2D8_o                  => open                                 , -- out std_logic_vector(18 downto 0);    -- Echo2_Data8
        CpSv_Echo2ID_o                  => PrSv_Echo2ID_s                       , -- out std_logic_vector( 2 downto 0);    -- Echo2_ID
        CpSv_Echo3D1_o                  => PrSv_Echo3D1_s                       , -- out std_logic_vector(18 downto 0);    -- Echo3_Data1
        CpSv_Echo3D2_o                  => PrSv_Echo3D2_s                       , -- out std_logic_vector(18 downto 0);    -- Echo3_Data2
        CpSv_Echo3D3_o                  => PrSv_Echo3D3_s                       , -- out std_logic_vector(18 downto 0);    -- Echo3_Data3
        CpSv_Echo3D4_o                  => PrSv_Echo3D4_s                       , -- out std_logic_vector(18 downto 0);    -- Echo3_Data4
        CpSv_Echo3D5_o                  => PrSv_Echo3D5_s                       , -- out std_logic_vector(18 downto 0);    -- Echo3_Data5
        CpSv_Echo3D6_o                  => PrSv_Echo3D6_s                       , -- out std_logic_vector(18 downto 0);    -- Echo3_Data6
        CpSv_Echo3D7_o                  => open                                 , -- out std_logic_vector(18 downto 0);    -- Echo3_Data7
        CpSv_Echo3D8_o                  => open                                 , -- out std_logic_vector(18 downto 0);    -- Echo3_Data8
        CpSv_Echo3ID_o                  => PrSv_Echo3ID_s                         -- out std_logic_vector( 2 downto 0)     -- Echo3_ID
    );

    U_M_Fifo_0 : M_Fifo 
    port map (
		clock		=> CpSl_Clk_i                                               , -- IN STD_LOGIC ;
		data		=> PrSv_GroupEcho1_Data                                     , -- IN STD_LOGIC_VECTOR (136 DOWNTO 0);
		rdreq		=> PrSl_GroupEcho1_Rd                                       , -- IN STD_LOGIC ;
		wrreq		=> PrSl_DVld_s                                              , -- IN STD_LOGIC ;
		empty		=> PrSl_GroupEcho1_RdEmpty		                            , -- OUT STD_LOGIC ;
		full		=> M_data_full                                              , -- OUT STD_LOGIC ;
		q			=> PrSv_GroupEcho1_RdData                                   , -- OUT STD_LOGIC_VECTOR (136 DOWNTO 0);
		usedw		=> open                                                       -- OUT STD_LOGIC_VECTOR (4 DOWNTO 0)    
    );
    PrSv_GroupEcho1_Data <= "000" & PrSv_Echo1D1_s & "000" & PrSv_Echo1D2_s & "000" & PrSv_Echo1D3_s 
                          & "000" & PrSv_Echo1D4_s & "000" & PrSv_Echo1D5_s & "000" & PrSv_Echo1D6_s & PrSv_Echo1ID_s & CpSv_LdNum_i;
    
    U_M_Fifo_1 : M_Fifo 
    port map(
        clock		=> CpSl_Clk_i                                               , -- IN STD_LOGIC ;
		data		=> PrSv_GroupEcho2_Data                                     , -- IN STD_LOGIC_VECTOR (136 DOWNTO 0);
		rdreq		=> PrSl_GroupEcho1_Rd                                       , -- IN STD_LOGIC ;
		wrreq		=> PrSl_DVld_s                                              , -- IN STD_LOGIC ;
		empty		=> open                                                     , -- OUT STD_LOGIC ;
		full		=> open                                                     , -- OUT STD_LOGIC ;       
		q			=> PrSv_GroupEcho2_RdData                                   , -- OUT STD_LOGIC_VECTOR (136 DOWNTO 0);
        usedw		=> open                                                       -- OUT STD_LOGIC_VECTOR (4 DOWNTO 0)    
    );
    PrSv_GroupEcho2_Data <= "000" & PrSv_Echo2D1_s & "000" & PrSv_Echo2D2_s & "000" & PrSv_Echo2D3_s 
                          & "000" & PrSv_Echo2D4_s & "000" & PrSv_Echo2D5_s & "000" & PrSv_Echo2D6_s & PrSv_Echo1ID_s & CpSv_LdNum_i;

    U_M_Fifo_2 : M_Fifo 
    port map(
        clock		=> CpSl_Clk_i                                               , -- IN STD_LOGIC ;
		data		=> PrSv_GroupEcho3_Data                                     , -- IN STD_LOGIC_VECTOR (136 DOWNTO 0);
		rdreq		=> PrSl_GroupEcho1_Rd                                       , -- IN STD_LOGIC ;
		wrreq		=> PrSl_DVld_s                                              , -- IN STD_LOGIC ;
		empty		=> open                                                     , -- OUT STD_LOGIC ;       
		full		=> open                                                     , -- OUT STD_LOGIC ;       
		q			=> PrSv_GroupEcho3_RdData                                   , -- OUT STD_LOGIC_VECTOR (136 DOWNTO 0);
        usedw		=> open                                                       -- OUT STD_LOGIC_VECTOR (4 DOWNTO 0)    
    );
    PrSv_GroupEcho3_Data <= "000" & PrSv_Echo3D1_s & "000" & PrSv_Echo3D2_s & "000" & PrSv_Echo3D3_s 
                          & "000" & PrSv_Echo3D4_s & "000" & PrSv_Echo3D5_s & "000" & PrSv_Echo3D6_s & PrSv_Echo1ID_s & CpSv_LdNum_i;
    
	 process (CpSl_Rst_i, CpSl_Clk_i) begin
	     if (CpSl_Rst_i = '0') then 
		      M_data_full_detect <= '0';
		  elsif rising_edge(CpSl_Clk_i) then 
            if(M_data_full = '1') then
				M_data_full_detect <= '1';
            end if;
		  end if;
	 end process;

	 process (CpSl_Rst_i, CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_GroupEcho1_RdEmptyDly <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_GroupEcho1_RdEmptyDly <= PrSl_GroupEcho1_RdEmpty;
        end if;
	 end process;
	 
    -- PrSl_Enable_s
    process (CpSl_Rst_i, CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_Enable_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_GroupEcho1_Rd = '1') then
                PrSl_Enable_s <= '1';
            elsif (PrSl_Echo1Vld_s = '1') then
                PrSl_Enable_s <= '0';
            else -- hold	
            end if;
        end if;
    end process;
    
    -- PrSl_EnableDly1_s
    process (CpSl_Rst_i, CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_EnableDly1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_EnableDly1_s <= PrSl_Enable_s;
        end if;
    end process;
    -- CpSl_WalkErrorRd_o
--    CpSl_WalkErrorRd_o <= (not PrSl_EnableDly1_s) and PrSl_Enable_s;
    CpSl_WalkErrorRd_o <= PrSl_GroupEcho1_Rd;
    

	-- PrSl_GroupEcho1_Rd
    process (CpSl_Rst_i, CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_GroupEcho1_Rd <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_GroupEcho1_RdEmpty = '0' and PrSl_Enable_s = '0' and PrSl_GroupEcho1_Rd = '0') then
                PrSl_GroupEcho1_Rd <= '1';
            else
                PrSl_GroupEcho1_Rd <= '0';
            end if;
        end if;
    end process;
    -- CpSl_GroupRd_o
    CpSl_GroupRd_o <= PrSl_GroupEcho1_Rd;
    
    -- PrSl_GroupEcho1_RdDly
    process (CpSl_Rst_i, CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_GroupEcho1_RdDly <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_GroupEcho1_RdDly <= PrSl_GroupEcho1_Rd;
        end if;
    end process;
    
    U_M_WaveData_0 : M_WaveData
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
        CpSv_LdNum_i                    => PrSv_GroupEcho1_RdData(1 downto 0)   , -- CpSv_LdNum_i, -- ld_num_s                             , -- in  std_logic_vector(1 downto 0);   
        
        --------------------------------
        -- WalkError
        --------------------------------
        CpSl_WalkErrorRdVld_i           => CpSl_WalkErrorRdVld_i                , -- in  std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_i          => CpSv_WalkErrorRdData_i               , -- in  std_logic_vector(20 downto 0)     -- WalkError_RdData
        
        --------------------------------
        -- Gray_Ratio
        --------------------------------
        CpSl_GrayDataVld_i              => PrSl_GrayDataVld_s                   , -- in  std_logic;                        -- Gray_RatioRdData_Vld
        CpSv_GrayData_i                 => PrSv_GrayData_s                      , -- in  std_logic_vector(15 downto 0);    -- Gray_RatioRdData
        
        --------------------------------
        -- Distance_Constant
        --------------------------------
        -- Start1
        CpSv_Start1_W20_min1_i          => PrSv_Start1_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W20_max1_i          => PrSv_Start1_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W20_a1_i            => PrSv_Start1_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W20_b1_i            => PrSv_Start1_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W20_min2_i          => PrSv_Start1_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W20_max2_i          => PrSv_Start1_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W20_a2_i            => PrSv_Start1_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2
        CpSv_Start1_W20_b2_i            => PrSv_Start1_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2
        CpSv_Start1_W20_min3_i          => PrSv_Start1_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W20_max3_i          => PrSv_Start1_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W20_a3_i            => PrSv_Start1_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3
        CpSv_Start1_W20_b3_i            => PrSv_Start1_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3
        CpSv_Start1_W50_min1_i          => PrSv_Start1_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W50_max1_i          => PrSv_Start1_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W50_a1_i            => PrSv_Start1_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W50_b1_i            => PrSv_Start1_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W50_min2_i          => PrSv_Start1_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W50_max2_i          => PrSv_Start1_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W50_a2_i            => PrSv_Start1_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W50_b2_i            => PrSv_Start1_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W50_min3_i          => PrSv_Start1_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W50_max3_i          => PrSv_Start1_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W50_a3_i            => PrSv_Start1_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W50_b3_i            => PrSv_Start1_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W50_min4_i          => PrSv_Start1_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W50_max4_i          => PrSv_Start1_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W50_a4_i            => PrSv_Start1_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a4
        CpSv_Start1_W50_b4_i            => PrSv_Start1_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b4    
        CpSv_Start1_W50_min5_i          => PrSv_Start1_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W50_max5_i          => PrSv_Start1_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W50_a5_i            => PrSv_Start1_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a5
        CpSv_Start1_W50_b5_i            => PrSv_Start1_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b5    
        CpSv_Start1_W90_min1_i          => PrSv_Start1_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W90_max1_i          => PrSv_Start1_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W90_a1_i            => PrSv_Start1_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W90_b1_i            => PrSv_Start1_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W90_min2_i          => PrSv_Start1_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W90_max2_i          => PrSv_Start1_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W90_a2_i            => PrSv_Start1_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W90_b2_i            => PrSv_Start1_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W90_min3_i          => PrSv_Start1_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W90_max3_i          => PrSv_Start1_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W90_a3_i            => PrSv_Start1_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W90_b3_i            => PrSv_Start1_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W90_min4_i          => PrSv_Start1_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W90_max4_i          => PrSv_Start1_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W90_a4_i            => PrSv_Start1_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a4  
        CpSv_Start1_W90_b4_i            => PrSv_Start1_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b4   
        CpSv_Start1_W90_min5_i          => PrSv_Start1_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W90_max5_i          => PrSv_Start1_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W90_a5_i            => PrSv_Start1_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a5  
        CpSv_Start1_W90_b5_i            => PrSv_Start1_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b5     
                                                                               
        -- Start2                                                               
        CpSv_Start2_W20_min1_i          => PrSv_Start2_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W20_max1_i          => PrSv_Start2_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W20_a1_i            => PrSv_Start2_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W20_b1_i            => PrSv_Start2_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W20_min2_i          => PrSv_Start2_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W20_max2_i          => PrSv_Start2_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W20_a2_i            => PrSv_Start2_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W20_b2_i            => PrSv_Start2_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W20_min3_i          => PrSv_Start2_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W20_max3_i          => PrSv_Start2_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W20_a3_i            => PrSv_Start2_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W20_b3_i            => PrSv_Start2_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min1_i          => PrSv_Start2_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W50_max1_i          => PrSv_Start2_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W50_a1_i            => PrSv_Start2_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W50_b1_i            => PrSv_Start2_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W50_min2_i          => PrSv_Start2_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W50_max2_i          => PrSv_Start2_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W50_a2_i            => PrSv_Start2_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W50_b2_i            => PrSv_Start2_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W50_min3_i          => PrSv_Start2_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W50_max3_i          => PrSv_Start2_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W50_a3_i            => PrSv_Start2_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W50_b3_i            => PrSv_Start2_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min4_i          => PrSv_Start2_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W50_max4_i          => PrSv_Start2_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W50_a4_i            => PrSv_Start2_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W50_b4_i            => PrSv_Start2_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W50_min5_i          => PrSv_Start2_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W50_max5_i          => PrSv_Start2_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W50_a5_i            => PrSv_Start2_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W50_b5_i            => PrSv_Start2_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b5     
        CpSv_Start2_W90_min1_i          => PrSv_Start2_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W90_max1_i          => PrSv_Start2_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W90_a1_i            => PrSv_Start2_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W90_b1_i            => PrSv_Start2_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W90_min2_i          => PrSv_Start2_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W90_max2_i          => PrSv_Start2_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W90_a2_i            => PrSv_Start2_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W90_b2_i            => PrSv_Start2_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W90_min3_i          => PrSv_Start2_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W90_max3_i          => PrSv_Start2_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W90_a3_i            => PrSv_Start2_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W90_b3_i            => PrSv_Start2_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W90_min4_i          => PrSv_Start2_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W90_max4_i          => PrSv_Start2_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W90_a4_i            => PrSv_Start2_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W90_b4_i            => PrSv_Start2_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W90_min5_i          => PrSv_Start2_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W90_max5_i          => PrSv_Start2_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W90_a5_i            => PrSv_Start2_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W90_b5_i            => PrSv_Start2_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b5     
                                                                               
        -- Start3                                                              
        CpSv_Start3_W20_min1_i          => PrSv_Start3_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W20_max1_i          => PrSv_Start3_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W20_a1_i            => PrSv_Start3_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W20_b1_i            => PrSv_Start3_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W20_min2_i          => PrSv_Start3_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W20_max2_i          => PrSv_Start3_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W20_a2_i            => PrSv_Start3_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W20_b2_i            => PrSv_Start3_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W20_min3_i          => PrSv_Start3_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W20_max3_i          => PrSv_Start3_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W20_a3_i            => PrSv_Start3_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W20_b3_i            => PrSv_Start3_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min1_i          => PrSv_Start3_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W50_max1_i          => PrSv_Start3_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W50_a1_i            => PrSv_Start3_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W50_b1_i            => PrSv_Start3_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W50_min2_i          => PrSv_Start3_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W50_max2_i          => PrSv_Start3_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W50_a2_i            => PrSv_Start3_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W50_b2_i            => PrSv_Start3_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W50_min3_i          => PrSv_Start3_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W50_max3_i          => PrSv_Start3_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W50_a3_i            => PrSv_Start3_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W50_b3_i            => PrSv_Start3_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min4_i          => PrSv_Start3_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W50_max4_i          => PrSv_Start3_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W50_a4_i            => PrSv_Start3_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W50_b4_i            => PrSv_Start3_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W50_min5_i          => PrSv_Start3_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W50_max5_i          => PrSv_Start3_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W50_a5_i            => PrSv_Start3_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W50_b5_i            => PrSv_Start3_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b5     
        CpSv_Start3_W90_min1_i          => PrSv_Start3_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W90_max1_i          => PrSv_Start3_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W90_a1_i            => PrSv_Start3_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W90_b1_i            => PrSv_Start3_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W90_min2_i          => PrSv_Start3_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W90_max2_i          => PrSv_Start3_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W90_a2_i            => PrSv_Start3_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W90_b2_i            => PrSv_Start3_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W90_min3_i          => PrSv_Start3_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W90_max3_i          => PrSv_Start3_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W90_a3_i            => PrSv_Start3_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W90_b3_i            => PrSv_Start3_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W90_min4_i          => PrSv_Start3_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W90_max4_i          => PrSv_Start3_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W90_a4_i            => PrSv_Start3_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W90_b4_i            => PrSv_Start3_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W90_min5_i          => PrSv_Start3_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W90_max5_i          => PrSv_Start3_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W90_a5_i            => PrSv_Start3_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W90_b5_i            => PrSv_Start3_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b5 
        
        --------------------------------
        -- TDC_Input_Data
        --------------------------------
        CpSl_DVld_i                     => PrSl_GroupEcho1_RdDly                 , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_EchoD1_i                   => PrSv_GroupEcho1_RdData(133 downto 115), -- PrSv_Echo1D1_s                       , -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo1_Data
        CpSv_EchoD2_i                   => PrSv_GroupEcho1_RdData(111 downto  93), -- PrSv_Echo1D2_s                       , -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo2_Data
        CpSv_EchoD3_i                   => PrSv_GroupEcho1_RdData( 89 downto  71), -- PrSv_Echo1D3_s                       , -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo3_Data
        CpSv_EchoD4_i                   => PrSv_GroupEcho1_RdData( 67 downto  49), -- PrSv_Echo1D4_s                       , -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo1_Data
        CpSv_EchoD5_i                   => PrSv_GroupEcho1_RdData( 45 downto  27), -- PrSv_Echo1D5_s                       , -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo2_Data
        CpSv_EchoD6_i                   => PrSv_GroupEcho1_RdData( 23 downto   5), -- PrSv_Echo1D6_s                       , -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo3_Data    
        CpSv_EchoD7_i                   => (others => '0')                       , -- in  std_logic_vector(18 downto 0);    -- TDC3_Echo1_Data
        CpSv_EchoD8_i                   => (others => '0')                       , -- in  std_logic_vector(18 downto 0);    -- TDC3_Echo2_Data
        CpSv_Echo1ID_i                  => PrSv_GroupEcho1_RdData(4 downto 2)    , -- PrSv_Echo1ID_s                       , -- in  std_logic_vector( 2 downto 0);    -- Echo1_ID   

        --------------------------------
        -- Wave_Data
        --------------------------------
        CpSv_CompData_o                 => PrSv_Comp1Data_s                     , -- out std_logic_vector(53 downto 0);    -- Compare_EchoData 
        CpSl_EchoVld_o                  => PrSl_Echo1Vld_s                      , -- out std_logic;                        -- EchoValid
        CpSv_EchoWave_o                 => PrSv_Echo1Wave_s                     , -- out std_logic_vector(18 downto 0);    -- EchoWave
        CpSv_EchoGray_o                 => PrSv_Echo1Gray_s                     , -- out std_logic_vector(15 downto 0)     -- EchoGray

        PrSv_EchoPW20_o                 => PrSv_EchoPW20_o
    );
    
    U_M_WaveData_1 : M_WaveData
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
        CpSv_LdNum_i                    => PrSv_GroupEcho2_RdData(1 downto 0)   , -- in  std_logic_vector(1 downto 0);
        
        --------------------------------
        -- WalkError
        --------------------------------
        CpSl_WalkErrorRdVld_i           => CpSl_WalkErrorRdVld_i                , -- in  std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_i          => CpSv_WalkErrorRdData_i               , -- in  std_logic_vector(20 downto 0)     -- WalkError_RdData
        
        --------------------------------
        -- Gray_Ratio
        --------------------------------
        CpSl_GrayDataVld_i              => PrSl_GrayDataVld_s                   , -- in  std_logic;                        -- Gray_RatioRdData_Vld
        CpSv_GrayData_i                 => PrSv_GrayData_s                      , -- in  std_logic_vector(15 downto 0);    -- Gray_RatioRdData

        --------------------------------
        -- Distance_Constant
        --------------------------------
        -- Start1
        CpSv_Start1_W20_min1_i          => PrSv_Start1_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W20_max1_i          => PrSv_Start1_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W20_a1_i            => PrSv_Start1_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W20_b1_i            => PrSv_Start1_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W20_min2_i          => PrSv_Start1_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W20_max2_i          => PrSv_Start1_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W20_a2_i            => PrSv_Start1_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2
        CpSv_Start1_W20_b2_i            => PrSv_Start1_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2
        CpSv_Start1_W20_min3_i          => PrSv_Start1_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W20_max3_i          => PrSv_Start1_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W20_a3_i            => PrSv_Start1_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3
        CpSv_Start1_W20_b3_i            => PrSv_Start1_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3
        CpSv_Start1_W50_min1_i          => PrSv_Start1_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W50_max1_i          => PrSv_Start1_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W50_a1_i            => PrSv_Start1_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W50_b1_i            => PrSv_Start1_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W50_min2_i          => PrSv_Start1_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W50_max2_i          => PrSv_Start1_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W50_a2_i            => PrSv_Start1_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W50_b2_i            => PrSv_Start1_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W50_min3_i          => PrSv_Start1_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W50_max3_i          => PrSv_Start1_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W50_a3_i            => PrSv_Start1_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W50_b3_i            => PrSv_Start1_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W50_min4_i          => PrSv_Start1_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W50_max4_i          => PrSv_Start1_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W50_a4_i            => PrSv_Start1_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a4
        CpSv_Start1_W50_b4_i            => PrSv_Start1_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b4    
        CpSv_Start1_W50_min5_i          => PrSv_Start1_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W50_max5_i          => PrSv_Start1_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W50_a5_i            => PrSv_Start1_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a5
        CpSv_Start1_W50_b5_i            => PrSv_Start1_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b5    
        CpSv_Start1_W90_min1_i          => PrSv_Start1_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W90_max1_i          => PrSv_Start1_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W90_a1_i            => PrSv_Start1_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W90_b1_i            => PrSv_Start1_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W90_min2_i          => PrSv_Start1_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W90_max2_i          => PrSv_Start1_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W90_a2_i            => PrSv_Start1_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W90_b2_i            => PrSv_Start1_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W90_min3_i          => PrSv_Start1_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W90_max3_i          => PrSv_Start1_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W90_a3_i            => PrSv_Start1_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W90_b3_i            => PrSv_Start1_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W90_min4_i          => PrSv_Start1_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W90_max4_i          => PrSv_Start1_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W90_a4_i            => PrSv_Start1_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a4  
        CpSv_Start1_W90_b4_i            => PrSv_Start1_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b4   
        CpSv_Start1_W90_min5_i          => PrSv_Start1_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W90_max5_i          => PrSv_Start1_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W90_a5_i            => PrSv_Start1_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a5  
        CpSv_Start1_W90_b5_i            => PrSv_Start1_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b5     
                                                                               
        -- Start2                                                               
        CpSv_Start2_W20_min1_i          => PrSv_Start2_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W20_max1_i          => PrSv_Start2_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W20_a1_i            => PrSv_Start2_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W20_b1_i            => PrSv_Start2_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W20_min2_i          => PrSv_Start2_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W20_max2_i          => PrSv_Start2_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W20_a2_i            => PrSv_Start2_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W20_b2_i            => PrSv_Start2_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W20_min3_i          => PrSv_Start2_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W20_max3_i          => PrSv_Start2_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W20_a3_i            => PrSv_Start2_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W20_b3_i            => PrSv_Start2_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min1_i          => PrSv_Start2_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W50_max1_i          => PrSv_Start2_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W50_a1_i            => PrSv_Start2_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W50_b1_i            => PrSv_Start2_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W50_min2_i          => PrSv_Start2_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W50_max2_i          => PrSv_Start2_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W50_a2_i            => PrSv_Start2_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W50_b2_i            => PrSv_Start2_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W50_min3_i          => PrSv_Start2_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W50_max3_i          => PrSv_Start2_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W50_a3_i            => PrSv_Start2_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W50_b3_i            => PrSv_Start2_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min4_i          => PrSv_Start2_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W50_max4_i          => PrSv_Start2_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W50_a4_i            => PrSv_Start2_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W50_b4_i            => PrSv_Start2_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W50_min5_i          => PrSv_Start2_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W50_max5_i          => PrSv_Start2_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W50_a5_i            => PrSv_Start2_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W50_b5_i            => PrSv_Start2_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b5     
        CpSv_Start2_W90_min1_i          => PrSv_Start2_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W90_max1_i          => PrSv_Start2_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W90_a1_i            => PrSv_Start2_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W90_b1_i            => PrSv_Start2_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W90_min2_i          => PrSv_Start2_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W90_max2_i          => PrSv_Start2_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W90_a2_i            => PrSv_Start2_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W90_b2_i            => PrSv_Start2_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W90_min3_i          => PrSv_Start2_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W90_max3_i          => PrSv_Start2_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W90_a3_i            => PrSv_Start2_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W90_b3_i            => PrSv_Start2_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W90_min4_i          => PrSv_Start2_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W90_max4_i          => PrSv_Start2_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W90_a4_i            => PrSv_Start2_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W90_b4_i            => PrSv_Start2_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W90_min5_i          => PrSv_Start2_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W90_max5_i          => PrSv_Start2_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W90_a5_i            => PrSv_Start2_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W90_b5_i            => PrSv_Start2_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b5     
                                                                               
        -- Start3                                                              
        CpSv_Start3_W20_min1_i          => PrSv_Start3_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W20_max1_i          => PrSv_Start3_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W20_a1_i            => PrSv_Start3_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W20_b1_i            => PrSv_Start3_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W20_min2_i          => PrSv_Start3_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W20_max2_i          => PrSv_Start3_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W20_a2_i            => PrSv_Start3_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W20_b2_i            => PrSv_Start3_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W20_min3_i          => PrSv_Start3_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W20_max3_i          => PrSv_Start3_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W20_a3_i            => PrSv_Start3_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W20_b3_i            => PrSv_Start3_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min1_i          => PrSv_Start3_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W50_max1_i          => PrSv_Start3_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W50_a1_i            => PrSv_Start3_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W50_b1_i            => PrSv_Start3_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W50_min2_i          => PrSv_Start3_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W50_max2_i          => PrSv_Start3_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W50_a2_i            => PrSv_Start3_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W50_b2_i            => PrSv_Start3_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W50_min3_i          => PrSv_Start3_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W50_max3_i          => PrSv_Start3_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W50_a3_i            => PrSv_Start3_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W50_b3_i            => PrSv_Start3_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min4_i          => PrSv_Start3_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W50_max4_i          => PrSv_Start3_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W50_a4_i            => PrSv_Start3_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W50_b4_i            => PrSv_Start3_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W50_min5_i          => PrSv_Start3_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W50_max5_i          => PrSv_Start3_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W50_a5_i            => PrSv_Start3_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W50_b5_i            => PrSv_Start3_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b5     
        CpSv_Start3_W90_min1_i          => PrSv_Start3_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W90_max1_i          => PrSv_Start3_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W90_a1_i            => PrSv_Start3_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W90_b1_i            => PrSv_Start3_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W90_min2_i          => PrSv_Start3_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W90_max2_i          => PrSv_Start3_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W90_a2_i            => PrSv_Start3_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W90_b2_i            => PrSv_Start3_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W90_min3_i          => PrSv_Start3_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W90_max3_i          => PrSv_Start3_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W90_a3_i            => PrSv_Start3_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W90_b3_i            => PrSv_Start3_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W90_min4_i          => PrSv_Start3_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W90_max4_i          => PrSv_Start3_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W90_a4_i            => PrSv_Start3_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W90_b4_i            => PrSv_Start3_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W90_min5_i          => PrSv_Start3_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W90_max5_i          => PrSv_Start3_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W90_a5_i            => PrSv_Start3_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W90_b5_i            => PrSv_Start3_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b5 
        
        --------------------------------
        -- TDC_Input_Data
        --------------------------------
        CpSl_DVld_i                     => PrSl_GroupEcho1_RdDly                 , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_EchoD1_i                   => PrSv_GroupEcho2_RdData(133 downto 115), -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo1_Data
        CpSv_EchoD2_i                   => PrSv_GroupEcho2_RdData(111 downto  93), -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo2_Data
        CpSv_EchoD3_i                   => PrSv_GroupEcho2_RdData( 89 downto  71), -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo3_Data
        CpSv_EchoD4_i                   => PrSv_GroupEcho2_RdData( 67 downto  49), -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo1_Data
        CpSv_EchoD5_i                   => PrSv_GroupEcho2_RdData( 45 downto  27), -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo2_Data
        CpSv_EchoD6_i                   => PrSv_GroupEcho2_RdData( 23 downto   5), -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo3_Data    
        CpSv_EchoD7_i                   => (others => '0')                       , -- in  std_logic_vector(18 downto 0);    -- TDC3_Echo1_Data
        CpSv_EchoD8_i                   => (others => '0')                       , -- in  std_logic_vector(18 downto 0);    -- TDC3_Echo2_Data
        CpSv_Echo1ID_i                  => PrSv_GroupEcho2_RdData(4 downto 2)    , -- in  std_logic_vector( 2 downto 0);    -- Echo1_ID   

        --------------------------------
        -- Wave_Data
        --------------------------------
        CpSv_CompData_o                 => PrSv_Comp2Data_s                     , -- out std_logic_vector(53 downto 0);    -- Compare_EchoData
        CpSl_EchoVld_o                  => PrSl_Echo2Vld_s                      , -- out std_logic;                        -- EchoValid
        CpSv_EchoWave_o                 => PrSv_Echo2Wave_s                     , -- out std_logic_vector(18 downto 0);    -- EchoWave
        CpSv_EchoGray_o                 => PrSv_Echo2Gray_s                     , -- out std_logic_vector(15 downto 0)     -- EchoGray

        PrSv_EchoPW20_o                 => open
    );
    
    U_M_WaveData_2 : M_WaveData
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
        CpSv_LdNum_i                    => PrSv_GroupEcho3_RdData(1 downto 0)   , -- in  std_logic_vector(1 downto 0);
        
        --------------------------------
        -- WalkError
        --------------------------------
        CpSl_WalkErrorRdVld_i           => CpSl_WalkErrorRdVld_i                , -- in  std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_i          => CpSv_WalkErrorRdData_i               , -- in  std_logic_vector(20 downto 0)     -- WalkError_RdData
        
        --------------------------------
        -- Gray_Ratio
        --------------------------------
        CpSl_GrayDataVld_i              => PrSl_GrayDataVld_s                   , -- in  std_logic;                        -- Gray_RatioRdData_Vld
        CpSv_GrayData_i                 => PrSv_GrayData_s                      , -- in  std_logic_vector(15 downto 0);    -- Gray_RatioRdData

        --------------------------------
        -- Distance_Constant
        --------------------------------
        -- Start1
        CpSv_Start1_W20_min1_i          => PrSv_Start1_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W20_max1_i          => PrSv_Start1_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W20_a1_i            => PrSv_Start1_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W20_b1_i            => PrSv_Start1_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W20_min2_i          => PrSv_Start1_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W20_max2_i          => PrSv_Start1_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W20_a2_i            => PrSv_Start1_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2
        CpSv_Start1_W20_b2_i            => PrSv_Start1_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2
        CpSv_Start1_W20_min3_i          => PrSv_Start1_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W20_max3_i          => PrSv_Start1_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W20_a3_i            => PrSv_Start1_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3
        CpSv_Start1_W20_b3_i            => PrSv_Start1_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3
        CpSv_Start1_W50_min1_i          => PrSv_Start1_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W50_max1_i          => PrSv_Start1_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W50_a1_i            => PrSv_Start1_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W50_b1_i            => PrSv_Start1_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W50_min2_i          => PrSv_Start1_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W50_max2_i          => PrSv_Start1_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W50_a2_i            => PrSv_Start1_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W50_b2_i            => PrSv_Start1_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W50_min3_i          => PrSv_Start1_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W50_max3_i          => PrSv_Start1_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W50_a3_i            => PrSv_Start1_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W50_b3_i            => PrSv_Start1_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W50_min4_i          => PrSv_Start1_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W50_max4_i          => PrSv_Start1_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W50_a4_i            => PrSv_Start1_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a4
        CpSv_Start1_W50_b4_i            => PrSv_Start1_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b4    
        CpSv_Start1_W50_min5_i          => PrSv_Start1_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W50_max5_i          => PrSv_Start1_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W50_a5_i            => PrSv_Start1_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a5
        CpSv_Start1_W50_b5_i            => PrSv_Start1_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b5    
        CpSv_Start1_W90_min1_i          => PrSv_Start1_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min1
        CpSv_Start1_W90_max1_i          => PrSv_Start1_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max1
        CpSv_Start1_W90_a1_i            => PrSv_Start1_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a1
        CpSv_Start1_W90_b1_i            => PrSv_Start1_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b1
        CpSv_Start1_W90_min2_i          => PrSv_Start1_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min2
        CpSv_Start1_W90_max2_i          => PrSv_Start1_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max2
        CpSv_Start1_W90_a2_i            => PrSv_Start1_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a2  
        CpSv_Start1_W90_b2_i            => PrSv_Start1_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b2  
        CpSv_Start1_W90_min3_i          => PrSv_Start1_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min3
        CpSv_Start1_W90_max3_i          => PrSv_Start1_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max3
        CpSv_Start1_W90_a3_i            => PrSv_Start1_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a3  
        CpSv_Start1_W90_b3_i            => PrSv_Start1_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b3  
        CpSv_Start1_W90_min4_i          => PrSv_Start1_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min4
        CpSv_Start1_W90_max4_i          => PrSv_Start1_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max4
        CpSv_Start1_W90_a4_i            => PrSv_Start1_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a4  
        CpSv_Start1_W90_b4_i            => PrSv_Start1_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b4   
        CpSv_Start1_W90_min5_i          => PrSv_Start1_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_min5
        CpSv_Start1_W90_max5_i          => PrSv_Start1_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start1_max5
        CpSv_Start1_W90_a5_i            => PrSv_Start1_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_a5  
        CpSv_Start1_W90_b5_i            => PrSv_Start1_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start1_b5     
                                                                               
        -- Start2                                                               
        CpSv_Start2_W20_min1_i          => PrSv_Start2_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W20_max1_i          => PrSv_Start2_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W20_a1_i            => PrSv_Start2_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W20_b1_i            => PrSv_Start2_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W20_min2_i          => PrSv_Start2_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W20_max2_i          => PrSv_Start2_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W20_a2_i            => PrSv_Start2_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W20_b2_i            => PrSv_Start2_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W20_min3_i          => PrSv_Start2_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W20_max3_i          => PrSv_Start2_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W20_a3_i            => PrSv_Start2_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W20_b3_i            => PrSv_Start2_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min1_i          => PrSv_Start2_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W50_max1_i          => PrSv_Start2_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W50_a1_i            => PrSv_Start2_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W50_b1_i            => PrSv_Start2_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W50_min2_i          => PrSv_Start2_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W50_max2_i          => PrSv_Start2_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W50_a2_i            => PrSv_Start2_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W50_b2_i            => PrSv_Start2_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W50_min3_i          => PrSv_Start2_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W50_max3_i          => PrSv_Start2_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W50_a3_i            => PrSv_Start2_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W50_b3_i            => PrSv_Start2_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W50_min4_i          => PrSv_Start2_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W50_max4_i          => PrSv_Start2_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W50_a4_i            => PrSv_Start2_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W50_b4_i            => PrSv_Start2_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W50_min5_i          => PrSv_Start2_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W50_max5_i          => PrSv_Start2_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W50_a5_i            => PrSv_Start2_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W50_b5_i            => PrSv_Start2_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b5     
        CpSv_Start2_W90_min1_i          => PrSv_Start2_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min1   
        CpSv_Start2_W90_max1_i          => PrSv_Start2_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max1   
        CpSv_Start2_W90_a1_i            => PrSv_Start2_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a1     
        CpSv_Start2_W90_b1_i            => PrSv_Start2_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b1     
        CpSv_Start2_W90_min2_i          => PrSv_Start2_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min2   
        CpSv_Start2_W90_max2_i          => PrSv_Start2_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max2   
        CpSv_Start2_W90_a2_i            => PrSv_Start2_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a2     
        CpSv_Start2_W90_b2_i            => PrSv_Start2_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b2     
        CpSv_Start2_W90_min3_i          => PrSv_Start2_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min3   
        CpSv_Start2_W90_max3_i          => PrSv_Start2_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max3   
        CpSv_Start2_W90_a3_i            => PrSv_Start2_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a3     
        CpSv_Start2_W90_b3_i            => PrSv_Start2_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b3     
        CpSv_Start2_W90_min4_i          => PrSv_Start2_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min4   
        CpSv_Start2_W90_max4_i          => PrSv_Start2_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max4   
        CpSv_Start2_W90_a4_i            => PrSv_Start2_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a4     
        CpSv_Start2_W90_b4_i            => PrSv_Start2_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b4     
        CpSv_Start2_W90_min5_i          => PrSv_Start2_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_min5   
        CpSv_Start2_W90_max5_i          => PrSv_Start2_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start2_max5   
        CpSv_Start2_W90_a5_i            => PrSv_Start2_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_a5     
        CpSv_Start2_W90_b5_i            => PrSv_Start2_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start2_b5     
                                                                               
        -- Start3                                                              
        CpSv_Start3_W20_min1_i          => PrSv_Start3_W20_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W20_max1_i          => PrSv_Start3_W20_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W20_a1_i            => PrSv_Start3_W20_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W20_b1_i            => PrSv_Start3_W20_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W20_min2_i          => PrSv_Start3_W20_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W20_max2_i          => PrSv_Start3_W20_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W20_a2_i            => PrSv_Start3_W20_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W20_b2_i            => PrSv_Start3_W20_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W20_min3_i          => PrSv_Start3_W20_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W20_max3_i          => PrSv_Start3_W20_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W20_a3_i            => PrSv_Start3_W20_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W20_b3_i            => PrSv_Start3_W20_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min1_i          => PrSv_Start3_W50_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W50_max1_i          => PrSv_Start3_W50_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W50_a1_i            => PrSv_Start3_W50_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W50_b1_i            => PrSv_Start3_W50_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W50_min2_i          => PrSv_Start3_W50_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W50_max2_i          => PrSv_Start3_W50_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W50_a2_i            => PrSv_Start3_W50_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W50_b2_i            => PrSv_Start3_W50_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W50_min3_i          => PrSv_Start3_W50_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W50_max3_i          => PrSv_Start3_W50_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W50_a3_i            => PrSv_Start3_W50_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W50_b3_i            => PrSv_Start3_W50_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W50_min4_i          => PrSv_Start3_W50_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W50_max4_i          => PrSv_Start3_W50_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W50_a4_i            => PrSv_Start3_W50_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W50_b4_i            => PrSv_Start3_W50_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W50_min5_i          => PrSv_Start3_W50_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W50_max5_i          => PrSv_Start3_W50_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W50_a5_i            => PrSv_Start3_W50_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W50_b5_i            => PrSv_Start3_W50_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b5     
        CpSv_Start3_W90_min1_i          => PrSv_Start3_W90_min1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min1   
        CpSv_Start3_W90_max1_i          => PrSv_Start3_W90_max1_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max1   
        CpSv_Start3_W90_a1_i            => PrSv_Start3_W90_a1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a1     
        CpSv_Start3_W90_b1_i            => PrSv_Start3_W90_b1_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b1     
        CpSv_Start3_W90_min2_i          => PrSv_Start3_W90_min2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min2   
        CpSv_Start3_W90_max2_i          => PrSv_Start3_W90_max2_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max2   
        CpSv_Start3_W90_a2_i            => PrSv_Start3_W90_a2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a2     
        CpSv_Start3_W90_b2_i            => PrSv_Start3_W90_b2_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b2     
        CpSv_Start3_W90_min3_i          => PrSv_Start3_W90_min3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min3   
        CpSv_Start3_W90_max3_i          => PrSv_Start3_W90_max3_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max3   
        CpSv_Start3_W90_a3_i            => PrSv_Start3_W90_a3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a3     
        CpSv_Start3_W90_b3_i            => PrSv_Start3_W90_b3_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b3     
        CpSv_Start3_W90_min4_i          => PrSv_Start3_W90_min4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min4   
        CpSv_Start3_W90_max4_i          => PrSv_Start3_W90_max4_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max4   
        CpSv_Start3_W90_a4_i            => PrSv_Start3_W90_a4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a4     
        CpSv_Start3_W90_b4_i            => PrSv_Start3_W90_b4_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b4     
        CpSv_Start3_W90_min5_i          => PrSv_Start3_W90_min5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_min5   
        CpSv_Start3_W90_max5_i          => PrSv_Start3_W90_max5_s               , -- in  std_logic_vector(15 downto 0);    -- Start3_max5   
        CpSv_Start3_W90_a5_i            => PrSv_Start3_W90_a5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_a5     
        CpSv_Start3_W90_b5_i            => PrSv_Start3_W90_b5_s                 , -- in  std_logic_vector(15 downto 0);    -- Start3_b5 
        
        --------------------------------
        -- TDC_Input_Data
        --------------------------------
        CpSl_DVld_i                     => PrSl_GroupEcho1_RdDly                 , -- in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_EchoD1_i                   => PrSv_GroupEcho3_RdData(133 downto 115), -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo1_Data
        CpSv_EchoD2_i                   => PrSv_GroupEcho3_RdData(111 downto  93), -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo2_Data
        CpSv_EchoD3_i                   => PrSv_GroupEcho3_RdData( 89 downto  71), -- in  std_logic_vector(18 downto 0);    -- TDC1_Echo3_Data
        CpSv_EchoD4_i                   => PrSv_GroupEcho3_RdData( 67 downto  49), -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo1_Data
        CpSv_EchoD5_i                   => PrSv_GroupEcho3_RdData( 45 downto  27), -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo2_Data
        CpSv_EchoD6_i                   => PrSv_GroupEcho3_RdData( 23 downto   5), -- in  std_logic_vector(18 downto 0);    -- TDC2_Echo3_Data    
        CpSv_EchoD7_i                   => (others => '0')                       , -- in  std_logic_vector(18 downto 0);    -- TDC3_Echo1_Data
        CpSv_EchoD8_i                   => (others => '0')                       , -- in  std_logic_vector(18 downto 0);    -- TDC3_Echo2_Data
        CpSv_Echo1ID_i                  => PrSv_GroupEcho3_RdData(4 downto 2)    , -- in  std_logic_vector( 2 downto 0);    -- Echo1_ID   

        --------------------------------
        -- Wave_Data
        --------------------------------
        CpSv_CompData_o                 => PrSv_Comp3Data_s                     , -- out std_logic_vector(53 downto 0);    -- Compare_EchoData
        CpSl_EchoVld_o                  => PrSl_Echo3Vld_s                      , -- out std_logic;                        -- EchoValid
        CpSv_EchoWave_o                 => PrSv_Echo3Wave_s                     , -- out std_logic_vector(18 downto 0);    -- EchoWave
        CpSv_EchoGray_o                 => PrSv_Echo3Gray_s                     , -- out std_logic_vector(15 downto 0)     -- EchoGray

        PrSv_EchoPW20_o                 => open
    );
    
    U_M_CompWave_0 : M_CompWave
    port map (
        --------------------------------
    	-- Clk & Reset
    	--------------------------------
    	CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
    	CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz
    	
    	--------------------------------
    	-- Compare_Data_InPut
    	--------------------------------
    	CpSv_Comp1Data_i                => PrSv_Comp1Data_s                     , -- in  std_logic_vector(53 downto 0);    -- Compare_EchoData 
    	CpSv_Comp2Data_i                => PrSv_Comp2Data_s                     , -- in  std_logic_vector(53 downto 0);    -- Compare_EchoData 
    	CpSv_Comp3Data_i                => PrSv_Comp3Data_s                     , -- in  std_logic_vector(53 downto 0);    -- Compare_EchoData 
    	
    	--------------------------------
    	-- Check_Data_InPut
    	--------------------------------
    	CpSl_Echo1DVld_i                => PrSl_Echo1Vld_s                      , -- in  std_logic;                        -- Echo1_DataValid
    	CpSv_Echo1Wave_i                => PrSv_Echo1Wave_s                     , -- in  std_logic_vector(18 downto 0);    -- Echo1_Wave
    	CpSv_Echo1Gray_i                => PrSv_Echo1Gray_s                     , -- in  std_logic_vector(15 downto 0);    -- Echo1_Gray
    	CpSl_Echo2DVld_i                => PrSl_Echo2Vld_s                      , -- in  std_logic;                        -- Echo2_DataValid
    	CpSv_Echo2Wave_i                => PrSv_Echo2Wave_s                     , -- in  std_logic_vector(18 downto 0);    -- Echo2_Wave
    	CpSv_Echo2Gray_i                => PrSv_Echo2Gray_s                     , -- in  std_logic_vector(15 downto 0);    -- Echo2_Gray
    	CpSl_Echo3DVld_i                => PrSl_Echo3Vld_s                      , -- in  std_logic;                        -- Echo3_DataValid
    	CpSv_Echo3Wave_i                => PrSv_Echo3Wave_s                     , -- in  std_logic_vector(18 downto 0);    -- Echo3_Wave
    	CpSv_Echo3Gray_i                => PrSv_Echo3Gray_s                     , -- in  std_logic_vector(15 downto 0);    -- Echo3_Gray

    	--------------------------------
    	-- Check_Data_OutPut
    	--------------------------------
    	CpSl_CheckDVld_o                => PrSl_CheckDVld_s                     , -- out std_logic;                        -- Check_DataValid
    	CpSv_CheckWave_o                => PrSv_CheckWave_s                     , -- out std_logic_vector(18 downto 0);    -- Check
    	CpSv_CheckGray_o                => PrSv_CheckGray_s                       -- out std_logic_vector(15 downto 0)     -- Check_Gray
    );
    
    ----------------------------------------------------------------------------
    -- OutPut
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Check_Max_Data/Echo1_Data
    ------------------------------------
    CpSv_EchoDVld_o  <= PrSl_CheckDVld_s;
    CpSv_Echo1Wave_o <= PrSv_CheckWave_s;
    CpSv_Echo1Gray_o <= PrSv_CheckGray_s;
--    CpSv_EchoDVld_o  <= PrSl_Echo1Vld_s ;
--    CpSv_Echo1Wave_o <= PrSv_Echo1Wave_s;
--    CpSv_Echo1Gray_o <= PrSv_Echo1Gray_s;
    
    ------------------------------------
    -- Echo2/3_Data
    ------------------------------------
    CpSv_Echo2Wave_o <= PrSv_Echo2Wave_s;
    CpSv_Echo2Gray_o <= PrSv_Echo2Gray_s;
    CpSv_Echo3Wave_o <= PrSv_Echo3Wave_s;
    CpSv_Echo3Gray_o <= PrSv_Echo3Gray_s;
    
--------------------------------------------------------------------------------
-- End_Coding
--------------------------------------------------------------------------------
end arch_M_Data;