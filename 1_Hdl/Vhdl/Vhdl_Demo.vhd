--------------------------------------------------------------------------------
--        *****************          *****************
--                        **        **
--            ***          **      **           **
--           *   *          **    **           * *
--          *     *          **  **              *
--          *     *           ****               *
--          *     *          **  **              *
--           *   *          **    **             *
--            ***          **      **          *****
--                        **        **
--        *****************          *****************
--------------------------------------------------------------------------------
--Com     :  BiXing Tech
--Text    :  Vhdl_Demo.vhd
--Per     :  zhang wenjun
--E-mail  :  wenjunzhang@bixing-tech.com
--Data    :  2016/09/27
--Cust    :  Vhdl use demo
--Int     :  0.1
--IntTime :  1. Initial, zhang wenjun, 2016/09/27
--------------------------------------------------------------------------------
-- use ieee library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- xilinx lilbrary
library unisim;
use unisim.vcomponents.all;

entity Vhdl_Demo is
    generic (
        Simulation                      : integer := 1;                         -- simulation
        Use_ChipScope                   : integer := 1;                         -- ChipScope
        CfgDeviceId                     : std_logic_vector(15 downto 0) := x"000A" -- Device ID
    );
    port (
        --------------------------------
        -- Reset and Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- reset active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock signal 100M
        CpSl_Clk_iP                     : in  std_logic;                        -- CLock Diff_P 200M
        CpSl_Clk_iN                     : in  std_logic;                        -- Clock Diff_N 200M

        --------------------------------
        -- uart
        --------------------------------
        CpSl_RxData_i                   : in  std_logic;                        -- RxData from PC
        CpSl_TxData_o                   : out std_logic                         -- TxData to PC
    );

architecture arch_Vhdl_Demo of Vhdl_Demo is
    ------------------------------------
    -- constant describe
    ------------------------------------
    constant PrSl_Cnt_c                 : std_logic_vector(19 downto 0) := x"AABBC";

    ------------------------------------
    -- component describe
    ------------------------------------
    -- ChipScope
    component M_icon port (
        control0                    : inout std_logic_vector(35 downto 0);      -- control0
        control1                    : inout std_logic_vector(35 downto 0);      -- control1
    );
    end component;

    component M_ila port (
        control                     : inout std_logic_vector(35 downto 0);      -- control
        clk                         : in    std_logic;                          -- clock
        Trig0                       : in    std_logic_vector(39 downto 0)       -- Trig
    );
    end component;

    -- Pll
    component M_ClkPll port (
        -- Clock in ports
        CLK_IN1                         : in  std_logic;
        -- Clock out ports
        CLK_OUT1                        : out std_logic;
        CLK_OUT2                        : out std_logic;
        -- Status and control signals
        RESET                           : in  std_logic;
        LOCKED                          : out std_logic
    );
    end component;

    ------------------------------------
    -- signal describe
    ------------------------------------
    -- ChipScope
    signal PrSv_ChipCtrl0               : std_logic_vector(35 downto 0);        -- ChipScope Ctrl0
    signal PrSv_ChipTrig0               : std_logic_vector(39 downto 0);        -- ChipScope Trig0
    signal PrSl_ChipClk0                : std_logic;                            -- ChipScope Clk0
    signal PrSv_ChipCtrl1               : std_logic_vector(35 downto 0);        -- ChipScope Ctrl1
    signal PrSv_ChipTrig1               : std_logic_vector(39 downto 0);        -- ChipScope Trig1
    signal PrSl_ChipClk1                : std_logic;                            -- ChipScope Clk1

    --ClkPll
    signal PrSl_Clk100M_s               : std_logic;                            -- Clk_100M
    signal PrSl_Clk150M_s               : std_logic;                            -- Clk_150M
    signal PrSl_PllLocked_s             : std_logic;                            -- PllLocked
    signal PrSl_PllRst_s                : std_logic;                            -- PllRst active high

    -- Cnt
    signal PrSv_ClkCnt_s                : std_logic_vector(19 downto 0);        -- ClkCnt
    signal PrSv_Cnt_s                   : std_logic_vector(19 downto 0);        -- Cnt



begin
    ------------------------------------
    -- constant describe
    ------------------------------------
    -- ChipScope
    Use_ChipScope : if (Use_ChipScope = 1) generate
    U_M_icon_0 : M_icon
    port map (
        control0                        => PrSv_ChipCtrl0                       , -- ChipScope Ctrl0
        control1                        => PrSv_ChipCtrl1                         -- ChipScope Ctrl1
    );                                                                          
                                                                                
    U_M_ila_0 : M_ila                                                           
    port map (                                                                  
        control                         => PrSv_ChipCtrl0                       , -- ChipCtrl0
        clk                             => PrSl_ChipClk0                        , -- ChipClk0
        Trig0                           => PrSv_ChipTrig0                         -- ChipTrig0
    );
    PrSl_ChipClk0 <= PrSl_Clk100M_s;
    PrSv_ChipTrig0(19 downto  0) <= PrSv_ClkCnt_s;
    PrSv_ChipTrig0(39 downto 20) <= (others => '0');





    U_M_ila_1 : M_ila
    port map (
        control                         => PrSv_ChipCtrl1                       , -- ChipCtrl1
        clk                             => PrSl_ChipClk1                        , -- ChipClk1
        Trig0                           => PrSv_ChipTrig1                         -- ChipTrig1
    );
    PrSl_ChipClk1 <= PrSl_Clk150M_s;
    PrSv_ChipTrig1(19 downto  0) <= PrSv_Cnt_s;
    PrSv_ChipTrig1(39 downto 20) <=(others => '0');
        
    end generate Use_ChipScope;

    -- ClkPll
    U_M_ClkPll_0 : M_ClkPll 
    port map (
        -- Clock in ports
        CLK_IN1                         => CpSl_Clk_i                           , -- Clk100M 
        -- Clock out ports                                                        
        CLK_OUT1                        => PrSl_Clk100M_s                       , -- Clk100M
        CLK_OUT2                        => PrSl_Clk150M_s                       , -- Clk150M
        -- Status and control signals                                          
        RESET                           => PrSl_PllRst_s                        , -- PllRst
        LOCKED                          => PrSl_PllLocked_s                       -- PllLocked
    );
    PrSl_PllRst_s <= not CpSl_Rst_iN;


    ------------------------------------
    -- main describe
    ------------------------------------
    process (PrSl_PllLocked_s,PrSl_Clk100M_s) begin
        if (PrSl_PllLocked_s = '0') then 
            PrSv_ClkCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Clk100M_s) then 
            if (PrSv_ClkCnt_s = PrSl_Cnt_c) then 
                PrSv_ClkCnt_s <= (others => '0');
            else 
                PrSv_ClkCnt_s <= PrSv_ClkCnt_s + '1';
            end if;
        end if;
    end process;
    
    
    process (PrSl_PllLocked_s,PrSl_Clk150M_s) begin
        if (PrSl_PllLocked_s = '0') then 
            PrSv_Cnt_s <= (others => '0');
        elsif rising_edge (PrSl_Clk150M_s) then 
            if (PrSv_Cnt_s = PrSl_Cnt_c) then 
                PrSv_Cnt_s <= (others => '0');
            else
                PrSv_Cnt_s <= PrSv_Cnt_s + '1';
            end if;
        end if;
    end process;
    
end arch_Vhdl_Demo;