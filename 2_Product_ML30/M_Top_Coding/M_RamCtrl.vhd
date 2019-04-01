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
-- 文件名称  :  M_RamCtrl.vhd
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

entity M_RamCtrl is
    port (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
        CpSl_Rst_i                      : in  std_logic;                        -- active,low
        
        -------------------------------- 
        -- Eth Receive Data
        --------------------------------
        CpSl_StopTrig_i                 : in  std_logic;                        -- Stop Send Data
        CpSl_WrTrig_i                   : in  std_logic;                        -- Ethernet Write Trig
        CpSl_NetWrVld_i                 : in  std_logic;                        -- Ethernet Write Valid
        CpSv_NetWrData_i                : in  std_logic_vector(15 downto 0);    -- Ethernet Write Data
        CpSl_RecvSucc_i                 : in  std_logic;                        -- Receive Ethernet Data
        CpSl_RdTrig_i                   : in  std_logic;                        -- Read Ram Trig
        CpSv_RamData_o                  : out std_logic_vector(31 downto 0)     -- Read Ram Data
    );
end M_RamCtrl;

architecture arch_M_RamCtrl of M_RamCtrl is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    -- Constant_Ram_State
    constant PrSv_Idle_c                : std_logic_vector( 2 downto 0) := "000"; -- Idle
    constant PrSv_RamWrTrig_c           : std_logic_vector( 2 downto 0) := "001"; -- Write_Trig    
    constant PrSv_RamWrEnd_c            : std_logic_vector( 2 downto 0) := "010"; -- Write_End
    constant PrSv_RamRdTrig_c           : std_logic_vector( 2 downto 0) := "011"; -- Read_Trig
    constant PrSv_RamRdCycle_c          : std_logic_vector( 2 downto 0) := "100"; -- Send Data
    constant PrSv_RamStopTrig_c         : std_logic_vector( 2 downto 0) := "101"; -- Recv Stop Trig
    constant PrSv_RamStop_c             : std_logic_vector( 2 downto 0) := "110"; -- Send Stop
       
    -- Ram
    constant PrSv_RamRdCnt_c            : std_logic_vector(15 downto 0) := x"0023"; -- Read 1 Frame Cnt
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    ------------------------------------ 
    -- M_Ram
    ------------------------------------
    component M_Ram is 
    port (
		clock		                    : IN  STD_LOGIC := '1';
		data		                    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		rdaddress		                : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
		wraddress		                : IN  STD_LOGIC_VECTOR( 4 DOWNTO 0);
		wren		                    : IN  STD_LOGIC := '0';
		q		                        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	end component;

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSv_NetData_s               : std_logic_vector(15 downto 0);        -- Ram_Data
    signal PrSv_RamWrAdd_s              : std_logic_vector( 4 downto 0);        -- Ram_WrAddress
    signal PrSv_RamRdAdd_s              : std_logic_vector( 3 downto 0);        -- Ram_RdAddress
    signal PrSl_RamWR_s                 : std_logic;                            -- Ram_Write_Read
    signal PrSv_RamData_s               : std_logic_vector(31 downto 0);        -- Ram_OutData
    signal PrSv_RamRdCnt_s              : std_logic_vector(15 downto 0);        -- Ram_Read_Cycle
        
    -- Ram_State
    signal PrSv_RamState_s              : std_logic_vector( 2 downto 0);        -- Ram State
    
begin
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    ------------------------------------ 
    -- M_Ram
    ------------------------------------
    U_M_Ram_0 : M_Ram  
    port map (
        clock		                    => CpSl_Clk_i,
		data		                    => PrSv_NetData_s,
		rdaddress		                => PrSv_RamWrAdd_s,
		wraddress		                => PrSv_RamRdAdd_s,
		wren		                    => PrSl_RamWR_s,
		q		                        => PrSv_RamData_s
    );


    process (CpSl_Rst_i,CpSl_Clk_i) begin 
        if (CpSl_Rst_i = '0') then 
            PrSv_RamState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_RamState_s is 
            when PrSv_Idle_c => 
                if (CpSl_WrTrig_i = '1') then 
                    PrSv_RamState_s <= PrSv_RamWrTrig_c;
                else --hold
                end if;
            when PrSv_RamWrTrig_c => 
                if (CpSl_RecvSucc_i = '1') then
                    PrSv_RamState_s <= PrSv_RamRdTrig_c;
                else --hold
                end if;
            when PrSv_RamRdTrig_c => 
                if (CpSl_RdTrig_i = '1') then 
                    PrSv_RamState_s <= PrSv_RamRdCycle_c;
                else -- hold
                end if;
            when PrSv_RamRdCycle_c => 
                if (PrSv_RamRdCnt_s = PrSv_RamRdCnt_c) then 
                    PrSv_RamState_s <= PrSv_RamStopTrig_c;
                else -- hold
                end if;
            when PrSv_RamStopTrig_c => 
                if (CpSl_StopTrig_i = '1') then 
                    PrSv_RamState_s <= PrSv_RamStop_c;
                else
                    PrSv_RamState_s <= PrSv_RamRdCycle_c;
                end if;
            when PrSv_RamStop_c => PrSv_RamState_s <= (others => '0'); 
            when others => PrSv_RamState_s <= (others => '0');
            end case;
        end if;
    end process;




----------------------------------------
-- End
----------------------------------------
end arch_M_RamCtrl;