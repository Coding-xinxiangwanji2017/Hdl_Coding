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
-- 文件名称  :  M_CompWave.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/12/14
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/12/14
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_CompWave is 
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
end M_CompWave;

architecture arch_M_CompWave of M_CompWave is 
    ----------------------------------------------------------------------------
    -- constant_describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- component_describe
    ----------------------------------------------------------------------------
    component M_CompData is
    port (
        CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
    	CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
    	
    	--------------------------------
    	-- Compare_Data_InPut
    	--------------------------------
    	CpSv_Comp1Num_i                 : in  std_logic_vector( 1 downto 0);    -- Compare_EchoData 
    	CpSv_Comp2Num_i                 : in  std_logic_vector( 1 downto 0);    -- Compare_EchoData 
    	CpSv_Comp3Num_i                 : in  std_logic_vector( 1 downto 0);    -- Compare_EchoData 
    	
    	--------------------------------
    	-- Check_Data_InPut
    	--------------------------------
    	CpSl_Echo1DVld_i                : in  std_logic;                        -- Echo1_DataValid
    	CpSv_Echo1Wave_i                : in  std_logic_vector(18 downto 0);    -- Echo1_Wave
    	CpSv_Echo1Gray_i                : in  std_logic_vector(15 downto 0);    -- Echo1_Gray
    	CpSv_Echo2Wave_i                : in  std_logic_vector(18 downto 0);    -- Echo2_Wave
    	CpSv_Echo2Gray_i                : in  std_logic_vector(15 downto 0);    -- Echo2_Gray
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
        
    ----------------------------------------------------------------------------
    -- signal_describe
    ----------------------------------------------------------------------------
    signal PrSl_CompNum1_s              : std_logic_vector(1 downto 0);         -- CompareNum1
    signal PrSl_CompNum2_s              : std_logic_vector(1 downto 0);         -- CompareNum2
    signal PrSl_CompNum3_s              : std_logic_vector(1 downto 0);         -- CompareNum3
    
--------------------------------------------------------------------------------
-- Begin_Coding
--------------------------------------------------------------------------------
begin
    ----------------------------------------------------------------------------
    -- component_map
    ----------------------------------------------------------------------------
    U_M_CompData_0 : M_CompData
    port map (
        CpSl_Rst_i						=> CpSl_Rst_i                           , -- in  std_logic;						-- Reset,Active_low
    	CpSl_Clk_i						=> CpSl_Clk_i                           , -- in  std_logic;						-- Clock,Single_40Mhz
    	                                                                        
    	--------------------------------                                        
    	-- Compare_Data_InPut                                                   
    	--------------------------------    
    	CpSv_Comp1Num_i                 => PrSl_CompNum1_s                      , -- in  std_logic_vector( 1 downto 0);    -- Compare_EchoData 
    	CpSv_Comp2Num_i                 => PrSl_CompNum2_s                      , -- in  std_logic_vector( 1 downto 0);    -- Compare_EchoData 
    	CpSv_Comp3Num_i                 => PrSl_CompNum3_s                      , -- in  std_logic_vector( 1 downto 0);    -- Compare_EchoData 
    	                                                                         
    	--------------------------------                                         
    	-- Check_Data_InPut
    	--------------------------------
    	CpSl_Echo1DVld_i                => CpSl_Echo1DVld_i                     , -- in  std_logic;                        -- Echo1_DataValid
    	CpSv_Echo1Wave_i                => CpSv_Echo1Wave_i                     , -- in  std_logic_vector(18 downto 0);    -- Echo1_Wave
    	CpSv_Echo1Gray_i                => CpSv_Echo1Gray_i                     , -- in  std_logic_vector(15 downto 0)     -- Echo1_Gray
    	CpSv_Echo2Wave_i                => CpSv_Echo2Wave_i                     , -- in  std_logic_vector(18 downto 0);    -- Echo2_Wave
    	CpSv_Echo2Gray_i                => CpSv_Echo2Gray_i                     , -- in  std_logic_vector(15 downto 0)     -- Echo2_Gray
    	CpSv_Echo3Wave_i                => CpSv_Echo3Wave_i                     , -- in  std_logic_vector(18 downto 0);    -- Echo3_Wave
    	CpSv_Echo3Gray_i                => CpSv_Echo3Gray_i                     , -- in  std_logic_vector(15 downto 0)     -- Echo3_Gray
                                                                                 
    	--------------------------------                                         
    	-- Check_Data_OutPut                                                     
    	--------------------------------                                         
    	CpSl_CheckDVld_o                => CpSl_CheckDVld_o                     , -- out std_logic;                        -- Check_DataValid
    	CpSv_CheckWave_o                => CpSv_CheckWave_o                     , -- out std_logic_vector(18 downto 0);    -- Check
    	CpSv_CheckGray_o                => CpSv_CheckGray_o                       -- out std_logic_vector(15 downto 0)     -- Check_Gray
    );

    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    PrSl_CompNum1_s(1) <= '1' when (CpSv_Comp1Data_i > CpSv_Comp3Data_i) else '0';
    PrSl_CompNum1_s(0) <= '1' when (CpSv_Comp1Data_i > CpSv_Comp2Data_i) else '0';
    
    PrSl_CompNum2_s(1) <= '1' when (CpSv_Comp2Data_i > CpSv_Comp3Data_i) else '0';
    PrSl_CompNum2_s(0) <= '1' when (CpSv_Comp2Data_i > CpSv_Comp1Data_i) else '0';
    
    PrSl_CompNum3_s(1) <= '1' when (CpSv_Comp3Data_i > CpSv_Comp2Data_i) else '0';
    PrSl_CompNum3_s(0) <= '1' when (CpSv_Comp3Data_i > CpSv_Comp1Data_i) else '0';
    
--------------------------------------------------------------------------------
-- End_Coding
--------------------------------------------------------------------------------
end arch_M_CompWave;