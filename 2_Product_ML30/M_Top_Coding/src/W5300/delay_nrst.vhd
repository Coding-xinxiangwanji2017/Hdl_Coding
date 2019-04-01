library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity delay_nrst is
    generic (
        constant TIME_CNT : integer := 10	-- 复位延迟时间长度
	);
    port (
        clk                             : in  std_logic;
        nrst                            : in  std_logic;
		nrst_ctrl                       : in  std_logic;	-- '0'有效 
		tick_cnt                        : in  std_logic;	-- 计时时钟 
		CpSl_W5300Init_i                : in  std_logic;	                    -- W5300 Init
		
		--------------------------------
		-- nrst与nrst_ctrl均无效后，
		-- d_nrst延迟[tick_cnt*(TIME_CNT-1)+clk,tick_cnt*TIME_CNT+2*clk]  
		--------------------------------
		d_nrst                          : out std_logic
    );
end delay_nrst;

architecture arch_delay_nrst of delay_nrst is

    signal s_d_nrst                     : std_logic;
    signal s_cnt                        : std_logic_vector(3 downto 0);
--    signal s_cnt                        : integer range 0 to TIME_CNT + 1;

begin
    process (clk, nrst) begin
        if(nrst = '0') then
            s_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if(nrst_ctrl = '0') then
                s_cnt <= (others => '0');
            elsif (CpSl_W5300Init_i = '1') then 
                s_cnt <= (others => '0');
            elsif(s_cnt = TIME_CNT) then
                s_cnt <= conv_std_logic_vector(TIME_CNT,4);
            elsif (tick_cnt = '1') then 
                s_cnt <= s_cnt + 1;
            else -- hold
            end if;
        end if;
    end process;

    process (clk, nrst) begin
        if (nrst = '0') then 
            s_d_nrst <= '1';
        elsif rising_edge(clk) then 
            if (s_cnt = 2) then 
                s_d_nrst <= '0';
            elsif (s_cnt = TIME_CNT) then 
                s_d_nrst <= '1';
            else -- hold
    	    end if;
        end if;
    end process;
    
    -- d_nrst
    d_nrst <= s_d_nrst;
	
end arch_delay_nrst;