----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Bingbing Xia
-- 
-- Create Date:    29/10/2017 
-- Design Name: 
-- Module Name:    state_control_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity state_control_top is
    generic (
        PrSl_Sim_c                      : integer := 1                          -- Simulation
    );
    port (
        --------------------------------
        -- Clock & Reaet
        --------------------------------
        nrst                            :  in  std_logic;
        clk                             :  in  std_logic;
        
        --------------------------------
        -- Tick
        --------------------------------
        clk_125k_tick                   :  in  std_logic;
        clk_1ms_tick                    :  in  std_logic;
        
        --------------------------------
        -- UDP_Start & Reset
        --------------------------------
        start_tick                      : in  std_logic;                        -- UDP_Recv_Data_Start_Trig
        soft_reset_tick                 : in  std_logic;                        -- UDP_End_Trig
        
        --------------------------------
        -- Memory Data for DA7547 
        --------------------------------
        mem_dax                         : in  std_logic_vector(11 downto 0);
        mem_day                         : in  std_logic_vector(11 downto 0);
        mem_dastart                     : in  std_logic;
        
        --------------------------------
        -- W5300_Interface
        --------------------------------
        laser_rpi_start_start           : out std_logic;
        pic_tdc_procedure_start         : out std_logic;
        
        --------------------------------
        -- W5300_Interface
        --------------------------------
        w5300_nrst_ctrl                 : out std_logic;
        w5300_init_start                : out std_logic;
--        w5300_init_finish               : in  std_logic;
        w5300_init_result               : in  std_logic;
        CpSl_W5300InitSucc_i            : in  std_logic;
        initial_done_i                  : in  std_logic;
        --------------------------------
        -- DA7547_Interface
        --------------------------------
        da_datax                        : out std_logic_vector(11 downto 0);
        da_datay                        : out std_logic_vector(11 downto 0);
        da_start                        : out std_logic;
        da_finish                       : in  std_logic 
    );
end state_control_top;

architecture rtl of state_control_top is
    constant IDLE                         : std_logic_vector(5 downto 0) := "000000";
    constant STOP                         : std_logic_vector(5 downto 0) := "000001";
    constant PIC_MAKE_WAIT                : std_logic_vector(5 downto 0) := "000010";
    constant W5300_InitSucc               : std_logic_vector(5 downto 0) := "000011";
    constant W5300_INIT                   : std_logic_vector(5 downto 0) := "000100";
    constant W5300_WAIT                   : std_logic_vector(5 downto 0) := "000101";
    constant PIC_MAKE_DA_START_TICK       : std_logic_vector(5 downto 0) := "000110";
    constant PIC_MAKE_DA_WAIT             : std_logic_vector(5 downto 0) := "000111";
    constant PULSE_GEN                    : std_logic_vector(5 downto 0) := "001000";
    constant INITIAL_START_LOW            : std_logic_vector(5 downto 0) := "001001";
    constant LASER_PLE_HIGH               : std_logic_vector(5 downto 0) := "001010";
    constant PIC_TDC_PROCEDURE_START_TICK : std_logic_vector(5 downto 0) := "001011";
    constant PIC_TDC_PROCEDURE_WAIT       : std_logic_vector(5 downto 0) := "001100";
    constant W5300_NRST                   : std_logic_vector(5 downto 0) := "001101";
    constant W5300_NRST_WAIT              : std_logic_vector(5 downto 0) := "001110";
    constant LASER_GSE_LOW                : std_logic_vector(5 downto 0) := "001111";
    constant INITIAL_HIGH                 : std_logic_vector(5 downto 0) := "010000";
    constant LASER_RPI_LOW                : std_logic_vector(5 downto 0) := "010001";
    constant MEMS_RESET_DA_START_TICK     : std_logic_vector(5 downto 0) := "010010";
    constant MEMS_RESET_DA_WAIT           : std_logic_vector(5 downto 0) := "010011";
    constant MEMS_RESET_DA_NOP            : std_logic_vector(5 downto 0) := "010100";
    
    attribute syn_preserve : boolean;
    signal count                        : std_logic_vector(15 downto 0);
    signal count_ple                    : std_logic_vector( 9 downto 0);
    signal PrSv_CntPle_s                : std_logic_vector( 9 downto 0);
    signal state                        : std_logic_vector( 5 downto 0);
    signal da_datay_temp                : std_logic_vector(11 downto 0);
    signal memx_temp                    : std_logic_vector(11 downto 0);
    signal memy_temp                    : std_logic_vector(11 downto 0);
    signal laser_power_temp             : std_logic_vector( 9 downto 0);
    signal eth_rst_count                : std_logic_vector( 3 downto 0);
    attribute syn_preserve of state: signal is true;

