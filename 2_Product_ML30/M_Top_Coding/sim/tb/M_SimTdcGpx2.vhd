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
-- 文件名称  :  M_W5300Ctrl.vhd
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library unisim;
--use unisim.vcomponents.all;

--library altera_mf;
--use altera_mf.all; 

entity M_SimTdcGpx2 is 
end M_SimTdcGpx2;

architecture arch_M_SimTdcGpx2 of M_SimTdcGpx2 is 
    ----------------------------------------------------------------------------
    -- Constant declaration
    ----------------------------------------------------------------------------
    constant Refresh_Rate               : integer := 150;
    constant Simulation                 : integer := 0;
    constant Use_ChipScope              : integer := 0;
    constant PrSv_Sdo1_c                : std_logic_vector(23 downto 0) := x"EB90A5";

    ----------------------------------------------------------------------------
    -- Component declaration
    ----------------------------------------------------------------------------
    component M_TdcGpx2
    generic (
        PrSl_Sim_c                      : integer := 1                          -- Simulation
    );
    port (
        --------------------------------
        -- Clk & Reset
        --------------------------------
        CpSl_Rst_i                      : in  std_logic;                        -- Reset,Active_low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,Single_40Mhz
        CpSl_Clk200M_i                  : in  std_logic;                        -- Clock,Single 200MHz

        --------------------------------
        -- Start Trig
        --------------------------------
        CpSl_StartTrig_s                : in  std_logic;                        -- Start Trig

        --------------------------------
        -- TDC_GPX2 Interface
        --------------------------------
        -- Clock
        CpSl_RefClkP_o                  : out std_logic;                        -- TDC_GPX2_Clk_o                   
        CpSl_RefClkN_o                  : out std_logic;                        -- TDC_GPX2_Clk_o

        -- SPI_IF
        CpSl_SSN_o                      : out std_logic;                        -- TDC_GPX2_SSN
        CpSl_SClk_o                     : out std_logic;                        -- TDC_GPX2_SCLK
        CpSl_MOSI_o                     : out std_logic;                        -- TDC_GPX2_MOSI
        CpSl_MISO_i                     : in  std_logic;                        -- TDC_GPX2_MISO
        
        -- LVDS
        CpSl_RefClkP_i                  : in  std_logic;                        -- TDC_GPX2_Clk_i
        CpSl_RefClkN_i                  : in  std_logic;                        -- TDC_GPX2_Clk_i
        CpSl_Intertupt_i                : in  std_logic;                        -- TDC_GPX2_Interrupt                       
        CpSl_Frame1_i                   : in  std_logic;                        -- TDC_GPX2_Frame1
        CpSl_Frame2_i                   : in  std_logic;                        -- TDC_GPX2_Frame2
        CpSl_Frame3_i                   : in  std_logic;                        -- TDC_GPX2_Frame3
        CpSl_Frame4_i                   : in  std_logic;                        -- TDC_GPX2_Frame4
        CpSl_Sdo1_i                     : in  std_logic;                        -- TDC_GPX2_SDO1
        CpSl_Sdo2_i                     : in  std_logic;                        -- TDC_GPX2_SDO2
        CpSl_Sdo3_i                     : in  std_logic;                        -- TDC_GPX2_SDO3
        CpSl_Sdo4_i                     : in  std_logic;                        -- TDC_GPX2_SDO4
        CpSl_TdcDataVld_o               : out std_logic;                        -- TDC_Recv_Data Valid
        CpSv_TdcData_o                  : out std_logic_vector(47 downto 0)     -- TDC Recv Data
    );
    end component;
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    --------------------------------
    -- Clk & Reset
    --------------------------------
    signal CpSl_Rst_i                      : std_logic;                         -- Reset,Active_low
    signal CpSl_Clk_i                      : std_logic;                         -- Clock,Single_40Mhz
    signal CpSl_Clk200M_i                  : std_logic;                         -- Clock,Single 200MHzsignal 
    --------------------------------
    -- Start Trig
    --------------------------------
    signal CpSl_StartTrig_s                : std_logic;                         -- Start Trigsignal 
    
    -- Clock
    signal CpSl_RefClkP_o                  : std_logic;                         -- TDC_GPX2_Clk_o                   
    signal CpSl_RefClkN_o                  : std_logic;                         -- TDC_GPX2_Clk_osignal 
    
    -- LVDS     
    signal CpSl_RefClkP_i                  : std_logic;                         -- TDC_GPX2_Clk_i
    signal CpSl_RefClkN_i                  : std_logic;                         -- TDC_GPX2_Clk_i
    signal CpSl_Intertupt_i                : std_logic;                         -- TDC_GPX2_Interrupt                       
    signal CpSl_Frame1_i                   : std_logic;                         -- TDC_GPX2_Frame1
    signal CpSl_Frame2_i                   : std_logic;                         -- TDC_GPX2_Frame2
    signal CpSl_Frame3_i                   : std_logic;                         -- TDC_GPX2_Frame3
    signal CpSl_Frame4_i                   : std_logic;                         -- TDC_GPX2_Frame4
    signal CpSl_Sdo1_i                     : std_logic;                         -- TDC_GPX2_SDO1
    signal CpSl_Sdo2_i                     : std_logic;                         -- TDC_GPX2_SDO2
    signal CpSl_Sdo3_i                     : std_logic;                         -- TDC_GPX2_SDO3
    signal CpSl_Sdo4_i                     : std_logic;                         -- TDC_GPX2_SDO4
    signal CpSl_TdcDataVld_o               : std_logic;                         -- TDC_Recv_Data Valid
    signal CpSv_TdcData_o                  : std_logic_vector(47 downto 0);     -- TDC Recv Data

