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
-- �ļ�����  :  M_WaveData.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/05/17
-- ���ܼ���  :  Send Data to PC;  Unit : 10ps;
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_WaveData is
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
		  
        PrSv_EchoPW20_o                : out std_logic_vector(18 downto 0)
    );
end M_WaveData;

architecture arch_M_WaveData of M_WaveData is
    ----------------------------------------------------------------------------
    -- Constant_Describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- 20 : High TIA High Threshold
    -- 50 : Low  TIA Low  Threshold
    -- 90 : Low  TIA High Threshold
    ------------------------------------
    -- Colume
    -- HG_1.25V
--    constant w20_min_1                  : std_logic_vector(18 downto 0) := "000"&X"012C";
--    constant w20_max_1                  : std_logic_vector(18 downto 0) := "000"&X"028A";
--    constant w20_a_1                    : std_logic_vector(15 downto 0) := X"0217"; -- *2^10
--    constant w20_b_1                    : std_logic_vector(15 downto 0) := X"F5AD";
--    constant w20_min_2                  : std_logic_vector(18 downto 0) := "000"&X"028A";
--    constant w20_max_2                  : std_logic_vector(18 downto 0) := "000"&X"041A";
--    constant w20_a_2                    : std_logic_vector(15 downto 0) := X"01A8"; -- *2^10
--    constant w20_b_2                    : std_logic_vector(15 downto 0) := X"F5EF";
--    constant w20_min_3                  : std_logic_vector(18 downto 0) := "000"&X"041A";
--    constant w20_max_3                  : std_logic_vector(18 downto 0) := "000"&X"04CE";
--    constant w20_a_3                    : std_logic_vector(15 downto 0) := X"00E5"; -- *2^10
--    constant w20_b_3                    : std_logic_vector(15 downto 0) := X"F6B8";

--    -- HG_375mv
--    constant w20_min_1                  : std_logic_vector(18 downto 0) := "000"&X"012C";
--    constant w20_max_1                  : std_logic_vector(18 downto 0) := "000"&X"028A";
--    constant w20_a_1                    : std_logic_vector(15 downto 0) := X"01FE"; -- *2^10
--    constant w20_b_1                    : std_logic_vector(15 downto 0) := X"F5D4";
--    constant w20_min_2                  : std_logic_vector(18 downto 0) := "000"&X"028A";
--    constant w20_max_2                  : std_logic_vector(18 downto 0) := "000"&X"041A";
--    constant w20_a_2                    : std_logic_vector(15 downto 0) := X"01FE"; -- *2^10
--    constant w20_b_2                    : std_logic_vector(15 downto 0) := X"F5D4";
--    constant w20_min_3                  : std_logic_vector(18 downto 0) := "000"&X"041A";
--    constant w20_max_3                  : std_logic_vector(18 downto 0) := "000"&X"04CE";
--    constant w20_a_3                    : std_logic_vector(15 downto 0) := X"00D0"; -- *2^10
--    constant w20_b_3                    : std_logic_vector(15 downto 0) := X"F706";
--    
    -- Constant_PW50
    constant PrSv_IndPW50_c             : std_logic_vector(18 downto 0) := "000"&X"012C";
