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
-- °æ    È¨  :  ZVISION
-- ÎÄ¼þÃû³Æ  :  M_VolApd.vhd
-- Éè    ¼Æ  :  zhang wenjun
-- ÓÊ    ¼þ  :  wenjun.zhang@zvision.xyz
-- Ð£    ¶Ô  :
-- Éè¼ÆÈÕÆÚ  :  2018/05/17
-- ¹¦ÄÜ¼òÊö  :  Ocntrol APD Voltage
-- °æ±¾ÐòºÅ  :  0.1
-- ÐÞ¸ÄÀúÊ·  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

----------------------------------------
-- library Xilinx
----------------------------------------
--library unisim;
--use unisim.vcomponents.all;

----------------------------------------
-- library Altera
----------------------------------------
--library altera_mf;
--use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------

entity M_VolApd is
    generic (
        PrSl_Sim_c                      : integer := 1                          -- Simulation
    );
    port (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
        
        --------------------------------
        -- Temper
        --------------------------------
        CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Capture End
        CpSv_TemperData_i               : in  std_logic_vector(15 downto 0);    -- Temper Data

        --------------------------------
        -- Voltage
        --------------------------------
        CpSl_WrTrig_o                   : out std_logic;                        -- Write 5242_data
        CpSl_VolDataTrig_o              : out std_logic;                        -- Voltaga Valid
        CpSv_VolData_o                  : out std_logic_vector( 7 downto 0)     -- Voltage Data
    );
end M_VolApd;

