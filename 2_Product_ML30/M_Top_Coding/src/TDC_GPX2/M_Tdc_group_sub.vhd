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
-- ��    Ȩ  :  ZVISION
-- �ļ�����  :  M_Tdc_group_sub.vhd
-- ��    ��  :  zhang shuqiang
-- ��    ��  :  shuqiang.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2019/01/15
-- ���ܼ���  :  
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang shuqiang, 2019/01/15
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library altera;
--use altera.altera_primitives_components.all;

entity M_Tdc_group_sub is
    generic (
        frame_id_c                 : integer := 1
    );
    port (
		--------------------------------
		-- Clk & Reset
		--------------------------------
        CpSl_RefClkP_i                  : in  std_logic;
        clk_40m_i                       : in  std_logic;	  -- 40Mhz clock
        CpSl_Rst_i							 : in  std_logic;						-- Reset,Active_low

        start_grouping_i                : in  std_logic;                       
        ref_index_cnt_start_i           : in  std_logic_vector(15 downto 0);  
        grouping_timeout_en_i           : in  std_logic; 
        wr_tdc_data_en_i                : in  std_logic;						-- TDC_Recv_Data_Valid
        wr_tdc_data_i                   : in  std_logic_vector(31 downto 0);
        wr_tdc_full_o                   : out std_logic;						-- TDC_Recv_Data_Valid
    
        grouping_done_o                 : out std_logic;
        tdcecho1_o                      : out std_logic_vector(26 downto 0);
        tdcecho2_o                      : out std_logic_vector(26 downto 0);
        tdcecho3_o                      : out std_logic_vector(26 downto 0)    
	);
end M_Tdc_group_sub;

architecture arch_M_Tdc_group_sub of M_Tdc_group_sub is

component async_fifo_64x32 IS
	PORT
	(
		data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk			: IN STD_LOGIC ;
		rdreq			: IN STD_LOGIC ;
		wrclk			: IN STD_LOGIC ;
		wrreq			: IN STD_LOGIC ;
		q		    	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC 
	);
