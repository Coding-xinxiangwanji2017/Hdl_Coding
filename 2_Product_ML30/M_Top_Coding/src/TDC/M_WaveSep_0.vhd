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
-- 文件名称  :  M_WaveSep.vhd
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
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_WaveSep is
    port (
        --------------------------------
        -- Reset & Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset,active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,single 200MHz

        --------------------------------
        -- Input_Data
        --------------------------------
        -- Valid_signal
        CpSl_VldD_i                     : out std_logic;                        -- Valid_Data
        
        -- Echo_Num
        CpSl_Echo1Vld_i                 : in  std_logic;                        -- Echo1_Valid
        CpSv_Echo1Num_i                 : in  std_logic_vector( 2 downto 0);    -- Echo1_Num
        CpSl_Echo2Vld_i                 : in  std_logic;                        -- Echo2_Valid
        CpSv_Echo2Num_i                 : in  std_logic_vector( 2 downto 0);    -- Echo2_Num
        CpSl_Echo3Vld_i                 : in  std_logic;                        -- Echo3_Valid
        CpSv_Echo3Num_i                 : in  std_logic_vector( 2 downto 0);    -- Echo3_Num   
        CpSv_AddrEcho1_i                : in  std_logic_vector( 4 downto 0);    -- Addr_Echo1
        CpSv_AddrEcho2_i                : in  std_logic_vector( 4 downto 0);    -- Addr_Echo2
        CpSv_AddrEcho3_i                : in  std_logic_vector( 4 downto 0);    -- Addr_Echo3

        -- Data
        CpSv_Data0_i                    : in  std_logic_vector(21 downto 0);    -- Data0  
        CpSv_Data1_i                    : in  std_logic_vector(21 downto 0);    -- Data1 
        CpSv_Data2_i                    : in  std_logic_vector(21 downto 0);    -- Data2 
        CpSv_Data3_i                    : in  std_logic_vector(21 downto 0);    -- Data3 
        CpSv_Data4_i                    : in  std_logic_vector(21 downto 0);    -- Data4 
        CpSv_Data5_i                    : in  std_logic_vector(21 downto 0);    -- Data5 
        CpSv_Data6_i                    : in  std_logic_vector(21 downto 0);    -- Data6 
        CpSv_Data7_i                    : in  std_logic_vector(21 downto 0);    -- Data7 
        CpSv_Data8_i                    : in  std_logic_vector(21 downto 0);    -- Data8 
        CpSv_Data9_i                    : in  std_logic_vector(21 downto 0);    -- Data9 
        CpSv_Data10_i                   : in  std_logic_vector(21 downto 0);    -- Data10
        CpSv_Data11_i                   : in  std_logic_vector(21 downto 0);    -- Data11
        CpSv_Data12_i                   : in  std_logic_vector(21 downto 0);    -- Data12
        CpSv_Data13_i                   : in  std_logic_vector(21 downto 0);    -- Data13
        CpSv_Data14_i                   : in  std_logic_vector(21 downto 0);    -- Data14
        CpSv_Data15_i                   : in  std_logic_vector(21 downto 0);    -- Data15
        CpSv_Data16_i                   : in  std_logic_vector(21 downto 0);    -- Data16
        CpSv_Data17_i                   : in  std_logic_vector(21 downto 0);    -- Data17
        CpSv_Data18_i                   : in  std_logic_vector(21 downto 0);    -- Data18
        CpSv_Data19_i                   : in  std_logic_vector(21 downto 0);    -- Data19
        CpSv_Data20_i                   : in  std_logic_vector(21 downto 0);    -- Data20
        CpSv_Data21_i                   : in  std_logic_vector(21 downto 0);    -- Data21
        CpSv_Data22_i                   : in  std_logic_vector(21 downto 0);    -- Data22
        CpSv_Data23_i                   : in  std_logic_vector(21 downto 0);    -- Data23

        --------------------------------
        -- OutPut_Data
        --------------------------------
        CpSv_Gray_o                     : out std_logic_vector(15 downto 0);    -- Gary
        CpSv_VldD_o                     : out std_logic;                        -- Valid
        CpSv_Echo1_o                    : out std_logic_vector(15 downto 0);    -- Echo1
        CpSv_Echo2_o                    : out std_logic_vector(15 downto 0);    -- Echo2
        CpSv_Echo3_o                    : out std_logic_vector(15 downto 0)     -- Echo3
    );