begin
    Sim_Cnt : if (PrSl_Sim_c = 0) generate
        PrSv_CntPle_s <= "00"&X"01";
    end generate Sim_Cnt;
    
    Real_Cnt : if (PrSl_Sim_c = 1) generate
        PrSv_CntPle_s <= "00"&X"64";
    end generate Real_Cnt;

    -- state_transition_process
    process (nrst,clk) begin
        if (nrst = '0') then
            state <= IDLE;
        elsif rising_edge(clk) then
        case state is
            when IDLE => -- IDLE
                state <= STOP;
            
            when STOP =>  -- wait 100 ms
                if(count_ple >= PrSv_CntPle_s)then
                    state <= W5300_INIT;
                else -- hold
                end if; 

            when W5300_INIT =>
                state <= W5300_WAIT; 
            when W5300_WAIT =>
                if (w5300_init_result = '1') then 
                     state <= PIC_MAKE_WAIT;
                else -- hold
                end if;
--                if(w5300_init_finish = '1' and w5300_init_result = '1')then
--                    state <= PIC_MAKE_WAIT;
--                elsif(w5300_init_finish = '1' and w5300_init_result = '0')then
--                    state <= W5300_NRST;
--	            else -- hold
--	            end if;

            when W5300_NRST => 
                state <= W5300_NRST_WAIT;
            when W5300_NRST_WAIT =>
                if(eth_rst_count > X"D")then
                    state <= W5300_INIT;
                else -- hold
                end if;

            when PIC_MAKE_WAIT => -- W5300 Tx Send
                if (CpSl_W5300InitSucc_i = '1' and initial_done_i = '1') then 
                    state <= W5300_InitSucc;
                else -- hold
                end if;

	        when W5300_InitSucc =>    --  PIC_MAKE_WAIT => -- Enther_Start
	            if (start_tick = '1') then 
	                state <= PIC_MAKE_DA_START_TICK;
	            else -- hold
	            end if;
            when PIC_MAKE_DA_START_TICK =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                else
	                state <= PIC_MAKE_DA_WAIT;
                end if;
            when PIC_MAKE_DA_WAIT =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                elsif (CpSl_W5300InitSucc_i = '0') then
                    state <= PIC_MAKE_WAIT;
                elsif(da_finish = '1')then
	                state <= PULSE_GEN;
	            else
	                state <= PIC_MAKE_DA_WAIT;				
	            end if;
	         when PULSE_GEN =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                elsif (CpSl_W5300InitSucc_i = '0') then
                    state <= PIC_MAKE_WAIT;
                else
	                state <= INITIAL_START_LOW;
                end if;
	         when INITIAL_START_LOW =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                elsif (CpSl_W5300InitSucc_i = '0') then
                    state <= PIC_MAKE_WAIT;
                else
	                state <= LASER_PLE_HIGH;
                end if;
	         when LASER_PLE_HIGH =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                elsif (CpSl_W5300InitSucc_i = '0') then
                    state <= PIC_MAKE_WAIT;
                elsif (count_ple >= "0000000001") then 
