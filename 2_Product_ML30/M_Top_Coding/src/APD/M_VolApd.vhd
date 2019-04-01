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
-- Company      : ZVISION
-- Module_Name  : M_VolApd.vhd
-- Design_Name  : zhang wenjun
-- Emali        : wenjun.zhang@zvision.xyz
-- Create_Date  : 2019/02/22
-- Tool_Versions: Quartus Prime II 17.1 
-- Description  : Control APD Voltage
-- Revision     : 0.1
-- Revision     : 1. Initial, zhang wenjun, 2019/02/22
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


----2090321 改正bug:将dpram_cap_apd_vol模块的输入信号纠正过来

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
        -- ApdVol/Temper
        --------------------------------
        CpSl_CapApdTrig_o               : out std_logic;                        -- Cap_ApdTirg
        CpSl_CapApdVld_i                : in  std_logic;                        -- Apd_CapVolVld
        CpSv_CpdApdVol_i                : in  std_logic_vector(15 downto 0);    -- APd_CapVol

        CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Capture End
        CpSv_TemperData_i               : in  std_logic_vector(15 downto 0);    -- Temper Data
        
        --------------------------------
        -- from Flash
        --------------------------------
        wr_av_ram_en_i                  : in std_logic;
        wr_av_ram_data_i                : in std_logic_vector(31 downto 0);
        wr_av_ram_addr_i                : in std_logic_vector(18 downto 0);
        
        -- 16bit(Real_12bit) * 227
        wr_capav_ram_en_i               : in std_logic;
        wr_capav_ram_data_i             : in std_logic_vector(31 downto 0);
        wr_capav_ram_addr_i             : in std_logic_vector(18 downto 0);
        
        --------------------------------
        -- Voltage
        --------------------------------
        CpSl_WrTrig_o                   : out std_logic;                        -- Write_APDVol
        CpSl_VolDataTrig_o              : out std_logic;                        -- Voltaga Valid
        CpSv_VolData_o                  : out std_logic_vector(11 downto 0)     -- Voltage Data
    );
end M_VolApd;