end M_WaveSep;

architecture arch_M_WaveSep of M_WaveSep is 
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- component dexcribe
    ----------------------------------------------------------------------------
    
    
    ----------------------------------------------------------------------------
    -- signal dexcribe
    ----------------------------------------------------------------------------
    -- Echo1
    signal PrSl_Echo1Vld_s              : std_logic;                            -- Echo1_Valid
    signal PrSv_Echo1_ID_s              : std_logic_vector( 7 downto 0);        -- Echo1_ID
    signal PrSv_Echo1_Data1             : std_logic_vector(21 downto 0);        -- Echo1_Data1
    signal PrSv_Echo1_Data2             : std_logic_vector(21 downto 0);        -- Echo1_Data2
    signal PrSv_Echo1_Data3             : std_logic_vector(21 downto 0);        -- Echo1_Data3
    signal PrSv_Echo1_Data4             : std_logic_vector(21 downto 0);        -- Echo1_Data4
    signal PrSv_Echo1_Data5             : std_logic_vector(21 downto 0);        -- Echo1_Data5
    signal PrSv_Echo1_Data6             : std_logic_vector(21 downto 0);        -- Echo1_Data6
    signal PrSv_Echo1_Data7             : std_logic_vector(21 downto 0);        -- Echo1_Data7
    signal PrSv_Echo1_Data8             : std_logic_vector(21 downto 0);        -- Echo1_Data8
    signal 
    
    -- Echo2
    signal PrSl_Echo2Vld_s              : std_logic;                            -- Echo2_Valid
    
    -- Echo3
    signal PrSl_Echo3Vld_s              : std_logic;                            -- Echo3_Valid


    signal PrSv_Gray_s                  : std_logic_vector(15 downto 0);        -- Gray_Data
    