--                elsif(count_ple >= "1111101000")then  -- "11_1110_1000"  --100k, 1000ms
	                state <= PIC_TDC_PROCEDURE_START_TICK;
	            else -- hold
	            end if;
            when PIC_TDC_PROCEDURE_START_TICK =>
	            if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                elsif (CpSl_W5300InitSucc_i = '0') then
                    state <= PIC_MAKE_WAIT;
                else
                    state <= PIC_TDC_PROCEDURE_WAIT;
                end if;
            
            -- Laser Runing
            when PIC_TDC_PROCEDURE_WAIT =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
	            elsif (CpSl_W5300InitSucc_i = '0') then
                    state <= PIC_MAKE_WAIT;
	            else
	                state <= PIC_TDC_PROCEDURE_WAIT;
	            end if;
	        
	        when LASER_GSE_LOW => -- Laser_Scan
	            if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                else
                    state <= INITIAL_HIGH;
                end if;
            when INITIAL_HIGH =>
	            if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                else
                    state <= LASER_RPI_LOW;
                end if;
	        when LASER_RPI_LOW =>
                if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                else
	                state <= MEMS_RESET_DA_START_TICK;
                end if;
            when MEMS_RESET_DA_START_TICK =>
	            if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                else
                    state <= MEMS_RESET_DA_WAIT;
                end if;
	        when MEMS_RESET_DA_WAIT =>
	            if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
                elsif(da_finish = '1')then
		            if(da_datay_temp = X"000")then
                        state <= W5300_INIT;
                    else
                        state <= MEMS_RESET_DA_NOP;
                    end if;
                else
                end if;
            when  MEMS_RESET_DA_NOP =>
	            if(soft_reset_tick = '1')then
                    state <= LASER_GSE_LOW;
	            elsif(clk_125k_tick = '1')then
                    state <= MEMS_RESET_DA_START_TICK;
	            else
	            end if;
	        when others => state <= W5300_INIT;
	    end case;
        end if;
    end process;
		  
    -- state_manipulation_process
    process (clk,nrst) begin
        if (nrst = '0') then
            w5300_nrst_ctrl <= '0';
            eth_rst_count   <= X"0";
            da_datay_temp   <= X"FFF";
            laser_rpi_start_start <= '0';
            pic_tdc_procedure_start <= '0';
            da_datax <= (others => '0');
            da_datay <= (others => '0');
            da_start <= '0';
            count <= (others => '0');
            count_ple <= (others => '0');
            w5300_init_start     <= '0';
        elsif(clk'event and clk = '1')then
        case state is
            when IDLE => 
                pic_tdc_procedure_start <= '1';
            when STOP =>
                w5300_nrst_ctrl <= '1';
            
                if(clk_1ms_tick = '1')then
                    if (count_ple = ("00"&X"64")) then 
                        count_ple <= (others => '0');
                    else
                        count_ple <= count_ple + '1';
                    end if;
                else -- hold
                end if;
                pic_tdc_procedure_start <= '0';
            
            when W5300_INIT =>
                w5300_nrst_ctrl <= '1';
                eth_rst_count <= X"0";
                w5300_init_start <= '1';
            
            when W5300_WAIT =>
                w5300_nrst_ctrl <= '1';
                w5300_init_start <= '0';
            
            when W5300_NRST =>
                w5300_nrst_ctrl <= '0';
                eth_rst_count <= X"0";
            
            when W5300_NRST_WAIT =>
                w5300_nrst_ctrl <= '1';
                eth_rst_count <= eth_rst_count + '1';
            
            when PIC_MAKE_WAIT =>
                w5300_nrst_ctrl <= '1';
                laser_rpi_start_start <= '0';
                count   <= (others => '0'); 
            
            when W5300_InitSucc => 
                w5300_nrst_ctrl <= '1';
                laser_rpi_start_start <= '1';
                count   <= (others => '0'); 
            
            when PIC_MAKE_DA_START_TICK =>
                w5300_nrst_ctrl <= '1';
                da_start <= '1';
                da_datax  <= (others => '0');
                da_datay  <= (others => '0');
            
            when PIC_MAKE_DA_WAIT =>
                w5300_nrst_ctrl <= '1';
                da_start <= '0';
            
            when PULSE_GEN =>
                w5300_nrst_ctrl <= '1';
            
            when INITIAL_START_LOW =>
                w5300_nrst_ctrl <= '1';
            
            when LASER_PLE_HIGH =>
                w5300_nrst_ctrl <= '1';
                
                if(clk_1ms_tick = '1')then
                    count_ple <= count_ple + '1';
                end if;
            
            when PIC_TDC_PROCEDURE_START_TICK =>
                w5300_nrst_ctrl <= '1';
                pic_tdc_procedure_start <= '0';
                laser_rpi_start_start <= '1';
            
            when PIC_TDC_PROCEDURE_WAIT =>
                w5300_nrst_ctrl <= '1';
                da_start <= mem_dastart;
                da_datax <= mem_dax;
                da_datay <= mem_day;
                pic_tdc_procedure_start <= '0';
                count <= (others => '0');
            
            when LASER_GSE_LOW =>
                w5300_nrst_ctrl <= '1';
            
            when INITIAL_HIGH  =>
                w5300_nrst_ctrl <= '1';
            
            when LASER_RPI_LOW =>
                w5300_nrst_ctrl <= '1';
                laser_rpi_start_start <= '0';
            
            when MEMS_RESET_DA_START_TICK =>
                w5300_nrst_ctrl <= '1';
                da_start <= '1';
                da_datax  <= X"000"; --X"800" --"000000000000"; --Modified For Change The Reset DAX from 0 to -2048
                da_datay  <= da_datay_temp; --X"800" --"000000000000"; --Modified For Change The Reset DAY from 0 to -2048
            
            when MEMS_RESET_DA_WAIT =>
                w5300_nrst_ctrl <= '1';
                da_start <= '0';
                
                if(da_finish = '1')then
                    if(da_datay_temp <= X"01F")then
                        da_datay_temp <= X"000";
                    else
                        da_datay_temp <= (da_datay_temp - X"020");
                    end if;
                else
                    da_datay_temp <= da_datay_temp;
                end if;
                
            when MEMS_RESET_DA_NOP =>
                w5300_nrst_ctrl <= '1';
                da_start <= '0';
            
            when others =>
                w5300_nrst_ctrl  <= '1';
                w5300_init_start <= '0';
                laser_rpi_start_start   <= '0';
                pic_tdc_procedure_start <= '0';
	            da_datay_temp <= X"FFF";
	            da_datax <= (others => '0');
                da_datay <= (others => '0');
                da_start <= '0';
                count          <= (others => '0');
                count_ple      <= (others => '0');	
        end case;
        end if;
    end process;

--------------------------------------------------------------------------------
-- End
--------------------------------------------------------------------------------
end rtl;