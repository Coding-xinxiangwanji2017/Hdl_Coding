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
-- ��    Ȩ  :  ZVISION
-- �ļ�����  :  ctrlCycle_simple.vhd
-- ��    ��  :  xx
-- ��    ��  :  Email
-- У    ��  :
-- �������  :  2018/05/17
-- ���ܼ���  :  
-- �汾���  :  0.1
-- �޸���ʷ  :  1. Initial, xx, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ctrlCycle_simple is
    generic(
        --��λ��Чֵ 
        constant RstValidValue	        : std_logic := '0';	
        constant DATAWIDTH	            : integer range 1 to    16 := 8;
        constant RST_DIV	            : integer range 1 to 65535 := 9			--n+1 ��Ƶ,Ĭ��ֵ������Ϊ0
    ); 
    port (
        nrst                            : in  std_logic;
        clk                             : in  std_logic;
        enable                          : in  std_logic;   	--	'1' is enable
        clk_tick                        : out std_logic
    );
end ctrlCycle_simple;

architecture rtl of ctrlCycle_simple is
    constant ZEROCNT                    : std_logic_vector(DATAWIDTH-1 downto 0) := (others => '0');	
    signal cnt                          : std_logic_vector(DATAWIDTH-1 downto 0);
    signal tick                         : std_logic;
    
begin
    process (nrst,clk) begin
        if (nrst = RstValidValue) then
            cnt	<= CONV_STD_LOGIC_VECTOR(RST_DIV,DATAWIDTH);				--������һ��Ĭ��ֵ
        elsif rising_edge(clk) then
            if (cnt = ZEROCNT) then
                cnt <= CONV_STD_LOGIC_VECTOR(RST_DIV,DATAWIDTH);
            else
                cnt <= cnt - '1';
            end if;		
        end if;	
    end process;	
    
    process (nrst,clk) begin
        if (nrst = RstValidValue) then
            tick <= '0';				
        elsif rising_edge(clk) then
            if (cnt = ZEROCNT and enable = '1') then     
                tick <=	'1';
            else
                tick <=	'0';
            end if;		
        end if;	
    end process;
    -- clk_tick
    clk_tick <= tick;
    
end rtl;