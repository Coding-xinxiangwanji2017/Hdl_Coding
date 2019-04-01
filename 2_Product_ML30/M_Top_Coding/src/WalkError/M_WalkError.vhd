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
-- 版    权  :  ZVISION
-- 文件名称  :  M_WalkError.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2019/01/28
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2019/01/28
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
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
----将flash中读出来的数据通过延迟校正后输出
----
-----

entity M_WalkError is
    generic (
        PrSl_DebugApd_c                 : integer := 1                          -- Debug_APD
    );
    port (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz
        
        --------------------------------
        -- Start Trig
        --------------------------------
        CpSl_Start1Trig_i               : in  std_logic;                        -- Start1_Trig
        CpSl_Start2Trig_i               : in  std_logic;                        -- Start2_Trig
        CpSl_Start3Trig_i               : in  std_logic;                        -- Start3_Trig
        
        --------------------------------
        -- Apd_Address/Num
        --------------------------------
        CpSl_ApdNumVld_i                : in  std_logic;                        -- ADP_NumVld
        CpSv_ApdNum_i                   : in  std_logic_vector( 6 downto 0);    -- ADP_Num   
        CpSl_ApdAddr_i                  : in  std_logic_vector(10 downto 0);    -- APD_Address
        
        --------------------------------
        -- Apd_Channel_Dly(Num : 96)
        --------------------------------
        CpSl_ApdDlyEn_i                 : in  std_logic;                        -- ADP_ApdChannel_DlyEn
        CpSv_ApdDlyData_i               : in  std_logic_vector(31 downto 0);    -- ADP_ApdChannel_DlyData  
        CpSv_ApdDlyAddr_i               : in  std_logic_vector(18 downto 0);    -- ADP_ApdChannel_DlyAddress

        --------------------------------
        -- Fifo_WalkError
        --------------------------------
        CpSl_WalkErrorRd_i              : in  std_logic;                        -- WalkError_RdCmd
        CpSl_WalkErrorRdVld_o           : out std_logic;                        -- WalkError_RdVld
        CpSv_WalkErrorRdData_o          : out std_logic_vector(20 downto 0)     -- WalkError_RdData
    );
end M_WalkError;

