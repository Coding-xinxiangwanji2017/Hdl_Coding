--------------------------------------------------------------------------------
-- 版    权  :  BiXing Tech
-- 文件名称  :  M_Lcd4Top.vhd
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

LIBRARY altera_mf;
USE altera_mf.all; 

entity M_SimI2C is 
end M_SimI2C;

architecture arch_M_SimI2C of M_SimI2C is 
    ----------------------------------------------------------------------------
    -- Constant declaration
    ----------------------------------------------------------------------------
    constant Refresh_Rate               : integer := 150;
    constant Simulation                 : integer := 0;
    constant Use_ChipScope              : integer := 0;

    ----------------------------------------------------------------------------
    -- Component declaration
    ----------------------------------------------------------------------------
    component M_I2C is
    port (
        --------------------------------
        -- Reset&Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset,low active
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,Single 40M

        --------------------------------
        -- APD/Vth_Rd/Wr_Trig
        --------------------------------
        CpSl_ApdRdTrig_i                : in  std_logic;                        -- APD_Read_Trig
        CpSl_ApdWrTrig_i                : in  std_logic;                        -- APD_Write_Trig
        CpSl_VthRdTrig_i                : in  std_logic;                        -- Vth_Read_Trig
        CpSl_VthWrTrig_i                : in  std_logic;                        -- Vth_Write_Trig
        
        --------------------------------
        -- LTC2631
        --------------------------------
        CpSl_WrTrig1_i                  : in  std_logic;                        -- Wr_Trig1
        CpSl_WrTrig2_i                  : in  std_logic;                        -- Wr_Trig2
        
        --------------------------------
        -- LTC2631_Interface
        --------------------------------
        CpSv_WrTrigData_i               : in  std_logic_vector(11 downto 0);    -- WriteData
        
        --------------------------------
        -- AD5242_Interface
        --------------------------------
        CpSl_ApdChannel_i               : in  std_logic;                        -- AD5242_ApdChannnel
        CpSv_ApdWrData_i                : in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
        CpSv_ApdRdData_o                : out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
        CpSl_VthChannel_i               : in  std_logic;                        -- AD5242_VthChannnel
        CpSv_VthWrData_i                : in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
        CpSv_VthRdData_o                : out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
        CpSl_Finish_o                   : out std_logic;                        -- I2C_Finish
        
        --------------------------------
        -- I2C_Interface
        --------------------------------
        CpSl_Scl_o                      : out std_logic;                        -- AD5242_Scl
        CpSl_Sda_io                     : inout std_logic                       -- AD5242_Sda
    );
    end component;
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal CpSl_Rst_iN                  : std_logic;                        -- Reset,low active
    signal CpSl_Clk_i                   : std_logic;                        -- Clock,Single 40M
    signal CpSl_ApdRdTrig_i             : std_logic;                        -- APD_Read_Trig
    signal CpSl_ApdWrTrig_i             : std_logic;                        -- APD_Write_Trig
    signal CpSl_VthRdTrig_i             : std_logic;                        -- Vth_Read_Trig
    signal CpSl_VthWrTrig_i             : std_logic;                        -- Vth_Write_Trig
    signal CpSl_ApdChannel_i            : std_logic;                        -- AD5242_ApdChannnel
    signal CpSv_ApdWrData_i             : std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
    signal CpSv_ApdRdData_o             : std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
    signal CpSl_VthChannel_i            : std_logic;                        -- AD5242_VthChannnel
    signal CpSv_VthWrData_i             : std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
    signal CpSv_VthRdData_o             : std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
    signal CpSl_Finish_o                : std_logic;                        -- I2C_Finish
    signal CpSl_Scl_o                   : std_logic;                        -- AD5242_Scl
    signal CpSl_Sda_io                  : std_logic;                        -- AD5242_Sda
    
    signal CpSl_WrTrig1_i               : std_logic;                        -- WrTrig1
    signal CpSl_WrTrig2_i               : std_logic;                        -- WrTrig2
    
    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