begin
    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Echo_Valid
    ------------------------------------
    PrSl_Echo1Vld_s <= (CpSl_VldD_i and CpSl_Echo1Vld_i);
    PrSv_Echo1_ID_s <= CpSv_Echo1Num_i & CpSv_AddrEcho1_i;
    PrSl_Echo2Vld_s <= (CpSl_VldD_i and CpSl_Echo2Vld_i);
    PrSl_Echo3Vld_s <= (CpSl_VldD_i and CpSl_Echo3Vld_i);
        
    
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_Echo1_Data1 <= (others => '0');
            PrSv_Echo1_Data2 <= (others => '0');
            PrSv_Echo1_Data3 <= (others => '0');
            PrSv_Echo1_Data4 <= (others => '0');
            PrSv_Echo1_Data5 <= (others => '0');
            PrSv_Echo1_Data6 <= (others => '0');
            PrSv_Echo1_Data7 <= (others => '0');
            PrSv_Echo1_Data8 <= (others => '0');
            
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_Echo1Vld_s = '1') then
                PrSv_Echo1_Data1 <= (others => '0');
                PrSv_Echo1_Data2 <= (others => '0');
                PrSv_Echo1_Data3 <= (others => '0');
                PrSv_Echo1_Data4 <= (others => '0');
                PrSv_Echo1_Data5 <= (others => '0');
                PrSv_Echo1_Data6 <= (others => '0');
                PrSv_Echo1_Data7 <= (others => '0');
                PrSv_Echo1_Data8 <= (others => '0');
            else
                case PrSv_Echo1_ID_s is 
                    when x"20" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data0_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data1_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                            
                    when x"21" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data1_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data2_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                        
                    when x"22" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data2_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data3_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                            
                    when x"23" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data3_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data4_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                            
                    when x"24" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data4_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data5_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                            
                    when x"25" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data5_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data6_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"26" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data6_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data7_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                            
                    when x"27" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data7_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data8_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"28" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data8_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data9_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"29" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data9_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data10_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"2A" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data10_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data11_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"2B" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data11_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data12_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"2C" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data12_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data13_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"2D" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data13_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data14_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"2E" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data14_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data15_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"2F" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data15_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data16_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"30" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data16_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data17_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"31" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data17_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data18_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"32" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data18_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data19_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"33" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data19_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data20_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"34" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data20_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data21_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"35" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data21_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data22_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"36" => -- Vth_8%
                        PrSv_Echo1_Data1 <= CpSv_Data22_i;
                        PrSv_Echo1_Data2 <= (others => '0');
                        PrSv_Echo1_Data3 <= CpSv_Data23_i;
                        PrSv_Echo1_Data4 <= (others => '0');
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
--                    when x"37" => -- Vth_8%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    ----------------------------------------
                    -- Vth_8%/20%
                    ----------------------------------------
                    when x"60" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data0_i;
                        PrSv_Echo1_Data2 <= CpSv_Data1_i;
                        PrSv_Echo1_Data3 <= CpSv_Data3_i;
                        PrSv_Echo1_Data4 <= CpSv_Data2_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"61" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data1_i;
                        PrSv_Echo1_Data2 <= CpSv_Data2_i;
                        PrSv_Echo1_Data3 <= CpSv_Data4_i;
                        PrSv_Echo1_Data4 <= CpSv_Data3_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"62" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data2_i;
                        PrSv_Echo1_Data2 <= CpSv_Data3_i;
                        PrSv_Echo1_Data3 <= CpSv_Data5_i;
                        PrSv_Echo1_Data4 <= CpSv_Data4_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"63" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data3_i;
                        PrSv_Echo1_Data2 <= CpSv_Data4_i;
                        PrSv_Echo1_Data3 <= CpSv_Data6_i;
                        PrSv_Echo1_Data4 <= CpSv_Data5_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"64" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data4_i;
                        PrSv_Echo1_Data2 <= CpSv_Data5_i;
                        PrSv_Echo1_Data3 <= CpSv_Data7_i;
                        PrSv_Echo1_Data4 <= CpSv_Data6_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"65" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data5_i;
                        PrSv_Echo1_Data2 <= CpSv_Data6_i;
                        PrSv_Echo1_Data3 <= CpSv_Data8_i;
                        PrSv_Echo1_Data4 <= CpSv_Data7_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"66" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data6_i;
                        PrSv_Echo1_Data2 <= CpSv_Data7_i;
                        PrSv_Echo1_Data3 <= CpSv_Data9_i;
                        PrSv_Echo1_Data4 <= CpSv_Data8_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"67" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data7_i;
                        PrSv_Echo1_Data2 <= CpSv_Data8_i;
                        PrSv_Echo1_Data3 <= CpSv_Data10_i;
                        PrSv_Echo1_Data4 <= CpSv_Data9_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"68" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data8_i;
                        PrSv_Echo1_Data2 <= CpSv_Data9_i;
                        PrSv_Echo1_Data3 <= CpSv_Data11_i;
                        PrSv_Echo1_Data4 <= CpSv_Data10_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"69" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data9_i;
                        PrSv_Echo1_Data2 <= CpSv_Data10_i;
                        PrSv_Echo1_Data3 <= CpSv_Data12_i;
                        PrSv_Echo1_Data4 <= CpSv_Data11_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"6A" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data10_i;
                        PrSv_Echo1_Data2 <= CpSv_Data11_i;
                        PrSv_Echo1_Data3 <= CpSv_Data13_i;
                        PrSv_Echo1_Data4 <= CpSv_Data12_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"6B" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data11_i;
                        PrSv_Echo1_Data2 <= CpSv_Data12_i;
                        PrSv_Echo1_Data3 <= CpSv_Data14_i;
                        PrSv_Echo1_Data4 <= CpSv_Data13_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"6C" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data12_i;
                        PrSv_Echo1_Data2 <= CpSv_Data13_i;
                        PrSv_Echo1_Data3 <= CpSv_Data15_i;
                        PrSv_Echo1_Data4 <= CpSv_Data14_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"6D" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data13_i;
                        PrSv_Echo1_Data2 <= CpSv_Data14_i;
                        PrSv_Echo1_Data3 <= CpSv_Data16_i;
                        PrSv_Echo1_Data4 <= CpSv_Data15_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"6E" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data14_i;
                        PrSv_Echo1_Data2 <= CpSv_Data15_i;
                        PrSv_Echo1_Data3 <= CpSv_Data17_i;
                        PrSv_Echo1_Data4 <= CpSv_Data16_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"6F" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data15_i; 
                        PrSv_Echo1_Data2 <= CpSv_Data16_i; 
                        PrSv_Echo1_Data3 <= CpSv_Data18_i; 
                        PrSv_Echo1_Data4 <= CpSv_Data17_i; 
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"70" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data16_i;
                        PrSv_Echo1_Data2 <= CpSv_Data17_i;
                        PrSv_Echo1_Data3 <= CpSv_Data19_i;
                        PrSv_Echo1_Data4 <= CpSv_Data18_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"71" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data17_i;
                        PrSv_Echo1_Data2 <= CpSv_Data18_i;
                        PrSv_Echo1_Data3 <= CpSv_Data20_i;
                        PrSv_Echo1_Data4 <= CpSv_Data19_i;
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"72" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data18_i; 
                        PrSv_Echo1_Data2 <= CpSv_Data19_i; 
                        PrSv_Echo1_Data3 <= CpSv_Data21_i; 
                        PrSv_Echo1_Data4 <= CpSv_Data20_i; 
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"73" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data19_i; 
                        PrSv_Echo1_Data2 <= CpSv_Data20_i; 
                        PrSv_Echo1_Data3 <= CpSv_Data22_i; 
                        PrSv_Echo1_Data4 <= CpSv_Data21_i; 
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"74" => -- Vth_8%/20%
                        PrSv_Echo1_Data1 <= CpSv_Data20_i; 
                        PrSv_Echo1_Data2 <= CpSv_Data21_i; 
                        PrSv_Echo1_Data3 <= CpSv_Data23_i; 
                        PrSv_Echo1_Data4 <= CpSv_Data22_i; 
                        PrSv_Echo1_Data5 <= (others => '0');
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= (others => '0');
                        PrSv_Echo1_Data8 <= (others => '0');
                    
