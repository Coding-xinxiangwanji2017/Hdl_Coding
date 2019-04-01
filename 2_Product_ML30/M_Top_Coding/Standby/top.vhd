library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity top is
  port(
    CLK_40MHz_IN       :   in std_logic;	-- 40MHz 
    LVRESETN           :   in std_logic;	-- '0'��Ч 
    --Laser Driver Related Signals------------------
    F_START1           :  out std_logic;
    F_START2           :  out std_logic;
    F_GAINRST          :  out std_logic;
    F_RPI	           :  out std_logic;
	 F_STOP             :   in std_logic;
    ---------AD7547------------------------------------
    F_DA               :  out std_logic_vector(11 downto 0);
    F_DCSA	           :  out std_logic;
    F_DCSB	           :  out std_logic;
    F_DCSC             :  out std_logic;
    F_DWR	           :  out std_logic;
	 ---------GPS&PPS---------------------------------
	 F_PPS              :   in std_logic;
	 F_GPS_UART_RX      :   in std_logic;
    ---------LTC2324---------------------------------
	 F_CNV              :  out std_logic;
    F_SDR_DDR0         :  out std_logic;
    F_CMOS_LVDS0       :  out std_logic;
	 F_SDR_DDR1         :  out std_logic;
    F_CMOS_LVDS1       :  out std_logic;
	 F_SCK_1            :  out std_logic;
	 F_SD0_1            :   in std_logic;
	 F_SD1_1            :   in std_logic;
	 F_SD2_1            :   in std_logic;
	 F_SD3_1            :   in std_logic;
    F_SCK_P            :  out std_logic;
    --F_SCK_N            :  out std_logic;
    F_SDO0_P           :   in std_logic;
    --F_SDO0_N           :   in std_logic;
    F_SDO1_P           :   in std_logic;
    --F_SDO1_N           :   in std_logic;
    F_SDO2_P           :   in std_logic;
    --F_SDO2_N           :   in std_logic;
    F_SDO3_P           :   in std_logic;
    --F_SDO3_N           :   in std_logic;
	 F_AD_CLKOUT_P         :   in std_logic;
	 F_AD_CLKOUT_1         :   in std_logic;
	 F_AD_CLKOUT_ENABLE    :  out std_logic;
    ---------TDC-GPX2--------------------------------
	 F_CLKOUT_P         :   in std_logic;
    F_FRAME1_P         :   in std_logic;
	 --F_FRAME2_P(n)      :   in std_logic;
    --F_FRAME1_N         :   in std_logic;
    F_SD1_P            :   in std_logic;
    --F_SD1_N            :   in std_logic;
    F_FRAME2_P         :   in std_logic;
    --F_FRAME2_N         :   in std_logic;
    F_SD2_P            :   in std_logic;
    --F_SD2_N            :   in std_logic;
    F_FRAME3_P         :   in std_logic;
    --F_FRAME3_N         :   in std_logic;
    F_SD3_P            :   in std_logic;
    --F_SD3_N            :   in std_logic;
    F_FRAME4_P         :   in std_logic;
    --F_FRAME4_N         :   in std_logic;
    F_SD4_P            :   in std_logic;
    --F_SD4_N            :   in std_logic;
    F_LCLK_OUT_P       :   in std_logic;
    --F_LCLK_OUT_N       :   in std_logic;
    F_LCLK_IN_P        :  out std_logic;
    --F_LCLK_IN_N        :  out std_logic;
    F_DISABLE_P        :  out std_logic;
    --F_DISABLE_N        :  out std_logic;
    F_REFCLK_P         :  out std_logic;
    --F_REFCLK_N         :  out std_logic;
    F_RSTIDX_P         :  out std_logic;
    --F_RSTIDX_N         :  out std_logic;
    F_PARITY           :   in std_logic;
    F_INTERRUPT        :   in std_logic;
    F_SSN              :  out std_logic;
    F_SCK              :  out std_logic;
    F_MOSI             :  out std_logic;
    F_MISO             :   in std_logic;
    F_LCLKIN_P         :  out std_logic; 
	 F_HV_ENABLE        :  out std_logic;
	 F_SHDN             :  out std_logic;
    ----------I2C---------------------------------------
	 F_CHANNEL          :   in std_logic;
	 F_AD5242_DATA      :   in std_logic_vector(7 downto 0);
    F_SDA              :inout std_logic;
    F_SCL              :  out std_logic;
    -----------W5300------------------------------------
    F_ETH_D            : inout std_logic_vector(15 downto 0);
    F_ETH_A            :  out std_logic_vector( 9 downto 1);
    F_ETH_WRN	        :  out std_logic;
    F_ETH_OEN 	        :  out std_logic;
    F_ETH_CSN	        :  out std_logic;
    F_ETH_RSTN	        :  out std_logic;
    F_ETH_INT	        :   in std_logic
	);
end top;

