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
-- 文件名称  :  M_TdcDistance.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  Send Data to PC;  Unit : m;
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_TdcDistance is
	port (
		--------------------------------
    	-- Clk & Reset
    	--------------------------------
    	CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
    	CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
    
    	--------------------------------
    	-- TDC_Distance
    	--------------------------------
    	CpSl_TdcDataVld_i				: in  std_logic;						-- TDC_Recv_Data Valid
    	CpSv_TdcData_i					: in  std_logic_vector(47 downto 0);	-- TDC Recv Data
        
        --------------------------------
    	-- TDC_Distance
    	--------------------------------
    	CpSl_TdcDisVld_o	 			: out std_logic;						-- TDC_Recv_Data Valid
    	CpSv_TdcDisD_o					: out std_logic_vector(47 downto 0) 	-- TDC Recv Data
	);
end M_TdcDistance;

architecture arch_M_TdcDistance of M_TdcDistance is
	----------------------------------------------------------------------------
    -- Constant Describe
    ----------------------------------------------------------------------------
    constant PrSv_DisNum_c              : std_logic_vector(9 downto 0) := "11" & x"E8"; -- 1000
    
    ----------------------------------------------------------------------------
    -- Component Describe
    ----------------------------------------------------------------------------
    component M_TdcDisDivide is
    port (
        denom		                    : IN  STD_LOGIC_VECTOR( 9 DOWNTO 0);
        numer		                    : IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
        quotient                        : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        remain		                    : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0)
    );
    end component;
    
    ----------------------------------------------------------------------------
    -- Signal Describe
    ----------------------------------------------------------------------------
    signal PrSl_TdcDataVldDly1_s        : std_logic;                            -- TDC_Vld_Dly1
    signal PrSl_TdcDataVldDly2_s        : std_logic;                            -- TDC_Vld_Dly2
    signal PrSl_TdcDataVldTrig_s        : std_logic;                            -- TDC_Vld_Trig
    
    signal PrSv_Ench1Data_s             : std_logic_vector(16 downto 0);        -- Ench1Data
    signal PrSv_Ench2Data_s             : std_logic_vector(16 downto 0);        -- Ench2Data
    signal PrSv_Ench3Data_s             : std_logic_vector(16 downto 0);        -- Ench3Data
    signal PrSv_Ench1Quot_s             : std_logic_vector(16 downto 0);        -- Ench1Duot
    signal PrSv_Ench2Quot_s             : std_logic_vector(16 downto 0);        -- Ench2Duot
    signal PrSv_Ench3Quot_s             : std_logic_vector(16 downto 0);        -- Ench3Duot
    signal PrSv_ConvCnt_s               : std_logic_vector( 2 downto 0);        -- Divide Conv Cnt
begin
    ----------------------------------------------------------------------------
    -- Component Map
    ----------------------------------------------------------------------------
    U_M_TdcDisDivide_0 : M_TdcDisDivide
    port map (
        denom		                    => PrSv_DisNum_c                        , -- IN  STD_LOGIC_VECTOR( 9 DOWNTO 0);
        numer		                    => PrSv_Ench1Data_s                     , -- IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
        quotient                        => PrSv_Ench1Quot_s                     , -- OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        remain		                    => open                                   -- OUT STD_LOGIC_VECTOR( 9 DOWNTO 0)
    );
    
    U_M_TdcDisDivide_1 : M_TdcDisDivide
    port map (
        denom		                    => PrSv_DisNum_c                        , -- IN  STD_LOGIC_VECTOR( 9 DOWNTO 0);
        numer		                    => PrSv_Ench2Data_s                     , -- IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
        quotient                        => PrSv_Ench2Quot_s                     , -- OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        remain		                    => open                                   -- OUT STD_LOGIC_VECTOR( 9 DOWNTO 0)
    );   
    
    U_M_TdcDisDivide_2 : M_TdcDisDivide
    port map (
        denom		                    => PrSv_DisNum_c                        , -- IN  STD_LOGIC_VECTOR( 9 DOWNTO 0);
        numer		                    => PrSv_Ench3Data_s                     , -- IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
        quotient                        => PrSv_Ench3Quot_s                     , -- OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        remain		                    => open                                   -- OUT STD_LOGIC_VECTOR( 9 DOWNTO 0)
    );   

	----------------------------------------------------------------------------
	-- Main Area
	----------------------------------------------------------------------------
	-- Delay 2 Clk
    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSl_TdcDataVldDly1_s <= '0';
            PrSl_TdcDataVldDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_TdcDataVldDly1_s <= CpSl_TdcDataVld_i;
            PrSl_TdcDataVldDly2_s <= PrSl_TdcDataVldDly1_s;
        end if;
    end process;
	
	-- PrSl_TdcDataVldTrig_s
    PrSl_TdcDataVldTrig_s  <= '1' when (PrSl_TdcDataVldDly2_s = '0' and PrSl_TdcDataVldDly1_s = '1')
                                else '0';

    -- EnchData
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSv_Ench1Data_s <= (others => '0');
            PrSv_Ench2Data_s <= (others => '0');
            PrSv_Ench3Data_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_TdcDataVldTrig_s = '1') then
                PrSv_Ench1Data_s <= '0' & CpSv_TdcData_i(47 downto 32) + CpSv_TdcData_i(47 downto 33); 
                PrSv_Ench2Data_s <= '0' & CpSv_TdcData_i(31 downto 16) + CpSv_TdcData_i(31 downto 17); 
                PrSv_Ench3Data_s <= '0' & CpSv_TdcData_i(15 downto  0) + CpSv_TdcData_i(15 downto  1); 
            else -- hold
            end if;
        end if; 
    end process;

    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_ConvCnt_s <= (others => '1');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_TdcDataVldTrig_s = '1') then
                PrSv_ConvCnt_s <= (others => '0');
            elsif (PrSv_ConvCnt_s = 4) then
                PrSv_ConvCnt_s <= "111";
            elsif (PrSv_ConvCnt_s = "111") then 
                PrSv_ConvCnt_s <= "111";
            else
                PrSv_ConvCnt_s <= PrSv_ConvCnt_s + '1';
            end if;
        end if;
    end process;
    
    -- CpSl_TdcDisVld_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            CpSl_TdcDisVld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_ConvCnt_s = 3) then
                CpSl_TdcDisVld_o <= '1';
            else
                CpSl_TdcDisVld_o <= '0';
            end if;
        end if;
    end process;

    -- CpSv_TdcDisD_o
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_TdcDisD_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_ConvCnt_s = 3) then
                CpSv_TdcDisD_o <= PrSv_Ench1Quot_s(15 downto 0) & PrSv_Ench2Quot_s(15 downto 0) & PrSv_Ench3Quot_s(15 downto 0);
            else -- hold
            end if;
        end if;
    end process;
    
    
----------------------------------------------------------------------------
-- End Describe
----------------------------------------------------------------------------
end arch_M_TdcDistance;