begin
    ------------------------------------
    -- Compoonent Map
    ------------------------------------
    U_M_TdcGpx2_0 : M_TdcGpx2 
    generic map (
        PrSl_Sim_c                      => 1                                    -- Simulation
    )
    port map (
        --------------------------------
        -- Clk & Reset
        --------------------------------
        CpSl_Rst_i                      => CpSl_Rst_i,                          -- in  std_logic;                        -- Reset,Active_low
        CpSl_Clk_i                      => CpSl_Clk_i,                          -- in  std_logic;                        -- Clock,Single_40Mhz
        CpSl_Clk200M_i                  => CpSl_Clk200M_i,                      -- in  std_logic;                        -- Clock,Single 200MHz

        --------------------------------
        -- Start Trig
        --------------------------------
        CpSl_StartTrig_s                => CpSl_StartTrig_s,                    -- in  std_logic;                        -- Start Trig

        --------------------------------
        -- TDC_GPX2 Interface
        --------------------------------
        -- Clock
        CpSl_RefClkP_o                  => open,                                -- out std_logic;                        -- TDC_GPX2_Clk_o                   
        CpSl_RefClkN_o                  => open,                                -- out std_logic;                        -- TDC_GPX2_Clk_o

        -- SPI_IF
        CpSl_SSN_o                      => open,                                -- out std_logic;                        -- TDC_GPX2_SSN
        CpSl_SClk_o                     => open,                                -- out std_logic;                        -- TDC_GPX2_SCLK
        CpSl_MOSI_o                     => open,                                -- out std_logic;                        -- TDC_GPX2_MOSI
        CpSl_MISO_i                     => '0' ,                                -- in  std_logic;                        -- TDC_GPX2_MISO
                                                                                
        -- LVDS                                                                 
        CpSl_RefClkP_i                  => CpSl_RefClkP_i,                      -- in  std_logic;                        -- TDC_GPX2_Clk_i
        CpSl_RefClkN_i                  => CpSl_RefClkN_i,                      -- in  std_logic;                        -- TDC_GPX2_Clk_i
        CpSl_Intertupt_i                => '1',                                 -- in  std_logic;                        -- TDC_GPX2_Interrupt                       
        CpSl_Frame1_i                   => CpSl_Frame1_i,                       -- in  std_logic;                        -- TDC_GPX2_Frame1
        CpSl_Frame2_i                   => '0'  ,                               -- in  std_logic;                        -- TDC_GPX2_Frame2
        CpSl_Frame3_i                   => '0'  ,                               -- in  std_logic;                        -- TDC_GPX2_Frame3
        CpSl_Frame4_i                   => '0'  ,                               -- in  std_logic;                        -- TDC_GPX2_Frame4
        CpSl_Sdo1_i                     => CpSl_Sdo1_i,                         -- in  std_logic;                        -- TDC_GPX2_SDO1
        CpSl_Sdo2_i                     => '1'     ,                            -- in  std_logic;                        -- TDC_GPX2_SDO2
        CpSl_Sdo3_i                     => '1'     ,                            -- in  std_logic;                        -- TDC_GPX2_SDO3
        CpSl_Sdo4_i                     => '1'     ,                            -- in  std_logic;                        -- TDC_GPX2_SDO4
        CpSl_TdcDataVld_o               => open,                                -- out std_logic;                        -- TDC_Recv_Data Valid
        CpSv_TdcData_o                  => open                                 -- out std_logic_vector(47 downto 0)     -- TDC Recv Data
    ); 

    ------------------------------------
    -- Sim Reset & Clock
    ------------------------------------
    process
    begin 
        CpSl_Rst_i <= '0';
        wait for 25 ns;
        CpSl_Rst_i <= '1';
        wait;
    end process;
    
    process
    begin 
        CpSl_Clk_i <= '1';
        wait for 12.5 ns;
        CpSl_Clk_i <= '0';
        wait for 12.5 ns;
    end process;
    
    process
    begin
        CpSl_Clk200M_i <= '1';
        wait for 2.5 ns;
        CpSl_Clk200M_i <= '0';
        wait for 2.5 ns;
    end process;
    
    ------------------------------------
    -- CpSl_RefClkP_i
    ------------------------------------
    CpSl_RefClkP_i <= CpSl_Clk200M_i;
    CpSl_RefClkN_i <= not CpSl_Clk200M_i;
    
    process 
    begin
        CpSl_StartTrig_s <= '0';
        wait for 100 ns;
        CpSl_StartTrig_s <= '1';
        wait for 100 ns;
        CpSl_StartTrig_s <= '0';
        wait;
    end process;
    
    
    
    process
    begin
        CpSl_Frame1_i <= '0';
        wait for 200 ns;
        CpSl_Frame1_i <= '1';
        wait for 20 ns;
        CpSl_Frame1_i <= '0';
        wait;
    end process;
    
    process
        variable i : integer range 0 to 23 := 0;
    begin
        CpSl_Sdo1_i <= '0';
        wait for 200 ns;
        for i in 0 to 23 loop
            CpSl_Sdo1_i <= PrSv_Sdo1_c(i);
            wait for 5 ns;
        end loop;
        wait;
    end process;

end arch_M_SimTdcGpx2;