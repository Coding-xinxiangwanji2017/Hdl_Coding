library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity adc_ltc2324_16_controller is
    port (
        clk                :   in std_logic;
        nrst               :   in std_logic;
        start_tick         :   in std_logic;
        sck_out            :  out std_logic;
        sck_in             :   in std_logic;
        sdi0               :   in std_logic;
        sdi1               :   in std_logic;
        sdi2               :   in std_logic;
        sdi3               :   in std_logic;
        end_tick           :  out std_logic;
        
        CpSl_CapApdTrig_i               :  in  std_logic;
        CpSl_CapApdVld_o                :  out std_logic;
        ad_data0           :  out std_logic_vector(15 downto 0);
        ad_data1           :  out std_logic_vector(15 downto 0);
        ad_data2           :  out std_logic_vector(15 downto 0);
        ad_data3           :  out std_logic_vector(15 downto 0);
        covn               :  out std_logic
    );
end adc_ltc2324_16_controller;

architecture rtl of adc_ltc2324_16_controller is

signal  counter_wait : std_logic_vector( 7 downto 0);   
signal  state        : std_logic_vector( 2 downto 0);
signal  counter_bit  : std_logic_vector( 4 downto 0);
signal  data0_temp   : std_logic_vector(15 downto 0);
signal  data1_temp   : std_logic_vector(15 downto 0);
signal  data2_temp   : std_logic_vector(15 downto 0);
signal  data3_temp   : std_logic_vector(15 downto 0);
signal  sckin_prev   : std_logic;
signal PrSv_EndTrigCnt_s                : std_logic_vector(1 downto 0);

  signal PrSv_SckVld_s                : std_logic;
  signal PrSl_ApdVolVld_s               : std_logic;
  
  signal PrSl_TempVld_s                 : std_logic;



begin
    -- PrSl_ApdVolVld_s
    process (clk,nrst) begin 
        if (nrst = '0') then
            PrSl_ApdVolVld_s <= '0';
        elsif rising_edge(clk) then
            if (CpSl_CapApdTrig_i = '1') then
                PrSl_ApdVolVld_s <= '1';
            elsif (state = "111" and PrSv_EndTrigCnt_s = 2) then
                PrSl_ApdVolVld_s <= '0';
            end if;
        end if;
    end process;
    
    -- Temp&x/Y
    process (clk,nrst) begin 
        if (nrst = '0') then
            PrSl_TempVld_s <= '0';
        elsif rising_edge(clk) then
            if (start_tick = '1') then
                PrSl_TempVld_s <= '1';
            elsif (state = "111" and PrSv_EndTrigCnt_s = 2) then
                PrSl_TempVld_s <= '0';
            end if;
        end if;
    end process;
    

  prev_process : process(clk,nrst)
  begin
    if(nrst = '0')then
      sckin_prev <= '0';
    elsif(clk'event and clk = '1')then
      sckin_prev <= sck_in;
    end if;
  end process;
  
  state_transition_process : process(clk,nrst)
  begin
    if(nrst = '0') then 
      state <= "000";
    elsif(clk'event and clk = '1')then
      case state is
        when "001" =>
          state <= "010";
        when "010" =>
          if(counter_wait >= X"14") then
            --state <= "011";
            state <= "110";
          else
            state <= "010";
          end if;
        
        --------change20180808_zhangwenjun----
          when "110" =>
          if(counter_bit >= "10000")then
            state <= "111";
          else  -- hold
          end if; 
        --------change20180808_zhangwenjun----
--        when "011" =>
--          --state <= "100";
--			 state <= "110";
----        when "100" =>
----          state <= "101";
----        when "101" =>
----          state <= "110";
--        when "110" =>
--          if(counter_bit >= "10000")then
--            state <= "111";
--          else
--            state <= "011";
--          end if;
        --------change20180808_zhangwenjun----
        when "111" =>
            if (PrSv_EndTrigCnt_s = 3) then 
                state <= "000";
            else -- hold
            end if;
        when others =>
          if(PrSl_TempVld_s = '1' or PrSl_ApdVolVld_s = '1')then
            state <= "001";
          else
            state <= "000";
          end if;
      end case;
    end if;
  end process;


    state_manipulation_process : process(clk,nrst)
  begin
    if(nrst = '0') then 
      PrSv_SckVld_s <= '0';      
      end_tick      <= '0';
      data0_temp    <= (others => '0');
      data1_temp    <= (others => '0');
      data2_temp    <= (others => '0');
      data3_temp    <= (others => '0');
      covn          <= '1';
      counter_wait <= (others => '0');
      counter_bit  <= (others => '0');
        PrSv_EndTrigCnt_s <= (others => '0');
        CpSl_CapApdVld_o <= '0';
    elsif(clk'event and clk = '1')then
      case state is
        when "001" =>
          covn  <= '0'; 
          PrSv_SckVld_s <= '0';
        when "010" =>
          PrSv_SckVld_s <= '0';
          counter_wait <=  (counter_wait + X"01");
    --    when "011" =>
    --      sck_out      <= '1';
			 --counter_bit  <= (counter_bit + "00001"); 
        when "110" =>
            counter_bit  <= (counter_bit + "00001"); 
            PrSv_SckVld_s <= '1';
            end_tick      <= '0';
            CpSl_CapApdVld_o <= '0';
            data0_temp <= (data0_temp(14 downto 0) & sdi0);
            data1_temp <= (data1_temp(14 downto 0) & sdi1);
            data2_temp <= (data2_temp(14 downto 0) & sdi2);
            data3_temp <= (data3_temp(14 downto 0) & sdi3);

        when "111" =>
            PrSv_SckVld_s <= '0';
            PrSv_EndTrigCnt_s <= PrSv_EndTrigCnt_s + '1';
            
            -- CpSl_CapApdVld_o
            if (PrSl_ApdVolVld_s = '1') then
                CpSl_CapApdVld_o <= '1';
            else 
                CpSl_CapApdVld_o <= '0';
            end if;
            
            -- End_Tick
            if (PrSl_TempVld_s = '1') then
                end_tick <= '1';
            else 
                end_tick <= '0';
            end if;
            
            -- Data
--            ad_data0 <=  data0_temp;
--            ad_data1 <=  data1_temp;
--            ad_data2 <=  data2_temp;
--            ad_data3 <=  data3_temp; 

        when others =>
            covn         <= '1'; 
            end_tick     <= '0';
            counter_wait <= (others => '0');
            counter_bit  <= (others => '0');
            PrSv_EndTrigCnt_s <= (others => '0');
      end case;
    end if;
  end process;

    -- PrSv_SckVld_s
    sck_out <= clk when (PrSv_SckVld_s = '1') else '0';

    -- Data
	ad_data0 <= data0_temp;
	ad_data1 <= data1_temp;
	ad_data2 <= data2_temp;
	ad_data3 <= data3_temp;

end rtl;