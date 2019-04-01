library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_shdn is
  port(
    clk                :   in std_logic;	-- 40MHz 
    clk_1ms_tick       :   in std_logic;
    nrst               :   in std_logic;
    shdn               :  out std_logic
    );
end counter_shdn;

architecture rtl of counter_shdn is
 
  signal c_counter : std_logic_vector(7 downto 0);
  
begin
  counter_wait_shdn_process : process(clk,nrst)
  begin
    if(nrst = '0')then
      c_counter <= (others => '0');
      shdn      <= '0';
    elsif(clk'event and clk = '1')then
      if(c_counter >= X"64")then
        shdn <= '1';
      else
        c_counter <= c_counter + X"01";
        shdn <= '0';
      end if;
    end if;
  end process;
end rtl;