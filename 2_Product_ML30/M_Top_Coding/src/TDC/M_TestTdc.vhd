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
-- 文件名称  :  M_TestTdc.vhd
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

entity M_TestTdc is
    port (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset_activelow
        CpSl_Clk200M_i                  : in  std_logic;                        -- 200MHz
        
        --------------------------------
        -- Ladar_Trig
        --------------------------------
        CpSl_Start1_i                   : in  std_logic;
        CpSl_Start2_i                   : in  std_logic;
        CpSl_Start3_i                   : in  std_logic;
        
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_RefClkP_o					: out std_logic;						-- TDC_GPX2_Clk_i
        
        -- TDC0
		CpSl_Frame1_o					: out std_logic;						-- TDC_GPX2_Frame1_low
		CpSl_Frame2_o					: out std_logic;						-- TDC_GPX2_Frame2_30%
		CpSl_Frame3_o					: out std_logic;						-- TDC_GPX2_Frame3_Low
		CpSl_Frame4_o					: out std_logic;						-- TDC_GPX2_Frame4_30%
		CpSl_Sdo1_o	     				: out std_logic;						-- TDC_GPX2_SDO1
		CpSl_Sdo2_o	 	    		    : out std_logic;						-- TDC_GPX2_SDO2
		CpSl_Sdo3_o	     				: out std_logic;						-- TDC_GPX2_SDO3
		CpSl_Sdo4_o	 	    		    : out std_logic;						-- TDC_GPX2_SDO4

        -- TDC1
        CpSl_Frame5_o                   : out std_logic;                        -- TDC_GPX2_Frame5_50%
        CpSl_Frame6_o                   : out std_logic;                        -- TDC_GPX2_Frame6_90%
        CpSl_Frame7_o                   : out std_logic;                        -- TDC_GPX2_Frame7_50%
        CpSl_Frame8_o                   : out std_logic;                        -- TDC_GPX2_Frame8_90%
        CpSl_Sdo5_o                     : out std_logic;                        -- TDC_GPX2_SDO5
        CpSl_Sdo6_o                     : out std_logic;                        -- TDC_GPX2_SDO6
        CpSl_Sdo7_o                     : out std_logic;                        -- TDC_GPX2_SDO7
        CpSl_Sdo8_o                     : out std_logic                         -- TDC_GPX2_SDO8
    );
end M_TestTdc;

architecture arch_M_TestTdc of M_TestTdc is 
    ----------------------------------------------------------------------------
    -- Constant declaration
    ----------------------------------------------------------------------------
    constant PrSv_TestCyc_c             : std_logic_vector(11 downto 0) := x"03C"; -- 60
--    constant PrSv_RsiData_c             : std_logic_vector(23 downto 0) := x"0014A5"; 
--    constant PrSv_FalData_c             : std_logic_vector(23 downto 0) := x"001A5A"; 

    ----------------------------------------------------------------------------
    -- Component declaration
    ----------------------------------------------------------------------------
    
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal PrSv_TestCyc_s               : std_logic_vector(11 downto 0);        -- Test_Cycle
    signal PrSl_RisFrame_s              : std_logic;                            -- TDC_RisFrame
    signal PrSl_RisData_s               : std_logic;                            -- TDC_RisData
    signal PrSl_FalFrame_s              : std_logic;                            -- TDC_FallFrame
    signal PrSl_FalData_s               : std_logic;                            -- TDC_FallData
    
    -- Generate_SimTdcData
    signal PrSv_LdNum_s                 : std_logic_vector(1 downto 0);
    signal PrSl_Start1_s                : std_logic;
    signal PrSl_Start1Dly1_s            : std_logic;
    signal PrSl_Start1Trig_s            : std_logic;
    
    signal PrSl_Start2_s                : std_logic;
    signal PrSl_Start2Dly1_s            : std_logic;
    signal PrSl_Start2Trig_s            : std_logic;
    
    signal PrSl_Start3_s                : std_logic;
    signal PrSl_Start3Dly1_s            : std_logic;
    signal PrSl_Start3Trig_s            : std_logic;    
    
    signal PrSl_TdcVldTrig_s            : std_logic;
    signal PrSl_TdcVldTrigDly1_s        : std_logic;
    
    signal PrSv_RsiData_c               : std_logic_vector(31 downto 0); 
    signal PrSv_FalData_c               : std_logic_vector(31 downto 0); 
    
    signal PrSv_TdcTestD1_s             : std_logic_vector(31 downto 0);
    signal PrSv_TdcTestD2_s             : std_logic_vector(31 downto 0);
    signal PrSv_TdcTestD3_s             : std_logic_vector(31 downto 0);
    signal PrSv_TdcData_s               : std_logic_vector(31 downto 0);
    
