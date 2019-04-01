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

entity M_W5300Ctrl is 
end M_W5300Ctrl;

architecture arch_M_W5300Ctrl of M_W5300Ctrl is 
    ----------------------------------------------------------------------------
    -- Constant declaration
    ----------------------------------------------------------------------------
    constant Refresh_Rate               : integer := 150;
    constant Simulation                 : integer := 0;
    constant Use_ChipScope              : integer := 0;

    ----------------------------------------------------------------------------
    -- Component declaration
    ----------------------------------------------------------------------------
    component w5300_ctrl
    port (
        ------------------------------------ 
        -- Clock & Reset                
        ------------------------------------ 
        clk                             : in  std_logic;                        -- single 40MHz.clock
        nrst                            : in  std_logic;                        -- active,low
        
        ------------------------------------ 
        -- Tick
        ------------------------------------ 
        tick_1us                        : in  std_logic;	                    -- tick 1us 
        tick_10us                       : in  std_logic;	                    -- tick 10us 
        tick_100us                      : in  std_logic;	                    -- tick 100us 
        tick_1ms                        : in  std_logic;	                    -- tick 1ms 
        nint_f                          : in  std_logic;	                    -- W5300中断信号，'0'有效 

        ethernet_package_gap_cnt        : in  std_logic_vector(15 downto 0);	-- 以太网下传包间隔的包数
        ethernet_package_gap            : in  std_logic_vector(15 downto 0);	-- 以太网下传包间隔，当量1us 
        
        ethernet_nrst_ctrl              : in  std_logic;	                    -- 网口复位控制信号 
        ethernet_init_start             : in  std_logic;	                    -- 网口初始化启动标志，tick 
        ethernet_init_done              : out std_logic;	                    -- 网口初始化完成标志，tick 
        ethernet_init_result            : out std_logic;	                    -- 网口初始化结果，'1'成功，'0'失败 
        
        rcv                             : out std_logic;	                    -- 接收完成的tick 
        rcv_data                        : out std_logic_vector(15 downto 0);	-- 接收数据
                                        
        fifo_rd                         : out std_logic;	                    -- 发送数据FIFO读信号 
        fifo_data                       : in  std_logic_vector(31 downto 0);	-- 发送数据FIFO数据 
        fifo_empty                      : in  std_logic;	                    -- 发送数据FIFO空标志 
        send_start                      : in  std_logic;	                    -- 发送启动，tick 
        send_done                       : out std_logic;	                    -- 发送完成，tick 
        
        --------------------------------
        -- Control W5300
        --------------------------------
        CpSl_WrTrig_s                   : out std_logic;	                    -- W5300_Write_Trig
        CpSl_RdTrig_s                   : out std_logic;	                    -- W5300_Read_Trig
        CpSv_W5300Add_s                 : out std_logic_vector( 9 downto 0);	-- W5300_Address
        CpSv_W5300WrData_s              : out std_logic_vector(15 downto 0);	-- W5300WrData
        CpSv_W5300RdData_s              : in  std_logic_vector(15 downto 0)	    -- W5300RdData
    );
    end component;
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Clock & Reset
    ------------------------------------
    signal clk                          : std_logic;                            -- Clock,Sigl 40MHz
    signal nrst                         : std_logic;                            -- active,low

    ------------------------------------ 
    -- Tick
    ------------------------------------ 
    signal tick_1us                     : std_logic;	                        -- tick 1us 
    signal tick_10us                    : std_logic;	                        -- tick 10us 
    signal tick_100us                   : std_logic;	                        -- tick 100us 
    signal tick_1ms                     : std_logic;	                        -- tick 1ms 
    signal nint_f                       : std_logic;	                        -- W5300中断信号，'0'有效 
                                                                            
    signal ethernet_package_gap_cnt     : std_logic_vector(15 downto 0);        -- 以太网下传包间隔的包数
    signal ethernet_package_gap         : std_logic_vector(15 downto 0);        -- 以太网下传包间隔，当量1us 
                                                                            
    signal ethernet_nrst_ctrl           : std_logic;	                        -- 网口复位控制信号 
    signal ethernet_init_start          : std_logic;	                        -- 网口初始化启动标志，tick 
    signal ethernet_init_done           : std_logic;	                        -- 网口初始化完成标志，tick 
    signal ethernet_init_result         : std_logic;	                        -- 网口初始化结果，'1'成功，'0'失败 
                                                                                
    signal rcv                          : std_logic;	                        -- 接收完成的tick 
    signal rcv_data                     : std_logic_vector(15 downto 0);        -- 接收数据

    signal fifo_rd                      : std_logic;                            -- 发送数据FIFO读信号 
    signal fifo_data                    : std_logic_vector(31 downto 0);        -- 发送数据FIFO数据 
    signal fifo_empty                   : std_logic;	                        -- 发送数据FIFO空标志 
    signal send_start                   : std_logic;	                        -- 发送启动，tick 
    signal send_done                    : std_logic;	                        -- 发送完成，tick 

    --------------------------------
    -- Control W5300
    --------------------------------
    signal CpSl_WrTrig_s                : std_logic;	                        -- W5300_Write_Trig
    signal CpSl_RdTrig_s                : std_logic;	                        -- W5300_Read_Trig
    signal CpSv_W5300Add_s              : std_logic_vector( 9 downto 0);	    -- W5300_Address
    signal CpSv_W5300WrData_s           : std_logic_vector(15 downto 0);	    -- W5300WrData
    signal CpSv_W5300RdData_s           : std_logic_vector(15 downto 0)         -- W5300RdData    
