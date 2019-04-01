library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity da_controller_7547 is
port(
  nrst                 :  in std_logic;
  clk                  :  in std_logic;
  da_mems_start_tick   :  in std_logic;
  agc_da_start_tick    :  in std_logic; 
  da_datax             :  in std_logic_vector(11 downto 0);
  da_datay             :  in std_logic_vector(11 downto 0);
  da_data_agc          :  in std_logic_vector(11 downto 0);
  da_data              : out std_logic_vector(11 downto 0);
  da_wr                : out std_logic;
  da_acs               : out std_logic;  -- X
  da_bcs               : out std_logic;  -- Y 
  da_ccs               : out std_logic;  -- Gain
  da_finish            : out std_logic
);
end da_controller_7547;

architecture rtl of da_controller_7547 is
  signal agc_da_flag  : std_logic;
  signal mems_da_flag : std_logic;
  signal state        : std_logic_vector(2 downto 0);
  signal count_wait    : std_logic_vector(3 downto 0);
  signal da_datax_temp : std_logic_vector(11 downto 0);
  signal da_datay_temp : std_logic_vector(11 downto 0);
  signal da_agc_temp   : std_logic_vector(11 downto 0);

begin
  state_transition_process : process(clk,nrst)
  begin
    if(nrst = '0')then
      state <= "000";
    elsif(clk'event and clk = '1')then
      case state is
        when "001" =>
          if(agc_da_flag = '1' and mems_da_flag = '0')then
            state <= "010";
          elsif(agc_da_flag = '0' and mems_da_flag = '1')then
            state <= "011";
          elsif(agc_da_flag = '1' and mems_da_flag = '1')then
            state <= "011";
          else
            state <= "001";
          end if;
       when "010" =>
         if(count_wait >= "0100")then
           state <= "111";
         else
           state <= "010";
         end if;
       when "011" =>
         if(count_wait >= "0100")then
           state <= "100";
         else
           state <= "011";
         end if;
       when "100" =>
         state <= "101";
       when "101" =>
         if(count_wait >= "0100")then
           state <= "110";
         else
           state <= "101";
         end if;
       when "110" =>
         if(agc_da_flag = '1')then
           state <= "010";
         else
           state <= "111";
         end if;
       when "111" =>
         if(agc_da_flag = '1' or mems_da_flag = '1')then
           state <= "001";
         else
           state <= "111";
         end if;
        when others =>
          if(da_mems_start_tick = '1' or agc_da_start_tick = '1')then
            state <= "001";
          else
            state <= "000";
          end if;
        end case;
    end if;
  end process;

  state_manipulation_process : process(clk,nrst)
  begin
    if(nrst = '0')then
      agc_da_flag   <= '0';
      mems_da_flag  <= '0';
      count_wait    <= (others => '0');
      da_datax_temp <= (others => '0');
      da_datay_temp <= (others => '0');
      da_agc_temp   <= (others => '0');
      da_finish     <= '0';
      da_acs        <= '1';
      da_bcs        <= '1';
      da_ccs        <= '1';
      da_wr         <= '1'; 
      da_data       <= (others => '0');
    elsif(clk'event and clk = '1')then
      case state is
        when "001" =>
          da_finish   <= '0';
          da_acs        <= '1';
          da_bcs        <= '1';
          da_ccs        <= '1'; 
          da_wr         <= '1'; 
          if(da_mems_start_tick = '1')then
            mems_da_flag <= '1'; 
            da_datax_temp <= da_datax;
            da_datay_temp <= da_datay;
          end if;
          if(agc_da_start_tick = '1')then
            agc_da_flag <= '1';
            da_agc_temp <= da_data_agc;
          end if;
          count_wait   <= (others => '0');
        when "010" =>
          da_ccs        <= '0'; 
          da_wr         <= '0'; 
          da_data       <= da_agc_temp;
          if(count_wait >= "0100")then
            agc_da_flag <= '0';
            da_finish   <= '1';
          else
            count_wait   <= count_wait + "0001";
          end if;
        when "011" =>
          da_ccs        <= '1'; 
          da_acs        <= '0';
          da_bcs        <= '1';
          da_wr         <= '0'; 
          da_data       <= da_datax_temp;
          da_finish   <= '0';
          count_wait   <= count_wait + "0001";
          if(agc_da_start_tick = '1')then
            agc_da_flag <= '1'; 
            da_agc_temp <= da_data_agc;
          end if;
       when "100" =>
         da_ccs        <= '1'; 
          da_acs        <= '1';
          da_bcs        <= '1';
          da_wr         <= '1'; 
         da_finish   <= '0';
         if(agc_da_start_tick = '1')then
            agc_da_flag <= '1'; 
            da_agc_temp <= da_data_agc;
          end if;
          count_wait   <= (others => '0');
        when "101" =>
          da_ccs        <= '1'; 
          da_acs        <= '1';
          da_bcs        <= '0';
          da_wr         <= '0'; 
          da_data       <= da_datay_temp;
          if(count_wait >= "0100")then
            mems_da_flag <= '0';
            da_finish <= '1';
          else
            count_wait   <= count_wait + "0001";
          end if;
          if(agc_da_start_tick = '1')then
            agc_da_flag <= '1';
            da_agc_temp <= da_data_agc;
          end if;
        when "110" => 
          da_finish   <= '0';
          da_ccs        <= '1'; 
          da_acs        <= '1';
          da_bcs        <= '1';
          da_wr         <= '1'; 
          if(agc_da_start_tick = '1')then
            agc_da_flag <= '1';
            da_agc_temp <= da_data_agc;
          end if;
          if(da_mems_start_tick = '1')then
            da_datax_temp <= da_datax;
            da_datay_temp <= da_datay;
            mems_da_flag <= '1';
          end if;
        when "111" =>  
          da_ccs        <= '1'; 
          da_acs        <= '1';
          da_bcs        <= '1';
          da_wr         <= '1'; 
          da_finish   <= '0';
          if(da_mems_start_tick = '1')then
            da_datax_temp <= da_datax;
            da_datay_temp <= da_datay;
            mems_da_flag <= '1';
          end if;
           if(agc_da_start_tick = '1')then
            agc_da_flag <= '1';
            da_agc_temp <= da_data_agc;
          end if;
          count_wait   <= (others => '0');
        when others =>
          da_ccs        <= '1'; 
          da_acs        <= '1';
          da_bcs        <= '1';
          da_wr         <= '1'; 
          da_finish   <= '0';
          if(da_mems_start_tick = '1')then
            da_datax_temp <= da_datax;
            da_datay_temp <= da_datay;
            mems_da_flag <= '1';
          else
            mems_da_flag <= '0';
          end if;
          if(agc_da_start_tick = '1')then
            agc_da_flag <= '1';
            da_agc_temp <= da_data_agc;
          else
            agc_da_flag <= '0';
          end if;
      end case;
    end if;
  end process;



  
end rtl;