architecture arch_M_WalkError of M_WalkError is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    -- Start_Delay_x10ps
    constant PrSv_Start1Dly_c           : std_logic_vector(19 downto 0) := x"000B9"; -- 185
    constant PrSv_Start2Dly_c           : std_logic_vector(19 downto 0) := x"000BE"; -- 190
    constant PrSv_Start3Dly_c           : std_logic_vector(19 downto 0) := x"000B3"; -- 179
    
    -- ADP_Delay_x10ps
    constant PrSv_ApdA1Dly_c            : std_logic_vector(19 downto 0) := x"00009"; -- 9     
    constant PrSv_ApdB1Dly_c            : std_logic_vector(19 downto 0) := x"00009"; -- 9  
    constant PrSv_ApdC1Dly_c            : std_logic_vector(19 downto 0) := x"00003"; -- 3  
    constant PrSv_ApdD1Dly_c            : std_logic_vector(19 downto 0) := x"FFFFA"; -- -6 
    constant PrSv_ApdA2Dly_c            : std_logic_vector(19 downto 0) := x"0000E"; -- 14 
    constant PrSv_ApdB2Dly_c            : std_logic_vector(19 downto 0) := x"0000A"; -- 10 
    constant PrSv_ApdC2Dly_c            : std_logic_vector(19 downto 0) := x"00005"; -- 5  
    constant PrSv_ApdD2Dly_c            : std_logic_vector(19 downto 0) := x"00000"; -- 0  
    constant PrSv_ApdA3Dly_c            : std_logic_vector(19 downto 0) := x"0000E"; -- 14 
    constant PrSv_ApdB3Dly_c            : std_logic_vector(19 downto 0) := x"0001A"; -- 26 
    constant PrSv_ApdC3Dly_c            : std_logic_vector(19 downto 0) := x"FFFEF"; -- -17
    constant PrSv_ApdD3Dly_c            : std_logic_vector(19 downto 0) := x"0001F"; -- 31 
	 
	 -------
	 component vector_integer is
	 port(
		VECTOR_SIG		:	IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		INTEGER_SIG		:	OUT integer range 0 to 95
	 );
    end component;
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    component M_WalkErrorAdd is
    port (
		data0x		: IN STD_LOGIC_VECTOR (19 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (19 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (18 DOWNTO 0)
	);
    END component;
    
    component M_WalkErrorFifo is
    PORT (
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (20 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		    : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
    END component;

--    -- ApdDly_mif
--    component M_ApdNumDly is
--    port (
--		address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
--		clock		: IN STD_LOGIC  := '1';
--		q           : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
--	);
--    END component;

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSl_Start1Dly1_s            : std_logic;                            -- Start1_dly1
    signal PrSl_Start1Dly2_s            : std_logic;                            -- Start1_dly2
    signal PrSl_Start1Trig_s            : std_logic;                            -- Start1_Trig
    signal PrSl_Start2Dly1_s            : std_logic;                            -- Start2_dly1 
    signal PrSl_Start2Dly2_s            : std_logic;                            -- Start2_dly2 
    signal PrSl_Start2Trig_s            : std_logic;                            -- Start2_Trig 
    signal PrSl_Start3Dly1_s            : std_logic;                            -- Start3_dly1 
    signal PrSl_Start3Dly2_s            : std_logic;                            -- Start3_dly2 
    signal PrSl_Start3Trig_s            : std_logic;                            -- Start3_Trig 
    signal PrSv_LdTdcNum_s              : std_logic_vector( 1 downto 0);        -- Ld_Num
    signal PrSv_StartDly_s              : std_logic_vector(19 downto 0);        -- Start_Dly
    signal PrSv_ApdDly_s                : std_logic_vector(19 downto 0);        -- APd_Dly

    -- Fifo
    signal PrSl_Start_s                 : std_logic;                            -- Fifo_Start
    signal PrSl_StartDly1_s             : std_logic;                            -- Fifo_StartDly1
    signal PrSl_WrTrig_s                : std_logic;                            -- Fifo_WrTrig
    signal PrSv_ParAddData_s            : std_logic_vector(18 downto 0);        -- ParAdd_Data
    signal PrSv_FifoWrData_s            : std_logic_vector(20 downto 0);        -- Fifo_WrData
    signal PrSl_FifoEmpty_s             : std_logic;                            -- Fifo_Empty
    signal PrSl_RdCmd_s                 : std_logic;                            -- Fifo_RdCmd
    signal PrSl_RdCmdDly1_s             : std_logic;                            -- Fifo_RdCmdDly1
--    signal PrSl_RdCmdDly2_s             : std_logic;                            -- Fifo_RdCmdDly2
    signal PrSv_FifoRdData_s            : std_logic_vector(20 downto 0);        -- Fifo_RdData
    signal PrSl_WalkErrorRdDly1_s       : std_logic;                            -- Fifo_RdDly1
    signal PrSl_WalkErrorRdDly2_s       : std_logic;                            -- Fifo_RdDly2
    signal PrSv_WalkErrorRdData_s       : std_logic_vector(20 downto 0);        -- Fifo_RdData
    signal PrSl_WalkErrorTrig_s         : std_logic;                            -- Fifo_RdTrig

    -- Apd_NumDly
    signal PrSv_ApdDlyData_s            : std_logic_vector(1919 downto 0);      -- APD_Dly_Data
    signal PrSv_ApdNum_s                : STD_LOGIC_VECTOR( 7 DOWNTO 0);        -- Apd_Num 
    signal PrSv_ApdNumDly_s             : STD_LOGIC_VECTOR(19 DOWNTO 0);        -- Apd_NumDly
    signal PrSl_ApdNumVldDly1_s         : std_logic;                            -- ApdNumDly1
    signal PrSl_ApdNumVldDly2_s         : std_logic;                            -- ApdNumDly2
	 
	 
	 --------------------
	 type mem is array(95 downto 0) of std_logic_vector(19 downto 0);
	 signal Dlyram								 :	mem;
	 signal ramnum								 :	integer range 0 to 95;
	 signal rdnum								 :	integer range 0 to 95;
	 signal num_tp								 :	std_logic_vector(6 downto 0);

begin
    ----------------------------------------------------------------------------
    -- component_map
    ----------------------------------------------------------------------------
    U_M_WalkErrorAdd_0 : M_WalkErrorAdd
    port map (
		data0x		                    => PrSv_StartDly_s                      , -- IN  STD_LOGIC_VECTOR (19 DOWNTO 0);
		data1x		                    => PrSv_ApdNumDly_s,--PrSv_ApdDly_s                        , -- IN  STD_LOGIC_VECTOR (19 DOWNTO 0);
		result		                    => PrSv_ParAddData_s                      -- OUT STD_LOGIC_VECTOR (18 DOWNTO 0)
	);
    
    PrSv_FifoWrData_s <= PrSv_LdTdcNum_s & PrSv_ParAddData_s;
    U_M_WalkErrorFifo_0 : M_WalkErrorFifo
    PORT map (
		clock		                    => CpSl_Clk_i                           , --  IN  STD_LOGIC ;
		data		                    => PrSv_FifoWrData_s                    , --  IN  STD_LOGIC_VECTOR (20 DOWNTO 0);
		rdreq		                    => PrSl_RdCmd_s                         , --  IN  STD_LOGIC ;
		wrreq		                    => PrSl_WrTrig_s                        , --  IN  STD_LOGIC ;
		empty		                    => PrSl_FifoEmpty_s                     , --  OUT STD_LOGIC ;
		full		                    => open                                 , --  OUT STD_LOGIC ;
		q		                        => PrSv_WalkErrorRdData_s               , --  OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
		usedw		                    => open                                   --  OUT STD_LOGIC_VECTOR ( 6 DOWNTO 0)
	);
    -- CpSv_WalkErrorRdData_o
    CpSv_WalkErrorRdData_o <= PrSv_WalkErrorRdData_s;
	 ----------------------------------------------
	 ---------------------------------------------
	 u_ramnum:vector_integer
	 port map(
		VECTOR_SIG		=> CpSv_ApdDlyAddr_i(6 downto 0),
		INTEGER_SIG		=>	ramnum
	 );
	 
	 u_rdnum:vector_integer
	 port map(
		VECTOR_SIG		=> CpSv_ApdNum_i,
		INTEGER_SIG		=> rdnum
	 );
	 
--	 rdnum	<= conv_integer(CpSv_ApdNum_i);
--	 ramnum	<= conv_integer(CpSv_ApdDlyAddr_i(6 downto 0));
	 
	 
	 process(CpSl_Rst_iN,CpSl_Clk_i)
	 begin
		if(CpSl_Rst_iN='0') then
			for i in 0 to 95 loop
				Dlyram(i)	<= (others=>'0');
			end loop;
--			Dlyram(0) 	<= (others=>'0');
--			Dlyram(1) 	<= (others=>'0');
--			Dlyram(2) 	<= (others=>'0');
--			Dlyram(3) 	<= (others=>'0');
--			Dlyram(4) 	<= (others=>'0');
--			Dlyram(5) 	<= (others=>'0');
--			Dlyram(6) 	<= (others=>'0');
--			Dlyram(7) 	<= (others=>'0');
--			Dlyram(8) 	<= (others=>'0');
--			Dlyram(9) 	<= (others=>'0');
--			Dlyram(10) 	<= (others=>'0');
--			Dlyram(11) 	<= (others=>'0');
--			Dlyram(12) 	<= (others=>'0');
--			Dlyram(13) 	<= (others=>'0');
--			Dlyram(14) 	<= (others=>'0');
--			Dlyram(15) 	<= (others=>'0');
--			Dlyram(16) 	<= (others=>'0');
--			Dlyram(17) 	<= (others=>'0');
--			Dlyram(18) 	<= (others=>'0');
--			Dlyram(19) 	<= (others=>'0');
--			Dlyram(20) 	<= (others=>'0');
--			Dlyram(21) 	<= (others=>'0');
--			Dlyram(22) 	<= (others=>'0');
--			Dlyram(23) 	<= (others=>'0');
--			Dlyram(24) 	<= (others=>'0');
--			Dlyram(25) 	<= (others=>'0');
--			Dlyram(26) 	<= (others=>'0');
--			Dlyram(27) 	<= (others=>'0');
--			Dlyram(28) 	<= (others=>'0');
--			Dlyram(29) 	<= (others=>'0');
--			Dlyram(30) 	<= (others=>'0');
--			Dlyram(31) 	<= (others=>'0');
--			
--			Dlyram(32) 	<= (others=>'0');
--			Dlyram(33) 	<= (others=>'0');
--			Dlyram(34) 	<= (others=>'0');
--			Dlyram(35) 	<= (others=>'0');
--			Dlyram(36) 	<= (others=>'0');
--			Dlyram(37) 	<= (others=>'0');
--			Dlyram(38) 	<= (others=>'0');
--			Dlyram(39) 	<= (others=>'0');
--			Dlyram(40) 	<= (others=>'0');
--			Dlyram(41) 	<= (others=>'0');
--			Dlyram(42) 	<= (others=>'0');
--			Dlyram(43) 	<= (others=>'0');
--			Dlyram(44) 	<= (others=>'0');
--			Dlyram(45) 	<= (others=>'0');
--			Dlyram(46) 	<= (others=>'0');
--			Dlyram(47) 	<= (others=>'0');
--			Dlyram(48) 	<= (others=>'0');
--			Dlyram(49) 	<= (others=>'0');
--			Dlyram(50) 	<= (others=>'0');
--			Dlyram(51) 	<= (others=>'0');
--			Dlyram(52) 	<= (others=>'0');
--			Dlyram(53) 	<= (others=>'0');
--			Dlyram(54) 	<= (others=>'0');
--			Dlyram(55) 	<= (others=>'0');
--			Dlyram(56) 	<= (others=>'0');
--			Dlyram(57) 	<= (others=>'0');
--			Dlyram(58) 	<= (others=>'0');
--			Dlyram(59) 	<= (others=>'0');
--			Dlyram(60) 	<= (others=>'0');
--			Dlyram(61) 	<= (others=>'0');
--			Dlyram(62) 	<= (others=>'0');
--			Dlyram(63) 	<= (others=>'0');
--			
--			Dlyram(64) 	<= (others=>'0');
--			Dlyram(65) 	<= (others=>'0');
--			Dlyram(66) 	<= (others=>'0');
--			Dlyram(67) 	<= (others=>'0');
--			Dlyram(68) 	<= (others=>'0');
--			Dlyram(69) 	<= (others=>'0');
--			Dlyram(70) 	<= (others=>'0');
--			Dlyram(71) 	<= (others=>'0');
--			Dlyram(72) 	<= (others=>'0');
--			Dlyram(73) 	<= (others=>'0');
--			Dlyram(74) 	<= (others=>'0');
--			Dlyram(75) 	<= (others=>'0');
--			Dlyram(76) 	<= (others=>'0');
--			Dlyram(77) 	<= (others=>'0');
--			Dlyram(78) 	<= (others=>'0');
--			Dlyram(79) 	<= (others=>'0');
--			Dlyram(80) 	<= (others=>'0');
--			Dlyram(81) 	<= (others=>'0');
--			Dlyram(82) 	<= (others=>'0');
--			Dlyram(83) 	<= (others=>'0');
--			Dlyram(84) 	<= (others=>'0');
--			Dlyram(85) 	<= (others=>'0');
--			Dlyram(86) 	<= (others=>'0');
--			Dlyram(87) 	<= (others=>'0');
--			Dlyram(88) 	<= (others=>'0');
--			Dlyram(89) 	<= (others=>'0');
--			Dlyram(90) 	<= (others=>'0');
--			Dlyram(91) 	<= (others=>'0');
--			Dlyram(92) 	<= (others=>'0');
--			Dlyram(93) 	<= (others=>'0');
--			Dlyram(94) 	<= (others=>'0');
--			Dlyram(95) 	<= (others=>'0');
		elsif rising_edge(CpSl_Clk_i) then
			if(CpSl_ApdDlyEn_i='1') then
				Dlyram(ramnum)	<= CpSv_ApdDlyData_i(19 downto 0);
			end if;
		end if;
	 end process;
	 
	 process(CpSl_Rst_iN,CpSl_Clk_i)
	 begin
		if(CpSl_Rst_iN='0') then
			PrSv_ApdNumDly_s	<= (others=>'0');
		elsif rising_edge(CpSl_Clk_i) then
			if(CpSl_ApdNumVld_i='1') then
				PrSv_ApdNumDly_s	<= Dlyram(rdnum);
			end if;
		end if;
	 end process;
	 

    
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_ApdDlyData_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (CpSl_ApdDlyEn_i = '1') then
--                PrSv_ApdDlyData_s <= PrSv_ApdDlyData_s(1899 downto 0) & CpSv_ApdDlyData_i(19 downto 0);
--            end if;
--        end if;
--    end process;
--     
--
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if(CpSl_Rst_iN='0') then
--            PrSv_ApdNumDly_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            case PrSv_ApdNum_s is
--                when    x"00"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(19   downto 0   );
--                when    x"01"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(39   downto 20  );
--                when    x"02"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(59   downto 40  );
--                when    x"03"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(79   downto 60  );
--                when    x"04"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(99   downto 80  );
--                when    x"05"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(119  downto 100 );
--                when    x"06"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(139  downto 120 );
--                when    x"07"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(159  downto 140 );
--                when    x"08"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(179  downto 160 );
--                when    x"09"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(199  downto 180 );
--                when    x"0a"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(219  downto 200 );
--                when    x"0b"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(239  downto 220 );
--                when    x"0c"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(259  downto 240 );
--                when    x"0d"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(279  downto 260 );
--                when    x"0e"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(299  downto 280 );
--                when    x"0f"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(319  downto 300 );
--                when    x"10"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(339  downto 320 );
--                when    x"11"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(359  downto 340 );
--                when    x"12"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(379  downto 360 );
--                when    x"13"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(399  downto 380 );
--                when    x"14"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(419  downto 400 );
--                when    x"15"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(439  downto 420 );
--                when    x"16"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(459  downto 440 );
--                when    x"17"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(479  downto 460 );
--                when    x"18"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(499  downto 480 );
--                when    x"19"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(519  downto 500 );
--                when    x"1a"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(539  downto 520 );
--                when    x"1b"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(559  downto 540 );
--                when    x"1c"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(579  downto 560 );
--                when    x"1d"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(599  downto 580 );
--                when    x"1e"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(619  downto 600 );
--                when    x"1f"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(639  downto 620 );
--                when    x"20"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(659  downto 640 );
--                when    x"21"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(679  downto 660 );
--                when    x"22"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(699  downto 680 );
--                when    x"23"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(719  downto 700 );
--                when    x"24"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(739  downto 720 );
--                when    x"25"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(759  downto 740 );
--                when    x"26"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(779  downto 760 );
--                when    x"27"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(799  downto 780 );
--                when    x"28"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(819  downto 800 );
--                when    x"29"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(839  downto 820 );
--                when    x"2a"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(859  downto 840 );
--                when    x"2b"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(879  downto 860 );
--                when    x"2c"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(899  downto 880 );
--                when    x"2d"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(919  downto 900 );
--                when    x"2e"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(939  downto 920 );
--                when    x"2f"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(959  downto 940 );
--                when    x"30"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(979  downto 960 );
--                when    x"31"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(999  downto 980 );
--                when    x"32"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1019 downto 1000);
--                when    x"33"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1039 downto 1020);
--                when    x"34"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1059 downto 1040);
--                when    x"35"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1079 downto 1060);
--                when    x"36"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1099 downto 1080);
--                when    x"37"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1119 downto 1100);
--                when    x"38"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1139 downto 1120);
--                when    x"39"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1159 downto 1140);
--                when    x"3a"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1179 downto 1160);
--                when    x"3b"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1199 downto 1180);
--                when    x"3c"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1219 downto 1200);
--                when    x"3d"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1239 downto 1220);
--                when    x"3e"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1259 downto 1240);
--                when    x"3f"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1279 downto 1260);
--                when    x"40"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1299 downto 1280);
--                when    x"41"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1319 downto 1300);
--                when    x"42"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1339 downto 1320);
--                when    x"43"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1359 downto 1340);
--                when    x"44"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1379 downto 1360);
--                when    x"45"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1399 downto 1380);
--                when    x"46"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1419 downto 1400);
--                when    x"47"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1439 downto 1420);
--                when    x"48"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1459 downto 1440);
--                when    x"49"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1479 downto 1460);
--                when    x"4a"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1499 downto 1480);
--                when    x"4b"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1519 downto 1500);
--                when    x"4c"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1539 downto 1520);
--                when    x"4d"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1559 downto 1540);
--                when    x"4e"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1579 downto 1560);
--                when    x"4f"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1599 downto 1580);
--                when    x"50"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1619 downto 1600);
--                when    x"51"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1639 downto 1620);
--                when    x"52"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1659 downto 1640);
--                when    x"53"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1679 downto 1660);
--                when    x"54"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1699 downto 1680);
--                when    x"55"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1719 downto 1700);
--                when    x"56"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1739 downto 1720);
--                when    x"57"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1759 downto 1740);
--                when    x"58"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1779 downto 1760);
--                when    x"59"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1799 downto 1780);
--                when    x"5a"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1819 downto 1800);
--                when    x"5b"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1839 downto 1820);
--                when    x"5c"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1859 downto 1840);
--                when    x"5d"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1879 downto 1860);
--                when    x"5e"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1899 downto 1880);
--                when    x"5f"   =>  PrSv_ApdNumDly_s <= PrSv_ApdDlyData_s(1919 downto 1900);
--
--                when others => PrSv_ApdNumDly_s <= (others=>'0');
--            end case;
--        end if;
--    end process;
   