--                    when x"75" => -- Vth_8%/20%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"76" => -- Vth_8%/20%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"77" => -- Vth_8%/20% 
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
                    ----------------------------------------
                    -- Vth_8%/20%/50%   
                    ----------------------------------------
                    when x"A0" => -- Vth_8%/20%/50%
                        PrSv_Echo1_Data1 <= CpSv_Data0_i;
                        PrSv_Echo1_Data2 <= CpSv_Data1_i;
                        PrSv_Echo1_Data3 <= CpSv_Data5_i;
                        PrSv_Echo1_Data4 <= CpSv_Data4_i;
                        PrSv_Echo1_Data5 <= CpSv_Data2_i;
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= CpSv_Data3_i;
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A1" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data1_i;   
                        PrSv_Echo1_Data2 <= CpSv_Data2_i;   
                        PrSv_Echo1_Data3 <= CpSv_Data6_i;   
                        PrSv_Echo1_Data4 <= CpSv_Data5_i;   
                        PrSv_Echo1_Data5 <= CpSv_Data3_i;   
                        PrSv_Echo1_Data6 <= (others => '0');
                        PrSv_Echo1_Data7 <= CpSv_Data4_i;   
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A2" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data3_i;     
                        PrSv_Echo1_Data2 <= CpSv_Data4_i;     
                        PrSv_Echo1_Data3 <= CpSv_Data8_i;     
                        PrSv_Echo1_Data4 <= CpSv_Data7_i;     
                        PrSv_Echo1_Data5 <= CpSv_Data5_i;     
                        PrSv_Echo1_Data6 <= (others => '0');  
                        PrSv_Echo1_Data7 <= CpSv_Data5_i;     
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A3" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data4_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data5_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data9_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data8_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data6_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data7_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A4" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data5_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data6_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data10_i;   
                        PrSv_Echo1_Data4 <= CpSv_Data9_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data7_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data8_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A5" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data6_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data7_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data11_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data10_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data8_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data9_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A6" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data7_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data8_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data12_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data11_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data9_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data10_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A7" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data8_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data9_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data13_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data12_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data10_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data11_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A8" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data9_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data10_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data14_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data13_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data11_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data12_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"A9" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data10_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data11_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data15_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data14_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data12_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data13_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"AA" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data2_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data3_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data7_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data6_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data4_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data5_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"AB" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data11_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data12_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data16_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data15_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data13_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data14_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"AC" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data12_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data13_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data17_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data16_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data14_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data15_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"AD" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data13_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data14_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data18_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data17_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data15_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data16_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"AE" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data14_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data15_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data19_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data18_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data16_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data17_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"AF" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data15_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data16_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data20_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data19_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data17_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data18_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"B0" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data16_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data17_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data21_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data20_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data18_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data19_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"B1" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data17_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data18_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data22_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data21_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data19_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data20_i;
                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when x"B2" => -- Vth_8%/20%/50% 
                        PrSv_Echo1_Data1 <= CpSv_Data18_i;    
                        PrSv_Echo1_Data2 <= CpSv_Data19_i;    
                        PrSv_Echo1_Data3 <= CpSv_Data23_i;    
                        PrSv_Echo1_Data4 <= CpSv_Data22_i;    
                        PrSv_Echo1_Data5 <= CpSv_Data20_i;    
                        PrSv_Echo1_Data6 <= (others => '0'); 
                        PrSv_Echo1_Data7 <= CpSv_Data21_i;    
                        PrSv_Echo1_Data8 <= (others => '0');
                    