architecture arch_M_VolApd of M_VolApd is
    ----------------------------------------------------------------------------
    -- Formula Describe
    ----------------------------------------------------------------------------
    -- Chage_Time : 20180815
    -- Temper  = 500Mv + 10mv/C*T;
    -- LTC2324 = ADC*2^11/2^15 = ADC*4096/32768 = ADC/8;
    -- Vapd = 500*0.88 + 3.5*(T-25) = 352.5 + 3.5*T;
    -- Vapd = 177.5 + 0.35*ADC(15 downto 4);
    -- -> RomAddress = ADC(15 dwonto 4)/10 - 34;
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
--    constant PrSv_10msCnt_c             : std_logic_vector(19 downto 0) := x"61A7F"; -- 400000
--    constant PrSv_5msCnt_c              : std_logic_vector(19 downto 0) := x"30D3F"; -- 200000

    constant PrSv_10msCnt_c             : std_logic_vector(19 downto 0) := x"C34FF"; -- 800000
    constant PrSv_5msCnt_c              : std_logic_vector(19 downto 0) := x"61A7F"; -- 400000
    
    constant PrSv_Wait500ms_c           : std_logic_vector(27 downto 0)  := x"1312D00"; -- 500ms  
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    -- AdpVolDiv
    component M_AdpVolDiv is 
    port (
        denom		                    : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
		numer		                    : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
		quotient                        : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		remain		                    : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)
    );
    end component;
    
    -- ApdVolRom
    component M_ApdRom is 
    port (
        address		                    : IN  STD_LOGIC_VECTOR( 6 DOWNTO 0);
		clock		                    : IN  STD_LOGIC := '1';
		q		                        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    end component;

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSv_Numer_s                 : std_logic_vector(10 downto 0);        -- Numer 
    signal PrSv_Quot_s                  : std_logic_vector(10 downto 0);        -- Quotient
    signal PrSv_QuotDly1_s              : std_logic_vector(10 downto 0);        -- Quotient Delay 1 Clk
    signal PrSv_QuotDly2_s              : std_logic_vector(10 downto 0);        -- Quotient Delay 2 Clk
    signal PrSv_RomAddr1_s              : std_logic_vector(10 downto 0);        -- Rom Address
    signal PrSv_RomAddr_s               : std_logic_vector( 6 downto 0);        -- Rom Address
    signal PrSv_RomData_s               : std_logic_vector(15 downto 0);        -- Rom Data
    signal PrSv_DataState_s             : std_logic_vector( 2 downto 0);        -- State
    signal PrSl_StartTrig_s             : std_logic;                            -- State Trig
    signal PrSv_AdcData_s               : std_logic_vector(15 downto 0);        -- Adc Data
    signal PrSv_CfgCnt_s                : std_logic_vector(19 downto 0);        -- Config Cnt
    signal PrSv_Wait500ms_s             : std_logic_vector(27 downto 0);        -- 500ms
        
    ------------------------------------
    -- Change 5242_Reg
    ------------------------------------
    signal PrSv_Ad5242State_s           : std_logic_vector( 3 downto 0);        -- AD5242_State 
    signal PrSv_Data_s                  : std_logic_vector( 7 downto 0);        -- AD5242_Data
    signal PrSv_AdData_s                : std_logic_vector( 7 downto 0);        -- AdData
    signal PrSv_AdNum_s                 : std_logic_vector( 1 downto 0);        -- Control_Channel
    signal PrSv_Cnt1s_s                 : std_logic_vector(27 downto 0);        -- 1s(26259FF)
    signal PrSv_Num1s_s                 : std_logic_vector( 4 downto 0);        -- 20
    
    
begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    U_M_AdpVolDiv_0 : M_AdpVolDiv
    port map(
        denom		                    => "1010"                               , -- IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
		numer		                    => PrSv_Numer_s                         , -- IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
		quotient                        => PrSv_Quot_s                          , -- OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		remain		                    => open                                   -- OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)
    );
    Real_Data : if (PrSl_Sim_c = 1) generate
        U_M_ApdRom_0 : M_ApdRom
        port map (
            address		                    => PrSv_RomAddr_s                       , -- IN  STD_LOGIC_VECTOR( 6 DOWNTO 0);
	    	clock		                    => CpSl_Clk_i                           , -- IN  STD_LOGIC := '1';
	    	q		                        => PrSv_RomData_s                         -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
        
        -- PrSl_StartTrig_s
        process (CpSl_Rst_iN,CpSl_Clk_i) begin
            if (CpSl_Rst_iN = '0') then 
                PrSl_StartTrig_s <= '0';
            elsif rising_edge(CpSl_Clk_i) then
                if (PrSv_QuotDly1_s /= PrSv_QuotDly2_s) then
                    PrSl_StartTrig_s <= '1';
                else
                    PrSl_StartTrig_s <= '0';
                end if;
            end if;
        end process;
    end generate Real_Data;
    
    Sim_Data : if (PrSl_Sim_c = 0) generate
        PrSv_RomData_s <= x"E7E7";
        PrSl_StartTrig_s <= '1';
    end generate Sim_Data;
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- PrSv_Numer_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_Numer_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_EndTrig_i = '1' and CpSv_TemperData_i(15) = '0') then
                --PrSv_Numer_s <= "010"&x"EE";
                PrSv_Numer_s <= CpSv_TemperData_i(13 downto 3);
            else -- hold
            end if;
        end if; 
    end process;
    
    -- PrSv_QuotDly1_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_QuotDly1_s <= (others => '0');
            PrSv_QuotDly2_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            PrSv_QuotDly1_s <= PrSv_Quot_s;
            PrSv_QuotDly2_s <= PrSv_QuotDly1_s;
        end if;
    end process;
    
    -- PrSv_RomAddr1_s
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then 
--            PrSv_RomAddr1_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_QuotDly1_s /= PrSv_QuotDly2_s) then
--                if (PrSv_QuotDly2_s <= 34) then
--                    PrSv_RomAddr1_s <= (others => '0');
--                elsif (PrSv_QuotDly2_s >= 122) then 
--                    PrSv_RomAddr1_s <= "000" & x"58";
--                else
--                    PrSv_RomAddr1_s <= PrSv_QuotDly2_s - 34;
--                end if;
--            else -- hold
--            end if;
--        end if;
--    end process;
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_RomAddr1_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_QuotDly1_s /= PrSv_QuotDly2_s) then
                if (PrSv_QuotDly1_s <= 44) then
                    PrSv_RomAddr1_s <= (others => '0');
                elsif (PrSv_QuotDly1_s >= 103) then 
                    PrSv_RomAddr1_s <= "000" & x"3B";
                else
                    PrSv_RomAddr1_s <= PrSv_QuotDly1_s - 44;
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_RomAddr_s
    PrSv_RomAddr_s <= PrSv_RomAddr1_s(6 downto 0);

    -- PrSv_DataState_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_DataState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            case PrSv_DataState_s is 
                when "000" => -- Idle
                    PrSv_DataState_s <= "011";
                    
                when "001" => -- Config_Trig
                    if (PrSl_StartTrig_s = '1') then
                        PrSv_DataState_s <= "010";
                    else -- hold
                    end if;

                when "010" => -- Capture Rom Data
                    PrSv_DataState_s <= "011";
                
                when "011" => -- Config data
                    if (PrSv_CfgCnt_s = PrSv_10msCnt_c) then
                        PrSv_DataState_s <= "100";
                    else -- hold
                    end if;

                when "100" => -- wait 500ms
                    if (PrSv_Wait500ms_s = PrSv_Wait500ms_c) then 
                        PrSv_DataState_s <= "001";
                    else -- hold
                    end if;

                when others => PrSv_DataState_s <= (others => '0');
            end case;
        end if;
    end process;
    
    -- PrSv_AdcData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_AdcData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = "000") then 
                PrSv_AdcData_s <= x"E7E7";
            elsif (PrSv_DataState_s = "010") then
                --PrSv_AdcData_s <= x"E7E7";
                PrSv_AdcData_s <= PrSv_RomData_s;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_CfgCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_CfgCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = "011") then
                PrSv_CfgCnt_s <= PrSv_CfgCnt_s + '1';
            else
                PrSv_CfgCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- CpSl_WrTrig_o
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then 
--            CpSl_WrTrig_o <= '0';
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_DataState_s = "011") then
--                if (PrSv_CfgCnt_s = 0) then
--                    CpSl_WrTrig_o <= '1';
--                elsif (PrSv_CfgCnt_s = PrSv_5msCnt_c) then 
--                    CpSl_WrTrig_o <= '1';
--                else
--                    CpSl_WrTrig_o <= '0';
--                end if;
--            else
--                CpSl_WrTrig_o <= '0';
--            end if;
--        end if;
--    end process;
--    
--    -- CpSl_VolDataTrig_o
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then 
--            CpSl_VolDataTrig_o <= '0';
--            CpSv_VolData_o <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_DataState_s = "011") then
--                if (PrSv_CfgCnt_s = 0) then
--                    CpSl_VolDataTrig_o <= '0';
--                    CpSv_VolData_o <= PrSv_AdcData_s(15 downto 8);
--                elsif (PrSv_CfgCnt_s = PrSv_5msCnt_c) then 
--                    CpSl_VolDataTrig_o <= '1';
--                    CpSv_VolData_o <= PrSv_AdcData_s(7 downto 0);
--                else -- hold
--                end if;
--            else  -- hold
--            end if;
--        end if;
--    end process;
    
    -- PrSv_Wait500ms_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_Wait500ms_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = "100") then
                if (PrSv_Wait500ms_s = PrSv_Wait500ms_c) then 
                    PrSv_Wait500ms_s <= (others => '0');
                else
                    PrSv_Wait500ms_s <= PrSv_Wait500ms_s + '1';
                end if;
            else
                PrSv_Wait500ms_s <= (others => '0');
            end if;
        end if;
    end process;
    

    ------------------------------------
    -- Change AD5242 Register
    ------------------------------------
    -- AD5242_State
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
             PrSv_Ad5242State_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_Ad5242State_s is 
                when "0000" => -- Idle
                    PrSv_Ad5242State_s <= "0001";
                
                when "0001" => -- Generate_Data
                    PrSv_Ad5242State_s <= "0010";
                
                when "0010" => -- Control_Data
                    PrSv_Ad5242State_s <= "0100";
                
                when "0100" => -- Send_Data
                    PrSv_Ad5242State_s <= "1000";
                
                when "1000" => -- wait_time_20s
                    if (PrSv_Num1s_s = 20) then
                        if (PrSv_AdNum_s = 2)then 
                            PrSv_Ad5242State_s <= (others => '0');
                        else 
                            PrSv_Ad5242State_s <= "0001";
                        end if;
                    else -- hold
                    end if;

                when others => 
                    PrSv_Ad5242State_s <= (others => '0');
            end case;
        end if;
    end process;

    -- AD5242_Data
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_Data_s <= (others => '1');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_Ad5242State_s = "0001") then
                PrSv_Data_s <= PrSv_AdData_s;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_AdNum_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_AdNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_Ad5242State_s = "0000") then 
                PrSv_AdNum_s <= (others => '0');
            elsif (PrSv_Ad5242State_s = "0001") then
                PrSv_AdNum_s <= PrSv_AdNum_s + 1;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_AdData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_AdData_s <= (others => '1');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_Ad5242State_s = "0010") then
                PrSv_AdData_s <= PrSv_AdData_s - 10;
            else -- hold
            end if;
        end if;
    end process;


    -- CpSl_WrTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_WrTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_Ad5242State_s = "0100") then
                CpSl_WrTrig_o <= '1';
            else
                CpSl_WrTrig_o <= '0';
            end if;
        end if;
    end process;
    
    -- CpSl_VolDataTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_VolDataTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_Ad5242State_s = "0100") then
                CpSl_VolDataTrig_o <= PrSv_AdNum_s(0);
            else -- hold
            end if;
        end if;
    end process;
    
    -- CpSv_VolData_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSv_VolData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_Ad5242State_s = "0100") then
                CpSv_VolData_o <= PrSv_Data_s;
            else -- hold
            end if;
        end if;
    end process;
    
    -- wait_time
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_Cnt1s_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_Ad5242State_s = "1000") then
                if (PrSv_Cnt1s_s = x"26259FF") then 
                    PrSv_Cnt1s_s <= (others => '0');
                else
                    PrSv_Cnt1s_s <= PrSv_Cnt1s_s + '1';
                end if;
            else 
                PrSv_Cnt1s_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_Num1s_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_Num1s_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_Ad5242State_s = "1000") then
                if (PrSv_Cnt1s_s = x"26259FF") then 
                    PrSv_Num1s_s <= PrSv_Num1s_s + '1';
                else  -- hold
                end if;
            else 
                PrSv_Num1s_s <= (others => '0');
            end if;
        end if;
    end process;



----------------------------------------
-- End
----------------------------------------
end arch_M_VolApd;