END component;



    constant IDLE              			: std_logic_vector( 3 downto 0) := x"0";
    constant GROUPING          			: std_logic_vector( 3 downto 0) := x"1";
    constant JUDGE_DATA        			: std_logic_vector( 3 downto 0) := x"2";
    constant TIMEOUT           			: std_logic_vector( 3 downto 0) := x"3";
    constant GROUPING_DONE     			: std_logic_vector( 3 downto 0) := x"4";
    
		
    constant TIME_50US         			: std_logic_vector( 15 downto 0) := x"07d0"; -- 2000*25ns = 50us
    constant TIME_100US        			: std_logic_vector( 15 downto 0) := x"0fa0"; -- 2000*25ns = 50us
	 
	 
	 
    
    signal grouping_cnt       			: std_logic_vector( 15 downto 0);
    signal grouping_done_cnt  			: std_logic_vector( 15 downto 0);
    
 	 signal rd_tdc_data_en     			: std_logic;
    signal ref_index_cnt_start         : std_logic_vector(15 downto 0); 
    signal cur_state          			: std_logic_vector(3 downto 0);
    signal tdc_data_echo1          		: std_logic_vector(31 downto 0);
    signal tdc_data_echo2          		: std_logic_vector(31 downto 0);
    signal tdc_data_echo3          		: std_logic_vector(31 downto 0);
	 
	 signal tdc_data_echo_en      		: std_logic;
	 
    signal rd_tdc_data                 : std_logic_vector(31 downto 0);
    signal echo_num                    : std_logic_vector(1 downto 0);
    signal echo_num_d1                 : std_logic_vector(1 downto 0);
    signal echo1_index_s               : std_logic_vector(15 downto 0);
    signal echo2_index_s               : std_logic_vector(15 downto 0);
    signal echo3_index_s               : std_logic_vector(15 downto 0);
	 
    signal PrSv_TdcEcho1Mult1          : std_logic_vector(23 downto 0);        -- TDC1_Echo1Mult
    signal PrSv_TdcEcho1Mult2          : std_logic_vector(18 downto 0);        -- TDC1_Echo1Mult
    signal PrSv_TdcEcho1Mult3          : std_logic_vector(17 downto 0);        -- TDC1_Echo1Mult
    signal PrSv_TdcEcho1Mult4          : std_logic_vector(16 downto 0);        -- TDC1_Echo1Mult
    signal PrSv_TdcEcho1Mult5          : std_logic_vector(12 downto 0);        -- TDC1_Echo1Mult
    signal PrSv_TdcEcho2Mult1          : std_logic_vector(23 downto 0);        -- TDC1_Echo2Mult
    signal PrSv_TdcEcho2Mult2          : std_logic_vector(18 downto 0);        -- TDC1_Echo2Mult
    signal PrSv_TdcEcho2Mult3          : std_logic_vector(17 downto 0);        -- TDC1_Echo2Mult
    signal PrSv_TdcEcho2Mult4          : std_logic_vector(16 downto 0);        -- TDC1_Echo2Mult
    signal PrSv_TdcEcho2Mult5          : std_logic_vector(12 downto 0);        -- TDC1_Echo2Mult
    signal PrSv_TdcEcho3Mult1          : std_logic_vector(23 downto 0);        -- TDC1_Echo3Mult
    signal PrSv_TdcEcho3Mult2          : std_logic_vector(18 downto 0);        -- TDC1_Echo3Mult
    signal PrSv_TdcEcho3Mult3          : std_logic_vector(17 downto 0);        -- TDC1_Echo3Mult
    signal PrSv_TdcEcho3Mult4          : std_logic_vector(16 downto 0);        -- TDC1_Echo3Mult
    signal PrSv_TdcEcho3Mult5          : std_logic_vector(12 downto 0);        -- TDC1_Echo3Mult
    signal PrSv_TdcEcho1Sum            : std_logic_vector(23 downto 0);        -- TDC1_Echo1Sum
    signal PrSv_TdcEcho2Sum            : std_logic_vector(23 downto 0);        -- TDC1_Echo2Sum
    signal PrSv_TdcEcho3Sum            : std_logic_vector(23 downto 0);        -- TDC1_Echo3Sum
	 
    signal frameid_s                   : std_logic_vector(2 downto 0);        -- frameid_s

	 
    signal rd_tdc_data_empty           : std_logic;
    signal bigger_than_en              : std_logic;
begin

