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
-- 文件名称  :  M_MeanData.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/11/20
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/11/20
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_MeanData is
    port (
        --------------------------------
        -- Reset & Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset,active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,single 200MHz

        --------------------------------
        -- Frame_Valid
        --------------------------------
        CpSl_FrameVld_i                 : in  std_logic;                        -- Frame Valid
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);     -- Ld_Num

        --------------------------------
        -- InPut_Data
        --------------------------------
        CpSl_Echo1Vld_i                 : in  std_logic;                        -- Echo1Valid
        CpSv_WaveGrayD_i                : in  std_logic_vector(53 downto 0);    -- Echo1WaveD

        --------------------------------
        -- OutPut_Data
        --------------------------------
        CpSv_MeanData_o                 : out std_logic_vector(53 downto 0)     -- MeanWave
    );
end M_MeanData;

architecture arch_M_MeanData of M_MeanData is
    ----------------------------------------------------------------------------
    -- Constant_Describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- Component_Describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- Signal_Describe
    ----------------------------------------------------------------------------
    signal PrSl_FrameVld_s              : std_logic;                            -- Frame Valid
    signal PrSl_FrameVldDly_s           : std_logic;                            -- Frame Valid Dly1
    signal PrSl_FrameTrig_s             : std_logic;                            -- Frame Trig
    signal PrSl_FrameTrigDly1_s         : std_logic;                            -- Frame Trig delay 1 Clk
    signal PrSl_FrameTrigDly2_s         : std_logic;                            -- Frame Trig delay 2 Clk
    signal PrSl_FrameTrigDly3_s         : std_logic;                            -- Frame Trig delay 3 Clk
    signal PrSv_Sum1Data_s              : std_logic_vector(74 downto 0);        -- Sum_Data
    signal PrSv_Sum2Data_s              : std_logic_vector(74 downto 0);        -- Sum_Data
    signal PrSv_Sum3Data_s              : std_logic_vector(74 downto 0);        -- Sum_Data
    
    signal PrSv_FctRef_s                : std_logic_vector(53 downto 0);        -- Reference Data

begin 
    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
-- PrSl_FrameVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_FrameVld_s <= '0';
            PrSl_FrameVldDly_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_FrameVld_s <= CpSl_FrameVld_i;
            PrSl_FrameVldDly_s <= PrSl_FrameVld_s;
        end if;
    end process;
    -- PrSl_FrameTrig_s
    PrSl_FrameTrig_s <= '1' when (PrSl_FrameVldDly_s = '0' and PrSl_FrameVld_s = '1') else '0';
    
    -- PrSl_FrameTrigDly1_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_FrameTrigDly1_s <= '0';
            PrSl_FrameTrigDly2_s <= '0';
            PrSl_FrameTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_FrameTrigDly1_s <= PrSl_FrameTrig_s;
            PrSl_FrameTrigDly2_s <= PrSl_FrameTrigDly1_s;
            PrSl_FrameTrigDly3_s <= PrSl_FrameTrigDly2_s;
        end if;
    end process;
    
    -- PrSv_Sum1/2/3Data_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_Sum1Data_s <= (others => '0');
            PrSv_Sum2Data_s <= (others => '0');
            PrSv_Sum3Data_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_FrameTrigDly3_s = '1') then
                PrSv_Sum1Data_s <= (others => '0');
                PrSv_Sum2Data_s <= (others => '0');
                PrSv_Sum3Data_s <= (others => '0');  
            elsif (CpSl_Echo1Vld_i = '1') then
                case CpSv_LdNum_i is
                    when "01" => -- Start1
                        PrSv_Sum1Data_s <= PrSv_Sum1Data_s + CpSv_WaveGrayD_i;
                    when "10" => -- Start2
                        PrSv_Sum2Data_s <= PrSv_Sum2Data_s + CpSv_WaveGrayD_i;
                    when "11" => -- Start3
                        PrSv_Sum3Data_s <= PrSv_Sum3Data_s + CpSv_WaveGrayD_i;
                    when others => 
                        PrSv_Sum1Data_s <= PrSv_Sum1Data_s;
                        PrSv_Sum2Data_s <= PrSv_Sum2Data_s;
                        PrSv_Sum3Data_s <= PrSv_Sum3Data_s;
                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_FctRef_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_FctRef_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_FrameTrig_s = '1') then
                case CpSv_LdNum_i is 
                    when "01" => 
--                PrSv_FctRef_s <= PrSv_SumData_s(62 downto 15); -- 30%
--                PrSv_FctRef_s <= PrSv_SumData_s(63 downto 16); -- 15%
--                PrSv_FctRef_s <= PrSv_SumData_s(64 downto 17); -- 7.5%
--                PrSv_FctRef_s <= PrSv_SumData_s(65 downto 18); -- 3.75%
--                PrSv_FctRef_s <= PrSv_SumData_s(66 downto 19); -- 1.875%
--                PrSv_FctRef_s <= PrSv_SumData_s(67 downto 20); -- 0.9375%
                        PrSv_FctRef_s <= PrSv_Sum1Data_s(74 downto 21); -- 0.46875%
                    when "10" => 
                        PrSv_FctRef_s <= PrSv_Sum2Data_s(74 downto 21); -- 0.46875%
                    when "11" => 
                        PrSv_FctRef_s <= PrSv_Sum3Data_s(74 downto 21); -- 0.46875%
                    when others => 
                        PrSv_FctRef_s <= PrSv_FctRef_s;
                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    CpSv_MeanData_o <= PrSv_FctRef_s;

--------------------------------------------------------------------------------
-- End_Coding
--------------------------------------------------------------------------------
end arch_M_MeanData;