architecture arch_M_VolApd of M_VolApd is
    ----------------------------------------------------------------------------
    -- Formula Describe
    ----------------------------------------------------------------------------
    -- Chage_Time : 20180815
    -- Temper = LMT70采集电压反馈温度；
    -- LTC2324 = ADC*2^11/2^15 = ADC*4096/32768 = ADC/8;
    -- Vapd = 125 + (T - 25)*0.65
    -- -> RomAddress = ADC(15 downto 5) - 118;
    --     >> Temp_Rang ： -55 ~ 119
    --     >> Apd_Vol : min ~ max(Signle Address)
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
--    constant PrSv_100msCnt_c            : std_logic_vector(23 downto 0) := x"3D08FF"; -- 4000000
    constant PrSv_50msCnt_c             : std_logic_vector(23 downto 0) := x"1E847F"; -- 2000000
    constant PrSv_10msCnt_c             : std_logic_vector(23 downto 0) := x"061A7F"; -- 400000
    constant PrSv_5msCnt_c              : std_logic_vector(23 downto 0) := x"030D3F"; -- 200000    
        
    -- ApdVolState
    constant PrSv_StateIdle_c           : std_logic_vector( 3 downto 0) := x"0";-- State_Idle
    constant PrSv_StateTrig_c           : std_logic_vector( 3 downto 0) := x"1";-- Init_Trig
    constant PrSv_StateWait_c           : std_logic_vector( 3 downto 0) := x"2";-- Init_Wait
    constant PrSv_StateInit_c           : std_logic_vector( 3 downto 0) := x"3";-- Init_Time
    constant PrSv_StateCapVol_c         : std_logic_vector( 3 downto 0) := x"4";-- Cap_APdvol
    constant PrSv_StateChange_c         : std_logic_vector( 3 downto 0) := x"5";-- Chang_APdVol
    constant PrSv_StateEnd_c            : std_logic_vector( 3 downto 0) := x"6";-- State_end

   ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    component dpram_apd_vol IS
    PORT (
		clock		                    : IN STD_LOGIC  := '1';
		data                            : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress                       : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wraddress                       : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		wren                            : IN STD_LOGIC  := '0';
		q                               : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END component;

    component dpram_cap_apd_vol is
    PORT (
		clock                           : IN STD_LOGIC  := '1';
		data                            : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress                       : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wraddress                       : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		wren                            : IN STD_LOGIC  := '0';
		q                               : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    end component;

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSv_CapTemp_s               : std_logic_vector( 9 downto 0);        -- CapTemp 
    signal PrSv_CapTempDly1_s           : std_logic_vector( 9 downto 0);        -- CapTempDly1
    signal PrSv_CapTempDly2_s           : std_logic_vector( 9 downto 0);        -- CapTempDly2 
    signal PrSv_RomAddr1_s              : std_logic_vector( 9 downto 0);        -- Rom Address
    signal PrSv_RomAddr_s               : std_logic_vector( 7 downto 0);        -- Rom Address
    signal PrSv_RomData16_s             : std_logic_vector(15 downto 0);        -- Rom Data
    signal PrSv_RomData_s               : std_logic_vector(11 downto 0);        -- Rom Data
    signal PrSv_DataState_s             : std_logic_vector( 3 downto 0);        -- State
    signal PrSv_IntWait_s               : std_logic_vector(23 downto 0);        -- Init_WaitTime
    signal PrSv_Wait_2s_s               : std_logic_vector(23 downto 0);        -- WaitTime_2s
    signal PrSv_Wait_Cnt_s              : std_logic_vector( 5 downto 0);        -- WaitTime_Cnt
    signal PrSv_CapVolTime_s            : std_logic_vector(23 downto 0);        -- CapVol_Time
    
    signal PrSl_StartTrig_s             : std_logic;                            -- State Trig
    signal PrSl_StartTrigDly1_s         : std_logic;                            -- State Trig_Dly1
    signal PrSl_StartTrigDly2_s         : std_logic;                            -- State Trig_Dly2
    signal PrSl_StartTrigDly3_s         : std_logic;                            -- State Trig_Dly3
    signal PrSv_AdcData_s               : std_logic_vector(11 downto 0);        -- Adc Data
    
    -- CapRomVol 
    signal PrSv_CapRomAddr_s            : STD_LOGIC_VECTOR( 7 DOWNTO 0);        -- Cap_RomAddr
    signal PrSv_ApdVol16_s              : STD_LOGIC_VECTOR(15 DOWNTO 0);        -- Cap_RomData
    signal PrSv_ApdVol_s                : STD_LOGIC_VECTOR(11 DOWNTO 0);        -- Cap_RomData
    signal PrSv_CapRomData_s            : STD_LOGIC_VECTOR(11 DOWNTO 0);        -- Cap_RomData
    signal PrSl_CapApdVldDly1_s         : std_logic;                            -- CapApdVldDly1
    signal PrSl_CapApdVldDly2_s         : std_logic;                            -- CapApdVldDly2
    signal PrSl_CapApdTrig_s            : std_logic;                            -- CapApdTrig    
    signal PrSl_CapApdTrigDly1_s        : std_logic;                            -- CapApdTrigDly1
    signal PrSl_CapApdTrigDly2_s        : std_logic;                            -- CapApdTrigDly2
    signal PrSl_CapApdTrigDly3_s        : std_logic;                            -- CapApdTrigDly3
    signal PrSv_CmpRomData_s            : std_logic_vector(11 downto 0);        -- CmpRomData
    signal PrSv_RisingData_s            : std_logic_vector(11 downto 0);        -- Compare_RisingData
    signal PrSv_RisingDataVld_s         : std_logic;                            -- Compare_RisingData_Vld
    signal PrSv_FallingData_s           : std_logic_vector(11 downto 0);        -- Compare_FallingData
    signal PrSv_FallingDataVld_s        : std_logic;                            -- Compare_FallingData_Vld    
    
    -- mean_data
    signal PrSv_MeanCnt_s               : std_logic_vector( 4 downto 0);        -- MeanCnt
    signal PrSv_SumData_s               : std_logic_vector(15 downto 0);        -- SumData
    signal PrSl_EndTrigDly1_s           : std_logic;                            -- CpSl_EndTrig_i Dly1
    signal PrSl_EndTrigDly2_s           : std_logic;                            -- CpSl_EndTrig_i Dly2
    signal PrSl_EndTrigDly3_s           : std_logic;                            -- CpSl_EndTrig_i Dly3
    signal PrSl_CapTrig_s               : std_logic;                            -- CpSl_EndTrig_i Captrig
    signal PrSl_EndTrig_s               : std_logic;                            -- CpSl_EndTrig_i Trig
    signal PrSl_SumEnd_s                : std_logic;                            -- PrSl_SumEnd_s
    signal PrSl_SumEndDly1_s            : std_logic;                            -- PrSl_SumEnd_s Dly1
    signal PrSl_SumEndDly2_s            : std_logic;                            -- PrSl_SumEnd_s Dly2
    
    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    U_M_ApdVolRom_0 : dpram_apd_vol 
    port map (
		clock                           => CpSl_Clk_i                           , -- IN STD_LOGIC  := '1';
		data                            => wr_av_ram_data_i                     , 
		wraddress                       => wr_av_ram_addr_i( 6 downto 0)        , 
		wren                            => wr_av_ram_en_i                       , 
		rdaddress                       => PrSv_RomAddr_s                       , -- IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		q                               => PrSv_RomData16_s                       -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	PrSv_RomData_s <= PrSv_RomData16_s(11 downto 0);

--    U_dpram_cap_apd_vol_0 : dpram_cap_apd_vol
--    port map (
--		clock                           => CpSl_Clk_i                           , -- IN STD_LOGIC  := '1';
--		wren                            => wr_av_ram_en_i                       , -- IN STD_LOGIC  := '0';     
--		data                            => wr_av_ram_data_i                     , -- IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--		wraddress                       => wr_av_ram_addr_i(6 downto 0)         , -- IN STD_LOGIC_VECTOR (6 DOWNTO 0);     
--		rdaddress                       => PrSv_CapRomAddr_s                    , -- IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		q                               => PrSv_ApdVol16_s                        -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
--    );
	 
	 
	U_dpram_cap_apd_vol_0 : dpram_cap_apd_vol
    port map (
		clock                           => CpSl_Clk_i                           , -- IN STD_LOGIC  := '1';
		wren                            => wr_capav_ram_en_i                       , -- IN STD_LOGIC  := '0';     
		data                            => wr_capav_ram_data_i                     , -- IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wraddress                       => wr_capav_ram_addr_i(6 downto 0)         , -- IN STD_LOGIC_VECTOR (6 DOWNTO 0);     
		rdaddress                       => PrSv_CapRomAddr_s                    , -- IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		q                               => PrSv_ApdVol16_s                        -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
	 
    PrSv_ApdVol_s <= PrSv_ApdVol16_s(11 downto 0);

    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- Delay CpSl_EndTrig_i
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_EndTrigDly1_s <= '0';
            PrSl_EndTrigDly2_s <= '0';
            PrSl_EndTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_EndTrigDly1_s <= CpSl_EndTrig_i;
            PrSl_EndTrigDly2_s <= PrSl_EndTrigDly1_s;
            PrSl_EndTrigDly3_s <= PrSl_EndTrigDly2_s;
        end if;
    end process;
    PrSl_CapTrig_s <= PrSl_EndTrigDly1_s and (not PrSl_EndTrigDly2_s);
    PrSl_EndTrig_s <= PrSl_EndTrigDly2_s and (not PrSl_EndTrigDly3_s);
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_SumEnd_s     <= '0';
            PrSl_SumEndDly1_s <= '0';
            PrSl_SumEndDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_SumEnd_s     <= PrSl_EndTrig_s;
            PrSl_SumEndDly1_s <= PrSl_SumEnd_s;
            PrSl_SumEndDly2_s <= PrSl_SumEndDly1_s;
        end if;
    end process;
    
    -- PrSv_MeanCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_MeanCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_EndTrig_s = '1') then
                if (PrSv_MeanCnt_s = 31) then
                    PrSv_MeanCnt_s <= (others => '0');
                else
                    PrSv_MeanCnt_s <= PrSv_MeanCnt_s + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_SumData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_SumData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_CapTrig_s = '1' and CpSv_TemperData_i(15) = '0') then
                PrSv_SumData_s <= PrSv_SumData_s + CpSv_TemperData_i(14 downto 5);
            elsif (PrSl_SumEndDly2_s = '1' and PrSv_MeanCnt_s = 0) then
                PrSv_SumData_s <= (others => '0');
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_CapTemp_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CapTemp_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_EndTrig_s = '1' and PrSv_MeanCnt_s = 31) then
                PrSv_CapTemp_s <= PrSv_SumData_s(14 downto 5);
            else -- hold
            end if;
        end if; 
    end process;
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CapTempDly1_s <= (others => '0');
            PrSv_CapTempDly2_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            PrSv_CapTempDly1_s <= PrSv_CapTemp_s;
            PrSv_CapTempDly2_s <= PrSv_CapTempDly1_s;
        end if;
    end process;
    
    -- PrSl_StartTrig_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_StartTrig_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CapTempDly1_s /= PrSv_CapTempDly2_s) then
                PrSl_StartTrig_s <= '1';
            else
                PrSl_StartTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- Delay PrSl_StartTrig_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_StartTrigDly1_s <= '0';
            PrSl_StartTrigDly2_s <= '0';
            PrSl_StartTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_StartTrigDly1_s <= PrSl_StartTrig_s;
            PrSl_StartTrigDly2_s <= PrSl_StartTrigDly1_s;
            PrSl_StartTrigDly3_s <= PrSl_StartTrigDly2_s;
        end if;
    end process;
    
    -- PrSv_RomAddr1_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_RomAddr1_s <= "00" & x"E2";
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_CapTempDly1_s /= PrSv_CapTempDly2_s) then
                if (PrSv_CapTempDly1_s < 118) then
                    PrSv_RomAddr1_s <= PrSv_RomAddr1_s;
                else
                    PrSv_RomAddr1_s <= PrSv_CapTempDly1_s - 118;
                end if;
            else -- hold
            end if;
        end if;
    end process;
    -- PrSv_RomAddr_s
    PrSv_RomAddr_s    <= PrSv_RomAddr1_s(7 downto 0);
    PrSv_CapRomAddr_s <= PrSv_RomAddr1_s(7 downto 0);    

    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
             PrSv_CapRomData_s <= x"33B";
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSv_TemperData_i(15) = '0') then 
                if (CpSv_TemperData_i(14 downto 3) >= 440 and CpSv_TemperData_i(14 downto 3) <= 1300) then
                    PrSv_CapRomData_s <= PrSv_ApdVol_s;
                else 
                    PrSv_CapRomData_s <= x"33B";
                end if;
            else -- hold
            end if;
        end if;
    end process;

    ------------------------------------
    -- CapRomVol
    ------------------------------------
    -- Delay CpSl_CapApdVld_i
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_CapApdVldDly1_s <= '0';
            PrSl_CapApdVldDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_CapApdVldDly1_s <= CpSl_CapApdVld_i;
            PrSl_CapApdVldDly2_s <= PrSl_CapApdVldDly1_s;
        end if;
    end process;
    -- Trig
    PrSl_CapApdTrig_s <= '1' when (PrSl_CapApdVldDly2_s = '1' and PrSl_CapApdVldDly1_s = '0') else '0';
    
    -- Delay PrSl_CapApdTrig_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_CapApdTrigDly1_s <= '0';
            PrSl_CapApdTrigDly2_s <= '0';
            PrSl_CapApdTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_CapApdTrigDly1_s <= PrSl_CapApdTrig_s;
            PrSl_CapApdTrigDly2_s <= PrSl_CapApdTrigDly1_s;
            PrSl_CapApdTrigDly3_s <= PrSl_CapApdTrigDly2_s;
        end if;
    end process;
    
    -- PrSv_CmpRomData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CmpRomData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateInit_c) then
                PrSv_CmpRomData_s <= PrSv_RomData_s;
            elsif (PrSv_DataState_s = PrSv_StateChange_c) then 
                if (PrSv_RisingDataVld_s = '1') then 
                    PrSv_CmpRomData_s <= PrSv_RisingData_s;
                elsif (PrSv_FallingDataVld_s = '1') then 
                    PrSv_CmpRomData_s <= PrSv_FallingData_s;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_RisingData_s/PrSv_RisingDataVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_RisingData_s <= (others => '0');
            PrSv_RisingDataVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_CapApdTrig_s = '1' and CpSv_CpdApdVol_i(15) = '0' and PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3)) then
                if (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 4) then 
                    PrSv_RisingData_s <= PrSv_CmpRomData_s;
                    PrSv_RisingDataVld_s <= '0';
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 4 and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 7) then 
                    if (PrSv_CmpRomData_s < 4096 - 12) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 12;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 7 and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 14) then 
                    if (PrSv_CmpRomData_s < 4096 - 20) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 20;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 14 and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 28) then 
                    if (PrSv_CmpRomData_s < 4096 - 40) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 40;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 28 and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 56) then 
                    if (PrSv_CmpRomData_s < 4096 - 80) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 80;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 56 and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 112) then 
                    if (PrSv_CmpRomData_s < 4096 - 160) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 160;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 112 and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3) + 224) then 
                    if (PrSv_CmpRomData_s < 4096 - 320) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 320;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                elsif (PrSv_CapRomData_s >= CpSv_CpdApdVol_i(14 downto 3) + 224) then 
                    if (PrSv_CmpRomData_s < 4096 - 640) then 
                        PrSv_RisingData_s <= PrSv_CmpRomData_s + 640;
                    else 
                        PrSv_RisingData_s <= x"FFF";
                    end if;
                    PrSv_RisingDataVld_s <= '1';
                else 