--    process (CpSl_Rst_iN,CpSl_Clk_i)
--        variable PrSv_ApdNumDlyData_s : std_logic_vector(19 downto 0);
--    begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_ApdNumDly_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            PrSv_ApdNumDlyData_s := (others => '0');
--            for PrSv_ApdNum_s in 0 to 95 loop
--                PrSv_ApdNumDlyData_s := PrSv_ApdDlyData_s(20*(PrSv_ApdNum_s + 1) - 1 downto 20*PrSv_ApdNum_s);
--            end loop;
--            
--            PrSv_ApdNumDly_s <= PrSv_ApdNumDlyData_s;
--        end if;
--    end process;
    
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- Start1_Dly
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_Start1Dly1_s <= '0';
            PrSl_Start1Dly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_Start1Dly1_s <= CpSl_Start1Trig_i;
            PrSl_Start1Dly2_s <= PrSl_Start1Dly1_s;
        end if;
    end process;
    -- PrSl_Start1Trig_s
    PrSl_Start1Trig_s <= (not PrSl_Start1Dly2_s) and PrSl_Start1Dly1_s;
    
    -- Start2_Dly
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_Start2Dly1_s <= '0';
            PrSl_Start2Dly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_Start2Dly1_s <= CpSl_Start2Trig_i;
            PrSl_Start2Dly2_s <= PrSl_Start2Dly1_s;
        end if;
    end process;
    -- PrSl_Start2Trig_s
    PrSl_Start2Trig_s <= (not PrSl_Start2Dly2_s) and PrSl_Start2Dly1_s;
    
    -- Start3_Dly
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_Start3Dly1_s <= '0';
            PrSl_Start3Dly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_Start3Dly1_s <= CpSl_Start3Trig_i;
            PrSl_Start3Dly2_s <= PrSl_Start3Dly1_s;
        end if;
    end process;
    -- PrSl_Start3Trig_s
    PrSl_Start3Trig_s <= (not PrSl_Start3Dly2_s) and PrSl_Start3Dly1_s;
    
    -- PrSv_StartDly_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_StartDly_s <= (others => '0');
            PrSv_LdTdcNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_Start1Trig_s = '1') then--第1个发射
                PrSv_StartDly_s <= PrSv_Start1Dly_c;
                PrSv_LdTdcNum_s <= "01";
            elsif (PrSl_Start2Trig_s = '1') then --第2个发射
                PrSv_StartDly_s <= PrSv_Start2Dly_c;
                PrSv_LdTdcNum_s <= "10";
            elsif (PrSl_Start3Trig_s = '1') then--第3个发射 
                PrSv_StartDly_s <= PrSv_Start3Dly_c;
                PrSv_LdTdcNum_s <= "11";
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_ApdDly_s
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_ApdNum_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (CpSl_ApdNumVld_i = '1') then
--                 PrSv_ApdNum_s <= '0' & CpSv_ApdNum_i;
--            else -- hold
--            end if;
--        end if;
--    end process;

