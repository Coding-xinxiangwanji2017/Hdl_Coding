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
-- 文件名称  :  M_Tdc_s2p.vhd
-- 设    计  :  zhang shuqiang
-- 邮    件  :  shuqiang.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2019/01/15
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang shuqiang, 2019/01/15
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_Tdc_s2p is
    port (
		--------------------------------
		-- Reset
		--------------------------------
		CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
		--------------------------------
		-- LVDS Interface
		--------------------------------		
        -- TDC0
		CpSl_RefClkP_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Frame_i					: in  std_logic;						-- TDC_GPX2_Frame1_low
		CpSl_Sdo_i	     				: in  std_logic;						-- TDC_GPX2_SDO1

        --------------------------------
        -- TDC_Data
        --------------------------------
        wr_tdc_data_en_o                  : out std_logic;						-- TDC_Recv_Data_Valid
        wr_tdc_data_o                     : out std_logic_vector(31 downto 0);
        wr_tdc_full_i                     : in  std_logic;
        fifo_full_err_cnt_o               : out std_logic_vector(7 downto 0)
    );
end M_Tdc_s2p;

architecture arch_M_Tdc_s2p of M_Tdc_s2p is


	 signal  CpSl_Frame_d1            : std_logic;	
	 signal  CpSl_Frame_d2            : std_logic;	
	 signal  CpSl_Sdo_d1              : std_logic;	
	 signal  CpSl_Sdo_d2              : std_logic;	
	 signal  CpSl_FrameTrig_s         : std_logic;	

	 signal  fifo_full_err_cnt_s      : std_logic_vector(7 downto 0);


    signal  recvd_cnt                : std_logic_vector(7 downto 0);
    signal  recvd_cnt_d1             : std_logic_vector(7 downto 0);

    signal  CpSl_pd                  : std_logic_vector(31 downto 0);
    
begin

    ------------------------------------
    -- Frame_Data
    ------------------------------------
    process (CpSl_Rst_i,CpSl_RefClkP_i) begin
        if (CpSl_Rst_i = '0') then
			CpSl_Frame_d1 <= '0';
			CpSl_Frame_d2 <= '0';
			recvd_cnt_d1      <= (others => '0');
        elsif rising_edge(CpSl_RefClkP_i) then
			CpSl_Frame_d1 <= CpSl_Frame_i;
			CpSl_Frame_d2 <= CpSl_Frame_d1;
			recvd_cnt_d1  <= recvd_cnt;
        end if;
    end process;
	-- CpSl_FrameTrig_s
    CpSl_FrameTrig_s <= '1' when (CpSl_Frame_d2 = '0' and CpSl_Frame_d1 = '1') else '0';

	-- Delay SDO 2 CLK
    process (CpSl_Rst_i,CpSl_RefClkP_i) begin
        if (CpSl_Rst_i = '0') then
			CpSl_Sdo_d1 <= '0';
			CpSl_Sdo_d2 <= '0';
        elsif rising_edge (CpSl_RefClkP_i) then
			CpSl_Sdo_d1 <= CpSl_Sdo_i;
			CpSl_Sdo_d2 <= CpSl_Sdo_d1;
        end if;
    end process;

	-- recvd_cnt
    process (CpSl_Rst_i,CpSl_RefClkP_i) begin
        if (CpSl_Rst_i = '0') then
			 recvd_cnt <= (others => '0');
			 CpSl_pd   <= (others => '0');
        elsif rising_edge (CpSl_RefClkP_i) then
		    if(CpSl_FrameTrig_s = '1') then
            recvd_cnt <= x"1F";
				CpSl_pd   <= CpSl_pd(30 downto 0) & CpSl_Sdo_d1;
          elsif (recvd_cnt	/= 0) then
            recvd_cnt <= recvd_cnt - '1';
				CpSl_pd   <= CpSl_pd(30 downto 0) & CpSl_Sdo_d1;
			 else
			   recvd_cnt <= (others => '0');
				CpSl_pd   <= CpSl_pd;
			 end if;
        end if;
    end process;
		 
    process (CpSl_Rst_i,CpSl_RefClkP_i) begin
        if (CpSl_Rst_i = '0') then
			    wr_tdc_data_en_o    <= '0';
			    wr_tdc_data_o       <= (others => '0');
			    fifo_full_err_cnt_s   <= (others => '0');
        elsif rising_edge (CpSl_RefClkP_i) then
		      if(recvd_cnt_d1 = 1 and recvd_cnt = 0 and wr_tdc_full_i = '0') then
			      wr_tdc_data_en_o  <= '1';
			      wr_tdc_data_o     <= CpSl_pd;
			    elsif(recvd_cnt_d1 = 1 and recvd_cnt = 0 and wr_tdc_full_i = '1') then
			      wr_tdc_data_en_o  <= '0';
			      wr_tdc_data_o     <= (others => '0');
			      fifo_full_err_cnt_s <= fifo_full_err_cnt_s + '1';
			    else
			      wr_tdc_data_en_o  <= '0';
			      wr_tdc_data_o     <= (others => '0');
			    end if;
		    end if;
	 end process;
    
	 fifo_full_err_cnt_o <= fifo_full_err_cnt_s;

    ----------------------------------------------------------------------------
    -- End Coding
    ----------------------------------------------------------------------------
end arch_M_Tdc_s2p;