afifo_tdc_data_u : async_fifo_64x32
    port map 
	(
		wrclk		  =>  CpSl_RefClkP_i,
		wrreq		  =>  wr_tdc_data_en_i,
		data		  =>  wr_tdc_data_i,
		wrfull	  =>  wr_tdc_full_o,
		rdclk		  =>  clk_40m_i,
		rdreq		  =>  rd_tdc_data_en,
		q		     =>  rd_tdc_data,
		rdempty	  =>  rd_tdc_data_empty
	);


    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            ref_index_cnt_start <= (others => '0');        
        elsif rising_edge(clk_40m_i) then
            if(start_grouping_i = '1') then
                ref_index_cnt_start <= ref_index_cnt_start_i;  
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            cur_state <= IDLE;
            --rd_tdc_data_en <= '0';  
            bigger_than_en <= '0';
            
        elsif rising_edge(clk_40m_i) then
            case cur_state is
                when IDLE => 
                    if(start_grouping_i = '1') then
                        cur_state <= GROUPING;
                        --rd_tdc_data_en <= '0';
                    else
                        cur_state <= IDLE;
                    end if;
                when GROUPING =>
                    if(grouping_timeout_en_i = '1') then
                        cur_state <= TIMEOUT;
                    elsif(rd_tdc_data_empty = '0' and bigger_than_en = '0') then
                        cur_state <= JUDGE_DATA;
                        --rd_tdc_data_en <= '1';  
                    elsif(bigger_than_en = '1') then
                        cur_state <= JUDGE_DATA;
                        --rd_tdc_data_en <= '0';
						  		
                    else
                        cur_state <= GROUPING;
                    end if;
                when JUDGE_DATA =>
                    if(rd_tdc_data(31 downto 16) >=  ref_index_cnt_start and rd_tdc_data(31 downto 16) <= ref_index_cnt_start + 4) then
                        bigger_than_en <= '0';
                        cur_state <= GROUPING;
                    --elsif((ref_index_cnt_start >  205 and (rd_tdc_data(23 downto 16) > ref_index_cnt_start or rd_tdc_data(23 downto 16) <= ref_index_cnt_start - 205)) or
                    --   (ref_index_cnt_start <= 205 and (rd_tdc_data(23 downto 16) > ref_index_cnt_start and rd_tdc_data(23 downto 16) <= ref_index_cnt_start + 50 ))) then
                    elsif((ref_index_cnt_start >  65285 and (rd_tdc_data(31 downto 16) > ref_index_cnt_start or rd_tdc_data(31 downto 16) <= ref_index_cnt_start - 65285)) or
                       (ref_index_cnt_start <= 65285 and (rd_tdc_data(31 downto 16) > ref_index_cnt_start and rd_tdc_data(31 downto 16) <= ref_index_cnt_start + 250 ))) then
                        bigger_than_en <= '1';
                        cur_state <= GROUPING_DONE;
                    else
                        bigger_than_en <= '0';
                        cur_state <= GROUPING;
                    end if;
                        
                when TIMEOUT =>
                    cur_state <= GROUPING_DONE;
                when GROUPING_DONE =>
                    if(grouping_done_cnt >= 2) then
                        cur_state <= IDLE;
                    else
                        cur_state <= GROUPING_DONE;
                    end if;
                when others => 
                    cur_state <= IDLE;
            end case;
        end if;
    end process;
                    
    rd_tdc_data_en <=  '1' when (cur_state = GROUPING  and  bigger_than_en = '0' and rd_tdc_data_empty = '0') else '0';
    
    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            echo_num <= (others => '0');
        elsif rising_edge(clk_40m_i) then
		    case(cur_state) is 
				when IDLE =>
				    echo_num <= "00";
			   when GROUPING => 
				    echo_num <= echo_num;
            when JUDGE_DATA =>
                if ((ref_index_cnt_start >  216 and (rd_tdc_data(31 downto 16) > ref_index_cnt_start + 4 or  rd_tdc_data(31 downto 16) <= ref_index_cnt_start - 216)) or
                    (ref_index_cnt_start <= 216 and (rd_tdc_data(31 downto 16) > ref_index_cnt_start + 4 and rd_tdc_data(31 downto 16) <= ref_index_cnt_start + 40 ))) then
                    echo_num <= "00";
                elsif(rd_tdc_data(31 downto 16) >=  ref_index_cnt_start and rd_tdc_data(31 downto 16) <= ref_index_cnt_start + 4) then
                    if(echo_num = 3) then
                        echo_num <= "11";
                    else
                        echo_num <= echo_num + 1;
                    end if;
                else
                    echo_num <= echo_num;
                end if;
				when others => 
				    echo_num <= "00";
			 end case;	 
        end if;
    end process;
            
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            tdc_data_echo1 <= (others => '0');
            tdc_data_echo2 <= (others => '0');
            tdc_data_echo3 <= (others => '0');
				tdc_data_echo_en <= '0';
        elsif rising_edge(clk_40m_i) then
            if(cur_state = IDLE) then
                tdc_data_echo1 <= (others => '0');
                tdc_data_echo2 <= (others => '0');
                tdc_data_echo3 <= (others => '0');
					 tdc_data_echo_en <= '0';
            elsif(cur_state = JUDGE_DATA) then
                if(rd_tdc_data(31 downto 16) >=  ref_index_cnt_start and rd_tdc_data(31 downto 16) <= ref_index_cnt_start + 4) then
                    case echo_num is
                        when "00" => tdc_data_echo1 <= rd_tdc_data;
                        when "01" => tdc_data_echo2 <= rd_tdc_data;
                        when "10" => tdc_data_echo3 <= rd_tdc_data;
                        when others => tdc_data_echo1 <= tdc_data_echo1; tdc_data_echo2 <= tdc_data_echo2; tdc_data_echo3 <= tdc_data_echo3;-- hold
                    end case;
						  tdc_data_echo_en <= '1'; 
                end if;
			   else
				    tdc_data_echo_en <= '0';
            end if;
        end if;
    end process;


    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            grouping_cnt <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(cur_state /= GROUPING or cur_state /= JUDGE_DATA) then
                grouping_cnt <= (others => '0');
            elsif(grouping_cnt >= TIME_100US) then
                grouping_cnt <= TIME_100US;
            else
                grouping_cnt <= grouping_cnt + '1';
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            grouping_done_cnt <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(cur_state /= GROUPING_DONE) then
                grouping_done_cnt <= (others => '0');
            elsif(grouping_done_cnt > 2) then
                grouping_done_cnt <= grouping_done_cnt;
            else
                grouping_done_cnt <= grouping_done_cnt + '1';
            end if;
        end if;
    end process;

    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            grouping_done_o <= '0';
        elsif rising_edge(clk_40m_i) then
            if(cur_state = GROUPING_DONE and grouping_done_cnt = 2) then
                grouping_done_o <= '1';
            else
                grouping_done_o <= '0';
            end if;
        end if;
    end process;
	 
	 
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            echo_num_d1 <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            echo_num_d1 <= echo_num;
		  end if;
	 end process;

    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            echo1_index_s <= (others => '0');
            echo2_index_s <= (others => '0');
            echo3_index_s <= (others => '0');
        elsif rising_edge(clk_40m_i) then
		    if(tdc_data_echo_en = '1') then
			   case echo_num_d1 is
				  
				  when "00" =>
              if(tdc_data_echo1(31 downto 16) >= ref_index_cnt_start) then
                  echo1_index_s <= tdc_data_echo1(31 downto 16) - ref_index_cnt_start;
              else
                  echo1_index_s <= tdc_data_echo1(31 downto 16) + 256 - ref_index_cnt_start;
              end if;
				  
				  when "01" =>
              if(tdc_data_echo2(23 downto 16) >= ref_index_cnt_start) then
                  echo2_index_s <= tdc_data_echo2(23 downto 16) - ref_index_cnt_start;
              else
                  echo2_index_s <= tdc_data_echo2(23 downto 16) + 256 - ref_index_cnt_start;
              end if;
				  
				  when "10" =>
              if(tdc_data_echo3(23 downto 16) >= ref_index_cnt_start) then
                  echo3_index_s <= tdc_data_echo3(23 downto 16) - ref_index_cnt_start;
              else
                  echo3_index_s <= tdc_data_echo3(23 downto 16) + 256 - ref_index_cnt_start;
              end if;
				  
				  when others => echo1_index_s <= (others => '0'); echo2_index_s <= (others => '0'); echo3_index_s <= (others => '0');
            end case;
        end if;
		  end if;
    end process;

    -- Tdc1_RstId*20000_L (*10ps)
    process (CpSl_Rst_i,clk_40m_i) begin                       
        if (CpSl_Rst_i = '0') then
            PrSv_TdcEcho1Mult1 <= (others => '0');
            PrSv_TdcEcho1Mult2 <= (others => '0'); 
            PrSv_TdcEcho1Mult3 <= (others => '0');
            PrSv_TdcEcho1Mult4 <= (others => '0');
            PrSv_TdcEcho1Mult5 <= (others => '0');
                    
            PrSv_TdcEcho2Mult1 <= (others => '0');
            PrSv_TdcEcho2Mult2 <= (others => '0'); 
            PrSv_TdcEcho2Mult3 <= (others => '0');
            PrSv_TdcEcho2Mult4 <= (others => '0');
            PrSv_TdcEcho2Mult5 <= (others => '0');
                    
            PrSv_TdcEcho3Mult1 <= (others => '0');
            PrSv_TdcEcho3Mult2 <= (others => '0'); 
            PrSv_TdcEcho3Mult3 <= (others => '0');
            PrSv_TdcEcho3Mult4 <= (others => '0');
            PrSv_TdcEcho3Mult5 <= (others => '0');
            
        elsif rising_edge(clk_40m_i) then
            PrSv_TdcEcho1Mult1(21 downto 14) <= echo1_index_s(7 downto 0);
            PrSv_TdcEcho1Mult2(18 downto 11) <= echo1_index_s(7 downto 0);   
            PrSv_TdcEcho1Mult3(17 downto 10) <= echo1_index_s(7 downto 0);   
            PrSv_TdcEcho1Mult4(16 downto  9) <= echo1_index_s(7 downto 0);   
            PrSv_TdcEcho1Mult5(12 downto  5) <= echo1_index_s(7 downto 0);
            PrSv_TdcEcho1Mult1(13 downto  0) <= (others => '0');
            PrSv_TdcEcho1Mult2(10 downto  0) <= (others => '0'); 
            PrSv_TdcEcho1Mult3( 9 downto  0) <= (others => '0');
            PrSv_TdcEcho1Mult4( 8 downto  0) <= (others => '0');
            PrSv_TdcEcho1Mult5( 4 downto  0) <= (others => '0');
            PrSv_TdcEcho2Mult1(21 downto 14) <= echo2_index_s(7 downto 0); 
            PrSv_TdcEcho2Mult2(18 downto 11) <= echo2_index_s(7 downto 0); 
            PrSv_TdcEcho2Mult3(17 downto 10) <= echo2_index_s(7 downto 0); 
            PrSv_TdcEcho2Mult4(16 downto  9) <= echo2_index_s(7 downto 0); 
            PrSv_TdcEcho2Mult5(12 downto  5) <= echo2_index_s(7 downto 0); 
            PrSv_TdcEcho2Mult1(13 downto  0) <= (others => '0');
            PrSv_TdcEcho2Mult2(10 downto  0) <= (others => '0'); 
            PrSv_TdcEcho2Mult3( 9 downto  0) <= (others => '0');
            PrSv_TdcEcho2Mult4( 8 downto  0) <= (others => '0');
            PrSv_TdcEcho2Mult5( 4 downto  0) <= (others => '0');
            PrSv_TdcEcho3Mult1(21 downto 14) <= echo3_index_s(7 downto 0); 
            PrSv_TdcEcho3Mult2(18 downto 11) <= echo3_index_s(7 downto 0); 
            PrSv_TdcEcho3Mult3(17 downto 10) <= echo3_index_s(7 downto 0); 
            PrSv_TdcEcho3Mult4(16 downto  9) <= echo3_index_s(7 downto 0); 
            PrSv_TdcEcho3Mult5(12 downto  5) <= echo3_index_s(7 downto 0); 
            PrSv_TdcEcho3Mult1(13 downto  0) <= (others => '0');
            PrSv_TdcEcho3Mult2(10 downto  0) <= (others => '0'); 
            PrSv_TdcEcho3Mult3( 9 downto  0) <= (others => '0');
            PrSv_TdcEcho3Mult4( 8 downto  0) <= (others => '0');
            PrSv_TdcEcho3Mult5( 4 downto  0) <= (others => '0');
        end if;
    end process;


    PrSv_TdcEcho1Sum <= PrSv_TdcEcho1Mult1 + PrSv_TdcEcho1Mult2 + PrSv_TdcEcho1Mult3
                      + PrSv_TdcEcho1Mult4 + PrSv_TdcEcho1Mult5 + tdc_data_echo1(15 downto 0);
    PrSv_TdcEcho2Sum <= PrSv_TdcEcho2Mult1 + PrSv_TdcEcho2Mult2 + PrSv_TdcEcho2Mult3
                      + PrSv_TdcEcho2Mult4 + PrSv_TdcEcho2Mult5 + tdc_data_echo2(15 downto 0);
    PrSv_TdcEcho3Sum <= PrSv_TdcEcho3Mult1 + PrSv_TdcEcho3Mult2 + PrSv_TdcEcho3Mult3
                      + PrSv_TdcEcho3Mult4 + PrSv_TdcEcho3Mult5 + tdc_data_echo3(15 downto 0);
                                   
    frameid_s <= conv_std_logic_vector(frame_id_c,3); 
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            tdcecho1_o <= (others => '0');
            tdcecho2_o <= (others => '0');
            tdcecho3_o <= (others => '0');
        elsif rising_edge(clk_40m_i) then
						tdcecho1_o <= frameid_s & PrSv_TdcEcho1Sum;        
						tdcecho2_o <= frameid_s & PrSv_TdcEcho2Sum;        
						tdcecho3_o <= frameid_s & PrSv_TdcEcho3Sum;        
		  end if;
    end process;

    ----------------------------------------------------------------------------
    -- End Coding
    ----------------------------------------------------------------------------
end arch_M_Tdc_group_sub;