--    
--    constant w50_min_1                  : std_logic_vector(18 downto 0) := "000"&X"012C";
--    constant w50_max_1                  : std_logic_vector(18 downto 0) := "000"&X"0320";
--    constant w50_a_1                    : std_logic_vector(15 downto 0) := X"0208"; -- *2^10
--    constant w50_b_1                    : std_logic_vector(15 downto 0) := X"F61A";
--    constant w50_min_2                  : std_logic_vector(18 downto 0) := "000"&X"0320";
--    constant w50_max_2                  : std_logic_vector(18 downto 0) := "000"&X"03F8";
--    constant w50_a_2                    : std_logic_vector(15 downto 0) := X"00F3"; -- *2^10
--    constant w50_b_2                    : std_logic_vector(15 downto 0) := X"F6EA";
--    constant w50_min_3                  : std_logic_vector(18 downto 0) := "000"&X"03F8";
--    constant w50_max_3                  : std_logic_vector(18 downto 0) := "000"&X"0578";
--    constant w50_a_3                    : std_logic_vector(15 downto 0) := X"006D"; -- *2^10
--    constant w50_b_3                    : std_logic_vector(15 downto 0) := X"F785";
--    constant w50_min_4                  : std_logic_vector(18 downto 0) := "000"&X"0578";
--    constant w50_max_4                  : std_logic_vector(18 downto 0) := "000"&X"0708";
--    constant w50_a_4                    : std_logic_vector(15 downto 0) := X"0020"; -- *2^10
--    constant w50_b_4                    : std_logic_vector(15 downto 0) := X"F7ED";
--    constant w50_min_5                  : std_logic_vector(18 downto 0) := "000"&X"0708";
--    constant w50_a_5                    : std_logic_vector(15 downto 0) := X"0000"; -- *2^10
--    constant w50_b_5                    : std_logic_vector(15 downto 0) := X"F82B";
--    
--    constant w90_min_1                  : std_logic_vector(18 downto 0) := "000"&X"012C";
--    constant w90_max_1                  : std_logic_vector(18 downto 0) := "000"&X"0258";
--    constant w90_a_1                    : std_logic_vector(15 downto 0) := X"01F9"; -- *2^10
--    constant w90_b_1                    : std_logic_vector(15 downto 0) := X"F654";
--    constant w90_min_2                  : std_logic_vector(18 downto 0) := "000"&X"0258";
--    constant w90_max_2                  : std_logic_vector(18 downto 0) := "000"&X"04B0";
--    constant w90_a_2                    : std_logic_vector(15 downto 0) := X"007B"; -- *2^10
--    constant w90_b_2                    : std_logic_vector(15 downto 0) := X"F72E";
--    constant w90_min_3                  : std_logic_vector(18 downto 0) := "000"&X"04B0";
--    constant w90_max_3                  : std_logic_vector(18 downto 0) := "000"&X"06A4";
--    constant w90_a_3                    : std_logic_vector(15 downto 0) := X"000E"; -- *2^10
--    constant w90_b_3                    : std_logic_vector(15 downto 0) := X"F7B5";    
--    constant w90_min_4                  : std_logic_vector(18 downto 0) := "000"&X"06A4";
--    constant w90_max_4                  : std_logic_vector(18 downto 0) := "000"&X"078A";
--    constant w90_a_4                    : std_logic_vector(15 downto 0) := X"000E"; -- *2^10
--    constant w90_b_4                    : std_logic_vector(15 downto 0) := X"F7B5";
--    constant w90_min_5                  : std_logic_vector(18 downto 0) := "000"&X"078A";
--    constant w90_a_5                    : std_logic_vector(15 downto 0) := X"0000"; -- *2^10
--    constant w90_b_5                    : std_logic_vector(15 downto 0) := X"F7D1";

    constant tr_50_90_min_1             : std_logic_vector(18 downto 0) := "000"&X"0087";
    constant tr_50_90_max_1             : std_logic_vector(18 downto 0) := "000"&X"00C9";
    constant tr_50_90_a_1               : std_logic_vector(15 downto 0) := X"FA31"; -- *2^10
    constant tr_50_90_b_1               : std_logic_vector(15 downto 0) := X"F8C2";
    constant tr_50_90_min_2             : std_logic_vector(18 downto 0) := "000"&X"0074";
    constant tr_50_90_max_2             : std_logic_vector(18 downto 0) := "000"&X"0087";
    constant tr_50_90_a_2               : std_logic_vector(15 downto 0) := X"F69F"; -- *2^10
    constant tr_50_90_b_2               : std_logic_vector(15 downto 0) := X"F93A";
    constant tr_50_90_min_3             : std_logic_vector(18 downto 0) := "000"&X"0064";
    constant tr_50_90_max_3             : std_logic_vector(18 downto 0) := "000"&X"0074";
    constant tr_50_90_a_3               : std_logic_vector(15 downto 0) := X"EFD2"; -- *2^10
    constant tr_50_90_b_3               : std_logic_vector(15 downto 0) := X"FA00";
    
    constant tf_90_50_min_1             : std_logic_vector(18 downto 0) := "000"&X"009D";
    constant tf_90_50_max_1             : std_logic_vector(18 downto 0) := "000"&X"00AD";
    constant tf_90_50_a_1               : std_logic_vector(15 downto 0) := X"0A91"; -- *2^10
    constant tf_90_50_b_1               : std_logic_vector(15 downto 0) := X"F54C";
    constant tf_90_50_min_2             : std_logic_vector(18 downto 0) := "000"&X"0071";
    constant tf_90_50_max_2             : std_logic_vector(18 downto 0) := "000"&X"009D";
    constant tf_90_50_a_2               : std_logic_vector(15 downto 0) := X"08B1"; -- *2^10
    constant tf_90_50_b_2               : std_logic_vector(15 downto 0) := X"F599";
    constant tf_90_50_min_3             : std_logic_vector(18 downto 0) := "000"&X"005B";
    constant tf_90_50_max_3             : std_logic_vector(18 downto 0) := "000"&X"0071";
    constant tf_90_50_a_3               : std_logic_vector(15 downto 0) := X"0C59"; -- *2^10
    constant tf_90_50_b_3               : std_logic_vector(15 downto 0) := X"F530";
    
    ------------------------------------
    -- Gray_Colum
    ------------------------------------
    constant Gray_PW20_min_1            : std_logic_vector(18 downto 0) := "000"&X"012C";
    constant Gray_PW20_max_1            : std_logic_vector(18 downto 0) := "000"&X"02BC";
    constant Gray_PW20_a_1              : std_logic_vector( 3 downto 0) := X"0"; -- *2^6
    constant Gray_PW20_b_1              : std_logic_vector( 8 downto 0) := '0' & X"00";
    constant Gray_PW20_c_1              : std_logic_vector(21 downto 0) := "00" & X"00006";         
    constant Gray_PW20_min_2            : std_logic_vector(18 downto 0) := "000"&X"02BC";
    constant Gray_PW20_max_2            : std_logic_vector(18 downto 0) := "000"&X"07D0";
    constant Gray_PW20_a_2              : std_logic_vector( 3 downto 0) := X"2"; -- *2^6            
    constant Gray_PW20_b_2              : std_logic_vector( 8 downto 0) := '1' & X"DD";    
    constant Gray_PW20_c_2              : std_logic_vector(21 downto 0) := "00" & X"000D3";  
    constant Gray_PW20_min_3            : std_logic_vector(18 downto 0) := "000"&X"07D0";
    constant Gray_PW20_max_3            : std_logic_vector(18 downto 0) := "000"&X"0AF0";
    constant Gray_PW20_a_3              : std_logic_vector( 3 downto 0) := X"D"; -- *2^6   
    constant Gray_PW20_b_3              : std_logic_vector( 8 downto 0) := '0' & X"ED";    
    constant Gray_PW20_c_3              : std_logic_vector(21 downto 0) := "11" & X"FF046";  
    
    constant Gray_PW50_min_1            : std_logic_vector(18 downto 0) := "000"&X"012C";
    constant Gray_PW50_max_1            : std_logic_vector(18 downto 0) := "000"&X"02BC";
    constant Gray_PW50_a_1              : std_logic_vector( 3 downto 0) := X"0"; -- *2^6
    constant Gray_PW50_b_1              : std_logic_vector( 8 downto 0) := '0' & X"00";
    constant Gray_PW50_c_1              : std_logic_vector(21 downto 0) := "00" & X"0000A";         
    constant Gray_PW50_min_2            : std_logic_vector(18 downto 0) := "000"&X"02BC";
    constant Gray_PW50_max_2            : std_logic_vector(18 downto 0) := "000"&X"06A4";
    constant Gray_PW50_a_2              : std_logic_vector( 3 downto 0) := X"1"; -- *2^6   
    constant Gray_PW50_b_2              : std_logic_vector( 8 downto 0) := '1' & X"E6";    
    constant Gray_PW50_c_2              : std_logic_vector(21 downto 0) := "00" & X"00087";  
    constant Gray_PW50_min_3            : std_logic_vector(18 downto 0) := "000"&X"06A4";
    constant Gray_PW50_max_3            : std_logic_vector(18 downto 0) := "000"&X"0A8C";
    constant Gray_PW50_a_3              : std_logic_vector( 3 downto 0) := X"D"; -- *2^6   
    constant Gray_PW50_b_3              : std_logic_vector( 8 downto 0) := '0' & X"FD";    
    constant Gray_PW50_c_3              : std_logic_vector(21 downto 0) := "11" & X"FEF9B";  
    
    constant Gray_PW90_min_1            : std_logic_vector(18 downto 0) := "000"&X"012C";
    constant Gray_PW90_max_1            : std_logic_vector(18 downto 0) := "000"&X"06A4";
    constant Gray_PW90_a_1              : std_logic_vector( 3 downto 0) := X"1"; -- *2^6
    constant Gray_PW90_b_1              : std_logic_vector( 8 downto 0) := '1' & X"EE";
    constant Gray_PW90_c_1              : std_logic_vector(21 downto 0) := "00" & X"00058";         
    constant Gray_PW90_min_2            : std_logic_vector(18 downto 0) := "000"&X"06A4";
    constant Gray_PW90_max_2            : std_logic_vector(18 downto 0) := "000"&X"0A28";
    constant Gray_PW90_a_2              : std_logic_vector( 3 downto 0) := X"3"; -- *2^6   
    constant Gray_PW90_b_2              : std_logic_vector( 8 downto 0) := '0' & X"D5";    
    constant Gray_PW90_c_2              : std_logic_vector(21 downto 0) := "11" & X"FF39C";  
    
    ------------------------------------
    -- Echo_State
    ------------------------------------
    constant PrSv_Idle_c                : std_logic_vector( 3 downto 0) := x"0";  -- Idle
    constant PrSv_Colum_c               : std_logic_vector( 3 downto 0) := x"1";  -- Colum
    constant PrSv_TdcMult_c             : std_logic_vector( 3 downto 0) := x"2";  -- TdcMult
    constant PrSv_DistGray_c            : std_logic_vector( 3 downto 0) := x"3";  -- Dist*Gray
    constant PrSv_MeanData_c            : std_logic_vector( 3 downto 0) := x"4";  -- MeanData
    constant PrSv_TdcEnd_c              : std_logic_vector( 3 downto 0) := x"8";  -- TdcEnd
    constant PrSv_TdcVldEnd_c           : std_logic_vector( 3 downto 0) := x"A";  -- TDCEndVld
    
    constant PrSv_ColumTime_c           : std_logic_vector( 3 downto 0) := x"9";  -- ColumTime
    ----------------------------------------------------------------------------
    -- Component_Describe
    ----------------------------------------------------------------------------
    -- Distance
    component M_MultRate is
    port (
		dataa		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		datab		: IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (34 DOWNTO 0)
	);
    end component;
    
    component M_TdcParAdd is
    port (
		data0x		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		data1x		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		data2x		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		data3x		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);    
		result		: OUT STD_LOGIC_VECTOR (18 DOWNTO 0)
	);
    end component;

    -- Gray_Colum
    component M_GrayColum IS
    PORT (
		dataa		: IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
		datab		: IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
    );
    end component;

    component M_GrayColum_a IS
    PORT (
		dataa		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (21 DOWNTO 0)
	);
    END component;

    component M_GrayColum_b is
    PORT (
		dataa		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (21 DOWNTO 0)
	);
    END component;
    
    component M_GrayColum_Add is
    port (
		data0x		: IN STD_LOGIC_VECTOR (21 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (21 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (21 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
    end component;
    
    --------------------------
    -- Gray = PW*Gray_Ratio
    --------------------------
    component M_PulseMultGray is
    PORT (
		dataa		                    : IN  STD_LOGIC_VECTOR (12 DOWNTO 0);
		datab		                    : IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		result		                    : OUT STD_LOGIC_VECTOR (22 DOWNTO 0)
    );
    end component;
    
    ------------------------------------
    -- Distance^2*Gray
    ------------------------------------
    component M_DistMult is
    port (
        dataa		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		datab		: IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (37 DOWNTO 0)
    );
    end component;

    component M_GrayMult is
    port (
		dataa		: IN  STD_LOGIC_VECTOR (37 DOWNTO 0);
		datab		: IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (53 DOWNTO 0)
	);
    end component; 

    component M_MeanData is
    port (
        --------------------------------
        -- Reset & Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset,active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,single 200MHz

        --------------------------------
        -- Frame_Valid
        --------------------------------
        CpSl_FrameVld_i                 : in  std_logic;                        -- Frame Valid
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);     -- Ld_Num

        --------------------------------
        -- InPut_Data
        --------------------------------
        CpSl_Echo1Vld_i                 : in  std_logic;                        -- Echo1Valid
        CpSv_WaveGrayD_i                : in  std_logic_vector(53 downto 0);    -- Echo1WaveD

        --------------------------------
        -- OutPut_Data
        --------------------------------
        CpSv_MeanData_o                 : out std_logic_vector(53 downto 0)     -- MeanWave
    );
    end component;
        
    ------------------------------------
    -- Signal_Describe
    ------------------------------------
    -- Echo_State
    signal PrSv_EchoState_s             : std_logic_vector( 3 downto 0);        -- Echo_State
    signal PrSv_ColumTime_s             : std_logic_vector( 3 downto 0);        -- ColumTime
    
    -- PC -> FPGA_Constant
    signal w20_min_1                    : std_logic_vector(15 downto 0); 
    signal w20_max_1                    : std_logic_vector(15 downto 0); 
    signal w20_a_1                      : std_logic_vector(15 downto 0); 
    signal w20_b_1                      : std_logic_vector(15 downto 0); 
    signal w20_min_2                    : std_logic_vector(15 downto 0); 
    signal w20_max_2                    : std_logic_vector(15 downto 0); 
    signal w20_a_2                      : std_logic_vector(15 downto 0); 
    signal w20_b_2                      : std_logic_vector(15 downto 0); 
    signal w20_min_3                    : std_logic_vector(15 downto 0); 
    signal w20_max_3                    : std_logic_vector(15 downto 0); 
    signal w20_a_3                      : std_logic_vector(15 downto 0); 
    signal w20_b_3                      : std_logic_vector(15 downto 0); 
    signal w50_min_1                    : std_logic_vector(15 downto 0); 
    signal w50_max_1                    : std_logic_vector(15 downto 0); 
    signal w50_a_1                      : std_logic_vector(15 downto 0); 
    signal w50_b_1                      : std_logic_vector(15 downto 0); 
    signal w50_min_2                    : std_logic_vector(15 downto 0); 
    signal w50_max_2                    : std_logic_vector(15 downto 0); 
    signal w50_a_2                      : std_logic_vector(15 downto 0); 
    signal w50_b_2                      : std_logic_vector(15 downto 0); 
    signal w50_min_3                    : std_logic_vector(15 downto 0); 
    signal w50_max_3                    : std_logic_vector(15 downto 0); 
    signal w50_a_3                      : std_logic_vector(15 downto 0); 
    signal w50_b_3                      : std_logic_vector(15 downto 0); 
    signal w50_min_4                    : std_logic_vector(15 downto 0); 
    signal w50_max_4                    : std_logic_vector(15 downto 0); 
    signal w50_a_4                      : std_logic_vector(15 downto 0); 
    signal w50_b_4                      : std_logic_vector(15 downto 0); 
    signal w50_min_5                    : std_logic_vector(15 downto 0); 
    signal w50_a_5                      : std_logic_vector(15 downto 0); 
    signal w50_b_5                      : std_logic_vector(15 downto 0); 
    signal w90_min_1                    : std_logic_vector(15 downto 0); 
    signal w90_max_1                    : std_logic_vector(15 downto 0); 
    signal w90_a_1                      : std_logic_vector(15 downto 0); 
    signal w90_b_1                      : std_logic_vector(15 downto 0); 
    signal w90_min_2                    : std_logic_vector(15 downto 0); 
    signal w90_max_2                    : std_logic_vector(15 downto 0); 
    signal w90_a_2                      : std_logic_vector(15 downto 0); 
    signal w90_b_2                      : std_logic_vector(15 downto 0); 
    signal w90_min_3                    : std_logic_vector(15 downto 0); 
    signal w90_max_3                    : std_logic_vector(15 downto 0); 
    signal w90_a_3                      : std_logic_vector(15 downto 0); 
    signal w90_b_3                      : std_logic_vector(15 downto 0); 
    signal w90_min_4                    : std_logic_vector(15 downto 0); 
    signal w90_max_4                    : std_logic_vector(15 downto 0); 
    signal w90_a_4                      : std_logic_vector(15 downto 0); 
    signal w90_b_4                      : std_logic_vector(15 downto 0); 
    signal w90_min_5                    : std_logic_vector(15 downto 0); 
    signal w90_a_5                      : std_logic_vector(15 downto 0); 
    signal w90_b_5                      : std_logic_vector(15 downto 0); 
    
    -- ID/PW/Rising/Falling
    signal PrSv_Echo1PW20_s             : std_logic_vector(18 downto 0);        -- Echo1PW20   
    signal PrSv_Echo1PW50_s             : std_logic_vector(18 downto 0);        -- Echo1PW50   
    signal PrSv_Echo1PW90_s             : std_logic_vector(18 downto 0);        -- Echo1PW90   
    signal PrSv_Echo1R50_90_s           : std_logic_vector(18 downto 0);        -- Echo1R50_90
    signal PrSv_Echo1F90_50_s           : std_logic_vector(18 downto 0);        -- Echo1F90_50
    signal PrSv_Comp1Head_s             : std_logic_vector( 3 downto 0);        -- Compare1_Head
    signal PrSv_IndHead_s               : std_logic_vector( 7 downto 0);        -- Indication_Head
    signal PrSv_HGain_s                 : std_logic_vector( 3 downto 0);        -- HGain
    signal PrSv_LGain_PW10_s            : std_logic_vector( 3 downto 0);        -- LGain_PW10
    signal PrSv_LGain_PW50_s            : std_logic_vector( 3 downto 0);        -- LGain_PW50

    -- Pulse*Gray_Ratio
    signal PrSv_PulseGray_s             : std_logic_vector(15 downto 0);        -- PulseGray
    signal PrSv_RatioGray_s             : std_logic_vector(15 downto 0);        -- RatioGray
    signal PrSv_PulseMultGray_s         : std_logic_vector(22 downto 0);        -- PulseMultGray

    -- Dist*Dist*Gray
    signal PrSv_Dist_s                  : std_logic_vector(18 DOWNTO 0);        -- Dist
    signal PrSv_DistMult_s              : std_logic_vector(37 DOWNTO 0);        -- DistMult
    signal PrSv_MultGray_s              : std_logic_vector( 9 DOWNTO 0);        -- Gray
    signal PrSv_DistGrayVld_s           : std_logic;                            -- Dist*Gary_Valid
    signal PrSv_DistGray_s              : std_logic_vector(53 DOWNTO 0);        -- Dist*Gray
    signal PrSv_MeanData_s              : std_logic_vector(53 downto 0);        -- MeanData

    -- Echo1_Distance
    signal PrSv_Echo1Rate_s             : std_logic_vector(15 downto 0);        -- Echo1_Colum
    signal PrSv_Echo1Cons_s             : std_logic_vector(18 downto 0);        -- Echo1_Colum
    signal PrSv_Echo1Styl_s             : std_logic_vector(18 downto 0);        -- Echo1_Colum
    signal PrSv_Echo1Data_s             : std_logic_vector(18 downto 0);        -- Echo1_Colum
    signal PrSv_Echo1Rslt_s             : std_logic_vector(34 DOWNTO 0);        -- Echo1_Result
    signal PrSv_MultResult1_s           : std_logic_vector(18 downto 0);        -- Echo1_MultResult
    signal PrSv_AddConst1_s             : std_logic_vector(18 downto 0);        -- Echo1_Constant
    signal PrSv_Result0_s               : std_logic_vector(18 downto 0);        -- Change_Distance

    -- Echo1_Gray
    signal PrSv_GrayColum_s             : STD_LOGIC_VECTOR(17 DOWNTO 0);        -- GrayColum
    signal PrSv_GrayResult_a_s          : STD_LOGIC_VECTOR(21 DOWNTO 0);        -- GrayColumResult_a   
    signal PrSv_GrayResult_b_s          : STD_LOGIC_VECTOR(21 DOWNTO 0);        -- GrayColumResult_b                  
    signal PrSv_GrayResult_s            : STD_LOGIC_VECTOR(23 DOWNTO 0);        -- GrayColumResult_b
    signal PrSv_EchoGray_s              : std_logic_vector( 9 downto 0);        -- Gray_Data
    signal PrSv_Gray_a_s                : std_logic_vector( 3 downto 0);        -- Gray_a
    signal PrSv_Gray_b_s                : std_logic_vector( 8 downto 0);        -- Gray_b
    signal PrSv_Gray_c_s                : std_logic_vector(21 downto 0);        -- Gray_c

    -- WalkError
    signal PrSv_AddWalkError_s          : std_logic_vector(18 downto 0);        -- WalkError_Add

    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
begin
    ------------------------------------
    -- Component_Map
    ------------------------------------
    -- Distance
    U_M_MultRate_0 : M_MultRate
    port map (
		dataa		                   => PrSv_Echo1Styl_s                      , -- IN STD_LOGIC_VECTOR (18 DOWNTO 0);
		datab		                   => PrSv_Echo1Rate_s                      , -- IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		                   => PrSv_Echo1Rslt_s                        -- OUT STD_LOGIC_VECTOR (34 DOWNTO 0)
	);

    U_M_TdcParAdd_0 : M_TdcParAdd
    port map (
		data0x		                    => PrSv_MultResult1_s                   , -- IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		data1x		                    => PrSv_AddConst1_s                     , -- IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		data2x		                    => PrSv_Echo1Data_s                     , -- IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		data3x		                    => PrSv_AddWalkError_s                  , -- IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		result		                    => PrSv_Result0_s                         -- OUT STD_LOGIC_VECTOR (18 DOWNTO 0)
	);
	
	-- Gray
    M_GrayColum_0 : M_GrayColum
    port map (
		dataa		=> PrSv_Echo1Styl_s(14 downto 6)                            , -- IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
		datab		=> PrSv_Echo1Styl_s(14 downto 6)                            , -- IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
		result		=> PrSv_GrayColum_s                                           -- OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
    );
    
	U_M_GrayColum_a_0 : M_GrayColum_a
    PORT map (
		dataa		=> PrSv_Gray_a_s                                            , -- IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		datab		=> PrSv_GrayColum_s                                         , -- IN STD_LOGIC_VECTOR (17 DOWNTO 0);
		result		=> PrSv_GrayResult_a_s                                        -- OUT STD_LOGIC_VECTOR(21 DOWNTO 0)
	);
    
    U_M_GrayColum_b_0 : M_GrayColum_b
    PORT map (
		dataa		=> PrSv_Gray_b_s                                            , -- IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		datab		=> PrSv_Echo1Styl_s(18 downto 6)                            , -- IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		result		=> PrSv_GrayResult_b_s                                        -- OUT STD_LOGIC_VECTOR (21 DOWNTO 0)
	);
    
    U_M_GrayColum_Add_0 : M_GrayColum_Add
    port map (
		data0x		=> PrSv_GrayResult_a_s                                      , -- IN STD_LOGIC_VECTOR (21 DOWNTO 0);
		data1x		=> PrSv_GrayResult_b_s                                      , -- IN STD_LOGIC_VECTOR (21 DOWNTO 0);
		data2x		=> PrSv_Gray_c_s                                            , -- IN STD_LOGIC_VECTOR (21 DOWNTO 0);
		result		=> PrSv_GrayResult_s                                          -- OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);

    --------------------------
    -- Gray = PW*Gray_Ratio
    --------------------------
    U_M_PulseMultGray_0 : M_PulseMultGray
    PORT map (
		dataa		                    => PrSv_PulseGray_s(12 downto 0)        , -- IN  STD_LOGIC_VECTOR (12 DOWNTO 0);
		datab		                    => PrSv_RatioGray_s( 9 downto 0)        , -- IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		result		                    => PrSv_PulseMultGray_s                   -- OUT STD_LOGIC_VECTOR (22 DOWNTO 0)
    );

	------------------------------------
    -- Distance^2*Gray
    ------------------------------------
    U_M_DistMult_0 : M_DistMult
    port map (
        dataa		                    => PrSv_Dist_s                          , -- IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		datab		                    => PrSv_Dist_s                          , -- IN  STD_LOGIC_VECTOR (18 DOWNTO 0);
		result		                    => PrSv_DistMult_s                        -- OUT STD_LOGIC_VECTOR (37 DOWNTO 0)
    );
        
    U_M_GrayMult_0 : M_GrayMult
    port map (
		dataa		                    => PrSv_DistMult_s                      , -- IN  STD_LOGIC_VECTOR (37 DOWNTO 0);
		datab		                    => PrSv_PulseMultGray_s(20 downto 5)    , -- IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		                    => PrSv_DistGray_s                        -- OUT STD_LOGIC_VECTOR (53 DOWNTO 0)
	);

    -- CpSv_CompData_o
    CpSv_CompData_o <= PrSv_DistGray_s;
    
    U_M_MeanData_0 : M_MeanData
    port map (
        --------------------------------
        -- Reset & Clock
        --------------------------------
        CpSl_Rst_iN                     => CpSl_Rst_i                           , -- in  std_logic;                        -- Reset,active low
        CpSl_Clk_i                      => CpSl_Clk_i                           , -- in  std_logic;                        -- Clock,single 200MHz

        --------------------------------
        -- Frame_Valid
        --------------------------------
        CpSl_FrameVld_i                 => CpSl_FrameVld_i                      , -- in  std_logic;                        -- Frame Valid
        CpSv_LdNum_i                    => CpSv_LdNum_i                         , -- in  std_logic_vector(1 downto 0);     -- Ld_Num

        --------------------------------
        -- InPut_Data
        --------------------------------
        CpSl_Echo1Vld_i                 => PrSv_DistGrayVld_s                   , -- in  std_logic;                        -- Echo1Valid
        CpSv_WaveGrayD_i                => PrSv_DistGray_s                      , -- in  std_logic_vector(53 downto 0);    -- Echo1WaveD

        --------------------------------
        -- OutPut_Data
        --------------------------------
        CpSv_MeanData_o                 => PrSv_MeanData_s                        -- out std_logic_vector(53 downto 0)     -- MeanWave
    );
	
	----------------------------------------------------------------------------
    -- PC -> FPGA_Constant
    ----------------------------------------------------------------------------
	-- HG_375mv
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            w20_min_1 <= (others => '0');
            w20_max_1 <= (others => '0');
            w20_a_1   <= (others => '0');
            w20_b_1   <= (others => '0');
            w20_min_2 <= (others => '0');
            w20_max_2 <= (others => '0');
            w20_a_2   <= (others => '0');
            w20_b_2   <= (others => '0');
            w20_min_3 <= (others => '0');
            w20_max_3 <= (others => '0');
            w20_a_3   <= (others => '0');
            w20_b_3   <= (others => '0');
            w50_min_1 <= (others => '0');
            w50_max_1 <= (others => '0');
            w50_a_1   <= (others => '0');
            w50_b_1   <= (others => '0');
            w50_min_2 <= (others => '0');
            w50_max_2 <= (others => '0');
            w50_a_2   <= (others => '0');
            w50_b_2   <= (others => '0');
            w50_min_3 <= (others => '0');
            w50_max_3 <= (others => '0');
            w50_a_3   <= (others => '0');
            w50_b_3   <= (others => '0');
            w50_min_4 <= (others => '0');
            w50_max_4 <= (others => '0');
            w50_a_4   <= (others => '0');
            w50_b_4   <= (others => '0');
            w50_min_5 <= (others => '0');
            w50_a_5   <= (others => '0');
            w50_b_5   <= (others => '0');
            w90_min_1 <= (others => '0');
            w90_max_1 <= (others => '0');
            w90_a_1   <= (others => '0');
            w90_b_1   <= (others => '0');
            w90_min_2 <= (others => '0');
            w90_max_2 <= (others => '0');
            w90_a_2   <= (others => '0');
            w90_b_2   <= (others => '0');
            w90_min_3 <= (others => '0');
            w90_max_3 <= (others => '0');
            w90_a_3   <= (others => '0');
            w90_b_3   <= (others => '0');
            w90_min_4 <= (others => '0');
            w90_max_4 <= (others => '0');
            w90_a_4   <= (others => '0');
            w90_b_4   <= (others => '0');
            w90_min_5 <= (others => '0');
            w90_a_5   <= (others => '0');
            w90_b_5   <= (others => '0');
                           
        elsif rising_edge(CpSl_Clk_i) then
            case CpSv_LdNum_i is
                when "01" => 
                    w20_min_1 <= CpSv_Start1_W20_min1_i;
                    w20_max_1 <= CpSv_Start1_W20_max1_i;
                    w20_a_1   <= CpSv_Start1_W20_a1_i  ;
                    w20_b_1   <= CpSv_Start1_W20_b1_i  ;
                    w20_min_2 <= CpSv_Start1_W20_min2_i;
                    w20_max_2 <= CpSv_Start1_W20_max2_i;
                    w20_a_2   <= CpSv_Start1_W20_a2_i  ;
                    w20_b_2   <= CpSv_Start1_W20_b2_i  ;
                    w20_min_3 <= CpSv_Start1_W20_min3_i;
                    w20_max_3 <= CpSv_Start1_W20_max3_i;
                    w20_a_3   <= CpSv_Start1_W20_a3_i  ;
                    w20_b_3   <= CpSv_Start1_W20_b3_i  ;
                    w50_min_1 <= CpSv_Start1_W50_min1_i;
                    w50_max_1 <= CpSv_Start1_W50_max1_i;
                    w50_a_1   <= CpSv_Start1_W50_a1_i  ;
                    w50_b_1   <= CpSv_Start1_W50_b1_i  ;
                    w50_min_2 <= CpSv_Start1_W50_min2_i;
                    w50_max_2 <= CpSv_Start1_W50_max2_i;
                    w50_a_2   <= CpSv_Start1_W50_a2_i  ;
                    w50_b_2   <= CpSv_Start1_W50_b2_i  ;
                    w50_min_3 <= CpSv_Start1_W50_min3_i;
                    w50_max_3 <= CpSv_Start1_W50_max3_i;
                    w50_a_3   <= CpSv_Start1_W50_a3_i  ;
                    w50_b_3   <= CpSv_Start1_W50_b3_i  ;
                    w50_min_4 <= CpSv_Start1_W50_min4_i;
                    w50_max_4 <= CpSv_Start1_W50_max4_i;
                    w50_a_4   <= CpSv_Start1_W50_a4_i  ;
                    w50_b_4   <= CpSv_Start1_W50_b4_i  ;
                    w50_min_5 <= CpSv_Start1_W50_min5_i;
                    w50_a_5   <= CpSv_Start1_W50_a5_i  ;
                    w50_b_5   <= CpSv_Start1_W50_b5_i  ;
                    w90_min_1 <= CpSv_Start1_W90_min1_i;
                    w90_max_1 <= CpSv_Start1_W90_max1_i;
                    w90_a_1   <= CpSv_Start1_W90_a1_i  ;
                    w90_b_1   <= CpSv_Start1_W90_b1_i  ;
                    w90_min_2 <= CpSv_Start1_W90_min2_i;
                    w90_max_2 <= CpSv_Start1_W90_max2_i;
                    w90_a_2   <= CpSv_Start1_W90_a2_i  ;
                    w90_b_2   <= CpSv_Start1_W90_b2_i  ;
                    w90_min_3 <= CpSv_Start1_W90_min3_i;
                    w90_max_3 <= CpSv_Start1_W90_max3_i;
                    w90_a_3   <= CpSv_Start1_W90_a3_i  ;
                    w90_b_3   <= CpSv_Start1_W90_b3_i  ;
                    w90_min_4 <= CpSv_Start1_W90_min4_i;
                    w90_max_4 <= CpSv_Start1_W90_max4_i;
                    w90_a_4   <= CpSv_Start1_W90_a4_i  ;
                    w90_b_4   <= CpSv_Start1_W90_b4_i  ;
                    w90_min_5 <= CpSv_Start1_W90_min5_i;
                    w90_a_5   <= CpSv_Start1_W90_a5_i  ;
                    w90_b_5   <= CpSv_Start1_W90_b5_i  ;
                when "10" => 
                    w20_min_1 <= CpSv_Start2_W20_min1_i;
                    w20_max_1 <= CpSv_Start2_W20_max1_i;
                    w20_a_1   <= CpSv_Start2_W20_a1_i  ;
                    w20_b_1   <= CpSv_Start2_W20_b1_i  ;
                    w20_min_2 <= CpSv_Start2_W20_min2_i;
                    w20_max_2 <= CpSv_Start2_W20_max2_i;
                    w20_a_2   <= CpSv_Start2_W20_a2_i  ;
                    w20_b_2   <= CpSv_Start2_W20_b2_i  ;
                    w20_min_3 <= CpSv_Start2_W20_min3_i;
                    w20_max_3 <= CpSv_Start2_W20_max3_i;
                    w20_a_3   <= CpSv_Start2_W20_a3_i  ;
                    w20_b_3   <= CpSv_Start2_W20_b3_i  ;
                    w50_min_1 <= CpSv_Start2_W50_min1_i;
                    w50_max_1 <= CpSv_Start2_W50_max1_i;
                    w50_a_1   <= CpSv_Start2_W50_a1_i  ;
                    w50_b_1   <= CpSv_Start2_W50_b1_i  ;
                    w50_min_2 <= CpSv_Start2_W50_min2_i;
                    w50_max_2 <= CpSv_Start2_W50_max2_i;
                    w50_a_2   <= CpSv_Start2_W50_a2_i  ;
                    w50_b_2   <= CpSv_Start2_W50_b2_i  ;
                    w50_min_3 <= CpSv_Start2_W50_min3_i;
                    w50_max_3 <= CpSv_Start2_W50_max3_i;
                    w50_a_3   <= CpSv_Start2_W50_a3_i  ;
                    w50_b_3   <= CpSv_Start2_W50_b3_i  ;
                    w50_min_4 <= CpSv_Start2_W50_min4_i;
                    w50_max_4 <= CpSv_Start2_W50_max4_i;
                    w50_a_4   <= CpSv_Start2_W50_a4_i  ;
                    w50_b_4   <= CpSv_Start2_W50_b4_i  ;
                    w50_min_5 <= CpSv_Start2_W50_min5_i;
                    w50_a_5   <= CpSv_Start2_W50_a5_i  ;
                    w50_b_5   <= CpSv_Start2_W50_b5_i  ;
                    w90_min_1 <= CpSv_Start2_W90_min1_i;
                    w90_max_1 <= CpSv_Start2_W90_max1_i;
                    w90_a_1   <= CpSv_Start2_W90_a1_i  ;
                    w90_b_1   <= CpSv_Start2_W90_b1_i  ;
                    w90_min_2 <= CpSv_Start2_W90_min2_i;
                    w90_max_2 <= CpSv_Start2_W90_max2_i;
                    w90_a_2   <= CpSv_Start2_W90_a2_i  ;
                    w90_b_2   <= CpSv_Start2_W90_b2_i  ;
                    w90_min_3 <= CpSv_Start2_W90_min3_i;
                    w90_max_3 <= CpSv_Start2_W90_max3_i;
                    w90_a_3   <= CpSv_Start2_W90_a3_i  ;
                    w90_b_3   <= CpSv_Start2_W90_b3_i  ;
                    w90_min_4 <= CpSv_Start2_W90_min4_i;
                    w90_max_4 <= CpSv_Start2_W90_max4_i;
                    w90_a_4   <= CpSv_Start2_W90_a4_i  ;
                    w90_b_4   <= CpSv_Start2_W90_b4_i  ;
                    w90_min_5 <= CpSv_Start2_W90_min5_i;
                    w90_a_5   <= CpSv_Start2_W90_a5_i  ;
                    w90_b_5   <= CpSv_Start2_W90_b5_i  ;
                     
                when "11" => 
                    w20_min_1 <= CpSv_Start3_W20_min1_i;
                    w20_max_1 <= CpSv_Start3_W20_max1_i;
                    w20_a_1   <= CpSv_Start3_W20_a1_i  ;
                    w20_b_1   <= CpSv_Start3_W20_b1_i  ;
                    w20_min_2 <= CpSv_Start3_W20_min2_i;
                    w20_max_2 <= CpSv_Start3_W20_max2_i;
                    w20_a_2   <= CpSv_Start3_W20_a2_i  ;
                    w20_b_2   <= CpSv_Start3_W20_b2_i  ;
                    w20_min_3 <= CpSv_Start3_W20_min3_i;
                    w20_max_3 <= CpSv_Start3_W20_max3_i;
                    w20_a_3   <= CpSv_Start3_W20_a3_i  ;
                    w20_b_3   <= CpSv_Start3_W20_b3_i  ;
                    w50_min_1 <= CpSv_Start3_W50_min1_i;
                    w50_max_1 <= CpSv_Start3_W50_max1_i;
                    w50_a_1   <= CpSv_Start3_W50_a1_i  ;
                    w50_b_1   <= CpSv_Start3_W50_b1_i  ;
                    w50_min_2 <= CpSv_Start3_W50_min2_i;
                    w50_max_2 <= CpSv_Start3_W50_max2_i;
                    w50_a_2   <= CpSv_Start3_W50_a2_i  ;
                    w50_b_2   <= CpSv_Start3_W50_b2_i  ;
                    w50_min_3 <= CpSv_Start3_W50_min3_i;
                    w50_max_3 <= CpSv_Start3_W50_max3_i;
                    w50_a_3   <= CpSv_Start3_W50_a3_i  ;
                    w50_b_3   <= CpSv_Start3_W50_b3_i  ;
                    w50_min_4 <= CpSv_Start3_W50_min4_i;
                    w50_max_4 <= CpSv_Start3_W50_max4_i;
                    w50_a_4   <= CpSv_Start3_W50_a4_i  ;
                    w50_b_4   <= CpSv_Start3_W50_b4_i  ;
                    w50_min_5 <= CpSv_Start3_W50_min5_i;
                    w50_a_5   <= CpSv_Start3_W50_a5_i  ;
                    w50_b_5   <= CpSv_Start3_W50_b5_i  ;
                    w90_min_1 <= CpSv_Start3_W90_min1_i;
                    w90_max_1 <= CpSv_Start3_W90_max1_i;
                    w90_a_1   <= CpSv_Start3_W90_a1_i  ;
                    w90_b_1   <= CpSv_Start3_W90_b1_i  ;
                    w90_min_2 <= CpSv_Start3_W90_min2_i;
                    w90_max_2 <= CpSv_Start3_W90_max2_i;
                    w90_a_2   <= CpSv_Start3_W90_a2_i  ;
                    w90_b_2   <= CpSv_Start3_W90_b2_i  ;
                    w90_min_3 <= CpSv_Start3_W90_min3_i;
                    w90_max_3 <= CpSv_Start3_W90_max3_i;
                    w90_a_3   <= CpSv_Start3_W90_a3_i  ;
                    w90_b_3   <= CpSv_Start3_W90_b3_i  ;
                    w90_min_4 <= CpSv_Start3_W90_min4_i;
                    w90_max_4 <= CpSv_Start3_W90_max4_i;
                    w90_a_4   <= CpSv_Start3_W90_a4_i  ;
                    w90_b_4   <= CpSv_Start3_W90_b4_i  ;
                    w90_min_5 <= CpSv_Start3_W90_min5_i;
                    w90_a_5   <= CpSv_Start3_W90_a5_i  ;
                    w90_b_5   <= CpSv_Start3_W90_b5_i  ;
                     
                when others => 
                    w20_min_1 <= (others => '0');
                    w20_max_1 <= (others => '0');
                    w20_a_1   <= (others => '0');
                    w20_b_1   <= (others => '0');
                    w20_min_2 <= (others => '0');
                    w20_max_2 <= (others => '0');
                    w20_a_2   <= (others => '0');
                    w20_b_2   <= (others => '0');
                    w20_min_3 <= (others => '0');
                    w20_max_3 <= (others => '0');
                    w20_a_3   <= (others => '0');
                    w20_b_3   <= (others => '0');
                    w50_min_1 <= (others => '0');
                    w50_max_1 <= (others => '0');
                    w50_a_1   <= (others => '0');
                    w50_b_1   <= (others => '0');
                    w50_min_2 <= (others => '0');
                    w50_max_2 <= (others => '0');
                    w50_a_2   <= (others => '0');
                    w50_b_2   <= (others => '0');
                    w50_min_3 <= (others => '0');
                    w50_max_3 <= (others => '0');
                    w50_a_3   <= (others => '0');
                    w50_b_3   <= (others => '0');
                    w50_min_4 <= (others => '0');
                    w50_max_4 <= (others => '0');
                    w50_a_4   <= (others => '0');
                    w50_b_4   <= (others => '0');
                    w50_min_5 <= (others => '0');
                    w50_a_5   <= (others => '0');
                    w50_b_5   <= (others => '0');
                    w90_min_1 <= (others => '0');
                    w90_max_1 <= (others => '0');
                    w90_a_1   <= (others => '0');
                    w90_b_1   <= (others => '0');
                    w90_min_2 <= (others => '0');
                    w90_max_2 <= (others => '0');
                    w90_a_2   <= (others => '0');
                    w90_b_2   <= (others => '0');
                    w90_min_3 <= (others => '0');
                    w90_max_3 <= (others => '0');
                    w90_a_3   <= (others => '0');
                    w90_b_3   <= (others => '0');
                    w90_min_4 <= (others => '0');
                    w90_max_4 <= (others => '0');
                    w90_a_4   <= (others => '0');
                    w90_b_4   <= (others => '0');
                    w90_min_5 <= (others => '0');
                    w90_a_5   <= (others => '0');
                    w90_b_5   <= (others => '0');
            end case;
        end if;
    end process;
	
    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    -- PrSv_AddWalkError_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_AddWalkError_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case CpSv_Echo1ID_i is 
                when "100"|"110"|"111" => 
                    if (CpSl_WalkErrorRdVld_i = '1' and CpSv_WalkErrorRdData_i(20 downto 19) = CpSv_LdNum_i) then 
                        PrSv_AddWalkError_s <= CpSv_WalkErrorRdData_i(18 downto 0);
                    else 
                        PrSv_AddWalkError_s <= (others => '0');
                    end if;
                when others => 
                    PrSv_AddWalkError_s <= (others => '0');
            end case;
        end if;
    end process;
    
    -- PrSv_EchoState_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_EchoState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_EchoState_s is
                when PrSv_Idle_c => 
                    if (CpSl_DVld_i = '1') then
                        PrSv_EchoState_s <= PrSv_Colum_c;
                    else -- hold
                    end if;
                
                when PrSv_Colum_c => 
                    if (PrSv_ColumTime_s = PrSv_ColumTime_c) then 
                        PrSv_EchoState_s <= PrSv_TdcMult_c;
                    else -- hold
                    end if;
                
                when PrSv_TdcMult_c => 
                    PrSv_EchoState_s <= PrSv_DistGray_c;
                
                when PrSv_DistGray_c => 
                    PrSv_EchoState_s <= PrSv_MeanData_c;
                
                when PrSv_MeanData_c => -- MeanData
                    if (PrSv_ColumTime_s = PrSv_ColumTime_c) then 
                        PrSv_EchoState_s <= PrSv_TdcEnd_c;
                    else -- hold
                    end if;
                
                when PrSv_TdcEnd_c => -- End
                    PrSv_EchoState_s <= PrSv_TdcVldEnd_c;
                
                when PrSv_TdcVldEnd_c => -- End_Vld
                    PrSv_EchoState_s <= (others => '0');
                
                when others => 
                    PrSv_EchoState_s <= (others => '0');
            end case;
        end if;
    end process;
    
    -- PrSv_ColumTime_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_ColumTime_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_Colum_c) then 
                PrSv_ColumTime_s <= PrSv_ColumTime_s + '1';
            elsif (PrSv_EchoState_s = PrSv_MeanData_c) then
                PrSv_ColumTime_s <= PrSv_ColumTime_s + '1';
            else 
                PrSv_ColumTime_s <= (others => '0');
            end if; 
        end if;
    end process;
    
    -- Echo1_PW/Rising/Falling
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_Echo1PW20_s   <= (others => '0');
            PrSv_Echo1PW50_s   <= (others => '0');
            PrSv_Echo1PW90_s   <= (others => '0');
            PrSv_Echo1R50_90_s <= (others => '0');
            PrSv_Echo1F90_50_s <= (others => '0');

        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DVld_i = '1') then
                case CpSv_Echo1ID_i is 
                    when "100" => 
                        PrSv_Echo1PW20_s   <= CpSv_EchoD2_i - CpSv_EchoD1_i;
                        PrSv_Echo1PW50_s   <= (others => '0');
                        PrSv_Echo1PW90_s   <= (others => '0');
                        PrSv_Echo1R50_90_s <= (others => '0');
                        PrSv_Echo1F90_50_s <= (others => '0');
                    
                    when "110" => 
                        PrSv_Echo1PW20_s   <= CpSv_EchoD2_i - CpSv_EchoD1_i;
                        PrSv_Echo1PW50_s   <= CpSv_EchoD4_i - CpSv_EchoD3_i;
                        PrSv_Echo1PW90_s   <= (others => '0');
                        PrSv_Echo1R50_90_s <= (others => '0');
                        PrSv_Echo1F90_50_s <= (others => '0');
                    
                    when "111" =>
                        PrSv_Echo1PW20_s   <= CpSv_EchoD2_i - CpSv_EchoD1_i;
                        PrSv_Echo1PW50_s   <= CpSv_EchoD4_i - CpSv_EchoD3_i;
                        PrSv_Echo1PW90_s   <= CpSv_EchoD6_i - CpSv_EchoD5_i;
                        PrSv_Echo1R50_90_s <= CpSv_EchoD5_i - CpSv_EchoD3_i;
                        PrSv_Echo1F90_50_s <= CpSv_EchoD4_i - CpSv_EchoD6_i;
                    
                    when others => 
                        PrSv_Echo1PW20_s   <= (others => '0');
                        PrSv_Echo1PW50_s   <= (others => '0');
                        PrSv_Echo1PW90_s   <= (others => '0');
                        PrSv_Echo1R50_90_s <= (others => '0');
                        PrSv_Echo1F90_50_s <= (others => '0');
                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    -- Pulse*Gray_Ratio
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then
            PrSv_PulseGray_s <= (others => '0');
            PrSv_RatioGray_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_GrayDataVld_i = '1') then 
                PrSv_PulseGray_s <= PrSv_Echo1PW20_s(15 downto 0);
                PrSv_RatioGray_s <= CpSv_GrayData_i;
            else -- hold 
            end if;
        end if;
    end process;
    
    ------------------------------------
    -- Compare_Data
    -- PW20/50/90/R50_90
    -- Indication
    --  >> PrSv_Comp1Head_s & PrSv_LGain_PW50_s
    ------------------------------------
    -- PrSv_Comp1Head_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then
            PrSv_Comp1Head_s <= (others => '0');      
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_Colum_c) then
                if (PrSv_Echo1PW50_s >= PrSv_IndPW50_c) then
                    if (PrSv_Echo1PW90_s >= PrSv_IndPW50_c) then
                        PrSv_Comp1Head_s <= x"4";
                    else 
                        PrSv_Comp1Head_s <= x"2";
                    end if;
                else
                    if (PrSv_Echo1PW20_s >= PrSv_IndPW50_c) then
                        PrSv_Comp1Head_s <= x"1";
                    else
                        PrSv_Comp1Head_s <= x"0";
                    end if;
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_HGain_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then
            PrSv_HGain_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_Colum_c) then
                if (PrSv_Echo1PW20_s >= w20_min_1 and PrSv_Echo1PW20_s < w20_max_1) then
                    PrSv_HGain_s <= x"1";
                elsif (PrSv_Echo1PW20_s >= w20_min_2 and PrSv_Echo1PW20_s < w20_max_2) then
                    PrSv_HGain_s <= x"2";
                elsif (PrSv_Echo1PW20_s >= w20_min_3 and PrSv_Echo1PW20_s < w20_max_3) then
                    PrSv_HGain_s <= x"3";
                else
                    PrSv_HGain_s <= (others => '0');
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_LGain_PW10_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then
            PrSv_LGain_PW10_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_Colum_c) then
                if (PrSv_Echo1PW50_s >= w50_min_1 and PrSv_Echo1PW50_s < w50_max_1) then
                    PrSv_LGain_PW10_s <= x"1";
                elsif (PrSv_Echo1PW50_s >= w50_min_2 and PrSv_Echo1PW50_s < w50_max_2) then
                    PrSv_LGain_PW10_s <= x"2";
                elsif (PrSv_Echo1PW50_s >= w50_min_3 and PrSv_Echo1PW50_s < w50_max_3) then
                    PrSv_LGain_PW10_s <= x"3";
                elsif (PrSv_Echo1PW50_s >= w50_min_4 and PrSv_Echo1PW50_s < w50_max_4) then
                    PrSv_LGain_PW10_s <= x"4";
                elsif (PrSv_Echo1PW50_s >= w50_min_5) then
                    PrSv_LGain_PW10_s <= x"5";
                else 
                    PrSv_LGain_PW10_s <= x"0";
                end if;    
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_LGain_PW50_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then
            PrSv_LGain_PW50_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_Colum_c) then
                if (PrSv_Echo1PW90_s >= w90_min_1 and PrSv_Echo1PW90_s < w90_max_1) then
                    PrSv_LGain_PW50_s <= x"1";
                elsif (PrSv_Echo1PW90_s >= w90_min_2 and PrSv_Echo1PW90_s < w90_max_2) then 
                    PrSv_LGain_PW50_s <= x"2";
                elsif (PrSv_Echo1PW90_s >= w90_min_3 and PrSv_Echo1PW90_s < w90_max_3) then 
                    PrSv_LGain_PW50_s <= x"3";
                elsif (PrSv_Echo1PW90_s >= w90_min_4 and PrSv_Echo1PW90_s < w90_max_4) then 
                    PrSv_LGain_PW50_s <= x"4";
                elsif (PrSv_Echo1PW90_s >= w90_min_5) then 
                    PrSv_LGain_PW50_s <= x"5";
                else
                    PrSv_LGain_PW50_s <= x"0";
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_IndHead_s
    PrSv_IndHead_s <= PrSv_Comp1Head_s & PrSv_LGain_PW50_s;

    ------------------------------------
    -- Echo_Wave&Gray
    ------------------------------------
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_Echo1Rate_s <= (others => '0');
            PrSv_Echo1Cons_s <= (others => '0');
            PrSv_Echo1Styl_s <= (others => '0');
            PrSv_Echo1Data_s <= (others => '0');
            PrSv_Gray_a_s    <= (others => '0');
            PrSv_Gray_b_s    <= (others => '0');
            PrSv_Gray_c_s    <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