begin
    ------------------------------------
    -- Compoonent Map
    ------------------------------------
    U_w5300_ctrl_0 : w5300_ctrl 
    port map (
        -------------------------------- 
        -- Clock & Reset                
        -------------------------------- 
        clk                             => clk                                  , -- single 40MHz.clock
        nrst                            => nrst                                 , -- active,low
        
        --------------------------------
        -- Tick
        --------------------------------
        tick_1us                        => tick_1us                             , -- tick 1us 
        tick_10us                       => tick_10us                            , -- tick 10us 
        tick_100us                      => tick_100us                           , -- tick 100us 
        tick_1ms                        => tick_1ms                             , -- tick 1ms 
        nint_f                          => nint_f                               , -- W5300中断信号，'0'有效 
        ethernet_package_gap_cnt        => ethernet_package_gap_cnt             , -- 以太网下传包间隔的包数
        ethernet_package_gap            => ethernet_package_gap                 , -- 以太网下传包间隔，当量1us 
        ethernet_nrst_ctrl              => ethernet_nrst_ctrl                   , -- 网口复位控制信号 
        ethernet_init_start             => ethernet_init_start                  , -- 网口初始化启动标志，tick 
        ethernet_init_done              => ethernet_init_done                   , -- 网口初始化完成标志，tick 
        ethernet_init_result            => ethernet_init_result                 , -- 网口初始化结果，'1'成功，'0'失败 
        rcv                             => rcv                                  , -- 接收完成的tick 
        rcv_data                        => rcv_data                             , -- 接收数据
        fifo_rd                         => fifo_rd                              , -- 发送数据FIFO读信号 
        fifo_data                       => fifo_data                            , -- 发送数据FIFO数据 
        fifo_empty                      => fifo_empty                           , -- 发送数据FIFO空标志 
        send_start                      => send_start                           , -- 发送启动，tick 
        send_done                       => send_done                            , -- 发送完成，tick 
        
        --------------------------------
        -- Control W5300
        --------------------------------
        CpSl_WrTrig_s                   => CpSl_WrTrig_s                        , -- W5300_Write_Trig
        CpSl_RdTrig_s                   => CpSl_RdTrig_s                        , -- W5300_Read_Trig
        CpSv_W5300Add_s                 => CpSv_W5300Add_s                      , -- W5300_Address
        CpSv_W5300WrData_s              => CpSv_W5300WrData_s                   , -- W5300WrData
        CpSv_W5300RdData_s              => CpSv_W5300RdData_s                     -- W5300RdData
    ); 

    ------------------------------------
    -- Sim Reset & Clock
    ------------------------------------
    process
    begin 
        nrst <= '0';
        wait for 25 ns;
        nrst <= '1';
        wait;
    end process;
    
    process
    begin 
        clk <= '1';
        wait for 12.5 ns;
        clk <= '0';
        wait for 12.5 ns;
    end process;
    
    
    ------------------------------------
    -- Tick
    ------------------------------------
    tick_1us <= '1';
    tick_10us <= '1';
    tick_100us <= '1';
    tick_1ms <= '1';
    nint_f <= '1';
    
    ethernet_package_gap_cnt <= (others => '1');
    ethernet_package_gap <= (others => '1');
        
    ethernet_nrst_ctrl <= '1';
    ethernet_init_start <= '1';
    
    fifo_data <= x"A5A6";
    fifo_empty <= '0';
    send_start <= '1';
    
    CpSv_W5300RdData_s <= x"EB90";
    
end arch_M_W5300Ctrl;