--                    when x"B3" => -- Vth_8%/20%/50% 
--                        PrSv_Echo1_Data1 <= CpSv_Data0_i;
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= CpSv_Data1_i;
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"B4" => -- Vth_8%/20%/50% 
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"B5" => -- Vth_8%/20%/50% 
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"B6" => -- Vth_8%/20%/50%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"B7" => -- Vth_8%/20%/50%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
                    ----------------------------------------
                    -- Vth_8%/20%/50%/90%
                    ----------------------------------------
                    when x"E0" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data0_i;
                        PrSv_Echo1_Data2 <= CpSv_Data1_i;
                        PrSv_Echo1_Data3 <= CpSv_Data7_i;
                        PrSv_Echo1_Data4 <= CpSv_Data6_i;
                        PrSv_Echo1_Data5 <= CpSv_Data2_i;
                        PrSv_Echo1_Data6 <= CpSv_Data3_i;
                        PrSv_Echo1_Data7 <= CpSv_Data5_i;
                        PrSv_Echo1_Data8 <= CpSv_Data4_i;
                    
                    when x"E1" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data1_i;
                        PrSv_Echo1_Data2 <= CpSv_Data2_i;
                        PrSv_Echo1_Data3 <= CpSv_Data8_i;
                        PrSv_Echo1_Data4 <= CpSv_Data7_i;
                        PrSv_Echo1_Data5 <= CpSv_Data3_i;
                        PrSv_Echo1_Data6 <= CpSv_Data4_i;
                        PrSv_Echo1_Data7 <= CpSv_Data6_i;
                        PrSv_Echo1_Data8 <= CpSv_Data5_i;
                    
                    when x"E2" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data2_i;
                        PrSv_Echo1_Data2 <= CpSv_Data3_i;
                        PrSv_Echo1_Data3 <= CpSv_Data9_i;
                        PrSv_Echo1_Data4 <= CpSv_Data8_i;
                        PrSv_Echo1_Data5 <= CpSv_Data4_i;
                        PrSv_Echo1_Data6 <= CpSv_Data5_i;
                        PrSv_Echo1_Data7 <= CpSv_Data7_i;
                        PrSv_Echo1_Data8 <= CpSv_Data6_i;
                    
                    when x"E3" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data3_i;
                        PrSv_Echo1_Data2 <= CpSv_Data4_i;
                        PrSv_Echo1_Data3 <= CpSv_Data10_i;
                        PrSv_Echo1_Data4 <= CpSv_Data9_i;
                        PrSv_Echo1_Data5 <= CpSv_Data5_i;
                        PrSv_Echo1_Data6 <= CpSv_Data6_i;
                        PrSv_Echo1_Data7 <= CpSv_Data8_i;
                        PrSv_Echo1_Data8 <= CpSv_Data7_i;
                    
                    when x"E4" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data4 _i;
                        PrSv_Echo1_Data2 <= CpSv_Data5 _i;
                        PrSv_Echo1_Data3 <= CpSv_Data11_i;
                        PrSv_Echo1_Data4 <= CpSv_Data10_i;
                        PrSv_Echo1_Data5 <= CpSv_Data6 _i;
                        PrSv_Echo1_Data6 <= CpSv_Data7 _i;
                        PrSv_Echo1_Data7 <= CpSv_Data9 _i;
                        PrSv_Echo1_Data8 <= CpSv_Data8 _i;
                    
                    when x"E5" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data5 _i;
                        PrSv_Echo1_Data2 <= CpSv_Data6 _i;
                        PrSv_Echo1_Data3 <= CpSv_Data12_i;
                        PrSv_Echo1_Data4 <= CpSv_Data11_i;
                        PrSv_Echo1_Data5 <= CpSv_Data7 _i;
                        PrSv_Echo1_Data6 <= CpSv_Data8 _i;
                        PrSv_Echo1_Data7 <= CpSv_Data10_i;
                        PrSv_Echo1_Data8 <= CpSv_Data9 _i;
                    
                    when x"E6" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data6 _i;
                        PrSv_Echo1_Data2 <= CpSv_Data7 _i;
                        PrSv_Echo1_Data3 <= CpSv_Data13_i;
                        PrSv_Echo1_Data4 <= CpSv_Data12_i;
                        PrSv_Echo1_Data5 <= CpSv_Data8 _i;
                        PrSv_Echo1_Data6 <= CpSv_Data9 _i;
                        PrSv_Echo1_Data7 <= CpSv_Data11_i;
                        PrSv_Echo1_Data8 <= CpSv_Data10_i;
                    
                    when x"E7" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data7 _i;
                        PrSv_Echo1_Data2 <= CpSv_Data8 _i;
                        PrSv_Echo1_Data3 <= CpSv_Data14_i;
                        PrSv_Echo1_Data4 <= CpSv_Data13_i;
                        PrSv_Echo1_Data5 <= CpSv_Data9 _i;
                        PrSv_Echo1_Data6 <= CpSv_Data10_i;
                        PrSv_Echo1_Data7 <= CpSv_Data12_i;
                        PrSv_Echo1_Data8 <= CpSv_Data11_i;
                    
                    when x"E8" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data8 _i; 
                        PrSv_Echo1_Data2 <= CpSv_Data9 _i; 
                        PrSv_Echo1_Data3 <= CpSv_Data15_i; 
                        PrSv_Echo1_Data4 <= CpSv_Data14_i; 
                        PrSv_Echo1_Data5 <= CpSv_Data10_i; 
                        PrSv_Echo1_Data6 <= CpSv_Data11_i; 
                        PrSv_Echo1_Data7 <= CpSv_Data13_i; 
                        PrSv_Echo1_Data8 <= CpSv_Data12_i; 
                    
                    when x"E9" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data9 _i;
                        PrSv_Echo1_Data2 <= CpSv_Data10_i;
                        PrSv_Echo1_Data3 <= CpSv_Data16_i;
                        PrSv_Echo1_Data4 <= CpSv_Data15_i;
                        PrSv_Echo1_Data5 <= CpSv_Data11_i;
                        PrSv_Echo1_Data6 <= CpSv_Data12_i;
                        PrSv_Echo1_Data7 <= CpSv_Data14_i;
                        PrSv_Echo1_Data8 <= CpSv_Data13_i;
                    
                    when x"EA" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data10_i;
                        PrSv_Echo1_Data2 <= CpSv_Data11_i;
                        PrSv_Echo1_Data3 <= CpSv_Data17_i;
                        PrSv_Echo1_Data4 <= CpSv_Data16_i;
                        PrSv_Echo1_Data5 <= CpSv_Data12_i;
                        PrSv_Echo1_Data6 <= CpSv_Data13_i;
                        PrSv_Echo1_Data7 <= CpSv_Data15_i;
                        PrSv_Echo1_Data8 <= CpSv_Data14_i;
                    
                    when x"EB" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data11_i;
                        PrSv_Echo1_Data2 <= CpSv_Data12_i;
                        PrSv_Echo1_Data3 <= CpSv_Data18_i;
                        PrSv_Echo1_Data4 <= CpSv_Data17_i;
                        PrSv_Echo1_Data5 <= CpSv_Data13_i;
                        PrSv_Echo1_Data6 <= CpSv_Data14_i;
                        PrSv_Echo1_Data7 <= CpSv_Data16_i;
                        PrSv_Echo1_Data8 <= CpSv_Data15_i;
                    
                    when x"EC" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data12_i;
                        PrSv_Echo1_Data2 <= CpSv_Data13_i;
                        PrSv_Echo1_Data3 <= CpSv_Data19_i;
                        PrSv_Echo1_Data4 <= CpSv_Data18_i;
                        PrSv_Echo1_Data5 <= CpSv_Data14_i;
                        PrSv_Echo1_Data6 <= CpSv_Data15_i;
                        PrSv_Echo1_Data7 <= CpSv_Data17_i;
                        PrSv_Echo1_Data8 <= CpSv_Data16_i;
                    
                    when x"ED" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data13_i;
                        PrSv_Echo1_Data2 <= CpSv_Data14_i;
                        PrSv_Echo1_Data3 <= CpSv_Data20_i;
                        PrSv_Echo1_Data4 <= CpSv_Data19_i;
                        PrSv_Echo1_Data5 <= CpSv_Data15_i;
                        PrSv_Echo1_Data6 <= CpSv_Data16_i;
                        PrSv_Echo1_Data7 <= CpSv_Data18_i;
                        PrSv_Echo1_Data8 <= CpSv_Data17_i;
                    
                    when x"EE" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data14_i; 
                        PrSv_Echo1_Data2 <= CpSv_Data15_i; 
                        PrSv_Echo1_Data3 <= CpSv_Data21_i; 
                        PrSv_Echo1_Data4 <= CpSv_Data20_i; 
                        PrSv_Echo1_Data5 <= CpSv_Data16_i; 
                        PrSv_Echo1_Data6 <= CpSv_Data17_i; 
                        PrSv_Echo1_Data7 <= CpSv_Data19_i; 
                        PrSv_Echo1_Data8 <= CpSv_Data18_i; 
                    
                    when x"EF" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data15_i;
                        PrSv_Echo1_Data2 <= CpSv_Data16_i;
                        PrSv_Echo1_Data3 <= CpSv_Data22_i;
                        PrSv_Echo1_Data4 <= CpSv_Data21_i;
                        PrSv_Echo1_Data5 <= CpSv_Data17_i;
                        PrSv_Echo1_Data6 <= CpSv_Data18_i;
                        PrSv_Echo1_Data7 <= CpSv_Data20_i;
                        PrSv_Echo1_Data8 <= CpSv_Data19_i;
                    
                    when x"F0" => -- Vth_8%/20%/50%/90%
                        PrSv_Echo1_Data1 <= CpSv_Data16_i;
                        PrSv_Echo1_Data2 <= CpSv_Data17_i;
                        PrSv_Echo1_Data3 <= CpSv_Data23_i;
                        PrSv_Echo1_Data4 <= CpSv_Data22_i;
                        PrSv_Echo1_Data5 <= CpSv_Data18_i;
                        PrSv_Echo1_Data6 <= CpSv_Data19_i;
                        PrSv_Echo1_Data7 <= CpSv_Data21_i;
                        PrSv_Echo1_Data8 <= CpSv_Data20_i;
                    
