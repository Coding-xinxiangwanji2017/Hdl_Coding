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
-- 文件名称  :  M_CompData.vhd
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

entity M_CompData is 
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
end M_CompData;

architecture arch_M_CompData of M_CompData is 
    ----------------------------------------------------------------------------
    -- constant_describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- component_describe
    ----------------------------------------------------------------------------
        
    ----------------------------------------------------------------------------
    -- signal_describe
    ----------------------------------------------------------------------------
    type WaveReg is array (3 downto 0) of std_logic_vector(18 downto 0);
    signal PrSv_CompWave_s : WaveReg;
    
    type GrayReg is array (3 downto 0) of std_logic_vector(15 downto 0);
    signal PrSv_CompGray_s : GrayReg;
    
    signal PrSl_DVldDly1_s              : std_logic;                            -- Delay 1 Clk
    signal PrSl_DVldDly2_s              : std_logic;                            -- Delay 2 Clk
--------------------------------------------------------------------------------
-- Begin_Coding
--------------------------------------------------------------------------------
begin
    ----------------------------------------------------------------------------
    -- component_map
    ----------------------------------------------------------------------------


    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    -- PrSl_DVldDly2_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_DVldDly1_s <= '0';
            PrSl_DVldDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_DVldDly1_s <= CpSl_Echo1DVld_i;
            PrSl_DVldDly2_s <= PrSl_DVldDly1_s;
        end if;
    end process;
    
    -- PrSv_CompWave_s
    process(CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_CompWave_s <= (others => (others => '0'));
        elsif rising_edge(CpSl_Clk_i) then 
            PrSv_CompWave_s(conv_integer(CpSv_Comp1Num_i)) <= CpSv_Echo1Wave_i;
            PrSv_CompWave_s(conv_integer(CpSv_Comp2Num_i)) <= CpSv_Echo2Wave_i;
            PrSv_CompWave_s(conv_integer(CpSv_Comp3Num_i)) <= CpSv_Echo3Wave_i;    
        end if; 
    end process;
    
    -- PrSv_CompGray_s
    process(CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_CompGray_s <= (others => (others => '0'));
        elsif rising_edge(CpSl_Clk_i) then 
            PrSv_CompGray_s(conv_integer(CpSv_Comp1Num_i)) <= CpSv_Echo1Gray_i;
            PrSv_CompGray_s(conv_integer(CpSv_Comp2Num_i)) <= CpSv_Echo2Gray_i;
            PrSv_CompGray_s(conv_integer(CpSv_Comp3Num_i)) <= CpSv_Echo3Gray_i;    
        end if; 
    end process;
    
    
    ------------------------------------
    -- Compare_OutPut
    ------------------------------------
    CpSl_CheckDVld_o <= PrSl_DVldDly2_s;
    CpSv_CheckWave_o <= PrSv_CompWave_s(3);
    CpSv_CheckGray_o <= PrSv_CompGray_s(3);
    

--------------------------------------------------------------------------------
-- End_Coding
--------------------------------------------------------------------------------
end arch_M_CompData;