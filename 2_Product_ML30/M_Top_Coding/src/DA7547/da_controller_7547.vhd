library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity da_controller_7547 is
    port(
        nrst                            :  in std_logic;
        clk                             :  in std_logic;
        da_mems_start_tick              :  in std_logic;
        agc_da_start_tick               :  in std_logic; 
        da_datax                        :  in std_logic_vector(11 downto 0);
        da_datay                        :  in std_logic_vector(11 downto 0);
        da_data_agc                     :  in std_logic_vector(11 downto 0);

        -------------------------------
        -- AD5447_Interface
        -------------------------------
        da_data                         : out std_logic_vector(11 downto 0);  -- DA5447_Data
        da_wr                           : out std_logic;
        da_sab                          : out std_logic;                      -- X/Y Channel
        da_cs1                          : out std_logic;                      -- X/Y CS1
        da_sc                           : out std_logic;                      -- Gain/9601Level Channel
        da_cs2                          : out std_logic;                      -- Gain/9601Level CS2
        da_finish                       : out std_logic
    );
end da_controller_7547;

architecture rtl of da_controller_7547 is
    signal agc_da_flag                  : std_logic;
    signal mems_da_flag                 : std_logic;
    signal state                        : std_logic_vector( 3 downto 0);
    signal da_datax_temp                : std_logic_vector(11 downto 0);
    signal da_datay_temp                : std_logic_vector(11 downto 0);
    signal da_agc_temp                  : std_logic_vector(11 downto 0);

begin
    -- state_transition_process
    process (clk,nrst) begin 
        if (nrst = '0') then
            state <= (others => '0');
        elsif rising_edge(clk) then
        case state is
            when "0001" => 
                if (agc_da_flag = '1' and mems_da_flag = '0') then
                    state <= "1010";
                elsif (agc_da_flag = '0' and mems_da_flag = '1') then
                    state <= "1011";
                elsif (agc_da_flag = '1' and mems_da_flag = '1') then
                    state <= "0011";
                else
                    state <= "0001";
                end if;
            
            when "1010" => -- AGC_Flag
                state <= "0010";

            when "0010" =>                            
                  state <= "0111";
                            
            when "1011" => -- Memscan_Flag
                state <= "0011";
            
            when "0011" => -- AGC & Memescan
                state <= "0100";
            
            when "0100" => 
                state <= "1101";
	        
	        when "1101" =>
                state <= "0101";	

            when "0101" =>
                state <= "0110";
       
            when "0110" =>
                if(agc_da_flag = '1')then
                    state <= "1010";
                else
                    state <= "0111";
                end if;
            
            when "0111" => -- Config_End
                if(agc_da_flag = '1' or mems_da_flag = '1')then
                    state <= "0001";
                else
                    state <= "0111";
                end if;
            
            when others =>
                if(da_mems_start_tick = '1' or agc_da_start_tick = '1')then
                    state <= "0001";
                else
                    state <= "0000";
                end if;
            end case;
        end if;
    end process;

    -- state_manipulation_process
    process (clk,nrst) begin
        if(nrst = '0')then
            agc_da_flag   <= '0';
            mems_da_flag  <= '0';
            da_datax_temp <= (others => '0');
            da_datay_temp <= (others => '0');
            da_agc_temp   <= (others => '0');
            
            da_data       <= (others => '0');
            da_wr         <= '1';
            da_sab        <= '1';
            da_cs1        <= '1';
            da_sc         <= '1';
            da_cs2        <= '1';
            da_finish     <= '0';

        elsif(clk'event and clk = '1')then
        case state is
            when "0001" =>
                da_wr  <= '1';
                da_sab <= '1';
                da_cs1 <= '1';
                da_sc  <= '1';
                da_cs2 <= '1';
                da_finish <= '0';
                
                if(da_mems_start_tick = '1')then
                    mems_da_flag <= '1'; 
                    da_datax_temp <= da_datax;
                    da_datay_temp <= da_datay;
                end if;
                
                if(agc_da_start_tick = '1')then
                    agc_da_flag <= '1';
                    da_agc_temp <= da_data_agc;
                end if;
		  
		    when "1010" =>  -- AGC_Flag
		        da_sc   <= '0'; 
                da_cs2  <= '0'; 
                da_wr   <= '0'; 
                da_data <= da_agc_temp;
                
            when "0010" =>
                agc_da_flag <= '0';
                da_finish   <= '1';
                 
		    when "1011" =>  -- X Point
		        da_wr     <= '0';
		        da_sab    <= '0';   
		        da_cs1    <= '0';   
		        da_sc     <= '1';   
		        da_cs2    <= '1';
                da_data <= da_datax_temp; 

            when "0011" =>
                da_wr   <= '0';
		        da_sab  <= '0';   
		        da_cs1  <= '0';   
		        da_sc   <= '1';   
		        da_cs2  <= '1';
                da_data <= da_datax_temp; 
                da_finish <= '0';
                                
                if(agc_da_start_tick = '1')then
                    agc_da_flag <= '1'; 
                    da_agc_temp <= da_data_agc;
                end if;
            
            when "0100" =>  -- CS --> ZERO
                da_wr     <= '1';
                da_sab    <= '1';
                da_cs1    <= '1';
                da_sc     <= '1';
                da_cs2    <= '1';
                da_finish <= '0';

                if(agc_da_start_tick = '1')then
                   agc_da_flag <= '1'; 
                   da_agc_temp <= da_data_agc;
                 end if;
                             
            when "1101" =>  -- Y Point
                da_wr   <= '0';
		        da_sab  <= '1';   
		        da_cs1  <= '0';   
		        da_sc   <= '1';   
		        da_cs2  <= '1';
                da_data <= da_datay_temp;
                
                
            when "0101" =>
                da_wr   <= '0';
		        da_sab  <= '1';   
		        da_cs1  <= '0';   
		        da_sc   <= '1';   
		        da_cs2  <= '1';
                da_data <= da_datay_temp;
                mems_da_flag <= '0';
                
                if(agc_da_start_tick = '1')then
                    agc_da_flag <= '1';
                    da_agc_temp <= da_data_agc;
                end if;

            when "0110" => -- -- CS --> ZERO
                da_wr     <= '1';
                da_sab    <= '1';
                da_cs1    <= '1';
                da_sc     <= '1';
                da_cs2    <= '1';
                da_finish <= '0';
                
                if(agc_da_start_tick = '1')then
                    agc_da_flag <= '1';
                    da_agc_temp <= da_data_agc;
                end if;
                
                if(da_mems_start_tick = '1')then
                    da_datax_temp <= da_datax;
                    da_datay_temp <= da_datay;
                    mems_da_flag <= '1';
                end if;
            
            when "0111" =>
                da_wr     <= '1';
                da_sab    <= '1';
                da_cs1    <= '1';
                da_sc     <= '1';
                da_cs2    <= '1';
                da_finish <= '0';
                
                if(da_mems_start_tick = '1')then
                    da_datax_temp <= da_datax;
                    da_datay_temp <= da_datay;
                    mems_da_flag <= '1';
                end if;
                
                if(agc_da_start_tick = '1')then
                    agc_da_flag <= '1';
                    da_agc_temp <= da_data_agc;
                end if;

            when others =>
                da_wr     <= '1';
                da_sab    <= '1';
                da_cs1    <= '1';
                da_sc     <= '1';
                da_cs2    <= '1';
                da_finish <= '0';
                
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

---------------------------------------------------------
-- End Coding
---------------------------------------------------------
end rtl;