--                    PrSv_RisingData_s <= PrSv_RisingData_s;
--                    PrSv_RisingDataVld_s <= '0';
                end if;
            elsif (PrSv_DataState_s = PrSv_StateEnd_c) then 
                PrSv_RisingData_s <= PrSv_RisingData_s;
                PrSv_RisingDataVld_s <= '0';
            else
            end if;
        end if;
    end process;
    
    -- PrSv_FallingData_s/PrSv_FallingDataVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_FallingData_s <= (others => '0');
            PrSv_FallingDataVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_CapApdTrig_s = '1' and CpSv_CpdApdVol_i(15) = '0' and PrSv_CapRomData_s < CpSv_CpdApdVol_i(14 downto 3)) then
                if (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 4) then 
                    PrSv_FallingData_s <= PrSv_CmpRomData_s;
                    PrSv_FallingDataVld_s <= '0';
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 4 and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 7) then 
                    if (PrSv_CmpRomData_s > 12) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 12;
                    else 
                        PrSv_FallingData_s <= (others => '0');
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 7 and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 14) then 
                    if (PrSv_CmpRomData_s > 20) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 20;
                    else 
                        PrSv_FallingData_s <= x"000";
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 14 and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 28) then 
                    if (PrSv_CmpRomData_s > 40) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 40;
                    else 
                        PrSv_FallingData_s <= x"000";
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 28 and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 56) then 
                    if (PrSv_CmpRomData_s > 80) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 80;
                    else 
                        PrSv_FallingData_s <= x"000";
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 56 and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 112) then 
                    if (PrSv_CmpRomData_s > 160) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 160;
                    else 
                        PrSv_FallingData_s <= x"000";
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 112 and PrSv_CapRomData_s > CpSv_CpdApdVol_i(14 downto 3) - 224) then 
                    if (PrSv_CmpRomData_s > 320) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 320;
                    else 
                        PrSv_FallingData_s <= x"000";
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                    
                elsif (PrSv_CapRomData_s <= CpSv_CpdApdVol_i(14 downto 3) - 224) then 
                    if (PrSv_CmpRomData_s > 640) then 
                        PrSv_FallingData_s <= PrSv_CmpRomData_s - 640;
                    else 
                        PrSv_FallingData_s <= x"000";
                    end if;
                    PrSv_FallingDataVld_s <= '1';
                else 