begin
    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    ------------------------------------
    -- TDC_Clock
    ------------------------------------
    CpSl_RefClkP_o <= CpSl_Clk200M_i;
    
    -- TDC_Trig
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_Start1_s     <= '0';
            PrSl_Start1Dly1_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then
            PrSl_Start1_s     <= CpSl_Start1_i;
            PrSl_Start1Dly1_s <= PrSl_Start1_s;
        end if;
    end process;        
    
    -- PrSl_Start1Trig_s
    PrSl_Start1Trig_s <= '1' when (PrSl_Start1Dly1_s = '0' and PrSl_Start1_s = '1') else '0';
    
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_Start2_s     <= '0';
            PrSl_Start2Dly1_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then
            PrSl_Start2_s     <= CpSl_Start2_i;
            PrSl_Start2Dly1_s <= PrSl_Start2_s;
        end if;
    end process;        
    
    -- PrSl_Start2Trig_s
    PrSl_Start2Trig_s <= '1' when (PrSl_Start2Dly1_s = '0' and PrSl_Start2_s = '1') else '0';
        
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_Start3_s     <= '0';
            PrSl_Start3Dly1_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then
            PrSl_Start3_s     <= CpSl_Start3_i;
            PrSl_Start3Dly1_s <= PrSl_Start3_s;
        end if;
    end process;        
    
    -- PrSl_Start3Trig_s
    PrSl_Start3Trig_s <= '1' when (PrSl_Start3Dly1_s = '0' and PrSl_Start3_s = '1') else '0';
    
    -- PrSv_LdNum_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_LdNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk200M_i) then
            if (PrSl_Start1Trig_s = '1') then
                PrSv_LdNum_s <= "01";
            elsif (PrSl_Start2Trig_s = '1') then
                PrSv_LdNum_s <= "10";
            elsif (PrSl_Start3Trig_s = '1') then
                PrSv_LdNum_s <= "11";
            else -- hold
            end if;
        end if; 
    end process;
    
    ------------------------------------
    -- Generate_TDC_SimData
    ------------------------------------
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_TdcTestD1_s <= x"000007D0";
            PrSv_TdcTestD2_s <= x"00002710";
            PrSv_TdcTestD3_s <= x"00006D60";
        elsif rising_edge(CpSl_Clk200M_i) then
            if (PrSl_TdcVldTrig_s = '1') then
                case PrSv_LdNum_s is
                    when "01" => 
                        if (PrSv_TdcTestD1_s = x"00002EDF") then 
                            PrSv_TdcTestD1_s <= x"000007D0";
                        else
                            PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s + 1;
                        end if;
                            PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s;
                            PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s;
                    
                    when "10" => 
                        if (PrSv_TdcTestD2_s = x"00004E1F") then 
                            PrSv_TdcTestD2_s <= x"00002710";
                        else
                            PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s + 1;
                        end if;
                            PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s;
                            PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s;
                        
                    when "11" => 
                        if (PrSv_TdcTestD3_s = x"0000946F") then 
                            PrSv_TdcTestD3_s <= x"00006D60";
                        else
                            PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s + 1;
                        end if;
                            PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s;
                            PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s;
                        
                    when others => 
                        PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s;
                        PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s;
                        PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s;

                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RsiData_c <= (others => '0');
            PrSv_FalData_c <= (others => '0');
        elsif rising_edge(CpSl_Clk200M_i) then
            if (PrSl_TdcVldTrigDly1_s = '1') then
                case PrSv_LdNum_s is
                    when "01" => 
                        PrSv_RsiData_c <= PrSv_TdcTestD1_s;
                        PrSv_FalData_c <= PrSv_TdcTestD1_s + 500;
                    
                    when "10" => 
                        PrSv_RsiData_c <= PrSv_TdcTestD2_s;
                        PrSv_FalData_c <= PrSv_TdcTestD2_s + 500;
                        
                    when "11" => 
                        PrSv_RsiData_c <= PrSv_TdcTestD3_s;
                        PrSv_FalData_c <= PrSv_TdcTestD3_s + 500;
                        
                    when others => 
                        PrSv_RsiData_c <= PrSv_RsiData_c;
                        PrSv_FalData_c <= PrSv_FalData_c;

                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    
    ------------------------------------
    -- Test_Cycle
    ------------------------------------
    -- PrSv_TestCyc_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_TestCyc_s <= PrSv_TestCyc_c;
        elsif rising_edge(CpSl_Clk200M_i) then
            if (CpSl_Start1_i = '1' or CpSl_Start2_i = '1' or CpSl_Start3_i = '1') then 
                PrSv_TestCyc_s <= (others => '0');
            elsif (PrSv_TestCyc_s = PrSv_TestCyc_c) then 
                PrSv_TestCyc_s <= PrSv_TestCyc_c;
            else
                PrSv_TestCyc_s <= PrSv_TestCyc_s + '1';
            end if;
        end if;
    end process;
    
    -- PrSl_TdcVldTrig_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_TdcVldTrig_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then
            if (PrSv_TestCyc_s = 1) then 
                PrSl_TdcVldTrig_s <= '1';
            else
                PrSl_TdcVldTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- PrSl_TdcVldTrigDly1_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_TdcVldTrigDly1_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then
            PrSl_TdcVldTrigDly1_s <= PrSl_TdcVldTrig_s;
        end if;
    end process;
    
    ------------------------------------
    -- Generate_TDC_Data
    ------------------------------------
    -- PrSl_RisFrame_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_RisFrame_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then 
            if (PrSv_TestCyc_s = 20) then
                PrSl_RisFrame_s <= '1';
            elsif (PrSv_TestCyc_s = 28) then
                PrSl_RisFrame_s <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSl_RisData_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_RisData_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then 
            case PrSv_TestCyc_s is 
                when x"014" => -- 20
                    PrSl_RisData_s <= PrSv_RsiData_c(31);
                when x"015" => -- 21
                    PrSl_RisData_s <= PrSv_RsiData_c(30);
                when x"016" => -- 22
                    PrSl_RisData_s <= PrSv_RsiData_c(29);
                when x"017" => -- 23
                    PrSl_RisData_s <= PrSv_RsiData_c(28);
                when x"018" => -- 24
                    PrSl_RisData_s <= PrSv_RsiData_c(27);
                when x"019" => -- 25
                    PrSl_RisData_s <= PrSv_RsiData_c(26);
                when x"01A" => -- 26
                    PrSl_RisData_s <= PrSv_RsiData_c(25);
                when x"01B" => -- 27
                    PrSl_RisData_s <= PrSv_RsiData_c(24);
                when x"01C" => -- 28
                    PrSl_RisData_s <= PrSv_RsiData_c(23);
                when x"01D" => -- 29                   
                    PrSl_RisData_s <= PrSv_RsiData_c(22);
                when x"01E" => -- 30                   
                    PrSl_RisData_s <= PrSv_RsiData_c(21);
                when x"01F" => -- 31                   
                    PrSl_RisData_s <= PrSv_RsiData_c(20);
                when x"020" => -- 32                   
                    PrSl_RisData_s <= PrSv_RsiData_c(19);
                when x"021" => -- 33
                    PrSl_RisData_s <= PrSv_RsiData_c(18);
                when x"022" => -- 34                   
                    PrSl_RisData_s <= PrSv_RsiData_c(17);
                when x"023" => -- 35                   
                    PrSl_RisData_s <= PrSv_RsiData_c(16);
                when x"024" => -- 36                   
                    PrSl_RisData_s <= PrSv_RsiData_c(15);
                when x"025" => -- 37                   
                    PrSl_RisData_s <= PrSv_RsiData_c(14);
                when x"026" => -- 38                   
                    PrSl_RisData_s <= PrSv_RsiData_c(13);
                when x"027" => -- 39                   
                    PrSl_RisData_s <= PrSv_RsiData_c(12);
                when x"028" => -- 40                   
                    PrSl_RisData_s <= PrSv_RsiData_c(11);
                when x"029" => -- 41                   
                    PrSl_RisData_s <= PrSv_RsiData_c(10);
                when x"02A" => -- 42
                    PrSl_RisData_s <= PrSv_RsiData_c(9);
                when x"02B" => -- 43                  
                    PrSl_RisData_s <= PrSv_RsiData_c(8);
                when x"02C" => -- 44                  
                    PrSl_RisData_s <= PrSv_RsiData_c(7);
                when x"02D" => -- 45                  
                    PrSl_RisData_s <= PrSv_RsiData_c(6);
                when x"02E" => -- 46                  
                    PrSl_RisData_s <= PrSv_RsiData_c(5);
                when x"02F" => -- 47                  
                    PrSl_RisData_s <= PrSv_RsiData_c(4);
                when x"030" => -- 48                  
                    PrSl_RisData_s <= PrSv_RsiData_c(3);
                when x"031" => -- 49                  
                    PrSl_RisData_s <= PrSv_RsiData_c(2);
                when x"032" => -- 50                  
                    PrSl_RisData_s <= PrSv_RsiData_c(1);
                when x"033" => -- 51                  
                    PrSl_RisData_s <= PrSv_RsiData_c(0);
                when others => 
                    PrSl_RisData_s <= '0';
            end case;
        end if;
    end process;
    
    -- PrSl_FalFrame_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_FalFrame_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then 
            if (PrSv_TestCyc_s = 20) then
                PrSl_FalFrame_s <= '1';
            elsif (PrSv_TestCyc_s = 28) then
                PrSl_FalFrame_s <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSl_FalData_s
    process (CpSl_Rst_iN,CpSl_Clk200M_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_FalData_s <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then 
            case PrSv_TestCyc_s is 
                -- Frame1
                when x"014" => -- 20
                    PrSl_FalData_s <= PrSv_FalData_c(31);
                when x"015" => -- 21
                    PrSl_FalData_s <= PrSv_FalData_c(30);
                when x"016" => -- 22
                    PrSl_FalData_s <= PrSv_FalData_c(29);
                when x"017" => -- 23
                    PrSl_FalData_s <= PrSv_FalData_c(28);
                when x"018" => -- 24
                    PrSl_FalData_s <= PrSv_FalData_c(27);
                when x"019" => -- 25
                    PrSl_FalData_s <= PrSv_FalData_c(26);
                when x"01A" => -- 26
                    PrSl_FalData_s <= PrSv_FalData_c(25);
                when x"01B" => -- 27
                    PrSl_FalData_s <= PrSv_FalData_c(24);
                when x"01C" => -- 28
                    PrSl_FalData_s <= PrSv_FalData_c(23);
                when x"01D" => -- 29                   
                    PrSl_FalData_s <= PrSv_FalData_c(22);
                when x"01E" => -- 30                   
                    PrSl_FalData_s <= PrSv_FalData_c(21);
                when x"01F" => -- 31                   
                    PrSl_FalData_s <= PrSv_FalData_c(20);
                when x"020" => -- 32                   
                    PrSl_FalData_s <= PrSv_FalData_c(19);
                when x"021" => -- 33
                    PrSl_FalData_s <= PrSv_FalData_c(18);
                when x"022" => -- 34                   
                    PrSl_FalData_s <= PrSv_FalData_c(17);
                when x"023" => -- 35                   
                    PrSl_FalData_s <= PrSv_FalData_c(16);
                when x"024" => -- 36                   
                    PrSl_FalData_s <= PrSv_FalData_c(15);
                when x"025" => -- 37                   
                    PrSl_FalData_s <= PrSv_FalData_c(14);
                when x"026" => -- 38                   
                    PrSl_FalData_s <= PrSv_FalData_c(13);
                when x"027" => -- 39                   
                    PrSl_FalData_s <= PrSv_FalData_c(12);
                when x"028" => -- 40                   
                    PrSl_FalData_s <= PrSv_FalData_c(11);
                when x"029" => -- 41                   
                    PrSl_FalData_s <= PrSv_FalData_c(10);
                when x"02A" => -- 42
                    PrSl_FalData_s <= PrSv_FalData_c(9);
                when x"02B" => -- 43                  
                    PrSl_FalData_s <= PrSv_FalData_c(8);
                when x"02C" => -- 44                  
                    PrSl_FalData_s <= PrSv_FalData_c(7);
                when x"02D" => -- 45                  
                    PrSl_FalData_s <= PrSv_FalData_c(6);
                when x"02E" => -- 46                  
                    PrSl_FalData_s <= PrSv_FalData_c(5);
                when x"02F" => -- 47                  
                    PrSl_FalData_s <= PrSv_FalData_c(4);
                when x"030" => -- 48                  
                    PrSl_FalData_s <= PrSv_FalData_c(3);
                when x"031" => -- 49                  
                    PrSl_FalData_s <= PrSv_FalData_c(2);
                when x"032" => -- 50                  
                    PrSl_FalData_s <= PrSv_FalData_c(1);
                when x"033" => -- 51                  
                    PrSl_FalData_s <= PrSv_FalData_c(0);
                    
                when others => 
                    PrSl_FalData_s <= '0';
            end case;
        end if;
    end process;
    
    ------------------------------------
    -- TDC_OutPut_Data
    ------------------------------------
--    CpSl_Frame2_o   <= PrSl_RisFrame_s;						                    -- TDC_GPX2_Frame1_low
--    CpSl_Frame1_o   <= PrSl_RisFrame_s;						                    -- TDC_GPX2_Frame2_30%
--    CpSl_Frame4_o   <= PrSl_FalFrame_s;						                    -- TDC_GPX2_Frame3_Low
--    CpSl_Frame3_o   <= PrSl_FalFrame_s;						                    -- TDC_GPX2_Frame4_30%
--    CpSl_Sdo2_o	    <= PrSl_RisData_s;				                            -- TDC_GPX2_SDO1
--    CpSl_Sdo1_o	    <= PrSl_RisData_s;					                        -- TDC_GPX2_SDO2
--    CpSl_Sdo4_o	    <= PrSl_FalData_s;					                        -- TDC_GPX2_SDO3
--    CpSl_Sdo3_o	    <= PrSl_FalData_s;					                        -- TDC_GPX2_SDO4
--                                                                    
--    CpSl_Frame5_o   <= '0';                                         -- TDC_GPX2_Frame5_50%
--    CpSl_Frame6_o   <= '0';                                         -- TDC_GPX2_Frame6_90%
--    CpSl_Frame7_o   <= '0';                                         -- TDC_GPX2_Frame7_50%
--    CpSl_Frame8_o   <= '0';                                         -- TDC_GPX2_Frame8_90%
--    CpSl_Sdo5_o     <= '0';                                         -- TDC_GPX2_SDO5
--    CpSl_Sdo6_o     <= '0';                                         -- TDC_GPX2_SDO6
--    CpSl_Sdo7_o     <= '0';                                         -- TDC_GPX2_SDO7
--    CpSl_Sdo8_o     <= '0';                                         -- TDC_GPX2_SDO8
    
    CpSl_Frame1_o   <= PrSl_RisFrame_s;						    -- TDC_GPX2_Frame1_low
    CpSl_Frame2_o   <= PrSl_RisFrame_s;						    -- TDC_GPX2_Frame2_30%
    CpSl_Frame3_o   <= PrSl_FalFrame_s;						    -- TDC_GPX2_Frame3_Low
    CpSl_Frame4_o   <= PrSl_FalFrame_s;						    -- TDC_GPX2_Frame4_30%
    CpSl_Sdo1_o	  <= PrSl_RisData_s;					        -- TDC_GPX2_SDO1
    CpSl_Sdo2_o	  <= PrSl_RisData_s;						    -- TDC_GPX2_SDO2
    CpSl_Sdo3_o	  <= PrSl_FalData_s;						    -- TDC_GPX2_SDO3
    CpSl_Sdo4_o	  <= PrSl_FalData_s;						    -- TDC_GPX2_SDO4

    CpSl_Frame5_o   <= PrSl_RisFrame_s;                         -- TDC_GPX2_Frame5_50%
    CpSl_Frame6_o   <= PrSl_RisFrame_s;                         -- TDC_GPX2_Frame6_90%
    CpSl_Frame7_o   <= PrSl_FalFrame_s;                         -- TDC_GPX2_Frame7_50%
    CpSl_Frame8_o   <= PrSl_FalFrame_s;                         -- TDC_GPX2_Frame8_90%
    CpSl_Sdo5_o     <= PrSl_RisData_s;                          -- TDC_GPX2_SDO5
    CpSl_Sdo6_o     <= PrSl_RisData_s;                          -- TDC_GPX2_SDO6
    CpSl_Sdo7_o     <= PrSl_FalData_s;                          -- TDC_GPX2_SDO7
    CpSl_Sdo8_o     <= PrSl_FalData_s;                          -- TDC_GPX2_SDO8
    
end arch_M_TestTdc;