library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

entity pulse_gen is 
    port(
        nrst                   :  IN std_logic;
        clk                    :  IN std_logic;
        enable                 :  IN std_logic;
        k_start_tick           :  IN std_logic;
        start1                 : OUT std_logic;
        start2                 : OUT std_logic;
        k_end_tick             : OUT std_logic;
        pulse_out_start        : OUT std_logic;
        pulse_out_rpi          : OUT std_logic;
        k_pulse_out            : OUT std_logic;
        start_tick             : OUT std_logic;
        k_period               :  IN std_logic_vector(19 downto 0);
        k_count                : OUT std_logic_vector(19 downto 0)
    );
end pulse_gen;

architecture rtl of pulse_gen is 
    ------------------------------------
    -- signal describe
    ------------------------------------
    signal state                        : std_logic_vector( 1 downto 0);
    signal count                        : std_logic_vector(11 downto 0);
    signal state_k                      : std_logic_vector( 1 downto 0);
    signal count_k                      : std_logic_vector(19 downto 0);
    signal start_tick_temp              : std_logic;
    signal start_flag                   : std_logic;
    signal state_rpi                    : std_logic_vector( 1 downto 0);
    signal odd_even_flag                : std_logic;


begin
    ------------------------------------
    -- Main Area
    ------------------------------------
    -- state_transition_rpi
    process (nrst,clk) begin 
        if(nrst = '0')then
            state_rpi <= "00";
        	odd_even_flag <= '0';
        elsif(clk'event and clk = '1')then
        case state_rpi is
            when "01" =>
                if(enable = '1')then
                    if(count >= X"002")then
                        state_rpi <= "10";
                    else
                        state_rpi <= "01";
                    end if;
                else
                    state_rpi <= "00";
                end if;
            when "10" =>
                if(enable = '1')then
                    if(count >= X"063")then   --Modified By Xia Bingbing To 100k 50000
                        state_rpi <= "01";
                        odd_even_flag <= not(odd_even_flag);
                    else
                        state_rpi <= "10";
                    end if;
                else
                    state_rpi <= "00";
                end if;
            when others =>
                if(enable = '1')then
                    state_rpi <= "01";
                else
                    odd_even_flag <= '0';
                    state_rpi <= "00";
                end if;
        end case; 
        end if;
    end process;	
    
    -- state_manipulation_rpi
    process (nrst,clk) begin 
        if(nrst = '0')then
            pulse_out_rpi <= '0';
        	start1        <= '0';
        	start2        <= '0';
        elsif(clk'event and clk = '1')then
        case state_rpi is
            when "01" =>
                pulse_out_rpi <= '1';
                if(odd_even_flag = '0')then
                    start1 <= '1';
                else
                    start2 <= '1';
                end if;
            when "10" =>
                start1 <= '0';
                start2 <= '0';
                pulse_out_rpi <= '0';
            when others =>
                start1 <= '0';
                start2 <= '0';
                pulse_out_rpi <= '0';
        end case;
        end if;
    end process;
    
    -- state_transition
    process (nrst,clk) begin
        if(nrst = '0')then
          state <= "00";
        elsif(clk'event and clk = '1')then
        case state is
            when "01" =>
                if(enable = '1')then
                    if(count >= X"014")then  --modified start
                        state <= "10";
                    else
                        state <= "01";
                    end if;
                else
                    state <= "00";
                end if;
            when "10" =>
                if(enable = '1')then
                    if(count >= X"063")then   --Modified By Xia Bingbing To 100k 50000
                        state <= "01";
                    else
                        state <= "10";
                    end if;
                else
                    state <= "00";
                end if;
            when others =>
                if(enable = '1')then
                    state <= "01";
                else
                    state <= "00";
                end if;
        end case;
        end if;
    end process;
	
  state_manipulation : process(clk,nrst)
  begin
    if(nrst = '0')then
      count           <= (others => '0');
      pulse_out_start <= '0';
      start_tick_temp <= '0';
      start_flag      <= '1';
    elsif(clk'event and clk = '1')then
      case state is
        when "01" =>
          pulse_out_start <= '1';
          if(state_k = "01" and start_flag = '1') then
            start_tick_temp <= '1';
            start_flag      <= '0';
          else
            start_tick_temp <= '0';
          end if;
          if(count = X"063")then                        --Modified By Xia Bingbing To 100k 50000
            count <= (others => '0');
          else
            count <= count + X"001";
          end if;
        when "10" =>
          start_flag      <= '1';
          pulse_out_start <= '0';
          start_tick_temp <= '0';
          if(count = X"063")then                       --Modified By Xia Bingbing To 100k 50000
            count <= (others => '0');
          else
            count <= count + X"001";
          end if;
        when others =>
          start_flag      <= '1';
          start_tick_temp <= '0';
          pulse_out_start <= '0';
          count <= (others => '0');
        end case;
      end if;
    end process;

  state_transition_k : process(clk,nrst)
  begin
    if(nrst = '0') then
      state_k <= "00";
    elsif(clk'event and clk = '1')then
      case state_k is
        when "01" =>
          if(enable = '0') then
            state_k <= "10"; 
          else
            state_k <= "01";
          end if;
        when "10" =>
          state_k <= "11";
        when "11" =>
          state_k <= "00";
        when others =>
          if(k_start_tick = '1')then
            state_k <= "01";
          else
            state_k <= "00";
          end if;
        end case;
      end if;
    end process;

  state_manipulation_k : process(clk,nrst)
  begin
    if(nrst = '0')then
      k_end_tick  <= '0';
      k_pulse_out <= '0';
      count_k     <= (others => '0');
    elsif(clk'event and clk = '1')then
      case state_k is
        when "01" =>
          if(count = X"054")then   --Modified By Xia Bingbing To 100k 50000
            k_pulse_out <= '1';
            if(count_k = k_period)then
              count_k <= X"00000";
            else
              count_k <= count_k + X"00001";
            end if;
          else
            k_pulse_out <= '0';
            count_k <= count_k;
          end if;
        when "10" =>
          k_end_tick <= '1';
          count_k <= (others => '0');
        when others =>
          k_end_tick <= '0';
          k_pulse_out <= '0';
          count_k <= (others => '0');
        end case;
      end if;
    end process;
  k_count    <= count_k;
  start_tick <= start_tick_temp;



end rtl;