architecture rtl of top is

  component ad_tick_generator is
  port(
    nrst            :  in std_logic;
    clk             :  in std_logic;
    start           :  in std_logic;
    ad_tick         : out std_logic
  );
  end component;


  component adc_ltc2324_16_controller is
  port(
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
    ad_data0           :  out std_logic_vector(15 downto 0);
    ad_data1           :  out std_logic_vector(15 downto 0);
    ad_data2           :  out std_logic_vector(15 downto 0);
    ad_data3           :  out std_logic_vector(15 downto 0);
    covn               :  out std_logic 
    );
  end component;

  component counter_shdn is
  port(
    clk                :   in std_logic;	-- 40MHz 
    clk_1ms_tick       :   in std_logic;
    nrst               :   in std_logic;
    shdn               :  out std_logic
    );
  end component;

  component MEMX_10000_LUT IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
  END component;
  
  component MEMY_10000_LUT IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
  END component;

  component TX_LVDS is
	port (
		tx_inclock  : in  std_logic                     := '0';             --  tx_inclock.tx_inclock
		tx_outclock : out std_logic;                                        --  tx_outclock.tx_outclock
		pll_areset  : in  std_logic                     := '0';             --  pll_areset.pll_areset
		tx_in       : in  std_logic_vector(7 downto 0) := (others => '0'); --  tx_in.tx_in
		tx_out      : out std_logic                     --  tx_out.tx_out
	);
  end component;

  component combine_fifo IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (47 DOWNTO 0)
	);
  end component;

  component tdc_gpx_control is
  port(
  nrst                 :   in std_logic;
  clk                  :   in std_logic;
  start                :   in std_logic;
  tdc_gpx_wrn          :  out std_logic;
  tdc_qpx_rdn          :  out std_logic;
  tdc_gpx_csn          :  out std_logic;
  tdc_gpx_ad           :  out std_logic_vector(3 downto 0);
  tdc_gpx_data         :inout std_logic_vector(15 downto 0);
  tdc_gpx_fe0          :   in std_logic;
  tdc_gpx_fe1          :   in std_logic;
  tdc_gpx_error        :   in std_logic;
  cal_start            :  out std_logic;
  tdc_gpx_data0        :  out std_logic_vector(27 downto 0);
  tdc_gpx_data1        :  out std_logic_vector(27 downto 0);
  tdc_gpx_data2        :  out std_logic_vector(27 downto 0);
  cal_finish           :   in std_logic;
  cal_result0          :   in std_logic_vector(15 downto 0);
  cal_result1          :   in std_logic_vector(15 downto 0);
  cal_result2          :   in std_logic_vector(15 downto 0);
  distance_fifo_data   :  out std_logic_vector(23 downto 0);
  fifo_wr              :  out std_logic;
  tdc_oen              :  out std_logic    
);
  end component;
  
  

  component da_controller_7547 is
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
    da_acs               : out std_logic;
    da_bcs               : out std_logic;
    da_ccs               : out std_logic;
    da_finish            : out std_logic
  );
  end component;
	
component mem_vx_vy_control is
  port (
    nrst           :  in  std_logic;
    clk            :  in  std_logic;
    cal_start_tick :  in  std_logic;
    datain         :  in  std_logic_vector(19 downto 0);
    lut_addr       : out  std_logic_vector(15 downto 0);
    lut_data       :  in  std_logic_vector(15 downto 0);
    lut_ydata      :  in std_logic_vector(15 downto 0);
    lut_down_ydata :  in std_logic_vector(15 downto 0);
    y_div_tick     : out  std_logic;
    y_dividend     : out  std_logic_vector(13 downto 0);
    y_divisor      : out  std_logic_vector( 6 downto 0);
    div_y_out      :  in  std_logic_vector(13 downto 0);  --100k
    y_finish       :  in  std_logic;
    cal_finish     : out  std_logic;
    vx_out         : out  std_logic_vector(11 downto 0);
    vy_out         : out  std_logic_vector(11 downto 0)
    );
  end component;
  
  component div_mem_n is
    GENERIC (
      WN:INTEGER := 14;    --24 --22---------39
      WD:INTEGER := 7 );   --16 --14---------22
    port(
      nrst :  in std_logic;
      clk  :  in std_logic;
      start:  in std_logic;
      finish: out std_logic;
        a    :  in std_logic_vector(WN-1 downto 0);
        b    :  in std_logic_vector(WD-1 downto 0);
        q    : out std_logic_vector(WN-1 downto 0)
       );
    end component;	
  
  component cmd_ctrl is 
    port(
      nrst                   :  IN std_logic;
      clk                    :  IN std_logic;
      rcv                    :  IN std_logic;
      rcv_data               :  IN std_logic_vector(15 downto 0);
      start_tick             : OUT std_logic;
      soft_reset_tick        : OUT std_logic
      );
    end component;	
	
  component v_filter_2 is
	 generic(
		constant RESET_VALID : std_logic := '0';		-- ��λ�ź���Чֵ
		constant RESET_VALUE : std_logic := '0';		-- ��λ����ֵ
		constant SCALER_SIZE : integer := 8;			-- �˲������Ĵ�����λ��
		constant SYNC_COUNT : integer := 2				-- ͬ���������� 
	);
	port(
	  rst        : in std_logic;            	-- ��λ�ź�
	  clk        : in std_logic;            	-- ����ʱ��
	  clk_filter : in std_logic;		  	-- �˲�ʱ��, tick	
	  scaler     : in std_logic_vector(SCALER_SIZE - 1 downto 0);	-- �˲��������˲�ʱ�� = scaler * Period(clk_filter)��Ĭ��ֵΪ4
	  signal_in  : in std_logic; 			-- �����ź�
	  signal_out : out std_logic        	-- �����ź�									 
	  );
    end component;	
	
   component w5300_access is
	  port(
		 clk : in std_logic;
		 nrst : in std_logic;
		 inter_wr : in std_logic;	-- �ڲ�д��tick 
		 inter_rd : in std_logic;	-- �ڲ����tick 
		 inter_ncs : in std_logic;	-- �ڲ�Ƭѡ 
		 inter_addr : in std_logic_vector(9 downto 0);	-- �ڲ���ַ 
		 inter_data_in : in std_logic_vector(15 downto 0);	-- �ڲ��������� 
		 inter_data_out : out std_logic_vector(15 downto 0);	-- �ڲ��������� 
		 nwr : out std_logic;	-- ����д�ź� 
		 nrd : out std_logic;	-- ���ڶ��ź� 
		 ncs : out std_logic;	-- ����Ƭѡ�ź�
		 addr : out std_logic_vector(9 downto 0);	-- ���ڵ�ַ�ź� 
		 data : inout std_logic_vector(15 downto 0)	-- ���������ź� 
	  );
    end component;
	
   component w5300_ctrl is
	  port(
	    clk : in std_logic;
	    nrst : in std_logic;
	    tick_1us : in std_logic;	-- tick 1us 
	    tick_10us : in std_logic;	-- tick 10us 
	    tick_100us : in std_logic;	-- tick 100us 
	    tick_1ms : in std_logic;	-- tick 1ms 
	    nint_f : in std_logic;	-- W5300�ж��źţ�'0'��Ч 
	    ethernet_package_gap_cnt : in std_logic_vector(15 downto 0);	-- ��̫���´��������İ��� 
	    ethernet_package_gap : in std_logic_vector(15 downto 0);	-- ��̫���´���������1us 
	    ethernet_nrst_ctrl : in std_logic;	-- ���ڸ�λ�����ź� 
	    ethernet_init_start : in std_logic;	-- ���ڳ�ʼ�����־��tick 
	    ethernet_init_done : out std_logic;	-- ���ڳ�ʼ�����ɱ�־��tick 
	    ethernet_init_result : out std_logic;	-- ���ڳ�ʼ��������'1'�ɹ���'0'ʧ�� 
	    rcv : out std_logic;	-- �������ɵ�tick 
	    rcv_data : out std_logic_vector(15 downto 0);	-- �������� 
	    fifo_rd : out std_logic;	-- ��������FIFO���ź� 
	    fifo_data : in std_logic_vector(31 downto 0);	-- ��������FIFO���� 
	    fifo_empty : in std_logic;	-- ��������FIFO�ձ�־ 
	    send_start : in std_logic;	-- �������tick 
	    send_done : out std_logic;	-- �������ɣ�tick 
	    wr : out std_logic;	-- д��tick 
	    rd : out std_logic;	-- ���tick 
	    ncs : out std_logic;	-- Ƭѡ 
	    addr : out std_logic_vector(9 downto 0);	-- ��ַ 
	    data_wr : out std_logic_vector(15 downto 0);	-- ����д 
	    data_rd : in std_logic_vector(15 downto 0)	-- ���ݶ� 
	   );
    end component;	
	
  component time_distance_conversion is
  port(
    nrst                 :   in std_logic;
    clk                  :   in std_logic;
    cal_start            :   in std_logic;
    tdc_gpx_data0        :   in std_logic_vector(27 downto 0);
    tdc_gpx_data1        :   in std_logic_vector(27 downto 0);
    tdc_gpx_data2        :   in std_logic_vector(27 downto 0);
    cal_finish           :  out std_logic;
    cal_result0          :  out std_logic_vector(15 downto 0);
    cal_result1          :  out std_logic_vector(15 downto 0);
    cal_result2          :  out std_logic_vector(15 downto 0)
  );
  end component;	
	
  component PLL_100M IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
  END component;	
	
  component pll_38M IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		    : OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
  END component;
	
  component Reset_Gen is
	generic(
	Constant iValidValue: std_logic:='0';
	Constant oValidValue: std_logic:='0'
	);
	 port(
		 clk : in std_logic;
		 reset_i : in std_logic;
		 reset_o : out std_logic
	     );
  end component;
  
  component ctrlCycle_simple
    generic( 
      constant  RstValidValue	: std_logic:='0';	
      constant  DATAWIDTH	: integer range 1 to 16 := 8;
      constant  RST_DIV	: integer range 1 to 65535 := 9			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ); 
  port (
      nrst   : in  std_logic;
      clk    : in  std_logic;
      enable : in  std_logic;   	--	'1' is enable
 clk_tick    : out std_logic
		);
  end component;


