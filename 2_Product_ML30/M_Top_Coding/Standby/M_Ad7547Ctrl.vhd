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
-- 文件名称  :  M_Ad7547Ctrl.vhd
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
entity M_Ad7547Ctrl is
    port (
        nrst                            : in  std_logic;                        -- Reset,Active Low
        clk                             : in  std_logic;                        -- Single,40MHz
        da_mems_start_tick              : in  std_logic;                        -- Mems_Trig
        da_datax                        : in  std_logic_vector(11 downto 0);    -- Mems_x
        da_datay                        : in  std_logic_vector(11 downto 0);    -- Mems_Y
        agc_da_start_tick               : in  std_logic;                        -- Agc_Trig 
        da_data_agc                     : in  std_logic_vector(11 downto 0);    -- Agc_Data
        da_wr                           : out std_logic;                        -- Write
        da_acs                          : out std_logic;                        -- Mem_X_CS
        da_bcs                          : out std_logic;                        -- Mem_Y_CS
        da_ccs                          : out std_logic;                        -- Gain_CS
        da_data                         : out std_logic_vector(11 downto 0);    -- Config_Data
        da_finish                       : out std_logic                         -- Gain_Finish
    );
end M_Ad7547Ctrl;


architecture arch_M_Ad7547Ctrl of M_Ad7547Ctrl is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSv_CfgState_s              : std_logic_vector( 3 downto 0);        -- Config AD7547 State
    signal PrSv_MemXData_s              : std_logic_vector(11 downto 0);        -- Mem_X
    signal PrSv_MemYData_s              : std_logic_vector(11 downto 0);        -- Mem_Y
    signal PrSv_GainData_s              : std_logic_vector(11 downto 0);        -- Gain
    signal PrSv_XYCnt_s                 : std_logic_vector( 3 downto 0);        -- X/Y Cnt
    signal PrSv_GainCnt_s               : std_logic_vector( 3 downto 0);        -- Gain Cnt
    signal PrSv_XYGCnt_s                : std_logic_vector( 4 downto 0);        -- X/Y/G Cnt

