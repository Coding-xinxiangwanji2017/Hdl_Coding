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
-- ??    ?  :  ZVISION
-- ???????  :  M_RomCtrl.vhd
-- ??    ??  :  zhang wenjun
-- ??    ??  :  wenjun.zhang@zvision.xyz
-- ��    ??  :
-- ????????  :  2018/05/17
-- ???????  :  Ocntrol Memory Data
-- ?��????  :  0.1
-- ??????  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------------------------------------
-- library Xilinx
----------------------------------------
--library unisim;
--use unisim.vcomponents.all;

----------------------------------------
-- library Altera
----------------------------------------
library altera_mf;
use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------

entity M_DistConst is
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
        CpSv_Start1_W20_min1_o          : out std_logic_vector(15 downto 0);    -- Start1_W20_min1
        CpSv_Start1_W20_max1_o          : out std_logic_vector(15 downto 0);    -- Start1_W20_max1
        CpSv_Start1_W20_a1_o            : out std_logic_vector(15 downto 0);    -- Start1_W20_a1
        CpSv_Start1_W20_b1_o            : out std_logic_vector(15 downto 0);    -- Start1_W20_b1
        CpSv_Start1_W20_min2_o          : out std_logic_vector(15 downto 0);    -- Start1_W20_min2
        CpSv_Start1_W20_max2_o          : out std_logic_vector(15 downto 0);    -- Start1_W20_max2
        CpSv_Start1_W20_a2_o            : out std_logic_vector(15 downto 0);    -- Start1_W20_a2
        CpSv_Start1_W20_b2_o            : out std_logic_vector(15 downto 0);    -- Start1_W20_b2
        CpSv_Start1_W20_min3_o          : out std_logic_vector(15 downto 0);    -- Start1_W20_min3
        CpSv_Start1_W20_max3_o          : out std_logic_vector(15 downto 0);    -- Start1_W20_max3
        CpSv_Start1_W20_a3_o            : out std_logic_vector(15 downto 0);    -- Start1_W20_a3
        CpSv_Start1_W20_b3_o            : out std_logic_vector(15 downto 0);    -- Start1_W20_b3
        CpSv_Start1_W50_min1_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_min1
        CpSv_Start1_W50_max1_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_max1
        CpSv_Start1_W50_a1_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_a1
        CpSv_Start1_W50_b1_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_b1
        CpSv_Start1_W50_min2_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_min2
        CpSv_Start1_W50_max2_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_max2
        CpSv_Start1_W50_a2_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_a2  
        CpSv_Start1_W50_b2_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_b2  
        CpSv_Start1_W50_min3_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_min3
        CpSv_Start1_W50_max3_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_max3
        CpSv_Start1_W50_a3_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_a3  
        CpSv_Start1_W50_b3_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_b3  
        CpSv_Start1_W50_min4_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_min4
        CpSv_Start1_W50_max4_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_max4
        CpSv_Start1_W50_a4_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_a4
        CpSv_Start1_W50_b4_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_b4    
        CpSv_Start1_W50_min5_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_min5
        CpSv_Start1_W50_max5_o          : out std_logic_vector(15 downto 0);    -- Start1_W50_max5
        CpSv_Start1_W50_a5_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_a5
        CpSv_Start1_W50_b5_o            : out std_logic_vector(15 downto 0);    -- Start1_W50_b5    
        CpSv_Start1_W90_min1_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_min1
        CpSv_Start1_W90_max1_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_max1
        CpSv_Start1_W90_a1_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_a1
        CpSv_Start1_W90_b1_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_b1
        CpSv_Start1_W90_min2_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_min2
        CpSv_Start1_W90_max2_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_max2
        CpSv_Start1_W90_a2_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_a2  
        CpSv_Start1_W90_b2_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_b2  
        CpSv_Start1_W90_min3_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_min3
        CpSv_Start1_W90_max3_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_max3
        CpSv_Start1_W90_a3_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_a3  
        CpSv_Start1_W90_b3_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_b3  
        CpSv_Start1_W90_min4_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_min4
        CpSv_Start1_W90_max4_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_max4
        CpSv_Start1_W90_a4_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_a4  
        CpSv_Start1_W90_b4_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_b4   
        CpSv_Start1_W90_min5_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_min5
        CpSv_Start1_W90_max5_o          : out std_logic_vector(15 downto 0);    -- Start1_W90_max5
        CpSv_Start1_W90_a5_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_a5  
        CpSv_Start1_W90_b5_o            : out std_logic_vector(15 downto 0);    -- Start1_W90_b5     
        
        -- Start2
        CpSv_Start2_W20_min1_o          : out std_logic_vector(15 downto 0);    -- Start2_W20_min1   
        CpSv_Start2_W20_max1_o          : out std_logic_vector(15 downto 0);    -- Start2_W20_max1   
        CpSv_Start2_W20_a1_o            : out std_logic_vector(15 downto 0);    -- Start2_W20_a1     
        CpSv_Start2_W20_b1_o            : out std_logic_vector(15 downto 0);    -- Start2_W20_b1     
        CpSv_Start2_W20_min2_o          : out std_logic_vector(15 downto 0);    -- Start2_W20_min2   
        CpSv_Start2_W20_max2_o          : out std_logic_vector(15 downto 0);    -- Start2_W20_max2   
        CpSv_Start2_W20_a2_o            : out std_logic_vector(15 downto 0);    -- Start2_W20_a2     
        CpSv_Start2_W20_b2_o            : out std_logic_vector(15 downto 0);    -- Start2_W20_b2     
        CpSv_Start2_W20_min3_o          : out std_logic_vector(15 downto 0);    -- Start2_W20_min3   
        CpSv_Start2_W20_max3_o          : out std_logic_vector(15 downto 0);    -- Start2_W20_max3   
        CpSv_Start2_W20_a3_o            : out std_logic_vector(15 downto 0);    -- Start2_W20_a3     
        CpSv_Start2_W20_b3_o            : out std_logic_vector(15 downto 0);    -- Start2_W20_b3     
        CpSv_Start2_W50_min1_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_min1   
        CpSv_Start2_W50_max1_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_max1   
        CpSv_Start2_W50_a1_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_a1     
        CpSv_Start2_W50_b1_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_b1     
        CpSv_Start2_W50_min2_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_min2   
        CpSv_Start2_W50_max2_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_max2   
        CpSv_Start2_W50_a2_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_a2     
        CpSv_Start2_W50_b2_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_b2     
        CpSv_Start2_W50_min3_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_min3   
        CpSv_Start2_W50_max3_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_max3   
        CpSv_Start2_W50_a3_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_a3     
        CpSv_Start2_W50_b3_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_b3     
        CpSv_Start2_W50_min4_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_min4   
        CpSv_Start2_W50_max4_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_max4   
        CpSv_Start2_W50_a4_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_a4     
        CpSv_Start2_W50_b4_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_b4     
        CpSv_Start2_W50_min5_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_min5   
        CpSv_Start2_W50_max5_o          : out std_logic_vector(15 downto 0);    -- Start2_W50_max5   
        CpSv_Start2_W50_a5_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_a5     
        CpSv_Start2_W50_b5_o            : out std_logic_vector(15 downto 0);    -- Start2_W50_b5     
        CpSv_Start2_W90_min1_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_min1   
        CpSv_Start2_W90_max1_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_max1   
        CpSv_Start2_W90_a1_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_a1     
        CpSv_Start2_W90_b1_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_b1     
        CpSv_Start2_W90_min2_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_min2   
        CpSv_Start2_W90_max2_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_max2   
        CpSv_Start2_W90_a2_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_a2     
        CpSv_Start2_W90_b2_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_b2     
        CpSv_Start2_W90_min3_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_min3   
        CpSv_Start2_W90_max3_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_max3   
        CpSv_Start2_W90_a3_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_a3     
        CpSv_Start2_W90_b3_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_b3     
        CpSv_Start2_W90_min4_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_min4   
        CpSv_Start2_W90_max4_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_max4   
        CpSv_Start2_W90_a4_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_a4     
        CpSv_Start2_W90_b4_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_b4     
        CpSv_Start2_W90_min5_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_min5   
        CpSv_Start2_W90_max5_o          : out std_logic_vector(15 downto 0);    -- Start2_W90_max5   
        CpSv_Start2_W90_a5_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_a5     
        CpSv_Start2_W90_b5_o            : out std_logic_vector(15 downto 0);    -- Start2_W90_b5     
            
        -- Start3
        CpSv_Start3_W20_min1_o          : out std_logic_vector(15 downto 0);    -- Start3_W20_min1   
        CpSv_Start3_W20_max1_o          : out std_logic_vector(15 downto 0);    -- Start3_W20_max1   
        CpSv_Start3_W20_a1_o            : out std_logic_vector(15 downto 0);    -- Start3_W20_a1     
        CpSv_Start3_W20_b1_o            : out std_logic_vector(15 downto 0);    -- Start3_W20_b1     
        CpSv_Start3_W20_min2_o          : out std_logic_vector(15 downto 0);    -- Start3_W20_min2   
        CpSv_Start3_W20_max2_o          : out std_logic_vector(15 downto 0);    -- Start3_W20_max2   
        CpSv_Start3_W20_a2_o            : out std_logic_vector(15 downto 0);    -- Start3_W20_a2     
        CpSv_Start3_W20_b2_o            : out std_logic_vector(15 downto 0);    -- Start3_W20_b2     
        CpSv_Start3_W20_min3_o          : out std_logic_vector(15 downto 0);    -- Start3_W20_min3   
        CpSv_Start3_W20_max3_o          : out std_logic_vector(15 downto 0);    -- Start3_W20_max3   
        CpSv_Start3_W20_a3_o            : out std_logic_vector(15 downto 0);    -- Start3_W20_a3     
        CpSv_Start3_W20_b3_o            : out std_logic_vector(15 downto 0);    -- Start3_W20_b3     
        CpSv_Start3_W50_min1_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_min1   
        CpSv_Start3_W50_max1_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_max1   
        CpSv_Start3_W50_a1_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_a1     
        CpSv_Start3_W50_b1_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_b1     
        CpSv_Start3_W50_min2_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_min2   
        CpSv_Start3_W50_max2_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_max2   
        CpSv_Start3_W50_a2_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_a2     
        CpSv_Start3_W50_b2_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_b2     
        CpSv_Start3_W50_min3_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_min3   
        CpSv_Start3_W50_max3_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_max3   
        CpSv_Start3_W50_a3_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_a3     
        CpSv_Start3_W50_b3_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_b3     
        CpSv_Start3_W50_min4_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_min4   
        CpSv_Start3_W50_max4_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_max4   
        CpSv_Start3_W50_a4_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_a4     
        CpSv_Start3_W50_b4_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_b4     
        CpSv_Start3_W50_min5_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_min5   
        CpSv_Start3_W50_max5_o          : out std_logic_vector(15 downto 0);    -- Start3_W50_max5   
        CpSv_Start3_W50_a5_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_a5     
        CpSv_Start3_W50_b5_o            : out std_logic_vector(15 downto 0);    -- Start3_W50_b5     
        CpSv_Start3_W90_min1_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_min1   
        CpSv_Start3_W90_max1_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_max1   
        CpSv_Start3_W90_a1_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_a1     
        CpSv_Start3_W90_b1_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_b1     
        CpSv_Start3_W90_min2_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_min2   
        CpSv_Start3_W90_max2_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_max2   
        CpSv_Start3_W90_a2_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_a2     
        CpSv_Start3_W90_b2_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_b2     
        CpSv_Start3_W90_min3_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_min3   
        CpSv_Start3_W90_max3_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_max3   
        CpSv_Start3_W90_a3_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_a3     
        CpSv_Start3_W90_b3_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_b3     
        CpSv_Start3_W90_min4_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_min4   
        CpSv_Start3_W90_max4_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_max4   
        CpSv_Start3_W90_a4_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_a4     
        CpSv_Start3_W90_b4_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_b4     
        CpSv_Start3_W90_min5_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_min5   
        CpSv_Start3_W90_max5_o          : out std_logic_vector(15 downto 0);    -- Start3_W90_max5   
        CpSv_Start3_W90_a5_o            : out std_logic_vector(15 downto 0);    -- Start3_W90_a5     
        CpSv_Start3_W90_b5_o            : out std_logic_vector(15 downto 0)     -- Start3_W90_b5          
    );