--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSl_ApdNumVldDly1_s <= '0';
--            PrSl_ApdNumVldDly2_s <= '0';
--        elsif rising_edge(CpSl_Clk_i) then
--            PrSl_ApdNumVldDly1_s <= CpSl_ApdNumVld_i;
--            PrSl_ApdNumVldDly2_s <= PrSl_ApdNumVldDly1_s;
--        end if;
--    end process;

--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_ApdDly_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSl_ApdNumVldDly2_s = '1') then 
--                PrSv_ApdDly_s <= PrSv_ApdNumDly_s;
--            else -- hold
--            end if;
--        end if;
--    end process;


    
    -- PrSl_Start_s
    PrSl_Start_s <= PrSl_Start1Trig_s or PrSl_Start2Trig_s or PrSl_Start3Trig_s;
    
    -- PrSl_WrTrig_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_StartDly1_s <= '0';
            PrSl_WrTrig_s    <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_StartDly1_s <= PrSl_Start_s;
            PrSl_WrTrig_s    <= PrSl_StartDly1_s;
        end if;
    end process;
    
    -- CpSl_WalkErrorRd_i
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_WalkErrorRdDly1_s <= '0';
            PrSl_WalkErrorRdDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_WalkErrorRdDly1_s <= CpSl_WalkErrorRd_i;
            PrSl_WalkErrorRdDly2_s <= PrSl_WalkErrorRdDly1_s;
        end if;
    end process;
    -- PrSl_WalkErrorTrig_s
    PrSl_WalkErrorTrig_s <= (not PrSl_WalkErrorRdDly2_s) and PrSl_WalkErrorRdDly1_s;
    
    -- PrSl_RdCmd_s     
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_RdCmd_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_FifoEmpty_s = '0') then 
                if (PrSl_WalkErrorTrig_s = '1') then
                    PrSl_RdCmd_s <= '1';
                else
                    PrSl_RdCmd_s <= '0';
                end if;
            else 
                PrSl_RdCmd_s <= '0';
            end if;
        end if;
    end process;
    
    -- CpSl_WalkErrorRdVld_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_RdCmdDly1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_FifoEmpty_s = '0') then 
                PrSl_RdCmdDly1_s <= PrSl_RdCmd_s;
            else
                PrSl_RdCmdDly1_s <= '0';
            end if;
        end if;
    end process;
    -- CpSl_WalkErrorRdVld_o
    CpSl_WalkErrorRdVld_o <= PrSl_RdCmdDly1_s;

----------------------------------------
-- End
----------------------------------------
end arch_M_WalkError;