--                    PrSv_FallingData_s <= PrSv_CmpRomData_s;
--                    PrSv_FallingDataVld_s <= '0';
                end if;
            elsif (PrSv_DataState_s = PrSv_StateEnd_c) then 
                PrSv_FallingData_s <= PrSv_FallingData_s;
                PrSv_FallingDataVld_s <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    ------------------------------------    
    -- PrSv_DataState_s
    ------------------------------------
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_DataState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            case PrSv_DataState_s is 
                when PrSv_StateIdle_c => -- Idle
                    PrSv_DataState_s <= PrSv_StateTrig_c;
                when PrSv_StateTrig_c => -- Trig
                    PrSv_DataState_s <= PrSv_StateWait_c;
                when PrSv_StateWait_c => -- Wait_Time
                    if (PrSv_IntWait_s = PrSv_50msCnt_c) then 
                        PrSv_DataState_s <= PrSv_StateInit_c;
                    else -- hold
                    end if;
                    
                when PrSv_StateInit_c => -- Wait_2s
                    if (PrSv_Wait_2s_s = PrSv_50msCnt_c and PrSv_Wait_Cnt_s = 39) then 
                        PrSv_DataState_s <= PrSv_StateCapVol_c;
                    else -- hold
                    end if;
                    
                when PrSv_StateCapVol_c => -- Cap_ApdVol
                    if (PrSv_CapVolTime_s = PrSv_10msCnt_c) then
                        PrSv_DataState_s <= PrSv_StateChange_c;
                    else
                    end if;
                
                when PrSv_StateChange_c => -- Change_Data
                    PrSv_DataState_s <= PrSv_StateEnd_c;
                
                when PrSv_StateEnd_c => -- End
                    PrSv_DataState_s <= PrSv_StateCapVol_c;
                
                when others => PrSv_DataState_s <= (others => '0');
            end case; 
        end if;
    end process;
    
    -- PrSv_IntWait_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_IntWait_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateWait_c) then 
                PrSv_IntWait_s <= PrSv_IntWait_s + '1';
            else 
                PrSv_IntWait_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_Wait_2s_s/PrSv_Wait_Cnt_s    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_Wait_2s_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateInit_c) then
                if (PrSv_Wait_2s_s = PrSv_50msCnt_c) then 
                    PrSv_Wait_2s_s <= (others => '0');
                else 
                    PrSv_Wait_2s_s <= PrSv_Wait_2s_s + '1';
                end if;
            else 
                PrSv_Wait_2s_s <= (others => '0');
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_Wait_Cnt_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateInit_c) then
                if (PrSv_Wait_2s_s = PrSv_50msCnt_c) then 
                    PrSv_Wait_Cnt_s <= PrSv_Wait_Cnt_s + '1';
                else -- hold
                end if;
            else 
                PrSv_Wait_Cnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_CapVolTime_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CapVolTime_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateCapVol_c) then
                PrSv_CapVolTime_s <= PrSv_CapVolTime_s + '1';
            else 
                PrSv_CapVolTime_s <= (others => '0');
            end if;
        end if;
    end process;
    
    
    -- PrSv_AdcData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_AdcData_s <= (others => '0'); 
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateIdle_c) then 
                PrSv_AdcData_s <= x"7E7";
            elsif (PrSv_DataState_s = PrSv_StateInit_c and PrSl_StartTrigDly2_s = '1') then
                PrSv_AdcData_s <= PrSv_RomData_s;
            else -- hold
            end if;
        end if;
    end process;
    
        
    ------------------------------------
    -- OutPut
    ------------------------------------
    -- CpSl_CapApdTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_CapApdTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateCapVol_c and PrSv_CapVolTime_s = PrSv_5msCnt_c) then
                CpSl_CapApdTrig_o <= '1';
            else
                CpSl_CapApdTrig_o <= '0';
            end if;
        end if; 
    end process;
    
    -- CpSl_WrTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_WrTrig_o  <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateTrig_c) then
                CpSl_WrTrig_o  <= '1';
            elsif (PrSv_DataState_s = PrSv_StateInit_c and PrSl_StartTrigDly2_s = '1') then 
                CpSl_WrTrig_o  <= '1';

            elsif (PrSv_DataState_s = PrSv_StateCapVol_c and PrSl_CapApdTrigDly2_s = '1') then     
                if (PrSv_RisingDataVld_s = '1' or PrSv_FallingDataVld_s = '1') then 
                    CpSl_WrTrig_o  <= '1';
                else 
                    CpSl_WrTrig_o  <= '0';
                end if;
            else
                CpSl_WrTrig_o  <= '0';
            end if;
        end if;
    end process;
    
    -- CpSv_VolData_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSv_VolData_o <= x"7E7";
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DataState_s = PrSv_StateInit_c and PrSl_StartTrigDly2_s = '1') then
                CpSv_VolData_o <= PrSv_RomData_s;
            elsif (PrSv_DataState_s = PrSv_StateCapVol_c and PrSl_CapApdTrigDly2_s = '1') then     
                if (PrSv_RisingDataVld_s = '1') then 
                    CpSv_VolData_o <= PrSv_RisingData_s;
                elsif (PrSv_FallingDataVld_s = '1') then 
                    CpSv_VolData_o <= PrSv_FallingData_s;
                else 
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- CpSl_VolDataTrig_o
    CpSl_VolDataTrig_o <= '0';

----------------------------------------
-- End_Coding
----------------------------------------
end arch_M_VolApd;