--            if (CpSl_DVld_i = '1') then 
--                PrSv_Echo1Rate_s <= (others => '0');
--                PrSv_Echo1Cons_s <= (others => '0');
--                PrSv_Echo1Styl_s <= (others => '0');
--                PrSv_Echo1Data_s <= (others => '0');
--                PrSv_Gray_a_s    <= (others => '0');
--                PrSv_Gray_b_s    <= (others => '0');
--                PrSv_Gray_c_s    <= (others => '0');
--    
--            else
            case PrSv_IndHead_s is 
                -- HGain
                when x"10" => -- HG_PW50
                    if (PrSv_HGain_s = x"1") then
                        PrSv_Echo1Rate_s <= w20_a_1;
                        PrSv_Echo1Cons_s <= "111" & w20_b_1;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW20_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD1_i;
                        PrSv_Gray_a_s    <= Gray_PW20_a_1;
                        PrSv_Gray_b_s    <= Gray_PW20_b_1;
                        PrSv_Gray_c_s    <= Gray_PW20_c_1;
                    elsif (PrSv_HGain_s = x"2") then
                        PrSv_Echo1Rate_s <= w20_a_2;
                        PrSv_Echo1Cons_s <= "111" & w20_b_2;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW20_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD1_i; 
                        PrSv_Gray_a_s    <= Gray_PW20_a_2;
                        PrSv_Gray_b_s    <= Gray_PW20_b_2;
                        PrSv_Gray_c_s    <= Gray_PW20_c_2;
                    elsif (PrSv_HGain_s = x"3") then
                        PrSv_Echo1Rate_s <= w20_a_3;
                        PrSv_Echo1Cons_s <= "111" & w20_b_3;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW20_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD1_i;
                        PrSv_Gray_a_s    <= Gray_PW20_a_2;
                        PrSv_Gray_b_s    <= Gray_PW20_b_2;
                        PrSv_Gray_c_s    <= Gray_PW20_c_2;
                    else 
                        PrSv_Echo1Rate_s <= (others => '0');     
                        PrSv_Echo1Cons_s <= (others => '0');     
                        PrSv_Echo1Styl_s <= (others => '0');     
                        PrSv_Echo1Data_s <= (others => '0');
                        PrSv_Gray_a_s    <= (others => '0');
                        PrSv_Gray_b_s    <= (others => '0');
                        PrSv_Gray_c_s    <= (others => '0');
                    end if;
                    
                -- LGain
                when x"20" => -- LGain_PW10
                    if (PrSv_LGain_PW10_s = x"1") then
                        PrSv_Echo1Rate_s <= w50_a_1;
                        PrSv_Echo1Cons_s <= "111" & w50_b_1;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW50_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD3_i;
                        PrSv_Gray_a_s    <= Gray_PW50_a_1;
                        PrSv_Gray_b_s    <= Gray_PW50_b_1;
                        PrSv_Gray_c_s    <= Gray_PW50_c_1;
                    elsif (PrSv_LGain_PW10_s = x"2") then
                        PrSv_Echo1Rate_s <= w50_a_2;
                        PrSv_Echo1Cons_s <= "111" & w50_b_2;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW50_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD3_i;
                        PrSv_Gray_a_s    <= Gray_PW50_a_2;
                        PrSv_Gray_b_s    <= Gray_PW50_b_2;
                        PrSv_Gray_c_s    <= Gray_PW50_c_2;
                    elsif (PrSv_LGain_PW10_s = x"3") then
                        PrSv_Echo1Rate_s <= w50_a_3;
                        PrSv_Echo1Cons_s <= "111" & w50_b_3;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW50_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD3_i;
                        PrSv_Gray_a_s    <= Gray_PW50_a_2;
                        PrSv_Gray_b_s    <= Gray_PW50_b_2;
                        PrSv_Gray_c_s    <= Gray_PW50_c_2;
                    elsif (PrSv_LGain_PW10_s = x"4") then
                        PrSv_Echo1Rate_s <= w50_a_4;
                        PrSv_Echo1Cons_s <= "111" & w50_b_4;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW50_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD3_i;
                        PrSv_Gray_a_s    <= Gray_PW50_a_2;
                        PrSv_Gray_b_s    <= Gray_PW50_b_2;
                        PrSv_Gray_c_s    <= Gray_PW50_c_2;
                    elsif (PrSv_LGain_PW10_s = x"5") then
                        PrSv_Echo1Rate_s <= w50_a_5;
                        PrSv_Echo1Cons_s <= "111" & w50_b_5;
                        PrSv_Echo1Styl_s <= PrSv_Echo1PW50_s;
                        PrSv_Echo1Data_s <= CpSv_EchoD3_i;
                        PrSv_Gray_a_s    <= Gray_PW50_a_3;
                        PrSv_Gray_b_s    <= Gray_PW50_b_3;
                        PrSv_Gray_c_s    <= Gray_PW50_c_3;
                    else 
                        PrSv_Echo1Rate_s <= (others => '0');     
                        PrSv_Echo1Cons_s <= (others => '0');     
                        PrSv_Echo1Styl_s <= (others => '0');     
                        PrSv_Echo1Data_s <= (others => '0');
                        PrSv_Gray_a_s    <= (others => '0');
                        PrSv_Gray_b_s    <= (others => '0');
                        PrSv_Gray_c_s    <= (others => '0');
                    end if;
                    
                when x"41" => -- LGain_PW50
                    PrSv_Echo1Rate_s <= w90_a_1;
                    PrSv_Echo1Cons_s <= "111" & w90_b_1;
                    PrSv_Echo1Styl_s <= PrSv_Echo1PW90_s;
                    PrSv_Echo1Data_s <= CpSv_EchoD5_i;
                    PrSv_Gray_a_s    <= Gray_PW90_a_1;
                    PrSv_Gray_b_s    <= Gray_PW90_b_1;
                    PrSv_Gray_c_s    <= Gray_PW90_c_1;
                
                when x"42" => -- LGain_PW50
                    PrSv_Echo1Rate_s <= w90_a_2;
                    PrSv_Echo1Cons_s <= "111" & w90_b_2;
                    PrSv_Echo1Styl_s <= PrSv_Echo1PW90_s;
                    PrSv_Echo1Data_s <= CpSv_EchoD5_i; 
                    PrSv_Gray_a_s    <= Gray_PW90_a_1;
                    PrSv_Gray_b_s    <= Gray_PW90_b_1;
                    PrSv_Gray_c_s    <= Gray_PW90_c_1;
               
                when x"43" => -- LGain_PW50
                    PrSv_Echo1Rate_s <= w90_a_3;
                    PrSv_Echo1Cons_s <= "111" & w90_b_3;
                    PrSv_Echo1Styl_s <= PrSv_Echo1PW90_s;
                    PrSv_Echo1Data_s <= CpSv_EchoD5_i;
                    PrSv_Gray_a_s    <= Gray_PW90_a_1;
                    PrSv_Gray_b_s    <= Gray_PW90_b_1;
                    PrSv_Gray_c_s    <= Gray_PW90_c_1;
                
                when x"44" => -- LGain_PW50
                    PrSv_Echo1Rate_s <= w90_a_4;
                    PrSv_Echo1Cons_s <= "111" & w90_b_4;
                    PrSv_Echo1Styl_s <= PrSv_Echo1PW90_s;
                    PrSv_Echo1Data_s <= CpSv_EchoD5_i;
                    PrSv_Gray_a_s    <= Gray_PW90_a_2;
                    PrSv_Gray_b_s    <= Gray_PW90_b_2;
                    PrSv_Gray_c_s    <= Gray_PW90_c_2;
                
                when x"45" => 
                    PrSv_Echo1Rate_s <= w90_a_5;
                    PrSv_Echo1Cons_s <= "111" & w90_b_5;
                    PrSv_Echo1Styl_s <= PrSv_Echo1PW90_s;
                    PrSv_Echo1Data_s <= CpSv_EchoD5_i;
                    PrSv_Gray_a_s    <= Gray_PW90_a_2;
                    PrSv_Gray_b_s    <= Gray_PW90_b_2;
                    PrSv_Gray_c_s    <= Gray_PW90_c_2;

                when others =>
                    PrSv_Echo1Rate_s <= (others => '0');     
                    PrSv_Echo1Cons_s <= (others => '0');     
                    PrSv_Echo1Styl_s <= (others => '0');     
                    PrSv_Echo1Data_s <= (others => '0');
                    PrSv_Gray_a_s    <= (others => '0');
                    PrSv_Gray_b_s    <= (others => '0');
                    PrSv_Gray_c_s    <= (others => '0');
            end case;