--                    when x"F1" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"F2" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"F3" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"F4" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"F5" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"F6" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
--                    
--                    when x"F7" => -- Vth_8%/20%/50%/90%
--                        PrSv_Echo1_Data1 <= (others => '0');
--                        PrSv_Echo1_Data2 <= (others => '0');
--                        PrSv_Echo1_Data3 <= (others => '0');
--                        PrSv_Echo1_Data4 <= (others => '0');
--                        PrSv_Echo1_Data5 <= (others => '0');
--                        PrSv_Echo1_Data6 <= (others => '0');
--                        PrSv_Echo1_Data7 <= (others => '0');
--                        PrSv_Echo1_Data8 <= (others => '0');
                    
                    when others => 
                        PrSv_Echo1_Data1 <= (others =-> '0');
                        PrSv_Echo1_Data2 <= (others =-> '0');
                        PrSv_Echo1_Data3 <= (others =-> '0');
                        PrSv_Echo1_Data4 <= (others =-> '0');
                        PrSv_Echo1_Data5 <= (others =-> '0');
                        PrSv_Echo1_Data6 <= (others =-> '0');
                        PrSv_Echo1_Data7 <= (others =-> '0');
                        PrSv_Echo1_Data8 <= (others =-> '0');
                end case;
            else -- hold
            end if;
        end if;
    end process;




    -- Gray_Data
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSv_Gray_o <= (others => '0');
            CpSv_VldD_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            CpSv_Gray_o <= (others => '0');
            CpSv_VldD_o <= (others => '0');
        end if;
    end process; 
    
    
    ----------------------------------------------------------------------------
    -- End_Coding
    ----------------------------------------------------------------------------
end arch_M_WaveSep;                     