begin
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- Mem_X/Y
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_MemXData_s <= (others => '0');
            PrSv_MemYData_s <= (others => '0');
        elsif rising_edge(clk) then
            if (da_mems_start_tick = '1') then 
                PrSv_MemXData_s <= da_datax;
                PrSv_MemYData_s <= da_datay;
            else -- hold
            end if;
        end if;
    end process;
    
    -- Gain
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_GainData_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (agc_da_start_tick = '1') then 
                PrSv_GainData_s <= da_data_agc;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_CfgState_s
    process (nrst,clk) begin 
        if (nrst = '0') then
            PrSv_CfgState_s <= x"0";
        elsif rising_edge(clk) then
            case PrSv_CfgState_s is 
                when x"0" => -- Idle
                    if (agc_da_start_tick = '1') then
                        PrSv_CfgState_s <= x"1";
                    elsif (da_mems_start_tick = '1') then 
                        PrSv_CfgState_s <= x"2";
                    elsif (da_mems_start_tick = '1' and agc_da_start_tick = '1') then 
                        PrSv_CfgState_s <= x"3";
                    else -- hold
                    end if;

                when x"1" => -- Gain
                    if (PrSv_GainCnt_s = 5) then
                        PrSv_CfgState_s <= x"0";
                    else
                    end if;
                
                when x"2" => -- Mem_X/Y
                    if (PrSv_XYCnt_s = 11) then
                        PrSv_CfgState_s <= x"4";
                    else -- hold
                    end if;
               
                when x"3" => -- Mem_X/Y/Gain
                    if (PrSv_XYGCnt_s = 17) then 
                        PrSv_CfgState_s <= x"4";
                    else
                    end if;
                
                when x"4" => 
                    PrSv_CfgState_s <= x"0";
                when others => 
                    PrSv_CfgState_s <= x"0";
            end case;
        end if;
    end process;
    
    -- PrSv_GainCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_GainCnt_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (PrSv_CfgState_s = x"1") then 
                if (PrSv_GainCnt_s = 5) then 
                    PrSv_GainCnt_s <= (others => '0');
                else
                    PrSv_GainCnt_s <= PrSv_GainCnt_s + '1';
                end if;
            else
                PrSv_GainCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_XYCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_XYCnt_s <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_CfgState_s = x"2") then 
                if (PrSv_XYCnt_s = 11) then 
                    PrSv_XYCnt_s <= (others => '0');
                else
                    PrSv_XYCnt_s <= PrSv_XYCnt_s + '1';
                end if;
            else
                PrSv_XYCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_XYGCnt_s
    process (nrst,clk) begin
        if (nrst = '0') then
            PrSv_XYGCnt_s <= (others => '0');
        elsif rising_edge(clk) then 
            if (PrSv_CfgState_s = x"3") then
                if (PrSv_XYGCnt_s = 17) then
                    PrSv_XYGCnt_s <= (others => '0');
                else
                    PrSv_XYGCnt_s <= PrSv_XYGCnt_s + '1';
                end if;
            else
                PrSv_XYGCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- da_acs
    process (nrst,clk) begin
        if (nrst = '0') then
            da_acs <= '1';
        elsif rising_edge(clk) then
            if (PrSv_CfgState_s = x"2") then 
                if (PrSv_XYCnt_s = 0) then
                    da_acs <= '0';
                elsif (PrSv_XYCnt_s = 4) then  
                    da_acs <= '1';
                else -- hold
                end if;
            elsif (PrSv_CfgState_s = x"3") then 
                if (PrSv_XYCnt_s = 0) then
                    da_acs <= '0';
                elsif (PrSv_XYCnt_s = 4) then  
                    da_acs <= '1';
                else -- hold
                end if;
            else
                da_acs <= '1';
            end if;
        end if;
    end process;
    
    -- da_bcs
    process (nrst,clk) begin
        if (nrst = '0') then
            da_bcs <= '1';
        elsif rising_edge(clk) then
            if (PrSv_CfgState_s = x"2") then 
                if (PrSv_XYCnt_s = 6) then
                    da_bcs <= '0';
                elsif (PrSv_XYCnt_s = 11) then  
                    da_bcs <= '1';
                else -- hold
                end if;
            elsif (PrSv_CfgState_s = x"3") then 
                if (PrSv_XYGCnt_s = 6) then
                    da_bcs <= '0';
                elsif (PrSv_XYGCnt_s = 11) then  
                    da_bcs <= '1';
                else -- hold
                end if;
            else
                da_bcs <= '1';
            end if;
        end if;
    end process;
    
    -- da_ccs
    process (nrst,clk) begin
        if (nrst = '0') then
            da_ccs <= '1';
        elsif rising_edge(clk) then
            if (PrSv_CfgState_s = x"1") then 
                if (PrSv_GainCnt_s = 0) then
                    da_ccs <= '0';
                elsif (PrSv_GainCnt_s = 4) then  
                    da_ccs <= '1';
                else -- hold
                end if;
            
            elsif (PrSv_CfgState_s = x"3") then 
                if (PrSv_XYGCnt_s = 13) then
                    da_ccs <= '0';
                elsif (PrSv_XYGCnt_s = 16) then
                    da_ccs <= '1';
                else -- hold
                end if;
            else
                da_ccs <= '1';
            end if;
        end if;
    end process;
    
    -- da_wr
    process (nrst,clk) begin
        if (nrst = '0') then
            da_wr <= '1';
        elsif rising_edge(clk) then
            if (PrSv_CfgState_s = x"1") then 
                if (PrSv_GainCnt_s = 1) then
                    da_wr <= '0';
                elsif (PrSv_GainCnt_s = 4) then  
                    da_wr <= '1';
                else -- hold
                end if;
            elsif (PrSv_CfgState_s = x"2") then
                if (PrSv_XYCnt_s = 1) then
                    da_wr <= '0';
                elsif (PrSv_XYCnt_s = 4) then
                    da_wr <= '1';
                elsif (PrSv_XYCnt_s = 7) then 
                    da_wr <= '0';
                elsif (PrSv_XYCnt_s = 10) then 
                    da_wr <= '1';
                else -- hold
                end if;
            elsif (PrSv_CfgState_s = x"3") then 
                if (PrSv_XYGCnt_s = 1) then
                    da_wr <= '0';
                elsif (PrSv_XYGCnt_s = 4) then
                    da_wr <= '1';
                elsif (PrSv_XYGCnt_s = 7) then 
                    da_wr <= '0';
                elsif (PrSv_XYGCnt_s = 10) then 
                    da_wr <= '1';
                elsif (PrSv_XYGCnt_s = 13) then 
                    da_wr <= '0';
                elsif (PrSv_XYGCnt_s = 16) then 
                    da_wr <= '1';
                else -- hold
                end if;
            else
                da_wr <= '1';
            end if;
        end if;
    end process;
    
    -- da_data
    process (nrst,clk) begin
        if (nrst = '0') then
            da_data <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_CfgState_s = x"1") then 
                if (PrSv_GainCnt_s = 1) then
                    da_data <= da_data_agc;
                else
                end if;
            elsif (PrSv_CfgState_s = x"2") then
                if (PrSv_XYCnt_s = 1) then
                    da_data <= da_datax;
                elsif (PrSv_XYCnt_s = 7) then
                    da_data <= da_datay;
                else
                end if;
            elsif (PrSv_CfgState_s = x"3") then 
                if (PrSv_XYGCnt_s = 1) then
                    da_data <= da_datax;
                elsif (PrSv_XYGCnt_s = 7) then
                    da_data <= da_datay;
                elsif (PrSv_XYGCnt_s = 13) then 
                    da_data <= da_data_agc;
                else
                end if;
            else
            end if;
        end if;
    end process;
    
    -- da_finish
    process (nrst,clk) begin
        if (nrst = '0') then
            da_finish <= '0';
        elsif rising_edge(clk) then 
            if (PrSv_CfgState_s = x"4") then
                da_finish <= '1';
            else
                da_finish <= '0';
            end if;
        end if;
    end process;
    
----------------------------------------
-- End
----------------------------------------
end arch_M_Ad7547Ctrl;