--            end if;
        end if;
    end process;
    
    -- PrSv_MultResult1_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSv_MultResult1_s <= (others => '0');
            PrSv_AddConst1_s   <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DVld_i = '1') then 
                PrSv_MultResult1_s <= (others => '0');
                PrSv_AddConst1_s   <= (others => '0');
            elsif (PrSv_EchoState_s = PrSv_TdcMult_c) then 
                PrSv_MultResult1_s <= PrSv_Echo1Rslt_s(28 downto 10);
                PrSv_AddConst1_s   <= PrSv_Echo1Cons_s;
            else -- hold
            end if;
        end if;
    end process;

    ------------------------------------
    -- Gray*Dist*Dist
    ------------------------------------
    -- PrSv_Dist_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_Dist_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_DistGray_c) then 
                if (PrSv_Result0_s(18) = '0') then
                    PrSv_Dist_s <= PrSv_Result0_s;
                else
                    PrSv_Dist_s <= (others => '0');
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_MultGray_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_MultGray_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_DistGray_c) then 
                PrSv_MultGray_s <= PrSv_GrayResult_s(9 downto 0);
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_DistGrayVld_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_DistGrayVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_MeanData_c and PrSv_ColumTime_s = PrSv_ColumTime_c) then 
                PrSv_DistGrayVld_s <= '1';
            else
                PrSv_DistGrayVld_s <= '0';
            end if;
        end if;
    end process;

    ------------------------------------
    -- TDC_OutPut
    ------------------------------------
    -- CpSl_EchoVld_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            CpSl_EchoVld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_EchoState_s = PrSv_TdcVldEnd_c) then 
                CpSl_EchoVld_o <= '1';
            else
                CpSl_EchoVld_o <= '0';
            end if;
        end if;
    end process;
    
    -- CpSv_EchoWave_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_EchoWave_o <= (others => '0');
            CpSv_EchoGray_o <= (others => '0');    
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DVld_i = '1') then 
                CpSv_EchoWave_o <= (others => '0');
                CpSv_EchoGray_o <= (others => '0');
            elsif (PrSv_EchoState_s = PrSv_TdcEnd_c) then                     
                case CpSv_LdNum_i is
                    when "01" => 
                        --if (PrSv_Result0_s(18) = '0') then
                        if (PrSv_Result0_s(18) = '0' and PrSv_DistGray_s >= PrSv_MeanData_s) then
                            CpSv_EchoWave_o <= PrSv_Result0_s;
                        else
                            CpSv_EchoWave_o <= (others => '0');
                        end if;
                        
                        CpSv_EchoGray_o <= PrSv_PulseMultGray_s(20 downto 5);      
                        
                    when "10" => 
                        --if (PrSv_Result0_s(18) = '0') then
                        if (PrSv_Result0_s(18) = '0' and PrSv_DistGray_s >= PrSv_MeanData_s) then
                            CpSv_EchoWave_o <= PrSv_Result0_s;
                        else
                            CpSv_EchoWave_o <= (others => '0');
                        end if;
                            
                        CpSv_EchoGray_o <= PrSv_PulseMultGray_s(20 downto 5);   
                        
                    when "11" =>
                        --if (PrSv_Result0_s(18) = '0') then
                        if (PrSv_Result0_s(18) = '0' and PrSv_DistGray_s >= PrSv_MeanData_s) then
                            CpSv_EchoWave_o <= PrSv_Result0_s;
                        else
                            CpSv_EchoWave_o <= (others => '0');
                        end if;
--                         CpSv_EchoGray_o <= "000" & PrSv_MultGray_s & "011";   
                        CpSv_EchoGray_o <= PrSv_PulseMultGray_s(20 downto 5);  
                    
                    when others => 
                        CpSv_EchoWave_o <= (others => '0');
                        CpSv_EchoGray_o <= (others => '0');    
                end case;    
                    
            else -- hold
            end if;
        end if;
    end process;
    
    -- CpSv_EchoWave_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_EchoPW20_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DVld_i = '1') then 
                PrSv_EchoPW20_o <= (others => '0');
            elsif (PrSv_EchoState_s = PrSv_TdcEnd_c) then                     
                PrSv_EchoPW20_o <= PrSv_Echo1PW20_s;      
            else -- hold
            end if;
        end if;
    end process;    
----------------------------------------------------------------------------
-- End Describe
----------------------------------------------------------------------------
end arch_M_WaveData;