component pulse_gen is 
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
  end component;
	
  
  component state_control_top is
  port (
    nrst                    :  in  std_logic;
    clk                     :  in  std_logic;
	clk_125k_tick            :  in  std_logic;
    clk_1ms_tick            :  in  std_logic;
	laser_power              :  in  std_logic_vector(9 downto 0);
    start_tick              :  in  std_logic;
    soft_reset_tick         :  in  std_logic;
    mem_dax                 :  in  std_logic_vector(11 downto 0);
    mem_day                 :  in  std_logic_vector(11 downto 0);
    mem_dastart             :  in  std_logic;
    laser_rpi_start_start   : out  std_logic;
    initial_flag            : out  std_logic;
    pic_tdc_procedure_start : out std_logic;
    w5300_nrst_ctrl         : out  std_logic;
    w5300_init_start        : out  std_logic;
    w5300_init_finish       :  in  std_logic;
    w5300_init_result       :  in  std_logic;
    w5300_ready             : out  std_logic;
    laser_gse               : out  std_logic;
    laser_ple               : out  std_logic;
    da_datax                : out  std_logic_vector(11 downto 0);
    da_datay                : out  std_logic_vector(11 downto 0);
    da_start                : out  std_logic;
    da_finish               :  in  std_logic;
	 state_output            : out  std_logic_vector(7 downto 0);
	 state_out               : out  std_logic_vector(5 downto 0);
	 write_ad5242_tick       : out  std_logic
  );
  end component;
  
  
  component agc_top is
port(
  nrst            : in std_logic;
  clk             : in std_logic;
  agc_data        : in std_logic_vector(7 downto 0);
  agc_start_tick  : in std_logic;
  agc_da_start_tick    : out std_logic;
  da_data_agc          : out std_logic_vector(11 downto 0)
);
end component;

  component delay_nrst is
	generic(
	  constant TIME_CNT : integer := 4	-- 复位延迟时间长度
	);
	port(
	  clk : in std_logic;
	  nrst : in std_logic;
	  nrst_ctrl : in std_logic;	-- '0'有效 
	  tick_cnt : in std_logic;	-- 计时时钟 
	  d_nrst : out std_logic	-- nrst与nrst_ctrl均无效后，d_nrst延迟[tick_cnt*(TIME_CNT-1)+clk,tick_cnt*TIME_CNT+2*clk]
	);
  end component;
  
  component eth_write is
port(
  clk         :  in  STD_LOGIC;
  nrst        :  in  STD_LOGIC;
  k_start_tick:  in  STD_LOGIC;
  fifo_rd     : out  STD_LOGIC;
  fifo_data   :  in  STD_LOGIC_VECTOR(63 downto 0);
  fifo_empty  :  in  STD_LOGIC;
  fifo_wr     : out  STD_LOGIC;
  fifo_wdata  : out  STD_LOGIC_VECTOR(31 downto 0);
  send_tick   : out  STD_LOGIC
  );
