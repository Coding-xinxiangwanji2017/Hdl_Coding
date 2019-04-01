library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ad5242_ctrl is
port(
  nrst       :     in std_logic;
  clk        :     in std_logic;
  clk_tick   :     in std_logic;
  read_tick  :     in std_logic;
  write_tick :     in std_logic;
  finish_tick:    out std_logic;
  channel    :     in std_logic;
  write_data :     in std_logic_vector(7 downto 0);
  read_data  :    out std_logic_vector(7 downto 0);
  i2c_sda    :  inout std_logic;
  i2c_scl    :    out std_logic
);
end ad5242_ctrl;

architecture rtl of ad5242_ctrl is
  constant AD5242_IDLE         : std_logic_vector(3 downto 0) := "0000";
  constant AD5242_START1       : std_logic_vector(3 downto 0) := "0001";
  constant AD5242_START2       : std_logic_vector(3 downto 0) := "0010";
  constant AD5242_SDATA1       : std_logic_vector(3 downto 0) := "0011";
  constant AD5242_SDATA2       : std_logic_vector(3 downto 0) := "0100";
  constant AD5242_SDATA3       : std_logic_vector(3 downto 0) := "1011";
  constant AD5242_SDATA4       : std_logic_vector(3 downto 0) := "1100";
  constant AD5242_ACK1         : std_logic_vector(3 downto 0) := "0101";
  constant AD5242_ACK2         : std_logic_vector(3 downto 0) := "0110";
  constant AD5242_ACK3         : std_logic_vector(3 downto 0) := "1010";
  constant AD5242_ACK4         : std_logic_vector(3 downto 0) := "1110";
  constant AD5242_STOP1        : std_logic_vector(3 downto 0) := "0111";
  constant AD5242_STOP2        : std_logic_vector(3 downto 0) := "1000";
  constant AD5242_STOP3        : std_logic_vector(3 downto 0) := "1111";
  constant AD5242_STOP4        : std_logic_vector(3 downto 0) := "1101";
  constant AD5242_FINISH       : std_logic_vector(3 downto 0) := "1001";
  signal   bus_flag            : std_logic; 
  signal   write_read_flag     : std_logic;
  signal   word_count          : std_logic_vector(2 downto 0);
  signal   byte_count          : std_logic_vector(3 downto 0);
  signal   state               : std_logic_vector(3 downto 0);
  signal   error_flag          : std_logic;
  signal   sda_temp            : std_logic;
  signal   write_data0         : std_logic_vector(7 downto 0);
  signal   write_data1         : std_logic_vector(7 downto 0);
  signal   write_data2         : std_logic_vector(7 downto 0);
  signal   read_data_temp           : std_logic_vector(7 downto 0);
  signal   read_data0          : std_logic_vector(7 downto 0);
  signal   number              : std_logic;
  signal   ack_flag            : std_logic;
  
  signal test_flag : std_logic;

