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
-- 文件名称  :  M_Clock.vhd
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
library altera_mf;
use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------

entity M_Clock is
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
end M_Clock;

architecture arch_M_Clock of M_Clock is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    constant PrSv_5MCnt_c               : std_logic_vector(7 downto 0) := x"27"; -- 40
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    ------------------------------------ 
    -- Clock_Pll
    ------------------------------------
    component M_ClkPll is 
    port (
        areset		                    : IN  STD_LOGIC := '0';
        inclk0		                    : IN  STD_LOGIC := '0';
        c0		                        : OUT STD_LOGIC;
        c1		                        : OUT STD_LOGIC;
        c2                              : OUT STD_LOGIC;
        locked		                    : OUT STD_LOGIC 
    );
    end component;
        
    --component M_TdcClkPll is 
    --port (
    --    areset		                    : IN  STD_LOGIC := '0';
    --    inclk0		                    : IN  STD_LOGIC := '0';
    --    c0		                        : OUT STD_LOGIC;
    --    locked		                    : OUT STD_LOGIC 
    --);
    --end component;    

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSl_Rst_s                   : std_logic;                            -- Reset
    signal PrSl_Clk200M_s               : std_logic;                            -- Clock 200MHz
    signal PrSl_Clk80M_s                : std_logic;                            -- Clock 80MHz
    signal PrSl_PllLock_s               : std_logic;                            -- Pll Locked
    signal PrSv_5MCnt_s                 : std_logic_vector(7 downto 0);         -- 5MHz Cnt
    signal PrSl_TdcPllLock_s            : std_logic;                            -- TDC Pll Locked
    signal PrSl_Locked_s                : std_logic;                            -- PLL Locked
	 
    signal sft_rst_fpga_cnt             : std_logic_vector(15 downto 0);        
	 signal sft_rst_fpga_s               : std_logic;
begin
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    ------------------------------------ 
    -- Clock_Pll
    -- c0 : 80MHz
    -- c1 : 40MHz
    ------------------------------------
    PrSl_Rst_s <= not CpSl_Rst_iN;
    U_M_ClkPll_0 : M_ClkPll  
    port map (
        areset		                    => PrSl_Rst_s,
        inclk0		                    => CpSl_Clk_i,
        c0		                        => PrSl_Clk200M_s,
        c1		                        => PrSl_Clk80M_s,
        c2                              => CpSl_Clk40M_o,
        locked		                    => PrSl_Locked_s
    );

    -- 200MHz
    --U_M_TdcClkPll_0 : M_TdcClkPll
    --port map (
    --    areset		                    => PrSl_Rst_s,                          -- IN  STD_LOGIC := '0';
    --    inclk0		                    => CpSl_Clk_i,                          -- IN  STD_LOGIC := '0';
    --    c0		                        => PrSl_Clk200M_s,                      -- OUT STD_LOGIC;
    --    locked		                    => PrSl_TdcPllLock_s                    -- OUT STD_LOGIC 
    --);
    -- PrSl_PllLock_s
    --PrSl_PllLock_s <= '1' when (PrSl_Locked_s = '1' and PrSl_TdcPllLock_s = '1') else '0';
	 
	 
	 
	 process (PrSl_Locked_s, CpSl_Clk_i) begin
        if (PrSl_Locked_s = '0') then
            sft_rst_fpga_cnt <= x"ffff";
        elsif rising_edge(CpSl_Clk_i) then
	         if(sft_rst_fpga_i = '1') then
                sft_rst_fpga_cnt <= (others => '0');
				elsif(sft_rst_fpga_cnt <= 1000) then
                sft_rst_fpga_cnt <= sft_rst_fpga_cnt + '1';
				else
				    sft_rst_fpga_cnt <= sft_rst_fpga_cnt;
            end if;
        end if;
	 end process;
	 sft_rst_fpga_s <= '1' when (sft_rst_fpga_cnt <= 1000) else '0';
	 
    PrSl_PllLock_s <= '1' when (PrSl_Locked_s = '1' and sft_rst_fpga_s = '0') else '0';
	 
	 
	 
    -- Clock OutPut
    CpSl_Clk80M_o    <= PrSl_Clk80M_s;
    CpSl_Clk200M_o   <= PrSl_Clk200M_s;
    CpSl_ClkLocked_o <= PrSl_PllLock_s;

--    -- Generate 5MHz Clk
--    process (PrSl_PllLock_s,PrSl_Clk200M_s) begin
--        if (PrSl_PllLock_s = '0') then 
--            PrSv_5MCnt_s <= (others => '0');
--        elsif rising_edge(PrSl_Clk200M_s) then
--            if (PrSv_5MCnt_s = PrSv_5MCnt_c) then 
--                PrSv_5MCnt_s <= (others => '0');
--            else
--                PrSv_5MCnt_s <= PrSv_5MCnt_s + '1';
--            end if;
--        end if;
--    end process;
--    
--    process (PrSl_PllLock_s,PrSl_Clk200M_s) begin 
--        if (PrSl_PllLock_s = '0') then
--            CpSl_Clk5M_o <= '0';
--        elsif rising_edge(PrSl_Clk200M_s) then 
--            if (PrSv_5MCnt_s = 4) then
--                CpSl_Clk5M_o <= '1';
--            elsif (PrSv_5MCnt_s = 23) then
--                CpSl_Clk5M_o <= '0';
--            else -- hold 
--            end if;
--        end if;
--    end process;

----------------------------------------
-- End
----------------------------------------
end arch_M_Clock;