begin   
    ------------------------------------
    -- Compoonent map
    ------------------------------------
    U_M_I2C_0 : M_I2C
    port map (
        --------------------------------
        -- Reset&Clock
        --------------------------------
        CpSl_Rst_iN                     => CpSl_Rst_iN                          , -- in  std_logic;                        -- Reset,low active
        CpSl_Clk_i                      => CpSl_Clk_i                           , -- in  std_logic;                        -- Clock,Single 40M

        --------------------------------
        -- APD/Vth_Rd/Wr_Trig
        --------------------------------
        CpSl_ApdRdTrig_i                => '0'                     , -- in  std_logic;                        -- APD_Read_Trig
        CpSl_ApdWrTrig_i                => CpSl_ApdWrTrig_i                     , -- in  std_logic;                        -- APD_Write_Trig
        CpSl_VthRdTrig_i                => '0'                     , -- in  std_logic;                        -- Vth_Read_Trig
        CpSl_VthWrTrig_i                => CpSl_VthWrTrig_i                     , -- in  std_logic;                        -- Vth_Write_Trig
        
        --------------------------------
        -- LTC2631
        --------------------------------
        CpSl_WrTrig1_i                  => CpSl_WrTrig1_i                       , -- in  std_logic;                        -- Wr_Trig1
        CpSl_WrTrig2_i                  => CpSl_WrTrig2_i                       , -- in  std_logic;                        -- Wr_Trig2
        
        --------------------------------
        -- LTC2631_Interface
        --------------------------------
        CpSv_WrTrigData_i               => x"A5A"                               , -- in  std_logic_vector(11 downto 0);    -- WriteData
        
        --------------------------------
        -- AD5242_Interface
        --------------------------------
        CpSl_ApdChannel_i               => CpSl_ApdChannel_i                    , -- in  std_logic;                        -- AD5242_ApdChannnel
        CpSv_ApdWrData_i                => CpSv_ApdWrData_i                     , -- in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
        CpSv_ApdRdData_o                => CpSv_ApdRdData_o                     , -- out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
        CpSl_VthChannel_i               => CpSl_VthChannel_i                    , -- in  std_logic;                        -- AD5242_VthChannnel
        CpSv_VthWrData_i                => CpSv_VthWrData_i                     , -- in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
        CpSv_VthRdData_o                => CpSv_VthRdData_o                     , -- out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
        CpSl_Finish_o                   => CpSl_Finish_o                        , -- out std_logic;                        -- I2C_Finish
        
        --------------------------------
        -- I2C_Interface
        --------------------------------
        CpSl_Scl_o                      => CpSl_Scl_o                           , -- out std_logic;                        -- AD5242_Scl
        CpSl_Sda_io                     => CpSl_Sda_io                            -- inout std_logic                       -- AD5242_Sda
    );
    
    
    ------------------------------------
    -- Sim Reset & Clock
    ------------------------------------
    process
    begin 
        CpSl_Rst_iN <= '0';
        wait for 50 ns;
        CpSl_Rst_iN <= '1';
        wait;
    end process;
    
    process
    begin 
        CpSl_Clk_i <= '0';
        wait for 12.5 ns;
        CpSl_Clk_i <= '1';
        wait for 12.5 ns;
    end process;
    
    ------------------------------------
    -- Trig
    ------------------------------------
    process 
    begin 
        CpSl_ApdWrTrig_i <= '0';
        wait for 100 ns;
        CpSl_ApdWrTrig_i <= '1';
        wait for 100 ns;
        CpSl_ApdWrTrig_i <= '0';
        wait;
    end process;
    
    CpSl_ApdChannel_i <= '1';
    CpSv_ApdWrData_i <= x"A5";
    
    process 
    begin 
        CpSl_VthWrTrig_i <= '0';
        wait for 100 us;
        CpSl_VthWrTrig_i <= '1';
        wait for 100 ns;
        CpSl_VthWrTrig_i <= '0';
        wait;
    end process;
    CpSl_VthChannel_i <= '0';
    CpSv_VthWrData_i <= x"5A";
    
    
    process 
    begin 
        CpSl_WrTrig1_i <= '0';
        wait for 200 us;
        CpSl_WrTrig1_i <= '1';
        wait for 100 ns;
        CpSl_WrTrig1_i <= '0';
        wait;
    end process;
    
    process
    begin 
        CpSl_Sda_io <= 'Z';
        wait for 22.5 us;
        CpSl_Sda_io <= '0';
        wait;
    end process;
    
end arch_M_SimI2C;