end M_DistConst;

architecture arch_M_DistConst of M_DistConst is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    component M_GrayRam is
    PORT (
		clock                           : IN STD_LOGIC  := '1';
		data                            : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress                       : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		wraddress                       : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		wren                            : IN STD_LOGIC  := '0';
		q                               : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
    end component;
    
    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSv_Start1_W20_min1_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_max1_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_a1_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_b1_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_min2_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_max2_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_a2_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_b2_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_min3_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_max3_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_a3_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W20_b3_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_min1_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_max1_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_a1_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_b1_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_min2_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_max2_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_a2_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_b2_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_min3_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_max3_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_a3_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_b3_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_min4_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_max4_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_a4_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_b4_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_min5_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_max5_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_a5_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W50_b5_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_min1_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_max1_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_a1_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_b1_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_min2_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_max2_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_a2_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_b2_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_min3_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_max3_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_a3_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_b3_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_min4_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_max4_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_a4_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_b4_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_min5_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_max5_s        : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_a5_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start1_W90_b5_s          : std_logic_vector(15 downto 0);       -- Start1 
    signal PrSv_Start2_W20_min1_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_max1_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_a1_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_b1_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_min2_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_max2_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_a2_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_b2_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_min3_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_max3_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_a3_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W20_b3_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_min1_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_max1_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_a1_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_b1_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_min2_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_max2_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_a2_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_b2_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_min3_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_max3_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_a3_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_b3_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_min4_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_max4_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_a4_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_b4_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_min5_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_max5_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_a5_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W50_b5_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_min1_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_max1_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_a1_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_b1_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_min2_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_max2_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_a2_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_b2_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_min3_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_max3_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_a3_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_b3_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_min4_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_max4_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_a4_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_b4_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_min5_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_max5_s        : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_a5_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start2_W90_b5_s          : std_logic_vector(15 downto 0);       -- Start2 
    signal PrSv_Start3_W20_min1_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_max1_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_a1_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_b1_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_min2_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_max2_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_a2_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_b2_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_min3_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_max3_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_a3_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W20_b3_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_min1_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_max1_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_a1_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_b1_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_min2_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_max2_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_a2_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_b2_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_min3_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_max3_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_a3_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_b3_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_min4_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_max4_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_a4_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_b4_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_min5_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_max5_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_a5_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W50_b5_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_min1_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_max1_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_a1_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_b1_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_min2_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_max2_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_a2_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_b2_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_min3_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_max3_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_a3_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_b3_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_min4_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_max4_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_a4_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_b4_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_min5_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_max5_s        : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_a5_s          : std_logic_vector(15 downto 0);       -- Start3 
    signal PrSv_Start3_W90_b5_s          : std_logic_vector(15 downto 0);       -- Start3
    
    -- Gray_Ratio                                                   
    signal PrSl_GrayRd_s                 : std_logic;
    signal PrSl_GrayRdDly1_s             : std_logic;
    signal PrSl_GrayRdDly2_s             : std_logic;
    signal PrSl_GrayRdDly3_s             : std_logic;
    signal PrSv_GrayAddr_s               : STD_LOGIC_VECTOR(14 DOWNTO 0);
    signal PrSv_GrayRamAddr_s            : STD_LOGIC_VECTOR(14 DOWNTO 0);
    signal PrSv_GrayData_s               : STD_LOGIC_VECTOR( 7 DOWNTO 0);      

begin
    ----------------------------------------------------------------------------
    -- Component_Map
    ----------------------------------------------------------------------------
    U_M_GrayRam_0 : M_GrayRam
    port map (
		clock                           => CpSl_Clk_i                           , -- IN STD_LOGIC  := '1';
		wren                            => CpSl_GrayEn_i                        , -- IN STD_LOGIC  := '0';
		data                            => CpSv_GrayData_i                      , -- IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wraddress                       => CpSv_GrayAddr_i(12 downto 0)         , -- IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		rdaddress                       => PrSv_GrayRamAddr_s                   , -- IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		q                               => PrSv_GrayData_s                        -- OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
--    
    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    -- Delay CpSl_GrayRd_i
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_GrayRd_s     <= '0';
            PrSl_GrayRdDly1_s <= '0';
            PrSl_GrayRdDly2_s <= '0';
            PrSl_GrayRdDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_GrayRd_s     <= CpSl_GrayRd_i;
            PrSl_GrayRdDly1_s <= PrSl_GrayRd_s;   
            PrSl_GrayRdDly2_s <= PrSl_GrayRdDly1_s;
            PrSl_GrayRdDly3_s <= PrSl_GrayRdDly2_s;
        end if;
    end process;
    
    -- CpSl_GrayDataVld_o
    CpSl_GrayDataVld_o <= PrSl_GrayRdDly3_s;

    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_GrayAddr_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
        case CpSv_LdNum_i is 
            when "01" => 
                if (PrSl_GrayRd_s = '1') then
                    PrSv_GrayAddr_s <= CpSl_GroupRdData_i;
                else -- hold
                end if;
            when "10" => 
                if (PrSl_GrayRd_s = '1') then
                    PrSv_GrayAddr_s <= 10000 + CpSl_GroupRdData_i;
                else
                end if;
            when "11" =>
                if (PrSl_GrayRd_s = '1') then    
                    PrSv_GrayAddr_s <= 20000 + CpSl_GroupRdData_i;
                else
                end if;
            when others => 
                PrSv_GrayAddr_s <= (others => '0');
        end case;
        end if;
    end process;
    -- PrSv_GrayRamAddr_s
    PrSv_GrayRamAddr_s <= PrSv_GrayAddr_s(14 downto 0);
    
    -- CpSv_GrayData_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            CpSv_GrayData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_GrayRdDly2_s = '1') then
                --CpSv_GrayData_o <= x"0020";  -- 32
                CpSv_GrayData_o <= x"00" & PrSv_GrayData_s;
            else -- hold
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_Start1_W20_min1_s <= (others => '0');
            PrSv_Start1_W20_max1_s <= (others => '0');
            PrSv_Start1_W20_a1_s   <= (others => '0');
            PrSv_Start1_W20_b1_s   <= (others => '0');
            PrSv_Start1_W20_min2_s <= (others => '0');
            PrSv_Start1_W20_max2_s <= (others => '0');
            PrSv_Start1_W20_a2_s   <= (others => '0');
            PrSv_Start1_W20_b2_s   <= (others => '0');
            PrSv_Start1_W20_min3_s <= (others => '0');
            PrSv_Start1_W20_max3_s <= (others => '0');
            PrSv_Start1_W20_a3_s   <= (others => '0');
            PrSv_Start1_W20_b3_s   <= (others => '0');
            PrSv_Start1_W50_min1_s <= (others => '0');
            PrSv_Start1_W50_max1_s <= (others => '0');
            PrSv_Start1_W50_a1_s   <= (others => '0');
            PrSv_Start1_W50_b1_s   <= (others => '0');
            PrSv_Start1_W50_min2_s <= (others => '0');
            PrSv_Start1_W50_max2_s <= (others => '0');
            PrSv_Start1_W50_a2_s   <= (others => '0');
            PrSv_Start1_W50_b2_s   <= (others => '0');
            PrSv_Start1_W50_min3_s <= (others => '0');
            PrSv_Start1_W50_max3_s <= (others => '0');
            PrSv_Start1_W50_a3_s   <= (others => '0');
            PrSv_Start1_W50_b3_s   <= (others => '0');
            PrSv_Start1_W50_min4_s <= (others => '0');
            PrSv_Start1_W50_max4_s <= (others => '0');
            PrSv_Start1_W50_a4_s   <= (others => '0');
            PrSv_Start1_W50_b4_s   <= (others => '0');
            PrSv_Start1_W50_min5_s <= (others => '0');
            PrSv_Start1_W50_max5_s <= (others => '0');
            PrSv_Start1_W50_a5_s   <= (others => '0');
            PrSv_Start1_W50_b5_s   <= (others => '0');
            PrSv_Start1_W90_min1_s <= (others => '0');
            PrSv_Start1_W90_max1_s <= (others => '0');
            PrSv_Start1_W90_a1_s   <= (others => '0');
            PrSv_Start1_W90_b1_s   <= (others => '0');
            PrSv_Start1_W90_min2_s <= (others => '0');
            PrSv_Start1_W90_max2_s <= (others => '0');
            PrSv_Start1_W90_a2_s   <= (others => '0');
            PrSv_Start1_W90_b2_s   <= (others => '0');
            PrSv_Start1_W90_min3_s <= (others => '0');
            PrSv_Start1_W90_max3_s <= (others => '0');
            PrSv_Start1_W90_a3_s   <= (others => '0');
            PrSv_Start1_W90_b3_s   <= (others => '0');
            PrSv_Start1_W90_min4_s <= (others => '0');
            PrSv_Start1_W90_max4_s <= (others => '0');
            PrSv_Start1_W90_a4_s   <= (others => '0');
            PrSv_Start1_W90_b4_s   <= (others => '0');
            PrSv_Start1_W90_min5_s <= (others => '0');
            PrSv_Start1_W90_max5_s <= (others => '0');
            PrSv_Start1_W90_a5_s   <= (others => '0');
            PrSv_Start1_W90_b5_s   <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DistEn_i = '1') then 
                case CpSv_DistAddr_i(15 downto 0) is
                    when x"0000" => 
                        PrSv_Start1_W20_min1_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W20_max1_s <= CpSv_DistData_i(15 downto  0);
                    when x"0001" =>  
                        PrSv_Start1_W20_a1_s   <= CpSv_DistData_i(31 downto 16); 
                        PrSv_Start1_W20_b1_s   <= CpSv_DistData_i(15 downto  0); 
                    when x"0002" =>
                        PrSv_Start1_W20_min2_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W20_max2_s <= CpSv_DistData_i(15 downto  0);
                    when x"0003" =>                                             
                        PrSv_Start1_W20_a2_s   <= CpSv_DistData_i(31 downto 16);     
                        PrSv_Start1_W20_b2_s   <= CpSv_DistData_i(15 downto  0);     
                    when x"0004" =>
                        PrSv_Start1_W20_min3_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W20_max3_s <= CpSv_DistData_i(15 downto  0);
                    when x"0005" =>                                             
                        PrSv_Start1_W20_a3_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W20_b3_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0006" =>       
                        PrSv_Start1_W50_min1_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W50_max1_s <= CpSv_DistData_i(15 downto  0);
                    when x"0007" =>                                             
                        PrSv_Start1_W50_a1_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W50_b1_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0008" => 
                        PrSv_Start1_W50_min2_s <= CpSv_DistData_i(31 downto 16);       
                        PrSv_Start1_W50_max2_s <= CpSv_DistData_i(15 downto  0);
                    when x"0009" =>                                             
                        PrSv_Start1_W50_a2_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W50_b2_s   <= CpSv_DistData_i(15 downto  0);
                    when x"000A" =>
                        PrSv_Start1_W50_min3_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W50_max3_s <= CpSv_DistData_i(15 downto  0);
                    when x"000B" =>                                             
                        PrSv_Start1_W50_a3_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W50_b3_s   <= CpSv_DistData_i(15 downto  0);
                    when x"000C" =>
                        PrSv_Start1_W50_min4_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W50_max4_s <= CpSv_DistData_i(15 downto  0);
                    when x"000D" =>                                             
                        PrSv_Start1_W50_a4_s   <= CpSv_DistData_i(31 downto 16);              
                        PrSv_Start1_W50_b4_s   <= CpSv_DistData_i(15 downto  0);
                    when x"000E" =>
                        PrSv_Start1_W50_min5_s <= CpSv_DistData_i(31 downto 16);                 
                        PrSv_Start1_W50_max5_s <= CpSv_DistData_i(15 downto  0);                 
                    when x"000F" =>                                             
                        PrSv_Start1_W50_a5_s   <= CpSv_DistData_i(31 downto 16);                
                        PrSv_Start1_W50_b5_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0010" =>
                        PrSv_Start1_W90_min1_s <= CpSv_DistData_i(31 downto 16);                  
                        PrSv_Start1_W90_max1_s <= CpSv_DistData_i(15 downto  0);                  
                    when x"0011" =>                                             
                        PrSv_Start1_W90_a1_s   <= CpSv_DistData_i(31 downto 16);                  
                        PrSv_Start1_W90_b1_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0012" =>
                        PrSv_Start1_W90_min2_s <= CpSv_DistData_i(31 downto 16);                    
                        PrSv_Start1_W90_max2_s <= CpSv_DistData_i(15 downto  0);                    
                    when x"0013" =>                                             
                        PrSv_Start1_W90_a2_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W90_b2_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0014" =>                               
                        PrSv_Start1_W90_min3_s <= CpSv_DistData_i(31 downto 16);                                         
                        PrSv_Start1_W90_max3_s <= CpSv_DistData_i(15 downto  0);                                         
                    when x"0015" =>                                                             
                        PrSv_Start1_W90_a3_s   <= CpSv_DistData_i(31 downto 16);                                        
                        PrSv_Start1_W90_b3_s   <= CpSv_DistData_i(15 downto  0);                                        
                    when x"0016" =>                               
                        PrSv_Start1_W90_min4_s <= CpSv_DistData_i(31 downto 16);                                            
                        PrSv_Start1_W90_max4_s <= CpSv_DistData_i(15 downto  0);                                         
                    when x"0017" =>                                                             
                        PrSv_Start1_W90_a4_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W90_b4_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0018" =>
                        PrSv_Start1_W90_min5_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W90_max5_s <= CpSv_DistData_i(15 downto  0);
                    when x"0019" =>                                             
                        PrSv_Start1_W90_a5_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start1_W90_b5_s   <= CpSv_DistData_i(15 downto  0);    
                             
                    when others => 
                        PrSv_Start1_W20_min1_s <= PrSv_Start1_W20_min1_s;
                        PrSv_Start1_W20_max1_s <= PrSv_Start1_W20_max1_s;
                        PrSv_Start1_W20_a1_s   <= PrSv_Start1_W20_a1_s  ;
                        PrSv_Start1_W20_b1_s   <= PrSv_Start1_W20_b1_s  ;
                        PrSv_Start1_W20_min2_s <= PrSv_Start1_W20_min2_s;
                        PrSv_Start1_W20_max2_s <= PrSv_Start1_W20_max2_s;
                        PrSv_Start1_W20_a2_s   <= PrSv_Start1_W20_a2_s  ;
                        PrSv_Start1_W20_b2_s   <= PrSv_Start1_W20_b2_s  ;
                        PrSv_Start1_W20_min3_s <= PrSv_Start1_W20_min3_s;
                        PrSv_Start1_W20_max3_s <= PrSv_Start1_W20_max3_s;
                        PrSv_Start1_W20_a3_s   <= PrSv_Start1_W20_a3_s  ;
                        PrSv_Start1_W20_b3_s   <= PrSv_Start1_W20_b3_s  ;
                        PrSv_Start1_W50_min1_s <= PrSv_Start1_W50_min1_s;
                        PrSv_Start1_W50_max1_s <= PrSv_Start1_W50_max1_s;
                        PrSv_Start1_W50_a1_s   <= PrSv_Start1_W50_a1_s  ;
                        PrSv_Start1_W50_b1_s   <= PrSv_Start1_W50_b1_s  ;
                        PrSv_Start1_W50_min2_s <= PrSv_Start1_W50_min2_s;
                        PrSv_Start1_W50_max2_s <= PrSv_Start1_W50_max2_s;
                        PrSv_Start1_W50_a2_s   <= PrSv_Start1_W50_a2_s  ;
                        PrSv_Start1_W50_b2_s   <= PrSv_Start1_W50_b2_s  ;
                        PrSv_Start1_W50_min3_s <= PrSv_Start1_W50_min3_s;
                        PrSv_Start1_W50_max3_s <= PrSv_Start1_W50_max3_s;
                        PrSv_Start1_W50_a3_s   <= PrSv_Start1_W50_a3_s  ;
                        PrSv_Start1_W50_b3_s   <= PrSv_Start1_W50_b3_s  ;
                        PrSv_Start1_W50_min4_s <= PrSv_Start1_W50_min4_s;
                        PrSv_Start1_W50_max4_s <= PrSv_Start1_W50_max4_s;
                        PrSv_Start1_W50_a4_s   <= PrSv_Start1_W50_a4_s  ;
                        PrSv_Start1_W50_b4_s   <= PrSv_Start1_W50_b4_s  ;
                        PrSv_Start1_W50_min5_s <= PrSv_Start1_W50_min5_s;
                        PrSv_Start1_W50_max5_s <= PrSv_Start1_W50_max5_s;
                        PrSv_Start1_W50_a5_s   <= PrSv_Start1_W50_a5_s  ;
                        PrSv_Start1_W50_b5_s   <= PrSv_Start1_W50_b5_s  ;
                        PrSv_Start1_W90_min1_s <= PrSv_Start1_W90_min1_s;
                        PrSv_Start1_W90_max1_s <= PrSv_Start1_W90_max1_s;
                        PrSv_Start1_W90_a1_s   <= PrSv_Start1_W90_a1_s  ;
                        PrSv_Start1_W90_b1_s   <= PrSv_Start1_W90_b1_s  ;
                        PrSv_Start1_W90_min2_s <= PrSv_Start1_W90_min2_s;
                        PrSv_Start1_W90_max2_s <= PrSv_Start1_W90_max2_s;
                        PrSv_Start1_W90_a2_s   <= PrSv_Start1_W90_a2_s  ;
                        PrSv_Start1_W90_b2_s   <= PrSv_Start1_W90_b2_s  ;
                        PrSv_Start1_W90_min3_s <= PrSv_Start1_W90_min3_s;
                        PrSv_Start1_W90_max3_s <= PrSv_Start1_W90_max3_s;
                        PrSv_Start1_W90_a3_s   <= PrSv_Start1_W90_a3_s  ;
                        PrSv_Start1_W90_b3_s   <= PrSv_Start1_W90_b3_s  ;
                        PrSv_Start1_W90_min4_s <= PrSv_Start1_W90_min4_s;
                        PrSv_Start1_W90_max4_s <= PrSv_Start1_W90_max4_s;
                        PrSv_Start1_W90_a4_s   <= PrSv_Start1_W90_a4_s  ;
                        PrSv_Start1_W90_b4_s   <= PrSv_Start1_W90_b4_s  ;
                        PrSv_Start1_W90_min5_s <= PrSv_Start1_W90_min5_s;
                        PrSv_Start1_W90_max5_s <= PrSv_Start1_W90_max5_s;
                        PrSv_Start1_W90_a5_s   <= PrSv_Start1_W90_a5_s  ;
                        PrSv_Start1_W90_b5_s   <= PrSv_Start1_W90_b5_s  ;
                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_Start2_W20_min1_s <= (others => '0');
            PrSv_Start2_W20_max1_s <= (others => '0');
            PrSv_Start2_W20_a1_s   <= (others => '0');
            PrSv_Start2_W20_b1_s   <= (others => '0');
            PrSv_Start2_W20_min2_s <= (others => '0');
            PrSv_Start2_W20_max2_s <= (others => '0');
            PrSv_Start2_W20_a2_s   <= (others => '0');
            PrSv_Start2_W20_b2_s   <= (others => '0');
            PrSv_Start2_W20_min3_s <= (others => '0');
            PrSv_Start2_W20_max3_s <= (others => '0');
            PrSv_Start2_W20_a3_s   <= (others => '0');
            PrSv_Start2_W20_b3_s   <= (others => '0');
            PrSv_Start2_W50_min1_s <= (others => '0');
            PrSv_Start2_W50_max1_s <= (others => '0');
            PrSv_Start2_W50_a1_s   <= (others => '0');
            PrSv_Start2_W50_b1_s   <= (others => '0');
            PrSv_Start2_W50_min2_s <= (others => '0');
            PrSv_Start2_W50_max2_s <= (others => '0');
            PrSv_Start2_W50_a2_s   <= (others => '0');
            PrSv_Start2_W50_b2_s   <= (others => '0');
            PrSv_Start2_W50_min3_s <= (others => '0');
            PrSv_Start2_W50_max3_s <= (others => '0');
            PrSv_Start2_W50_a3_s   <= (others => '0');
            PrSv_Start2_W50_b3_s   <= (others => '0');
            PrSv_Start2_W50_min4_s <= (others => '0');
            PrSv_Start2_W50_max4_s <= (others => '0');
            PrSv_Start2_W50_a4_s   <= (others => '0');
            PrSv_Start2_W50_b4_s   <= (others => '0');
            PrSv_Start2_W50_min5_s <= (others => '0');
            PrSv_Start2_W50_max5_s <= (others => '0');
            PrSv_Start2_W50_a5_s   <= (others => '0');
            PrSv_Start2_W50_b5_s   <= (others => '0');
            PrSv_Start2_W90_min1_s <= (others => '0');
            PrSv_Start2_W90_max1_s <= (others => '0');
            PrSv_Start2_W90_a1_s   <= (others => '0');
            PrSv_Start2_W90_b1_s   <= (others => '0');
            PrSv_Start2_W90_min2_s <= (others => '0');
            PrSv_Start2_W90_max2_s <= (others => '0');
            PrSv_Start2_W90_a2_s   <= (others => '0');
            PrSv_Start2_W90_b2_s   <= (others => '0');
            PrSv_Start2_W90_min3_s <= (others => '0');
            PrSv_Start2_W90_max3_s <= (others => '0');
            PrSv_Start2_W90_a3_s   <= (others => '0');
            PrSv_Start2_W90_b3_s   <= (others => '0');
            PrSv_Start2_W90_min4_s <= (others => '0');
            PrSv_Start2_W90_max4_s <= (others => '0');
            PrSv_Start2_W90_a4_s   <= (others => '0');
            PrSv_Start2_W90_b4_s   <= (others => '0');
            PrSv_Start2_W90_min5_s <= (others => '0');
            PrSv_Start2_W90_max5_s <= (others => '0');
            PrSv_Start2_W90_a5_s   <= (others => '0');
            PrSv_Start2_W90_b5_s   <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DistEn_i = '1') then 
                case CpSv_DistAddr_i(15 downto 0) is
                    when x"001A" => 
                        PrSv_Start2_W20_min1_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W20_max1_s <= CpSv_DistData_i(15 downto  0);    
                    when x"001B" =>                                                 
                        PrSv_Start2_W20_a1_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W20_b1_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"001C" =>                                                 
                        PrSv_Start2_W20_min2_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W20_max2_s <= CpSv_DistData_i(15 downto  0);    
                    when x"001D" =>                                                 
                        PrSv_Start2_W20_a2_s   <= CpSv_DistData_i(31 downto 16);     
                        PrSv_Start2_W20_b2_s   <= CpSv_DistData_i(15 downto  0);     
                    when x"001E" =>                                                 
                        PrSv_Start2_W20_min3_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W20_max3_s <= CpSv_DistData_i(15 downto  0);    
                    when x"001F" =>                                                 
                        PrSv_Start2_W20_a3_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W20_b3_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"0020" =>                                                 
                        PrSv_Start2_W50_min1_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W50_max1_s <= CpSv_DistData_i(15 downto  0);    
                    when x"0021" =>                                                 
                        PrSv_Start2_W50_a1_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start2_W50_b1_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"0022" =>                                                 
                        PrSv_Start2_W50_min2_s <= CpSv_DistData_i(31 downto 16);       
                        PrSv_Start2_W50_max2_s <= CpSv_DistData_i(15 downto  0);    
                    when x"0023" =>                                             
                        PrSv_Start2_W50_a2_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W50_b2_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0024" =>
                        PrSv_Start2_W50_min3_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W50_max3_s <= CpSv_DistData_i(15 downto  0);
                    when x"0025" =>                                             
                        PrSv_Start2_W50_a3_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W50_b3_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0026" =>
                        PrSv_Start2_W50_min4_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W50_max4_s <= CpSv_DistData_i(15 downto  0);
                    when x"0027" =>                                             
                        PrSv_Start2_W50_a4_s   <= CpSv_DistData_i(31 downto 16);              
                        PrSv_Start2_W50_b4_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0028" =>
                        PrSv_Start2_W50_min5_s <= CpSv_DistData_i(31 downto 16);                 
                        PrSv_Start2_W50_max5_s <= CpSv_DistData_i(15 downto  0);                 
                    when x"0029" =>                                             
                        PrSv_Start2_W50_a5_s   <= CpSv_DistData_i(31 downto 16);                
                        PrSv_Start2_W50_b5_s   <= CpSv_DistData_i(15 downto  0);
                    when x"002A" =>
                        PrSv_Start2_W90_min1_s <= CpSv_DistData_i(31 downto 16);                  
                        PrSv_Start2_W90_max1_s <= CpSv_DistData_i(15 downto  0);                  
                    when x"002B" =>                                             
                        PrSv_Start2_W90_a1_s   <= CpSv_DistData_i(31 downto 16);                  
                        PrSv_Start2_W90_b1_s   <= CpSv_DistData_i(15 downto  0); 
                    when x"002C" =>                                              
                        PrSv_Start2_W90_min2_s <= CpSv_DistData_i(31 downto 16);                    
                        PrSv_Start2_W90_max2_s <= CpSv_DistData_i(15 downto  0);                    
                    when x"002D" =>                                              
                        PrSv_Start2_W90_a2_s   <= CpSv_DistData_i(31 downto 16); 
                        PrSv_Start2_W90_b2_s   <= CpSv_DistData_i(15 downto  0); 
                    when x"002E" =>                                              
                        PrSv_Start2_W90_min3_s <= CpSv_DistData_i(31 downto 16);                                         
                        PrSv_Start2_W90_max3_s <= CpSv_DistData_i(15 downto  0);                                         
                    when x"002F" =>                                                             
                        PrSv_Start2_W90_a3_s   <= CpSv_DistData_i(31 downto 16);                                        
                        PrSv_Start2_W90_b3_s   <= CpSv_DistData_i(15 downto  0);                                        
                    when x"0030" =>                               
                        PrSv_Start2_W90_min4_s <= CpSv_DistData_i(31 downto 16);                                            
                        PrSv_Start2_W90_max4_s <= CpSv_DistData_i(15 downto  0);                                         
                    when x"0031" =>                                                             
                        PrSv_Start2_W90_a4_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W90_b4_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0032" =>
                        PrSv_Start2_W90_min5_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W90_max5_s <= CpSv_DistData_i(15 downto  0);
                    when x"0033" =>                                             
                        PrSv_Start2_W90_a5_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start2_W90_b5_s   <= CpSv_DistData_i(15 downto  0);    
                             
                    when others => 
                        PrSv_Start2_W20_min1_s <= PrSv_Start2_W20_min1_s;
                        PrSv_Start2_W20_max1_s <= PrSv_Start2_W20_max1_s;
                        PrSv_Start2_W20_a1_s   <= PrSv_Start2_W20_a1_s  ;
                        PrSv_Start2_W20_b1_s   <= PrSv_Start2_W20_b1_s  ;
                        PrSv_Start2_W20_min2_s <= PrSv_Start2_W20_min2_s;
                        PrSv_Start2_W20_max2_s <= PrSv_Start2_W20_max2_s;
                        PrSv_Start2_W20_a2_s   <= PrSv_Start2_W20_a2_s  ;
                        PrSv_Start2_W20_b2_s   <= PrSv_Start2_W20_b2_s  ;
                        PrSv_Start2_W20_min3_s <= PrSv_Start2_W20_min3_s;
                        PrSv_Start2_W20_max3_s <= PrSv_Start2_W20_max3_s;
                        PrSv_Start2_W20_a3_s   <= PrSv_Start2_W20_a3_s  ;
                        PrSv_Start2_W20_b3_s   <= PrSv_Start2_W20_b3_s  ;
                        PrSv_Start2_W50_min1_s <= PrSv_Start2_W50_min1_s;
                        PrSv_Start2_W50_max1_s <= PrSv_Start2_W50_max1_s;
                        PrSv_Start2_W50_a1_s   <= PrSv_Start2_W50_a1_s  ;
                        PrSv_Start2_W50_b1_s   <= PrSv_Start2_W50_b1_s  ;
                        PrSv_Start2_W50_min2_s <= PrSv_Start2_W50_min2_s;
                        PrSv_Start2_W50_max2_s <= PrSv_Start2_W50_max2_s;
                        PrSv_Start2_W50_a2_s   <= PrSv_Start2_W50_a2_s  ;
                        PrSv_Start2_W50_b2_s   <= PrSv_Start2_W50_b2_s  ;
                        PrSv_Start2_W50_min3_s <= PrSv_Start2_W50_min3_s;
                        PrSv_Start2_W50_max3_s <= PrSv_Start2_W50_max3_s;
                        PrSv_Start2_W50_a3_s   <= PrSv_Start2_W50_a3_s  ;
                        PrSv_Start2_W50_b3_s   <= PrSv_Start2_W50_b3_s  ;
                        PrSv_Start2_W50_min4_s <= PrSv_Start2_W50_min4_s;
                        PrSv_Start2_W50_max4_s <= PrSv_Start2_W50_max4_s;
                        PrSv_Start2_W50_a4_s   <= PrSv_Start2_W50_a4_s  ;
                        PrSv_Start2_W50_b4_s   <= PrSv_Start2_W50_b4_s  ;
                        PrSv_Start2_W50_min5_s <= PrSv_Start2_W50_min5_s;
                        PrSv_Start2_W50_max5_s <= PrSv_Start2_W50_max5_s;
                        PrSv_Start2_W50_a5_s   <= PrSv_Start2_W50_a5_s  ;
                        PrSv_Start2_W50_b5_s   <= PrSv_Start2_W50_b5_s  ;
                        PrSv_Start2_W90_min1_s <= PrSv_Start2_W90_min1_s;
                        PrSv_Start2_W90_max1_s <= PrSv_Start2_W90_max1_s;
                        PrSv_Start2_W90_a1_s   <= PrSv_Start2_W90_a1_s  ;
                        PrSv_Start2_W90_b1_s   <= PrSv_Start2_W90_b1_s  ;
                        PrSv_Start2_W90_min2_s <= PrSv_Start2_W90_min2_s;
                        PrSv_Start2_W90_max2_s <= PrSv_Start2_W90_max2_s;
                        PrSv_Start2_W90_a2_s   <= PrSv_Start2_W90_a2_s  ;
                        PrSv_Start2_W90_b2_s   <= PrSv_Start2_W90_b2_s  ;
                        PrSv_Start2_W90_min3_s <= PrSv_Start2_W90_min3_s;
                        PrSv_Start2_W90_max3_s <= PrSv_Start2_W90_max3_s;
                        PrSv_Start2_W90_a3_s   <= PrSv_Start2_W90_a3_s  ;
                        PrSv_Start2_W90_b3_s   <= PrSv_Start2_W90_b3_s  ;
                        PrSv_Start2_W90_min4_s <= PrSv_Start2_W90_min4_s;
                        PrSv_Start2_W90_max4_s <= PrSv_Start2_W90_max4_s;
                        PrSv_Start2_W90_a4_s   <= PrSv_Start2_W90_a4_s  ;
                        PrSv_Start2_W90_b4_s   <= PrSv_Start2_W90_b4_s  ;
                        PrSv_Start2_W90_min5_s <= PrSv_Start2_W90_min5_s;
                        PrSv_Start2_W90_max5_s <= PrSv_Start2_W90_max5_s;
                        PrSv_Start2_W90_a5_s   <= PrSv_Start2_W90_a5_s  ;
                        PrSv_Start2_W90_b5_s   <= PrSv_Start2_W90_b5_s  ;
                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_Start3_W20_min1_s <= (others => '0');
            PrSv_Start3_W20_max1_s <= (others => '0');
            PrSv_Start3_W20_a1_s   <= (others => '0');
            PrSv_Start3_W20_b1_s   <= (others => '0');
            PrSv_Start3_W20_min2_s <= (others => '0');
            PrSv_Start3_W20_max2_s <= (others => '0');
            PrSv_Start3_W20_a2_s   <= (others => '0');
            PrSv_Start3_W20_b2_s   <= (others => '0');
            PrSv_Start3_W20_min3_s <= (others => '0');
            PrSv_Start3_W20_max3_s <= (others => '0');
            PrSv_Start3_W20_a3_s   <= (others => '0');
            PrSv_Start3_W20_b3_s   <= (others => '0');
            PrSv_Start3_W50_min1_s <= (others => '0');
            PrSv_Start3_W50_max1_s <= (others => '0');
            PrSv_Start3_W50_a1_s   <= (others => '0');
            PrSv_Start3_W50_b1_s   <= (others => '0');
            PrSv_Start3_W50_min2_s <= (others => '0');
            PrSv_Start3_W50_max2_s <= (others => '0');
            PrSv_Start3_W50_a2_s   <= (others => '0');
            PrSv_Start3_W50_b2_s   <= (others => '0');
            PrSv_Start3_W50_min3_s <= (others => '0');
            PrSv_Start3_W50_max3_s <= (others => '0');
            PrSv_Start3_W50_a3_s   <= (others => '0');
            PrSv_Start3_W50_b3_s   <= (others => '0');
            PrSv_Start3_W50_min4_s <= (others => '0');
            PrSv_Start3_W50_max4_s <= (others => '0');
            PrSv_Start3_W50_a4_s   <= (others => '0');
            PrSv_Start3_W50_b4_s   <= (others => '0');
            PrSv_Start3_W50_min5_s <= (others => '0');
            PrSv_Start3_W50_max5_s <= (others => '0');
            PrSv_Start3_W50_a5_s   <= (others => '0');
            PrSv_Start3_W50_b5_s   <= (others => '0');
            PrSv_Start3_W90_min1_s <= (others => '0');
            PrSv_Start3_W90_max1_s <= (others => '0');
            PrSv_Start3_W90_a1_s   <= (others => '0');
            PrSv_Start3_W90_b1_s   <= (others => '0');
            PrSv_Start3_W90_min2_s <= (others => '0');
            PrSv_Start3_W90_max2_s <= (others => '0');
            PrSv_Start3_W90_a2_s   <= (others => '0');
            PrSv_Start3_W90_b2_s   <= (others => '0');
            PrSv_Start3_W90_min3_s <= (others => '0');
            PrSv_Start3_W90_max3_s <= (others => '0');
            PrSv_Start3_W90_a3_s   <= (others => '0');
            PrSv_Start3_W90_b3_s   <= (others => '0');
            PrSv_Start3_W90_min4_s <= (others => '0');
            PrSv_Start3_W90_max4_s <= (others => '0');
            PrSv_Start3_W90_a4_s   <= (others => '0');
            PrSv_Start3_W90_b4_s   <= (others => '0');
            PrSv_Start3_W90_min5_s <= (others => '0');
            PrSv_Start3_W90_max5_s <= (others => '0');
            PrSv_Start3_W90_a5_s   <= (others => '0');
            PrSv_Start3_W90_b5_s   <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_DistEn_i = '1') then 
                case CpSv_DistAddr_i(15 downto 0) is
                    when x"0034" => 
                        PrSv_Start3_W20_min1_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start3_W20_max1_s <= CpSv_DistData_i(15 downto  0);
                    when x"0035" =>  
                        PrSv_Start3_W20_a1_s   <= CpSv_DistData_i(31 downto 16); 
                        PrSv_Start3_W20_b1_s   <= CpSv_DistData_i(15 downto  0); 
                    when x"0036" =>
                        PrSv_Start3_W20_min2_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start3_W20_max2_s <= CpSv_DistData_i(15 downto  0);
                    when x"0037" =>                                             
                        PrSv_Start3_W20_a2_s   <= CpSv_DistData_i(31 downto 16);     
                        PrSv_Start3_W20_b2_s   <= CpSv_DistData_i(15 downto  0);     
                    when x"0038" =>
                        PrSv_Start3_W20_min3_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W20_max3_s <= CpSv_DistData_i(15 downto  0);    
                    when x"0039" =>                                                 
                        PrSv_Start3_W20_a3_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W20_b3_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"003A" =>                                                 
                        PrSv_Start3_W50_min1_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W50_max1_s <= CpSv_DistData_i(15 downto  0);    
                    when x"003B" =>                                                 
                        PrSv_Start3_W50_a1_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W50_b1_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"003C" =>                                                 
                        PrSv_Start3_W50_min2_s <= CpSv_DistData_i(31 downto 16);       
                        PrSv_Start3_W50_max2_s <= CpSv_DistData_i(15 downto  0);    
                    when x"003D" =>                                                 
                        PrSv_Start3_W50_a2_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W50_b2_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"003E" =>                                                 
                        PrSv_Start3_W50_min3_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W50_max3_s <= CpSv_DistData_i(15 downto  0);    
                    when x"003F" =>                                                 
                        PrSv_Start3_W50_a3_s   <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W50_b3_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"0040" =>                                                 
                        PrSv_Start3_W50_min4_s <= CpSv_DistData_i(31 downto 16);    
                        PrSv_Start3_W50_max4_s <= CpSv_DistData_i(15 downto  0);    
                    when x"0041" =>                                             
                        PrSv_Start3_W50_a4_s   <= CpSv_DistData_i(31 downto 16);              
                        PrSv_Start3_W50_b4_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0042" =>
                        PrSv_Start3_W50_min5_s <= CpSv_DistData_i(31 downto 16);                 
                        PrSv_Start3_W50_max5_s <= CpSv_DistData_i(15 downto  0);                 
                    when x"0043" =>                                                 
                        PrSv_Start3_W50_a5_s   <= CpSv_DistData_i(31 downto 16);                
                        PrSv_Start3_W50_b5_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"0044" =>                                                 
                        PrSv_Start3_W90_min1_s <= CpSv_DistData_i(31 downto 16);                  
                        PrSv_Start3_W90_max1_s <= CpSv_DistData_i(15 downto  0);                  
                    when x"0045" =>                                                 
                        PrSv_Start3_W90_a1_s   <= CpSv_DistData_i(31 downto 16);                  
                        PrSv_Start3_W90_b1_s   <= CpSv_DistData_i(15 downto  0);    
                    when x"0046" =>                                                 
                        PrSv_Start3_W90_min2_s <= CpSv_DistData_i(31 downto 16);                    
                        PrSv_Start3_W90_max2_s <= CpSv_DistData_i(15 downto  0);                    
                    when x"0047" =>                                             
                        PrSv_Start3_W90_a2_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start3_W90_b2_s   <= CpSv_DistData_i(15 downto  0);
                    when x"0048" =>                               
                        PrSv_Start3_W90_min3_s <= CpSv_DistData_i(31 downto 16);                                         
                        PrSv_Start3_W90_max3_s <= CpSv_DistData_i(15 downto  0);                                         
                    when x"0049" =>                                                             
                        PrSv_Start3_W90_a3_s   <= CpSv_DistData_i(31 downto 16);                                        
                        PrSv_Start3_W90_b3_s   <= CpSv_DistData_i(15 downto  0);                                        
                    when x"004A" =>                               
                        PrSv_Start3_W90_min4_s <= CpSv_DistData_i(31 downto 16);                                            
                        PrSv_Start3_W90_max4_s <= CpSv_DistData_i(15 downto  0);                                         
                    when x"004B" =>                                                             
                        PrSv_Start3_W90_a4_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start3_W90_b4_s   <= CpSv_DistData_i(15 downto  0);
                    when x"004C" =>
                        PrSv_Start3_W90_min5_s <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start3_W90_max5_s <= CpSv_DistData_i(15 downto  0);
                    when x"004D" =>                                             
                        PrSv_Start3_W90_a5_s   <= CpSv_DistData_i(31 downto 16);
                        PrSv_Start3_W90_b5_s   <= CpSv_DistData_i(15 downto  0);    
                             
                    when others => 
                        PrSv_Start3_W20_min1_s <= PrSv_Start3_W20_min1_s;
                        PrSv_Start3_W20_max1_s <= PrSv_Start3_W20_max1_s;
                        PrSv_Start3_W20_a1_s   <= PrSv_Start3_W20_a1_s  ;
                        PrSv_Start3_W20_b1_s   <= PrSv_Start3_W20_b1_s  ;
                        PrSv_Start3_W20_min2_s <= PrSv_Start3_W20_min2_s;
                        PrSv_Start3_W20_max2_s <= PrSv_Start3_W20_max2_s;
                        PrSv_Start3_W20_a2_s   <= PrSv_Start3_W20_a2_s  ;
                        PrSv_Start3_W20_b2_s   <= PrSv_Start3_W20_b2_s  ;
                        PrSv_Start3_W20_min3_s <= PrSv_Start3_W20_min3_s;
                        PrSv_Start3_W20_max3_s <= PrSv_Start3_W20_max3_s;
                        PrSv_Start3_W20_a3_s   <= PrSv_Start3_W20_a3_s  ;
                        PrSv_Start3_W20_b3_s   <= PrSv_Start3_W20_b3_s  ;
                        PrSv_Start3_W50_min1_s <= PrSv_Start3_W50_min1_s;
                        PrSv_Start3_W50_max1_s <= PrSv_Start3_W50_max1_s;
                        PrSv_Start3_W50_a1_s   <= PrSv_Start3_W50_a1_s  ;
                        PrSv_Start3_W50_b1_s   <= PrSv_Start3_W50_b1_s  ;
                        PrSv_Start3_W50_min2_s <= PrSv_Start3_W50_min2_s;
                        PrSv_Start3_W50_max2_s <= PrSv_Start3_W50_max2_s;
                        PrSv_Start3_W50_a2_s   <= PrSv_Start3_W50_a2_s  ;
                        PrSv_Start3_W50_b2_s   <= PrSv_Start3_W50_b2_s  ;
                        PrSv_Start3_W50_min3_s <= PrSv_Start3_W50_min3_s;
                        PrSv_Start3_W50_max3_s <= PrSv_Start3_W50_max3_s;
                        PrSv_Start3_W50_a3_s   <= PrSv_Start3_W50_a3_s  ;
                        PrSv_Start3_W50_b3_s   <= PrSv_Start3_W50_b3_s  ;
                        PrSv_Start3_W50_min4_s <= PrSv_Start3_W50_min4_s;
                        PrSv_Start3_W50_max4_s <= PrSv_Start3_W50_max4_s;
                        PrSv_Start3_W50_a4_s   <= PrSv_Start3_W50_a4_s  ;
                        PrSv_Start3_W50_b4_s   <= PrSv_Start3_W50_b4_s  ;
                        PrSv_Start3_W50_min5_s <= PrSv_Start3_W50_min5_s;
                        PrSv_Start3_W50_max5_s <= PrSv_Start3_W50_max5_s;
                        PrSv_Start3_W50_a5_s   <= PrSv_Start3_W50_a5_s  ;
                        PrSv_Start3_W50_b5_s   <= PrSv_Start3_W50_b5_s  ;
                        PrSv_Start3_W90_min1_s <= PrSv_Start3_W90_min1_s;
                        PrSv_Start3_W90_max1_s <= PrSv_Start3_W90_max1_s;
                        PrSv_Start3_W90_a1_s   <= PrSv_Start3_W90_a1_s  ;
                        PrSv_Start3_W90_b1_s   <= PrSv_Start3_W90_b1_s  ;
                        PrSv_Start3_W90_min2_s <= PrSv_Start3_W90_min2_s;
                        PrSv_Start3_W90_max2_s <= PrSv_Start3_W90_max2_s;
                        PrSv_Start3_W90_a2_s   <= PrSv_Start3_W90_a2_s  ;
                        PrSv_Start3_W90_b2_s   <= PrSv_Start3_W90_b2_s  ;
                        PrSv_Start3_W90_min3_s <= PrSv_Start3_W90_min3_s;
                        PrSv_Start3_W90_max3_s <= PrSv_Start3_W90_max3_s;
                        PrSv_Start3_W90_a3_s   <= PrSv_Start3_W90_a3_s  ;
                        PrSv_Start3_W90_b3_s   <= PrSv_Start3_W90_b3_s  ;
                        PrSv_Start3_W90_min4_s <= PrSv_Start3_W90_min4_s;
                        PrSv_Start3_W90_max4_s <= PrSv_Start3_W90_max4_s;
                        PrSv_Start3_W90_a4_s   <= PrSv_Start3_W90_a4_s  ;
                        PrSv_Start3_W90_b4_s   <= PrSv_Start3_W90_b4_s  ;
                        PrSv_Start3_W90_min5_s <= PrSv_Start3_W90_min5_s;
                        PrSv_Start3_W90_max5_s <= PrSv_Start3_W90_max5_s;
                        PrSv_Start3_W90_a5_s   <= PrSv_Start3_W90_a5_s  ;
                        PrSv_Start3_W90_b5_s   <= PrSv_Start3_W90_b5_s  ;
                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    
    ----------------------------------------------------------------------------
    -- OutPut
    ----------------------------------------------------------------------------
    CpSv_Start1_W20_min1_o  <= PrSv_Start1_W20_min1_s;
    CpSv_Start1_W20_max1_o  <= PrSv_Start1_W20_max1_s;                                             
    CpSv_Start1_W20_a1_o    <= PrSv_Start1_W20_a1_s  ;                                             
    CpSv_Start1_W20_b1_o    <= PrSv_Start1_W20_b1_s  ;                                             
    CpSv_Start1_W20_min2_o  <= PrSv_Start1_W20_min2_s;                                             
    CpSv_Start1_W20_max2_o  <= PrSv_Start1_W20_max2_s;                                             
    CpSv_Start1_W20_a2_o    <= PrSv_Start1_W20_a2_s  ;                                             
    CpSv_Start1_W20_b2_o    <= PrSv_Start1_W20_b2_s  ;                                             
    CpSv_Start1_W20_min3_o  <= PrSv_Start1_W20_min3_s;                                             
    CpSv_Start1_W20_max3_o  <= PrSv_Start1_W20_max3_s;                                             
    CpSv_Start1_W20_a3_o    <= PrSv_Start1_W20_a3_s  ;                                             
    CpSv_Start1_W20_b3_o    <= PrSv_Start1_W20_b3_s  ;                                             
    CpSv_Start1_W50_min1_o  <= PrSv_Start1_W50_min1_s;                                             
    CpSv_Start1_W50_max1_o  <= PrSv_Start1_W50_max1_s;                                             
    CpSv_Start1_W50_a1_o    <= PrSv_Start1_W50_a1_s  ;                                             
    CpSv_Start1_W50_b1_o    <= PrSv_Start1_W50_b1_s  ;                                             
    CpSv_Start1_W50_min2_o  <= PrSv_Start1_W50_min2_s;                                             
    CpSv_Start1_W50_max2_o  <= PrSv_Start1_W50_max2_s;                                             
    CpSv_Start1_W50_a2_o    <= PrSv_Start1_W50_a2_s  ;                                             
    CpSv_Start1_W50_b2_o    <= PrSv_Start1_W50_b2_s  ;                                             
    CpSv_Start1_W50_min3_o  <= PrSv_Start1_W50_min3_s;                                             
    CpSv_Start1_W50_max3_o  <= PrSv_Start1_W50_max3_s;                                             
    CpSv_Start1_W50_a3_o    <= PrSv_Start1_W50_a3_s  ;                                             
    CpSv_Start1_W50_b3_o    <= PrSv_Start1_W50_b3_s  ;                                             
    CpSv_Start1_W50_min4_o  <= PrSv_Start1_W50_min4_s;                                             
    CpSv_Start1_W50_max4_o  <= PrSv_Start1_W50_max4_s;                                             
    CpSv_Start1_W50_a4_o    <= PrSv_Start1_W50_a4_s  ;                                             
    CpSv_Start1_W50_b4_o    <= PrSv_Start1_W50_b4_s  ;                                             
    CpSv_Start1_W50_min5_o  <= PrSv_Start1_W50_min5_s;                                             
    CpSv_Start1_W50_max5_o  <= PrSv_Start1_W50_max5_s;                                             
    CpSv_Start1_W50_a5_o    <= PrSv_Start1_W50_a5_s  ;                                             
    CpSv_Start1_W50_b5_o    <= PrSv_Start1_W50_b5_s  ;                                             
    CpSv_Start1_W90_min1_o  <= PrSv_Start1_W90_min1_s;                                             
    CpSv_Start1_W90_max1_o  <= PrSv_Start1_W90_max1_s;                                             
    CpSv_Start1_W90_a1_o    <= PrSv_Start1_W90_a1_s  ;                                             
    CpSv_Start1_W90_b1_o    <= PrSv_Start1_W90_b1_s  ;                                             
    CpSv_Start1_W90_min2_o  <= PrSv_Start1_W90_min2_s;                                             
    CpSv_Start1_W90_max2_o  <= PrSv_Start1_W90_max2_s;                                             
    CpSv_Start1_W90_a2_o    <= PrSv_Start1_W90_a2_s  ;                                             
    CpSv_Start1_W90_b2_o    <= PrSv_Start1_W90_b2_s  ;                                             
    CpSv_Start1_W90_min3_o  <= PrSv_Start1_W90_min3_s;                                             
    CpSv_Start1_W90_max3_o  <= PrSv_Start1_W90_max3_s;                                             
    CpSv_Start1_W90_a3_o    <= PrSv_Start1_W90_a3_s  ;                                             
    CpSv_Start1_W90_b3_o    <= PrSv_Start1_W90_b3_s  ;                                             
    CpSv_Start1_W90_min4_o  <= PrSv_Start1_W90_min4_s;                                             
    CpSv_Start1_W90_max4_o  <= PrSv_Start1_W90_max4_s;                                             
    CpSv_Start1_W90_a4_o    <= PrSv_Start1_W90_a4_s  ;                                             
    CpSv_Start1_W90_b4_o    <= PrSv_Start1_W90_b4_s  ;                                             
    CpSv_Start1_W90_min5_o  <= PrSv_Start1_W90_min5_s;                                             
    CpSv_Start1_W90_max5_o  <= PrSv_Start1_W90_max5_s;                                             
    CpSv_Start1_W90_a5_o    <= PrSv_Start1_W90_a5_s  ;                                             
    CpSv_Start1_W90_b5_o    <= PrSv_Start1_W90_b5_s  ;                                             

    -- Start2
    CpSv_Start2_W20_min1_o  <= PrSv_Start2_W20_min1_s;                                            
    CpSv_Start2_W20_max1_o  <= PrSv_Start2_W20_max1_s;                                            
    CpSv_Start2_W20_a1_o    <= PrSv_Start2_W20_a1_s  ;                                            
    CpSv_Start2_W20_b1_o    <= PrSv_Start2_W20_b1_s  ;                                            
    CpSv_Start2_W20_min2_o  <= PrSv_Start2_W20_min2_s;                                            
    CpSv_Start2_W20_max2_o  <= PrSv_Start2_W20_max2_s;                                            
    CpSv_Start2_W20_a2_o    <= PrSv_Start2_W20_a2_s  ;                                            
    CpSv_Start2_W20_b2_o    <= PrSv_Start2_W20_b2_s  ;                                            
    CpSv_Start2_W20_min3_o  <= PrSv_Start2_W20_min3_s;                                            
    CpSv_Start2_W20_max3_o  <= PrSv_Start2_W20_max3_s;                                            
    CpSv_Start2_W20_a3_o    <= PrSv_Start2_W20_a3_s  ;                                            
    CpSv_Start2_W20_b3_o    <= PrSv_Start2_W20_b3_s  ;                                            
    CpSv_Start2_W50_min1_o  <= PrSv_Start2_W50_min1_s;                                            
    CpSv_Start2_W50_max1_o  <= PrSv_Start2_W50_max1_s;                                            
    CpSv_Start2_W50_a1_o    <= PrSv_Start2_W50_a1_s  ;                                            
    CpSv_Start2_W50_b1_o    <= PrSv_Start2_W50_b1_s  ;                                            
    CpSv_Start2_W50_min2_o  <= PrSv_Start2_W50_min2_s;                                            
    CpSv_Start2_W50_max2_o  <= PrSv_Start2_W50_max2_s;                                            
    CpSv_Start2_W50_a2_o    <= PrSv_Start2_W50_a2_s  ;                                            
    CpSv_Start2_W50_b2_o    <= PrSv_Start2_W50_b2_s  ;                                            
    CpSv_Start2_W50_min3_o  <= PrSv_Start2_W50_min3_s;                                            
    CpSv_Start2_W50_max3_o  <= PrSv_Start2_W50_max3_s;                                            
    CpSv_Start2_W50_a3_o    <= PrSv_Start2_W50_a3_s  ;                                            
    CpSv_Start2_W50_b3_o    <= PrSv_Start2_W50_b3_s  ;                                            
    CpSv_Start2_W50_min4_o  <= PrSv_Start2_W50_min4_s;                                            
    CpSv_Start2_W50_max4_o  <= PrSv_Start2_W50_max4_s;                                            
    CpSv_Start2_W50_a4_o    <= PrSv_Start2_W50_a4_s  ;                                            
    CpSv_Start2_W50_b4_o    <= PrSv_Start2_W50_b4_s  ;                                            
    CpSv_Start2_W50_min5_o  <= PrSv_Start2_W50_min5_s;                                            
    CpSv_Start2_W50_max5_o  <= PrSv_Start2_W50_max5_s;                                            
    CpSv_Start2_W50_a5_o    <= PrSv_Start2_W50_a5_s  ;                                            
    CpSv_Start2_W50_b5_o    <= PrSv_Start2_W50_b5_s  ;                                            
    CpSv_Start2_W90_min1_o  <= PrSv_Start2_W90_min1_s;                                            
    CpSv_Start2_W90_max1_o  <= PrSv_Start2_W90_max1_s;                                            
    CpSv_Start2_W90_a1_o    <= PrSv_Start2_W90_a1_s  ;                                            
    CpSv_Start2_W90_b1_o    <= PrSv_Start2_W90_b1_s  ;                                            
    CpSv_Start2_W90_min2_o  <= PrSv_Start2_W90_min2_s;                                            
    CpSv_Start2_W90_max2_o  <= PrSv_Start2_W90_max2_s;                                            
    CpSv_Start2_W90_a2_o    <= PrSv_Start2_W90_a2_s  ;                                            
    CpSv_Start2_W90_b2_o    <= PrSv_Start2_W90_b2_s  ;                                            
    CpSv_Start2_W90_min3_o  <= PrSv_Start2_W90_min3_s;                                            
    CpSv_Start2_W90_max3_o  <= PrSv_Start2_W90_max3_s;                                            
    CpSv_Start2_W90_a3_o    <= PrSv_Start2_W90_a3_s  ;                                            
    CpSv_Start2_W90_b3_o    <= PrSv_Start2_W90_b3_s  ;                                            
    CpSv_Start2_W90_min4_o  <= PrSv_Start2_W90_min4_s;                                            
    CpSv_Start2_W90_max4_o  <= PrSv_Start2_W90_max4_s;                                            
    CpSv_Start2_W90_a4_o    <= PrSv_Start2_W90_a4_s  ;                                            
    CpSv_Start2_W90_b4_o    <= PrSv_Start2_W90_b4_s  ;                                            
    CpSv_Start2_W90_min5_o  <= PrSv_Start2_W90_min5_s;                                            
    CpSv_Start2_W90_max5_o  <= PrSv_Start2_W90_max5_s;                                            
    CpSv_Start2_W90_a5_o    <= PrSv_Start2_W90_a5_s  ;                                            
    CpSv_Start2_W90_b5_o    <= PrSv_Start2_W90_b5_s  ;                                            
    
    -- Start3
    CpSv_Start3_W20_min1_o  <= PrSv_Start3_W20_min1_s;                                          
    CpSv_Start3_W20_max1_o  <= PrSv_Start3_W20_max1_s;                                          
    CpSv_Start3_W20_a1_o    <= PrSv_Start3_W20_a1_s  ;                                          
    CpSv_Start3_W20_b1_o    <= PrSv_Start3_W20_b1_s  ;                                          
    CpSv_Start3_W20_min2_o  <= PrSv_Start3_W20_min2_s;                                          
    CpSv_Start3_W20_max2_o  <= PrSv_Start3_W20_max2_s;                                          
    CpSv_Start3_W20_a2_o    <= PrSv_Start3_W20_a2_s  ;                                          
    CpSv_Start3_W20_b2_o    <= PrSv_Start3_W20_b2_s  ;                                          
    CpSv_Start3_W20_min3_o  <= PrSv_Start3_W20_min3_s;                                          
    CpSv_Start3_W20_max3_o  <= PrSv_Start3_W20_max3_s;                                          
    CpSv_Start3_W20_a3_o    <= PrSv_Start3_W20_a3_s  ;                                          
    CpSv_Start3_W20_b3_o    <= PrSv_Start3_W20_b3_s  ;                                          
    CpSv_Start3_W50_min1_o  <= PrSv_Start3_W50_min1_s;                                          
    CpSv_Start3_W50_max1_o  <= PrSv_Start3_W50_max1_s;                                          
    CpSv_Start3_W50_a1_o    <= PrSv_Start3_W50_a1_s  ;                                          
    CpSv_Start3_W50_b1_o    <= PrSv_Start3_W50_b1_s  ;                                          
    CpSv_Start3_W50_min2_o  <= PrSv_Start3_W50_min2_s;                                          
    CpSv_Start3_W50_max2_o  <= PrSv_Start3_W50_max2_s;                                          
    CpSv_Start3_W50_a2_o    <= PrSv_Start3_W50_a2_s  ;                                          
    CpSv_Start3_W50_b2_o    <= PrSv_Start3_W50_b2_s  ;                                          
    CpSv_Start3_W50_min3_o  <= PrSv_Start3_W50_min3_s;                                          
    CpSv_Start3_W50_max3_o  <= PrSv_Start3_W50_max3_s;                                          
    CpSv_Start3_W50_a3_o    <= PrSv_Start3_W50_a3_s  ;                                          
    CpSv_Start3_W50_b3_o    <= PrSv_Start3_W50_b3_s  ;                                          
    CpSv_Start3_W50_min4_o  <= PrSv_Start3_W50_min4_s;                                          
    CpSv_Start3_W50_max4_o  <= PrSv_Start3_W50_max4_s;                                          
    CpSv_Start3_W50_a4_o    <= PrSv_Start3_W50_a4_s  ;                                          
    CpSv_Start3_W50_b4_o    <= PrSv_Start3_W50_b4_s  ;                                          
    CpSv_Start3_W50_min5_o  <= PrSv_Start3_W50_min5_s;                                          
    CpSv_Start3_W50_max5_o  <= PrSv_Start3_W50_max5_s;                                          
    CpSv_Start3_W50_a5_o    <= PrSv_Start3_W50_a5_s  ;                                          
    CpSv_Start3_W50_b5_o    <= PrSv_Start3_W50_b5_s  ;                                          
    CpSv_Start3_W90_min1_o  <= PrSv_Start3_W90_min1_s;                                          
    CpSv_Start3_W90_max1_o  <= PrSv_Start3_W90_max1_s;                                          
    CpSv_Start3_W90_a1_o    <= PrSv_Start3_W90_a1_s  ;                                          
    CpSv_Start3_W90_b1_o    <= PrSv_Start3_W90_b1_s  ;                                          
    CpSv_Start3_W90_min2_o  <= PrSv_Start3_W90_min2_s;                                          
    CpSv_Start3_W90_max2_o  <= PrSv_Start3_W90_max2_s;                                          
    CpSv_Start3_W90_a2_o    <= PrSv_Start3_W90_a2_s  ;                                          
    CpSv_Start3_W90_b2_o    <= PrSv_Start3_W90_b2_s  ;                                          
    CpSv_Start3_W90_min3_o  <= PrSv_Start3_W90_min3_s;                                          
    CpSv_Start3_W90_max3_o  <= PrSv_Start3_W90_max3_s;                                          
    CpSv_Start3_W90_a3_o    <= PrSv_Start3_W90_a3_s  ;                                          
    CpSv_Start3_W90_b3_o    <= PrSv_Start3_W90_b3_s  ;                                          
    CpSv_Start3_W90_min4_o  <= PrSv_Start3_W90_min4_s;                                          
    CpSv_Start3_W90_max4_o  <= PrSv_Start3_W90_max4_s;                                          
    CpSv_Start3_W90_a4_o    <= PrSv_Start3_W90_a4_s  ;                                          
    CpSv_Start3_W90_b4_o    <= PrSv_Start3_W90_b4_s  ;                                          
    CpSv_Start3_W90_min5_o  <= PrSv_Start3_W90_min5_s;                                          
    CpSv_Start3_W90_max5_o  <= PrSv_Start3_W90_max5_s;                                          
    CpSv_Start3_W90_a5_o    <= PrSv_Start3_W90_a5_s  ;                                          
    CpSv_Start3_W90_b5_o    <= PrSv_Start3_W90_b5_s  ;                                          

    ----------------------------------------------------------------------------
    -- End_Coding
    ----------------------------------------------------------------------------
end arch_M_DistConst;