begin

  state_transition_process: process(clk,nrst)
  begin
    if(nrst = '0')then
      state <= "0000";
		ack_flag <= '0';
    elsif(clk'event and clk = '1')then
      case state is 
		  when AD5242_START1 =>
		    if(clk_tick = '1')then
			   state <= AD5242_SDATA1;--AD5242_START2;
			 else
			   state <= AD5242_START1;
			 end if;
		  when AD5242_START2 =>
		    if(clk_tick = '1')then
		      state <= AD5242_SDATA1;
			 else 
			   state <= AD5242_START2;
			 end if;
		  when AD5242_SDATA1 =>
		    ack_flag <= '0';
		    if(clk_tick = '1')then
		      state <= AD5242_SDATA2;
			 else 
			   state <= AD5242_SDATA1;
			 end if;
		  when AD5242_SDATA2 =>
		    if(clk_tick = '1')then
		      state <= AD5242_SDATA3;
			 else 
			   state <= AD5242_SDATA2;
			 end if;
		  when AD5242_SDATA3 =>
		    if(clk_tick = '1')then
		      state <= AD5242_SDATA4;
			 else 
			   state <= AD5242_SDATA3;
			 end if;
		  when AD5242_SDATA4 =>
		    if(clk_tick = '1')then
		      if(byte_count >= X"7")then
--			     if(write_read_flag = '0' and word_count >= "001")then
--				    state <= AD5242_STOP1;
--				  else  
			       state <= AD5242_ACK1;
--				  end if;
		      else
			     state <= AD5242_SDATA1;
			   end if;
			 else
			   state <= AD5242_SDATA4;
			 end if;
		  when AD5242_ACK1 =>
		    if(clk_tick = '1' and i2c_sda = '0')then
			   ack_flag <= '1';
				state <= AD5242_ACK2;
			 elsif(clk_tick = '1')then
			   state <= AD5242_ACK2;
			 else
			   state <= AD5242_ACK1;
			 end if;
		  when AD5242_ACK2 =>
		    if(clk_tick = '1' and i2c_sda = '0')then
			   ack_flag <= '1';
				state <= AD5242_ACK3;
			 elsif(clk_tick = '1')then
			   state <= AD5242_ACK3;
			 else
			   state <= AD5242_ACK2;
			 end if;
		  when AD5242_ACK3 =>
		    if(clk_tick = '1' and i2c_sda = '0')then
			   ack_flag <= '1';
				state <= AD5242_ACK4;
			 elsif(clk_tick = '1')then
			   state <= AD5242_ACK4;
			 else
			   state <= AD5242_ACK3;
			 end if;
		  when AD5242_ACK4 =>
		    if(clk_tick = '1' and ack_flag = '1')then
			   if(write_read_flag = '1' and word_count >= "010")then
		        state <= AD5242_STOP1;
				elsif(write_read_flag = '0' and word_count >= "001")then
		        state <= AD5242_STOP1;		
				else
				  state <= AD5242_SDATA1;
				end if; 
			 elsif(clk_tick = '1' and write_read_flag = '0' and word_count >= "001")then
				  state <= AD5242_STOP1;	
			 elsif(clk_tick = '1' and ack_flag = '0')then
			   state <= AD5242_FINISH;
			 else
			   state <= AD5242_ACK4;
			 end if;
		  
		  when AD5242_STOP1 =>
		    if(clk_tick = '1')then
			   state <= AD5242_STOP2;
			 else
			   state <= AD5242_STOP1;
			 end if;
		  when AD5242_STOP2 =>
		    if(clk_tick = '1')then
			   state <= AD5242_STOP3;
			 else
			   state <= AD5242_STOP2;
			 end if;
		  when AD5242_STOP3 =>
		    if(clk_tick = '1')then
			   state <= AD5242_STOP4;
			 else
			   state <= AD5242_STOP3;
			 end if;	 
			when AD5242_STOP4 =>
		    if(clk_tick = '1')then
			   state <= AD5242_FINISH;
			 else
			   state <= AD5242_STOP4;
			 end if;	 
		  when AD5242_FINISH =>
		    if(clk_tick = '1')then
		      state <= "0000";
			 else
			   state <= AD5242_FINISH;
			 end if;
		  when others =>
		    if(read_tick = '1' or write_tick = '1')then
			   state <= AD5242_START1;
			 else
			   state <= "0000";
			 end if;
		 end case;
	  end if;
	end process;
			 
  state_manipulation_process : process(clk,nrst)
  begin
    if(nrst = '0')then
      bus_flag         <= '1'; 
      write_read_flag  <= '0';
      word_count       <= (others => '0');
      byte_count       <= (others => '0');
      error_flag       <= '0';
		i2c_scl          <= '1';
		sda_temp         <= '1';
		write_data0      <= (others => '0');
		write_data1      <= (others => '0');
		write_data2      <= (others => '0');
		read_data0       <= (others => '0');
		number           <= '0';
		test_flag        <= '0';
    elsif(clk'event and clk = '1')then
      case state is
        when AD5242_START1 =>
          sda_temp         <= '0';
			 i2c_scl          <= '1';
			 bus_flag         <= '1';
			 word_count       <= "000"; --For Equal Length
			 byte_count       <= "1111"; --For Equal Length
		  when AD5242_START2 =>	 
			 sda_temp         <= '0';
			 i2c_scl          <= '0';
			 word_count       <= "000";
			 bus_flag         <= '1'; 
			 byte_count       <= "1111";
		  when AD5242_SDATA1 =>
		    if(write_read_flag = '1')then
			   bus_flag       <= '1';
			 elsif(write_read_flag = '0' and word_count = "000")then
			   bus_flag       <= '1';
			 else
			   bus_flag       <= '0';
			 end if;
			 i2c_scl          <= '0';
		  when  AD5242_SDATA2 =>
		    i2c_scl          <= '0';
			 if(write_read_flag = '1' and word_count = "000")then
			   sda_temp <= write_data0(7);
			 elsif(write_read_flag = '1' and word_count = "001")then
			   sda_temp <= write_data1(7);
		    elsif(write_read_flag = '1' and word_count = "010")then
			   sda_temp <= write_data2(7);
			 elsif(write_read_flag = '0' and word_count = "000")then
			   sda_temp <= read_data0(7);
			 end if;
			 if(clk_tick = '1')then
			   byte_count <= byte_count + "0001";
			 else
			   byte_count <= byte_count;
			 end if;
		  when  AD5242_SDATA3 =>
			 i2c_scl    <= '1';
        when  AD5242_SDATA4 =>
		    i2c_scl    <= '1';
			 if(clk_tick = '1' and write_read_flag = '0' and word_count = "001")then
			   read_data_temp <= (read_data_temp(6 downto 0) & i2c_sda);
			 elsif(clk_tick = '1' and write_read_flag = '1' and word_count = "000") then
			   write_data0 <= (write_data0(6)& write_data0(5 downto 0)&'0');
			 elsif(clk_tick = '1' and write_read_flag = '1' and word_count = "001") then
			   write_data1 <= (write_data1(6)& write_data1(5 downto 0)&'0');
		    elsif(clk_tick = '1' and write_read_flag = '1' and word_count = "010") then
			   write_data2 <= (write_data2(6)& write_data2(5 downto 0)&'0');
			 elsif(clk_tick = '1' and write_read_flag = '0' and word_count = "000")then
			   read_data0  <= (read_data0(6)& read_data0(5 downto 0)&'0');
			 end if;
		  when  AD5242_ACK1 =>
		    bus_flag   <= '0';
			 
			 i2c_scl    <= '0';
			 sda_temp   <= '0';
			 byte_count       <= "1111";
		  when  AD5242_ACK2 =>
		    bus_flag   <= '0';
			 i2c_scl    <= '0';
		  when  AD5242_ACK3 =>
		    bus_flag   <= '0';
			 i2c_scl    <= '1';
--			 if(clk_tick = '1')then
--		      word_count <= (word_count + "001");
--			 else
--			   word_count <= word_count;
--			 end if;
			 if(clk_tick = '1' and ack_flag = '1')then
			   error_flag  <= '0';
			 elsif(clk_tick = '1' and ack_flag = '0')then
			   error_flag  <= '1';
			 end if;
			 when  AD5242_ACK4 =>
		    bus_flag   <= '0';
			 i2c_scl    <= '1';
			 if(clk_tick = '1')then
		      word_count <= (word_count + "001");
			 else
			   word_count <= word_count;
			 end if;
			 if(clk_tick = '1' and ack_flag = '1')then
			   error_flag  <= '0';
			 elsif(clk_tick = '1' and ack_flag = '0')then
			   error_flag  <= '1';
			 end if;
		  when  AD5242_STOP1 =>
		    word_count       <= (others => '0');
          byte_count       <= (others => '0');
			 bus_flag       <= '1';
			 i2c_scl        <= '0';
			 sda_temp       <= '0';  
		  when  AD5242_STOP2 =>
		    bus_flag       <= '1';
			 i2c_scl        <= '0';
			 sda_temp       <= '0'; 
			 when  AD5242_STOP3 =>
		    bus_flag       <= '1';
			 i2c_scl        <= '1';
			 sda_temp       <= '0'; 
			 when  AD5242_STOP4 =>
		    bus_flag       <= '1';
			 i2c_scl        <= '1';
			 sda_temp       <= '1'; 
		  when AD5242_FINISH =>
		    bus_flag       <= '1';
			 i2c_scl        <= '1';
			 sda_temp       <= '1'; 
			 if(clk_tick = '1')then 
			   number         <= not(number);
			 else
			   number         <= number;
			 end if;
--			 if(test_flag = '0')then
--			   test_flag <= '1';
--			 else
--			   test_flag <= '0';
--				number         <= not(number);
--			 end if;
			 test_flag      <= '1';
        when others =>
--		    if(test_flag = '1')then
--			   write_read_flag <= '0';
--				read_data0      <= "01011001";
--          els
         if(write_tick = '1')then
			   write_read_flag <= '1';
				write_data0     <= "01011000";
				write_data1     <= (channel&"0000000");
				write_data2     <= write_data;
			 elsif(read_tick = '1')then
			   write_read_flag <= '0';
				read_data0      <= "01011001";
			 end if;
			 bus_flag         <= '1'; 
			 word_count       <= (others => '0');
          byte_count       <= (others => '0');
			 error_flag       <= '0';
        end case;
      end if;
    end process;
	 
	 i2c_sda <= sda_temp when bus_flag = '1' else 'Z';
	 

end rtl;
 
