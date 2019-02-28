--------------------------------------------------------------------------------
--           *****************          *****************
--                           **        **
--               ***          **      **           **
--              *   *          **    **           * *
--             *     *          **  **              *
--             *     *           ****               *
--             *     *          **  **              *
--              *   *          **    **             *
--               ***          **      **          *****
--                           **        **
--           *****************          *****************
--------------------------------------------------------------------------------
-- 版    权  :  BiXing Tech
-- 文件名称  :  M_Packge.vhd
-- 设    计  :  Wu Xiaopeng
-- 邮    件  :  zheng-jianfeng@139.com
-- 校    对  :
-- 设计日期  :  2017/01/29
-- 功能简述  :
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, Wu Xiaopeng, 2017/01/29
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

package M_Package is

    constant PrSl_RegNum_c              : std_logic_vector(29 downto 0) := "00" & x"000_0011";  -- Number of regester
    constant PrIn_DataDlyNum_c          : integer := 48;                                        -- Need to adjust
    constant PrIn_StackNum_c            : integer := 4;
    constant PrSv_RefPulseDeep_c        : std_logic_vector( 8 downto 0) := '1'&x"2C";           -- 300, Need to adjust
    constant PrSv_500usCnt_c            : std_logic_vector(14 downto 0) := "111" & x"EF3";      -- 
    constant PrSv_DmaLen_c              : std_logic_vector(19 downto 0) := x"9_99A0";           -- Byte
    constant PrSv_DmaTime_c             : std_logic_vector(24 downto 0) := '1' & x"EF_E920";    -- x"1EF_E920" Time of each dma that limits less than 500ms -- x"00_4680" for simulation
                                                                                                -- 65M clock
    constant PrSv_ShowOrigNum_c         : std_logic_vector(11 downto 0) := x"FFE";              -- 4095个采样点
    constant PrSv_CalcOrigDmaNum_c      : std_logic_vector( 7 downto 0) := x"FF";               -- 一次指令发256个包x"FF" -- x"05" for simulation
        
    type std_logic_vector_DlyNum_16     is array ((PrIn_DataDlyNum_c-1) downto 0) of std_logic_vector(15 downto 0);     -- Need to adjust, to make sure that the peak is in the range
    type std_logic_vector_DlyNum_6      is array ((PrIn_DataDlyNum_c-1) downto 0) of std_logic_vector( 5 downto 0);     -- Need to adjust, to make sure that the peak is in the range
    type std_logic_vector_StackNum_8    is array ((PrIn_StackNum_c-1) downto 0) of std_logic_vector( 7 downto 0);
    type std_logic_vector_StackNum_9    is array ((PrIn_StackNum_c-1) downto 0) of std_logic_vector( 8 downto 0);
    type std_logic_vector_StackNum_16   is array ((PrIn_StackNum_c-1) downto 0) of std_logic_vector(15 downto 0);
    type integer_StackNum               is array ((PrIn_StackNum_c-1) downto 0) of integer;
        
end M_Package;
    