end component;
  
  component fifo IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
  end component;
  
  component div IS
	PORT
	(
		clken		   : IN STD_LOGIC ;
		clock		   : IN STD_LOGIC ;
		denom		   : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		numer		   : IN STD_LOGIC_VECTOR (29 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (29 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
  END component;
  
  component xsincos is
	port 
	(
		a      : in  std_logic_vector(11 downto 0) := (others => '0'); --      a.a
		areset : in  std_logic                     := '0';             -- areset.reset
		c      : out std_logic_vector(10 downto 0);                    --      c.c
		clk    : in  std_logic                     := '0';             --    clk.clk
		en     : in  std_logic_vector(0 downto 0)  := (others => '0'); --     en.en
		s      : out std_logic_vector(10 downto 0)                     --      s.s
	);
  end component;

--  component ad_controller_9650 is
--    port(
--  nrst            :  in std_logic;
--  clk             :  in std_logic;
--  start           :  in std_logic;
--  xad             :  in std_logic_vector(13 downto 0);
--  agc_ad          :  in std_logic_vector( 7 downto 0);
--  adclk_p         : out std_logic;
--  adclk_n         : out std_logic;
--  ad_dcoa         :  in std_logic;
--  ad_dcob         :  in std_logic;  
--  memx_fifo_wr    : out std_logic; 
--  memx_fifo_data  : out std_logic_vector(13 downto 0);
--  agc_data_temp   : out std_logic_vector(7 downto 0);
--  agc_start_tick  : out std_logic
--);
--end component;

  component MEMX_LUT IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
  END component;
  
  component  MEMY_LUT IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
  END component;

 component memy_fifo IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
 end component;

 component memx_fifo IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
  end component;
  
  component distance_fifo IS
	 port
	 (
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	 );
  end component;
  
  component fifo_transfer is
port(
  clk            :  in  STD_LOGIC;
  nrst           :  in  STD_LOGIC;
  start          :  in  STD_LOGIC;
  agc_data       :  in  STD_LOGIC_VECTOR(7 downto 0);
  agc_start_tick :  in  STD_LOGIC;
  memx_fifo_data :  in  STD_LOGIC_VECTOR(13 downto 0);
  memx_fifo_rd   : out  STD_LOGIC;
  distance_data  :  in  STD_LOGIC_VECTOR(23 downto 0);
  distance_rd    : out  STD_LOGIC;
  distance_empty :  in  STD_LOGIC;
  distance_full  :  in  STD_LOGIC;
  combine_data   : out  STD_LOGIC_VECTOR(47 downto 0);
  combine_wr     : out  STD_LOGIC
  );
end component;

  component fifo_transfer_final is
  port(
    clk               :  in  STD_LOGIC;
    nrst              :  in  STD_LOGIC;
    k_pulse           :  in  STD_LOGIC;
    datain_fifo       :  in  STD_LOGIC_VECTOR(47 downto 0);
    datain_rd         : out  STD_LOGIC;
    datain_fifo_empty :  in  STD_LOGIC;
    datain_fifo_full  :  in  STD_LOGIC;
    memy_data         :  in  STD_LOGIC_VECTOR(11 downto 0);
    memy_rd           : out  STD_LOGIC;
    datafinal_data    : out  STD_LOGIC_VECTOR(63 downto 0);
    datafinal_wr      : out  STD_LOGIC
    );
  end component;
  
  component final_data_fifo IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
	);
  end component;
  
  component ad5242_ctrl is
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
end component;
  

  signal c_write_ad5242_tick       : std_logic;
  signal c_ad_data                 : std_logic_vector(7 downto 0);
  signal c_start_agc               : std_logic;
  signal c_gray                    : std_logic_vector(7 downto 0);
  signal c_nrst                    : std_logic;
  signal c_clk_125k_tick           : std_logic;
  signal c_clk_1ms_tick            : std_logic;
  signal c_clk_10us_tick           : std_logic;
  signal c_clk_100us_tick          : std_logic;
  signal c_start_tick              : std_logic;
  signal c_soft_reset_tick         : std_logic;
  signal c_mem_dax                 : std_logic_vector(11 downto 0);
  signal c_mem_day                 : std_logic_vector(11 downto 0);
  signal c_mem_dastart             : std_logic;
  signal c_laser_rpi_start_start   : std_logic;
  signal c_initial_flag            : std_logic;
  signal c_pic_tdc_procedure_start : std_logic;
  signal c_w5300_init_start        : std_logic;
  signal c_w5300_init_finish       : std_logic;
  signal c_laser_gse               : std_logic;
  signal c_laser_ple               : std_logic;
  signal c_da_datax                : std_logic_vector(11 downto 0);
  signal c_da_datay                : std_logic_vector(11 downto 0);
  signal c_da_start                : std_logic;
  signal c_da_finish               : std_logic;
  signal c_state_output            : std_logic_vector(7 downto 0);
  signal c_state_out               : std_logic_vector(5 downto 0);  
  signal c_start_rpi               : std_logic;
  signal c_k_pulse                 : std_logic;
  signal c_start_start_tick        : std_logic;
  signal c_k_count                 : std_logic_vector(19 downto 0);
  signal c_rpiplus                 : std_logic;
  signal c_ad_datax                : std_logic_vector(15 downto 0);
  signal c_ad_datay                : std_logic_vector(15 downto 0);
  signal c_clk_36m                 : std_logic;
  signal c_com_error1              : std_logic;
  signal c_com_error2              : std_logic;
  signal c_cal_flag1               : std_logic;
  signal c_cal_flag2               : std_logic;
  signal c_error_flag1             : std_logic;
  signal c_dataout1                : std_logic_vector(31 downto 0);
  signal c_corf1                   : std_logic_vector(21 downto 0); 
  signal c_error_flag2             : std_logic;
  signal c_dataout2                : std_logic_vector(31 downto 0);
  signal c_corf2                   : std_logic_vector(21 downto 0);
  signal c_f_ready                 : std_logic;
  signal c_f_data                  : std_logic_vector(15 downto 0);
  signal c_corf_out                : std_logic_vector(15 downto 0);
  signal c_tdc_out                 : std_logic_vector(15 downto 0);
  signal c_1us_tick                : std_logic;
  signal c_w5300_nrst_ctrl         : std_logic;
  signal c_w5300_nrst              : std_logic;
  signal c_w5300_ready             : std_logic;
  signal c_nint_f                  : std_logic;
  signal c_w5300_init_result       : std_logic;
  signal c_rcv_tick                : std_logic;
  signal c_rcv_data                : std_logic_vector(15 downto 0);
  signal c_fifo_rd                 : std_logic;
  signal c_fifo_data               : std_logic_vector(31 downto 0);
  signal c_fifo_empty              : std_logic;
  signal c_send_start_tick         : std_logic;
  signal c_send_done_tick          : std_logic;
  signal c_inter_wr                : std_logic;
  signal c_inter_rd                : std_logic;
  signal c_inter_ncs               : std_logic;
  signal c_inter_addr              : std_logic_vector(9 downto 0);
  signal c_inter_data_wr           : std_logic_vector(15 downto 0);
  signal c_inter_data_rd           : std_logic_vector(15 downto 0);
  signal c_eth_addr                : std_logic_vector(9 downto 0);
  signal c_fifo_wdata              : std_logic_vector(31 downto 0);
  signal c_fifo_full               : std_logic;
  signal c_fifo_wr                 : std_logic;
  
  signal c_addr_lut                : std_logic_vector(15 downto 0);
  signal c_q_lut                   : std_logic_vector(15 downto 0);
  signal c_y_lut                   : std_logic_vector(15 downto 0);
  signal c_div_tick                : std_logic;
  signal c_y_dividend              : std_logic_vector(13 downto 0);
  signal c_y_divisor               : std_logic_vector( 6 downto 0);
  signal c_y_divout                : std_logic_vector(13 downto 0);
  signal c_y_div_finish            : std_logic;
  signal c_fpga_fifo_empty         : std_logic;
  signal c_ad                      : std_logic_vector(4 downto 0);
  signal c_ad_lock                 : std_logic;
  
  signal c_command_valid           : std_logic;                                         -- valid
  signal c_command_channel         : std_logic_vector(4 downto 0);                     -- channel
  signal c_command_startofpacket   : std_logic;                                        -- startofpacket
  signal c_command_endofpacket     : std_logic;                                        -- endofpacket
  signal c_command_ready           : std_logic;                                        -- ready
  signal c_response_valid          : std_logic;                                        -- valid
  signal c_response_channel        : std_logic_vector(4 downto 0);                     -- channel
  signal c_response_data           : std_logic_vector(11 downto 0);                    -- data
  signal c_response_startofpacket  : std_logic;                                        -- startofpacket
  signal c_response_endofpacket    : std_logic;  
  signal c_denom                   : std_logic_vector(10 downto 0);
  signal c_numer                   : std_logic_vector(29 downto 0);
  signal c_quotient                : std_logic_vector(29 downto 0);
  signal c_remain                  : std_logic_vector(10 downto 0);  
  
  signal c_cordic_a                : std_logic_vector(11 downto 0);
  signal c_cordic_en               : std_logic_vector(0 downto 0);	
  signal c_cordic_result           : std_logic_vector(10 downto 0);
  signal c_rst                     : std_logic;
   
  signal c_ady_temp                : std_logic_vector(13 downto 0);
  signal c_memy_fifo_wr            : std_logic; 
  signal c_memy_fifo_data          : std_logic_vector(11 downto 0);
  signal c_apd_temp                : std_logic_vector(11 downto 0);
  signal c_memx_fifo_wr            : std_logic;
  signal c_memx_fifo_data          : std_logic_vector(13 downto 0);
  signal c_agc_data_temp           : std_logic_vector(7 downto 0);
  signal c_agc_start_tick          : std_logic;
  
  signal c_memy_fifo_rd            : STD_LOGIC ;
  signal c_memy_fifo_empty         : std_logic;
  signal c_memy_fifo_full          : std_logic;
  signal c_memy_fifo_q             : std_logic_vector(11 downto 0);
  
  signal c_memx_fifo_rd            : std_logic;
  signal c_memx_fifo_empty         : std_logic;
  signal c_memx_fifo_full          : std_logic;
  signal c_memx_fifo_q             : std_logic_vector(13 downto 0);
  signal c_agc_da_start_tick       : std_logic;
  signal c_agc_da_data             : std_logic_vector(11 downto 0);
  signal c_distance_fifo_data      : std_logic_vector(23 downto 0);
  signal c_distance_fifo_wr        : std_logic;
  signal c_cal_start               : std_logic;
  signal c_tdc_gpx_data0           : std_logic_vector(27 downto 0);
  signal c_tdc_gpx_data1           : std_logic_vector(27 downto 0);
  signal c_tdc_gpx_data2           : std_logic_vector(27 downto 0);
  signal c_cal_finish              : std_logic;
  signal c_cal_result0             : std_logic_vector(15 downto 0);
  signal c_cal_result1             : std_logic_vector(15 downto 0);
  signal c_cal_result2             : std_logic_vector(15 downto 0);
  
  signal c_distance_fifo_rd        : std_logic;
  signal c_distance_fifo_empty     : std_logic;
  signal c_distance_fifo_full      : std_logic;
  signal c_distance_fifo_q         : std_logic_vector(23 downto 0);
  signal c_combine_data            : std_logic_vector(47 downto 0);
  signal c_combine_wr              : std_logic;
  signal c_combine_rd              : std_logic;
  signal c_combine_empty           : std_logic;
  signal c_combine_full            : std_logic;
  signal c_combine_q               : std_logic_vector(47 downto 0);
  signal c_data_final_fifo         : std_logic_vector(63 downto 0);
  signal c_data_final_wr           : std_logic;
  signal c_data_final_rd           : std_logic;
  signal c_data_final_empty        : std_logic;
  signal c_data_final_full         : std_logic;
  signal c_data_final_q            : std_logic_vector(63 downto 0);
  signal c_2us_tick                : std_logic;
  signal c_clk_100m                : std_logic;
  signal c_gray_temp               : std_logic_vector(15 downto 0);
  signal c_temper_temp             : std_logic_vector(15 downto 0);
  signal c_memx_temp               : std_logic_vector(15 downto 0);
  signal c_memy_temp               : std_logic_vector(15 downto 0);
  signal c_ad_ready                : std_logic;
  signal c_ad_start_tick           : std_logic;
  signal c_clk_80m                 : std_logic;
  
  
begin

  ad_tick_generator_uut : ad_tick_generator
  port map(
    nrst            => c_nrst,
    clk             => CLK_40MHz_IN,
    start           => c_start_rpi,
    ad_tick         => c_ad_start_tick
  );

counter_shdn_uut : counter_shdn
  port map(
    clk                =>  CLK_40MHz_IN,
    clk_1ms_tick       =>  c_clk_1ms_tick,
    nrst               =>  c_nrst,
    shdn               =>  F_SHDN
    );

ad5242_ctrl_uut :  ad5242_ctrl
port map(
  nrst        => c_nrst,
  clk         => CLK_40MHz_IN,
  clk_tick    => c_clk_10us_tick,
  read_tick   => '1',
  write_tick  => '1', -- c_write_ad5242_tick
  finish_tick => open,
  channel     => F_CHANNEL,
  write_data  => F_AD5242_DATA(7 downto 0),
  read_data   => open,
  i2c_sda     => F_SDA,
  i2c_scl     => F_SCL
);

MEMX_LUT_uut : MEMX_LUT
	PORT map
	(
		address		=> c_addr_lut(15 downto 1),
		clock		   => CLK_40MHz_IN,
		q		=> c_q_lut
	);

	MEMY_LUT_uut : MEMY_LUT
	PORT map
	(
		address		=> c_addr_lut(15 downto 1),
		clock		   => CLK_40MHz_IN,
		q		=> c_y_lut
	);

  agc_top_uut :  agc_top
port map(
  nrst            => c_nrst,
  clk             => CLK_40MHz_IN,
  agc_data        => c_agc_data_temp,
  agc_start_tick  => c_ad_ready,
  agc_da_start_tick   => c_agc_da_start_tick,
  da_data_agc         => c_agc_da_data
  );
  
--  final_data_fifo_uut : final_data_fifo
--	PORT map
--	(
--		clock		=> CLK_40MHz_IN,
--		data		=> c_data_final_fifo,
--		rdreq		=> c_data_final_rd,
--		wrreq		=> c_data_final_wr,
--		empty		=> c_data_final_empty,
--		full		=> c_data_final_full,
--		q		   => c_data_final_q
--	);


--  fifo_transfer_final_uut : fifo_transfer_final
--  port map(
--    clk               => CLK_40MHz_IN,
--    nrst              => c_nrst,
--    k_pulse           => c_k_pulse,
--    datain_fifo       => c_combine_q,
--    datain_rd         => c_combine_rd,
--    datain_fifo_empty => c_combine_empty,
--    datain_fifo_full  => c_combine_full,
--    memy_data         => c_memy_fifo_q,
--    memy_rd           => c_memy_fifo_rd,
--    datafinal_data    => c_data_final_fifo,
--    datafinal_wr      => c_data_final_wr
--    );

--  combine_fifo_uut : combine_fifo
--	PORT map
--	(
--		clock		=> CLK_40MHz_IN,
--		data		=> c_combine_data,
--		rdreq		=> c_combine_rd,
--		wrreq		=> c_combine_wr,
--		empty		=> c_combine_empty,
--		full		=> c_combine_full,
--		q		   => c_combine_q
--	);

  time_distance_conversion_uut : time_distance_conversion
port map(
  nrst                 => c_nrst,
  clk                  => CLK_40MHz_IN,
  cal_start            => c_cal_start,
  tdc_gpx_data0        => c_tdc_gpx_data0,
  tdc_gpx_data1        => c_tdc_gpx_data1,
  tdc_gpx_data2        => c_tdc_gpx_data2,
  cal_finish           => c_cal_finish,
  cal_result0          => c_cal_result0,
  cal_result1          => c_cal_result1,
  cal_result2          => c_cal_result2
);

--  distance_fifo_uut : distance_fifo
--	PORT map
--	(
--		clock		=> CLK_40MHz_IN,
--		data		=> c_distance_fifo_data,
--		rdreq		=> c_distance_fifo_rd,
--		wrreq		=> c_distance_fifo_wr,
--		empty		=> c_distance_fifo_empty,
--		full		=> c_distance_fifo_full,
--		q		   => c_distance_fifo_q
--	);

  da_controller_7547_uut : da_controller_7547
  port map(
    nrst                 => c_nrst,
    clk                  => CLK_40MHz_IN,
    da_mems_start_tick   => c_da_start,
    agc_da_start_tick    => c_agc_da_start_tick,
    da_datax             => c_da_datax,
    da_datay             => c_da_datay,
    da_data_agc          => c_agc_da_data,
    da_data              => F_DA,
    da_wr                => F_DWR,
    da_acs               => F_DCSA,
    da_bcs               => F_DCSB,
    da_ccs               => F_DCSC,
    da_finish            => c_da_finish
  );
 
 
--  memx_fifo_uut : memx_fifo
--	PORT map
--	(
--		clock		=> CLK_40MHz_IN,
--		data		=> c_memx_fifo_data,
--		rdreq		=> c_memx_fifo_rd,
--		wrreq		=> c_memx_fifo_wr,
--		empty		=> c_memx_fifo_empty,
--		full		=> c_memx_fifo_full,
--		q		   => c_memx_fifo_q
--	);

  div_uut : div
  port map
	(
		clken		   => '1',
		clock		   => CLK_40MHz_IN,
		denom		   => c_denom,
		numer		   => c_numer,
		quotient		=> c_quotient,
		remain		=> c_remain
	);
	
	xsincos_uut : xsincos
	port map
	(
		a      => c_cordic_a,
		areset => c_rst,
		c      => open,                --      c.c
		clk    => CLK_40MHz_IN,        --    clk.clk
		en     => c_cordic_en,
		s      => c_cordic_result               --      s.s
	);
	
	
	--
	mem_vx_vy_control_uut : mem_vx_vy_control
  port map(
    nrst           => c_nrst,
    clk            => CLK_40MHz_IN,
    cal_start_tick => c_start_start_tick,
    datain         => c_k_count,
    lut_addr       => c_addr_lut,
    lut_data       => c_q_lut,
    lut_ydata      => c_y_lut,
    lut_down_ydata   => X"0000",
    y_div_tick     => c_div_tick,
    y_dividend     => c_y_dividend,
    y_divisor      => c_y_divisor,
    div_y_out      => c_y_divout,    --100k
    y_finish       => c_y_div_finish,
    cal_finish     => c_mem_dastart,
    vx_out         => c_mem_dax,
    vy_out         => c_mem_day
    );
	
--	memy_fifo_uut : memy_fifo
--	port map
--	(
--		clock		=> CLK_40MHz_IN,
--		data		=> c_memy_fifo_data,
--		rdreq		=> c_memy_fifo_rd,
--		wrreq		=> c_memy_fifo_wr,
--		empty		=> c_memy_fifo_empty,
--		full		=> c_memy_fifo_full,
--		q		   => c_memy_fifo_q
--	);
	
	
adc_ltc2324_16_controller_uut : adc_ltc2324_16_controller
  port map(
    clk                => c_clk_80m, 
    nrst               => c_nrst,
    start_tick         => c_ad_start_tick,
    sck_out            => F_SCK_1,
    sck_in             => F_AD_CLKOUT_1,
    sdi0               => F_SD0_1,
    sdi1               => F_SD1_1,
    sdi2               => F_SD2_1,
    sdi3               => F_SD3_1,
    end_tick           => c_ad_ready,
    ad_data0           => c_gray_temp,
    ad_data1           => c_temper_temp,
    ad_data2           => c_memx_temp,
    ad_data3           => c_memy_temp,
    covn               => F_CNV 
    );
	 
	 


eth_write_uut : eth_write
port map(
  clk          => CLK_40MHz_IN,
  nrst         => c_nrst,
  k_start_tick => c_pic_tdc_procedure_start,
  fifo_rd      => c_data_final_rd,
  fifo_data    => c_data_final_q,
  fifo_empty   => c_data_final_empty,
  fifo_wr      => c_fifo_wr,
  fifo_wdata   => c_fifo_wdata,
  send_tick   => c_send_start_tick
  );
    
  div_mem_n_uut : div_mem_n
  GENERIC MAP(
    WN => 14,    --24 --22---------39
    WD => 7 )   --16 --14---------22
  port map(
    nrst => c_nrst,
    clk  => CLK_40MHz_IN,
    start=> c_div_tick,
   finish=> c_y_div_finish,
    a    => c_y_dividend,
    b    => c_y_divisor,
    q    => c_y_divout
  );
  
  cmd_ctrl_uut : cmd_ctrl 
  port map(
    nrst                   => c_nrst,
    clk                    => CLK_40MHz_IN,
    rcv                    => c_rcv_tick,
    rcv_data               => c_rcv_data,
    start_tick             => c_start_tick,
    soft_reset_tick        => c_soft_reset_tick
    );
  
  w5300_ctrl_uut : w5300_ctrl
  port map(
	clk                      => CLK_40MHz_IN,
	nrst                     => c_nrst,
	tick_1us                 => c_1us_tick, 
	tick_10us                => c_clk_10us_tick,
	tick_100us               => c_clk_100us_tick,	-- tick 100us 
	tick_1ms                 => c_clk_1ms_tick, 
	nint_f                   => c_nint_f,
	ethernet_package_gap_cnt => X"FFFF",                         	-- ��̫���´��������İ��� 
    ethernet_package_gap    => X"0000",       	                    -- ��̫���´���������1us 
	ethernet_nrst_ctrl       => c_w5300_nrst_ctrl,
	ethernet_init_start      => c_w5300_init_start,
	ethernet_init_done       => c_w5300_init_finish,
	ethernet_init_result     => c_w5300_init_result,
	rcv                      => c_rcv_tick,
	rcv_data                 => c_rcv_data, 
	fifo_rd                  => c_fifo_rd, 
	fifo_data                => c_fifo_data,
	fifo_empty               => c_fifo_empty,
	send_start               => c_send_start_tick, 
	send_done                => c_send_done_tick, 
	wr                       => c_inter_wr,	-- д��tick 
	rd                       => c_inter_rd,	-- ���tick 
	ncs                      => c_inter_ncs,	-- Ƭѡ 
	addr                     => c_inter_addr,	-- ��ַ 
	data_wr                  => c_inter_data_wr,	-- ����д 
	data_rd                  => c_inter_data_rd	-- ���ݶ� 
	);	
	
  w5300_access_uut : w5300_access
	port map(
		clk     =>  CLK_40MHz_IN,
		nrst    =>  c_nrst,
		inter_wr => c_inter_wr,	    -- �ڲ�д��tick 
		inter_rd => c_inter_rd,	    -- �ڲ����tick 
		inter_ncs => c_inter_ncs,	-- �ڲ�Ƭѡ 
		inter_addr => c_inter_addr, -- �ڲ���ַ 
		inter_data_in => c_inter_data_wr,	-- �ڲ��������� 
		inter_data_out => c_inter_data_rd,
		nwr            => F_ETH_WRN,
		nrd            => F_ETH_OEN,
		ncs            => F_ETH_CSN,
		addr => c_eth_addr,	-- ���ڵ�ַ�ź� 
		data => F_ETH_D	-- ���������ź� 
	);
	
  fifo_uut : fifo
	PORT MAP
	(
		clock	=>  CLK_40MHz_IN,
		data	=>  c_fifo_wdata,
		rdreq	=>  c_fifo_rd,
		wrreq	=>  c_fifo_wr,
		empty	=>  c_fifo_empty,
		full  =>  c_fifo_full,
		q		=>  c_fifo_data
	);

  U_W5300_DELAY_NRST : delay_nrst
	generic map(
	  TIME_CNT => 4	-- ��λ�ӳ�ʱ�䳤��
	)
	port map(
	  clk => CLK_40MHz_IN,
	  nrst => c_nrst,
	  nrst_ctrl => c_w5300_nrst_ctrl,	-- '0'��Ч 
	  tick_cnt => c_1us_tick,	        -- ��ʱʱ�� 
	  d_nrst => c_w5300_nrst	        -- nrst��nrst_ctrl����Ч����d_nrst�ӳ�[tick_cnt*(TIME_CNT-1)+clk,tick_cnt*TIME_CNT+2*clk]
	);

	PLL_100M_uut : PLL_100M
	PORT MAP
	(
		areset		=> '0',
		inclk0		=> CLK_40MHz_IN,
		c0		      => c_clk_80m,
		locked		=> open 
	);
	
  pll_38M_uut : pll_38M
	PORT MAP
	(
		areset		=> '0',
		inclk0		=> CLK_40MHz_IN,
		c0		    => c_clk_36m,
		locked		=> c_ad_lock
	);
  
  Reset_Gen_uut : Reset_Gen
	generic map(
	  iValidValue => '0',
	  oValidValue => '0'
	)
	 port map(
		 clk  => CLK_40MHz_IN,
		 reset_i => LVRESETN,
		 reset_o => c_nrst
	     );
  
  
  ctrlCycle_simple0_uut : ctrlCycle_simple
    generic map( 
      RstValidValue => '0',	
      DATAWIDTH	    => 16,
      RST_DIV	    => 39999			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ) 
  port map(
      nrst   => c_nrst,
      clk    => CLK_40MHz_IN,
      enable => '1',   	--	'1' is enable
 clk_tick    => c_clk_1ms_tick
     );
     
     
 ctrlCycle_simple1_uut : ctrlCycle_simple
    generic map( 
      RstValidValue => '0',	
      DATAWIDTH	    => 16,
      RST_DIV	    => 39			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ) 
  port map(
      nrst   => c_nrst,
      clk    => CLK_40MHz_IN,
      enable => '1',   	--	'1' is enable
 clk_tick    => c_1us_tick
     );
	  
	   ctrlCycle_simple5_uut : ctrlCycle_simple
    generic map( 
      RstValidValue => '0',	
      DATAWIDTH	    => 16,
      RST_DIV	    => 79			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ) 
  port map(
      nrst   => c_nrst,
      clk    => CLK_40MHz_IN,
      enable => '1',   	--	'1' is enable
 clk_tick    => c_2us_tick
     );
     
    ctrlCycle_simple2_uut : ctrlCycle_simple
    generic map( 
      RstValidValue => '0',	
      DATAWIDTH	    => 16,
      RST_DIV	    => 399			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ) 
  port map(
      nrst   => c_nrst,
      clk    => CLK_40MHz_IN,
      enable => '1',   	--	'1' is enable
 clk_tick    => c_clk_10us_tick
     );
	  
	  ctrlCycle_simple4_uut : ctrlCycle_simple
    generic map( 
      RstValidValue => '0',	
      DATAWIDTH	    => 16,
      RST_DIV	    => 319			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ) 
  port map(
      nrst   => c_nrst,
      clk    => CLK_40MHz_IN,
      enable => '1',   	--	'1' is enable
 clk_tick    => c_rpiplus
     );
	  
     
  ctrlCycle_simple3_uut : ctrlCycle_simple
    generic map( 
      RstValidValue => '0',	
      DATAWIDTH	    => 16,
      RST_DIV	    => 3999			--n+1 ·ÖÆµ,Ä¬ÈÏÖµ²»œšÒéÎª0
    ) 
  port map(
      nrst   => c_nrst,
      clk    => CLK_40MHz_IN,
      enable => '1',   	--	'1' is enable
 clk_tick    => c_clk_100us_tick
     );  

fifo_transfer_uut : fifo_transfer
  port map(
  clk            => CLK_40MHz_IN,
  nrst           => c_nrst,
  start          => c_start_rpi,
  agc_data       => c_agc_data_temp,
  agc_start_tick => c_agc_start_tick,
  memx_fifo_data => c_memx_fifo_q,
  memx_fifo_rd   => c_memx_fifo_rd,
  distance_data  => c_distance_fifo_q,
  distance_rd    => c_distance_fifo_rd,
  distance_empty => c_distance_fifo_empty,
  distance_full  => c_distance_fifo_full,
  combine_data   => c_combine_data,
  combine_wr     => c_combine_wr
  );
	

	state_control_top_uut : state_control_top
    port map(
    nrst                    => c_nrst,
    clk                     => CLK_40MHz_IN,
	 clk_125k_tick           => c_rpiplus,
    clk_1ms_tick            => c_clk_1ms_tick,
	 laser_power             => "1110000000",
    start_tick              => '1', --c_start_tick,
    soft_reset_tick         => c_soft_reset_tick,
    mem_dax                 => c_mem_dax,
    mem_day                 => c_mem_day,
    mem_dastart             => c_mem_dastart,
    laser_rpi_start_start   => c_laser_rpi_start_start,
    initial_flag            => c_initial_flag,
    pic_tdc_procedure_start => c_pic_tdc_procedure_start,
    w5300_nrst_ctrl         => c_w5300_nrst_ctrl,
    w5300_init_start        => c_w5300_init_start,
    w5300_init_finish       => c_w5300_init_finish,
    w5300_init_result       => c_w5300_init_result,
    w5300_ready             => c_w5300_ready,
    laser_gse               => c_laser_gse,
    laser_ple               => c_laser_ple,
    da_datax                => c_da_datax,
    da_datay                => c_da_datay,
    da_start                => c_da_start,
    da_finish               => c_da_finish,
	 state_output            => c_state_output,
	 state_out               => c_state_out,
	 write_ad5242_tick       => c_write_ad5242_tick
  );  
	  
pulse_gen_uut : pulse_gen 
  port map(
    nrst             => c_nrst,
    clk              => CLK_40MHz_IN,
    enable           => c_laser_rpi_start_start,
    k_start_tick     => c_pic_tdc_procedure_start,
	 start1           => F_START1,
	 start2           => F_START2,
    k_end_tick       => open,
    pulse_out_start  => c_start_rpi,
    pulse_out_rpi    => F_RPI,
    k_pulse_out      => c_k_pulse,
    start_tick       => c_start_start_tick,
	 k_period         => X"09C3F",
    k_count          => c_k_count
    );
    
   	U_ET_NINT_FILTER : v_filter_2
	generic map(
		RESET_VALID => '0',
		RESET_VALUE => '1',
		SCALER_SIZE => 2,
		SYNC_COUNT => 2
	)	
	port map(
		rst => c_nrst,
		clk => CLK_40MHz_IN,
		clk_filter => '1',
		scaler => "10",
		signal_in => F_ETH_INT,
		signal_out => c_nint_f
	);

	TX_LVDS_uut : TX_LVDS
	port map (
		tx_inclock  => c_clk_36m,
		tx_outclock => F_LCLK_IN_P,                                      -- tx_outclock.tx_outclock
		pll_areset  => '0',                                 --  pll_areset.pll_areset
		tx_in       => X"55", --: in  std_logic_vector(15 downto 0) := (others => '0'); --       tx_in.tx_in
		tx_out      => F_DISABLE_P                     --      tx_out.tx_out
	);
	
	--c_ad_data <= F_AD;
	
	--process(c_laser_rpi_start_start,c_start_rpi,c_rpiplus)
    --begin
    --  if(c_laser_rpi_start_start='1')then
    --    F_RPI <= c_start_rpi;
	--    c_start_agc <= c_start_rpi;
    --  else
    --    F_RPI <= c_rpiplus;
	--    c_start_agc <= c_rpiplus;
    --  end if;
    --end process;
   --F_RPI <= c_start_rpi;
	--F_START <= c_start_rpi; 
	c_ady_temp <= ("00"&c_response_data);
	F_ETH_RSTN <= c_w5300_nrst;
	F_ETH_A    <= c_eth_addr(9 downto 1);
	c_rst <= not(c_nrst);
	F_SDR_DDR0  <= '0';
	F_AD_CLKOUT_ENABLE <= '0';
end rtl;
