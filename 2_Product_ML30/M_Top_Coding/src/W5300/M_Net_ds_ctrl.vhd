--------------------------------------------------------------------------------
-- °æ    È¨  :  ZVISION
-- ÎÄ¼þÃû³Æ  :  M_Net_ds_ctrl.vhd
-- Éè    ¼Æ  :  Zhang Shuqiang
-- ÓÊ    ¼þ  :  shuqiang.zhang@zvision.xyz
-- Ð£    ¶Ô  :
-- Éè¼ÆÈÕÆÚ  :  2019/02/11
-- ¹¦ÄÜ¼òÊö  :  ethernet downstream controller
-- °æ±¾ÐòºÅ  :  0.1
-- ÐÞ¸ÄÀúÊ·  :  1. Initial, Zhang Shuqiang, 2019/02/11
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity M_Net_ds_ctrl is
    port (
        --------------------------------
        -- Reset and clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
        CpSl_Clk_i                      : in  std_logic;                        -- 40MHz Clock,single

        --------------------------------
        -- downstream Interface
        --------------------------------
        frame_fst_rcv_i                 : in  std_logic;
        PrSl_RxPalDvld_i                : in  std_logic;                        -- Parallel data valid
        PrSv_RxPalData_i                : in  std_logic_vector(15 downto 0);    -- Parallel data
        rcv_data_len_i                  : in  std_logic_vector(15 downto 0);    -- Parallel data lenth
        --------------------------------
        -- Parallel Time Indicator
        --------------------------------
        CpSl_WrTrig1_o                  : out std_logic;                        -- Wr_Trig1        
        CpSl_WrTrig2_o                  : out std_logic;                        -- Wr_Trig2
        vx_trig_o                       : out std_logic; 
        vy_trig_o                       : out std_logic; 
        CpSv_Addr_o                     : out std_logic_vector(10 downto 0);    -- Parallel Time data
        CpSv_WrVthData_o                : out std_logic_vector(11 downto 0);
        PrSl_WrVthTrig_o                : out std_logic;
        start1_close_en_o               : out std_logic;                        -- start1 enable
        start2_close_en_o               : out std_logic;                        -- start2 enable
        start3_close_en_o               : out std_logic;                        -- start3 enable
        CpSv_vxData_o                   : out std_logic_vector(11 downto 0);
        CpSv_vyData_o                   : out std_logic_vector(11 downto 0);
        CpSv_Mems_noscan_o              : out std_logic;
        test_mode_o                     : out std_logic;
        train_cmd_done                  : out std_logic_vector( 1 downto 0);
        send_trig_point_num_o           : out std_logic_vector(15 downto 0); 
        send_trig_close_o               : out std_logic;
        sft_rst_fpga_o                  : out std_logic;
        op_flash_cmd_en_o               : out std_logic;
        op_flash_cmd_o                  : out std_logic_vector(31 downto 0);
        wr_flash_frame_req_o            : out std_logic;
        wr_flash_frame_len_o            : out std_logic_vector(15 downto 0);
        wr_flash_frame_addr_o           : out std_logic_vector(18 downto 0);
        wr_ufm_en_o                     : out std_logic;
        wr_ufm_data_o                   : out std_logic_vector(15 downto 0);
        rw_flash_frame_done_i           : in  std_logic_vector( 1 downto 0)
    );
end M_Net_ds_ctrl;

architecture arch_M_Net_ds_ctrl of M_Net_ds_ctrl is
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------
    -- Frame
    constant PrSv_CfgStartHead_c       : std_logic_vector(7 downto 0) := x"BA";    -- Flash_Config_BA
    constant PrSv_CfgHead_c            : std_logic_vector(7 downto 0) := x"BB";    -- Flash_WrData_BB
    constant PrSv_RDHead_c             : std_logic_vector(7 downto 0) := x"BC";    -- Flash_RdData_BC
    constant PrSv_CmdHead_c            : std_logic_vector(7 downto 0) := x"AA";    -- Flash_Reset_AA
    
    -- Recv_Data_State
    constant PrSv_FrameIdle_c           : std_logic_vector(3 downto 0) := "0000";
    constant PrSv_FrameRecvEnd_c        : std_logic_vector(3 downto 0) := "0001";
    constant PrSv_FrameCheck_c          : std_logic_vector(3 downto 0) := "0010";
    constant PrSv_WAIT_c                : std_logic_vector(3 downto 0) := "0011";
	 constant PrSv_CfgAddr_c             : std_logic_vector(3 downto 0) := "0100";
	 constant PrSv_CfgData_c             : std_logic_vector(3 downto 0) := "0101";
    constant PrSv_wait_FrameEnd_c       : std_logic_vector(3 downto 0) := "0110";
    constant PrSv_FrameEnd_c            : std_logic_vector(3 downto 0) := "0111";

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal PrSv_FrameState_s            : std_logic_vector( 3 downto 0);        -- Frame state
    signal PrSv_FrameState_d1           : std_logic_vector( 3 downto 0);        -- Frame state
    signal state_wait_cnt               : std_logic_vector( 7 downto 0);        -- Frame state

    -- Address
    signal PrSv_RecvData_s              : std_logic_vector(23 downto 0);        -- Recv_Data
    signal PrSl_Ind_s                   : std_logic;                            -- Address_Ind
    signal rec_cfg_data_cnt             : std_logic_vector(15 downto 0);       
    signal inframe_cfg_data_num         : std_logic_vector(15 downto 0);        
    signal head_low_byte                : std_logic_vector( 7 downto 0);        

	signal wr_flash_frame_len           : std_logic_vector(15 downto 0);
	signal wr_flash_frame_addr          : std_logic_vector(18 downto 0);
	 
	signal PrSv_Fst_RxPalData           : std_logic_vector(15 downto 0);
	signal PrSv_Second_RxPalData        : std_logic_vector(15 downto 0);

	signal test_mode                    : std_logic;
	signal cmd_flag                     : std_logic_vector( 7 downto 0);
    
	signal cfg_apd_num                  : std_logic_vector( 6 downto 0);
	
	signal sft_rst_fpga_cnt             : std_logic_vector(15 downto 0);
	 
	 begin
    ----------------------------------------------------------------------------
    -- Receive serial data
    ----------------------------------------------------------------------------

    ------------------------------------
    -- Frame head : "$GNRMC"
    -- Data : Time
    ------------------------------------
    -- Frame State machine
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_FrameState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_FrameState_s is
            when  PrSv_FrameIdle_c => -- Frame Idle
                if (frame_fst_rcv_i = '1' and PrSl_RxPalDvld_i = '1' and (PrSv_RxPalData_i(15 downto 8) = PrSv_CmdHead_c or
					     PrSv_RxPalData_i(15 downto 8) = PrSv_RDHead_c or PrSv_RxPalData_i(15 downto 8) = PrSv_CfgStartHead_c)) then
                    PrSv_FrameState_s <= PrSv_FrameRecvEnd_c;
                elsif (frame_fst_rcv_i = '1' and PrSl_RxPalDvld_i = '1' and PrSv_RxPalData_i(15 downto 8) = PrSv_CfgHead_c) then  
                    PrSv_FrameState_s <= PrSv_CfgAddr_c;
                else -- hold
                end if;

            when PrSv_FrameRecvEnd_c => -- FrameEnd
                if (PrSl_RxPalDvld_i = '1' and rec_cfg_data_cnt >= (inframe_cfg_data_num - 1)) then
                    PrSv_FrameState_s <= PrSv_FrameCheck_c;
                end if;
            when PrSv_FrameCheck_c => 
               PrSv_FrameState_s <= PrSv_WAIT_c;      
            when PrSv_WAIT_c => 
				    if(PrSv_FrameState_s = PrSv_FrameState_d1 and state_wait_cnt >= 15) then
                    PrSv_FrameState_s <= PrSv_FrameEnd_c;      
					 end if;
            
            when PrSv_CfgAddr_c => -- CfgAddr
                if(PrSl_RxPalDvld_i = '1') then
                    PrSv_FrameState_s <= PrSv_CfgData_c; 
                else
                end if;
            when PrSv_CfgData_c => -- CfgData
                if(PrSl_RxPalDvld_i = '1' and rec_cfg_data_cnt >= (inframe_cfg_data_num - 2)) then
                    PrSv_FrameState_s <= PrSv_Wait_FrameEnd_c; 
                else
                end if;
            when PrSv_Wait_FrameEnd_c => 
                if(rw_flash_frame_done_i(1) = '1') then
                    PrSv_FrameState_s <= PrSv_FrameEnd_c;            
                else
                end if;
            when PrSv_FrameEnd_c => -- Valid_End
                PrSv_FrameState_s <= (others => '0');

            when others =>
                PrSv_FrameState_s <= (others => '0');
            end case;
        end if;
    end process;

	 process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_FrameState_d1 <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then  	 
            PrSv_FrameState_d1 <= PrSv_FrameState_s;
		  end if;
    end process;
	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            state_wait_cnt <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then  
            if(PrSv_FrameState_s /= PrSv_FrameState_d1) then
				    state_wait_cnt <= (others => '0');
				elsif(state_wait_cnt < x"ff") then 
	             state_wait_cnt <= state_wait_cnt + '1';
	   		end if;				 
        end if;
    end process;	  
	 
	 process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            cmd_flag <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then  
            if(PrSv_FrameState_s = PrSv_FrameIdle_c and frame_fst_rcv_i = '1' and PrSl_RxPalDvld_i = '1') then
                cmd_flag <= PrSv_RxPalData_i(15 downto 8);
	   		end if;				 
	     end if;
	 end process;	  
	 	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            head_low_byte <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then     
            if(PrSv_FrameState_s = PrSv_FrameIdle_c and PrSl_RxPalDvld_i = '1' and frame_fst_rcv_i = '1') then
                head_low_byte <= PrSv_RxPalData_i(7 downto 0);
            else
            end if;
        end if;
    end process;
	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_Fst_RxPalData  <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_FrameIdle_c and PrSl_RxPalDvld_i = '1' and frame_fst_rcv_i = '1') then
                PrSv_Fst_RxPalData  <= PrSv_RxPalData_i;
            end if;
        end if;
    end process;
	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_Second_RxPalData  <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_FrameRecvEnd_c and rec_cfg_data_cnt = 1 and PrSl_RxPalDvld_i = '1') then
                PrSv_Second_RxPalData  <= PrSv_RxPalData_i;
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            op_flash_cmd_en_o  <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_FrameCheck_c and (PrSv_Fst_RxPalData(15 downto 8) = PrSv_CfgStartHead_c or PrSv_Fst_RxPalData(15 downto 8) = PrSv_RDHead_c)) then
                op_flash_cmd_en_o  <= '1';
            else
                op_flash_cmd_en_o  <= '0';
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            op_flash_cmd_o  <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_FrameCheck_c and 
				  (PrSv_Fst_RxPalData(15 downto 8) = PrSv_CfgStartHead_c or PrSv_Fst_RxPalData(15 downto 8) = PrSv_RDHead_c)) then
                op_flash_cmd_o  <= (PrSv_Fst_RxPalData & PrSv_Second_RxPalData);
            else
                op_flash_cmd_o  <= (others => '0');
            end if;
        end if;
    end process;
	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            wr_ufm_en_o   <= '0';
            wr_ufm_data_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_CfgData_c and PrSl_RxPalDvld_i = '1') then
                wr_ufm_en_o   <= '1';
                wr_ufm_data_o <= PrSv_RxPalData_i;
            else
                wr_ufm_en_o   <= '0';
                wr_ufm_data_o <= (others => '0');
            end if;
        end if;
    end process;


    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            wr_flash_frame_addr <= (others => '0');
            wr_flash_frame_len  <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_CfgAddr_c and PrSl_RxPalDvld_i = '1') then
                wr_flash_frame_addr <= (PrSv_RxPalData_i(10 downto 0) & head_low_byte);
                wr_flash_frame_len  <= ('0' & rcv_data_len_i(15 downto 1)) + rcv_data_len_i(0) - 2;
            else --hold
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            wr_flash_frame_req_o  <= '0';
            wr_flash_frame_addr_o <= (others => '0');
            wr_flash_frame_len_o  <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_CfgData_c and PrSl_RxPalDvld_i = '1' and rec_cfg_data_cnt >= (inframe_cfg_data_num - 2)) then
                wr_flash_frame_req_o  <= '1';
                wr_flash_frame_addr_o <= wr_flash_frame_addr;
                wr_flash_frame_len_o  <= wr_flash_frame_len;
            else
                wr_flash_frame_req_o  <= '0';
                wr_flash_frame_addr_o <= (others => '0');
                wr_flash_frame_len_o  <= (others => '0');
            end if;
        end if;
    end process;
	 	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            inframe_cfg_data_num <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSl_RxPalDvld_i = '1' and frame_fst_rcv_i = '1') then
                inframe_cfg_data_num <= ('0' & rcv_data_len_i(15 downto 1)) + rcv_data_len_i(0);
            else
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            rec_cfg_data_cnt <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(PrSv_FrameState_s = PrSv_FrameIdle_c and PrSl_RxPalDvld_i = '1') then
                rec_cfg_data_cnt <= x"000" & "000" & '1';
            elsif(PrSl_RxPalDvld_i = '1' and (PrSv_FrameState_s = PrSv_CfgData_c or PrSv_FrameState_s = PrSv_FrameRecvEnd_c) 
              and rec_cfg_data_cnt < inframe_cfg_data_num) then
                rec_cfg_data_cnt <= rec_cfg_data_cnt + '1';
            else --hold
            end if;
        end if;
    end process;

    -- PrSv_RecvData_s                     
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RecvData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_FrameState_s = PrSv_FrameIdle_c and frame_fst_rcv_i = '1' and PrSl_RxPalDvld_i = '1' 
                and PrSv_RxPalData_i(15 downto 8) = PrSv_CmdHead_c) then
                PrSv_RecvData_s(23 downto 16) <= PrSv_RxPalData_i( 7 downto 0);
            elsif (PrSv_FrameState_s = PrSv_FrameRecvEnd_c and rec_cfg_data_cnt = 1 and PrSl_RxPalDvld_i = '1') then
                PrSv_RecvData_s(15 downto 0) <= PrSv_RxPalData_i;
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            test_mode <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"1f0000") then
                test_mode <= '0';
            elsif(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"110000") then
                test_mode <= '1';
            end if;
        end if;
    end process;
    test_mode_o <= test_mode;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then         
            CpSl_WrTrig1_o <= '0';
            CpSl_WrTrig2_o <= '0';
            vx_trig_o      <= '0';
            vy_trig_o      <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameCheck_c and test_mode = '1') then 
                case PrSv_RecvData_s(23 downto 20) is
                when x"2" => 
                    CpSl_WrTrig1_o <= '0';
                    CpSl_WrTrig2_o <= '0';
						  vx_trig_o      <= '0';
						  vy_trig_o      <= '0';
                when x"3" => 
                    CpSl_WrTrig1_o <= '1';
                    CpSl_WrTrig2_o <= '0';
						  vx_trig_o      <= '0';
						  vy_trig_o      <= '0';
                when x"4" => 
                    CpSl_WrTrig1_o <= '0';
                    CpSl_WrTrig2_o <= '1';
						  vx_trig_o      <= '0';
						  vy_trig_o      <= '0';
                when x"5" => 
                    CpSl_WrTrig1_o <= '0';
                    CpSl_WrTrig2_o <= '0';
						  vx_trig_o      <= '1';
						  vy_trig_o      <= '0';
                when x"6" => 
                    CpSl_WrTrig1_o <= '0';
                    CpSl_WrTrig2_o <= '0';
						  vx_trig_o      <= '0';
						  vy_trig_o      <= '1';
                when others => 
                    CpSl_WrTrig1_o <= '0';
                    CpSl_WrTrig2_o <= '0';
						  vx_trig_o      <= '0';
						  vy_trig_o      <= '0';
                end case;
            else
				    CpSl_WrTrig1_o <= '0';
                CpSl_WrTrig2_o <= '0';
					 vx_trig_o      <= '0';
					 vy_trig_o      <= '0';
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            cfg_apd_num <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (test_mode = '1') then
                if (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 16) = x"20") then 
                    cfg_apd_num <= PrSv_RecvData_s(6 downto 0);
                else
                end if;
            else  -- hold
                cfg_apd_num <= (others => '0');
            end if;
        end if;
    end process;
	 
    -- PrSv_Addr_s
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if(CpSl_Rst_iN = '0')then
            CpSv_Addr_o <= (others => '0');
        elsif(CpSl_Clk_i'event and CpSl_Clk_i = '1')then
            case cfg_apd_num is 
                when "0000000" => CpSv_Addr_o <= "000" & x"28";--28
                when "0000001" => CpSv_Addr_o <= "000" & x"89";--89
                when "0000010" => CpSv_Addr_o <= "000" & x"2a";--2a
                when "0000011" => CpSv_Addr_o <= "000" & x"8b";--8b
                when "0000100" => CpSv_Addr_o <= "000" & x"24";--24
                when "0000101" => CpSv_Addr_o <= "000" & x"85";--85
                when "0000110" => CpSv_Addr_o <= "000" & x"26";--26
                when "0000111" => CpSv_Addr_o <= "000" & x"87";--87
                when "0001000" => CpSv_Addr_o <= "000" & x"88";--88
                when "0001001" => CpSv_Addr_o <= "000" & x"29";--29
                when "0001010" => CpSv_Addr_o <= "000" & x"8a";--8a
                when "0001011" => CpSv_Addr_o <= "000" & x"2b";--2b
                when "0001100" => CpSv_Addr_o <= "000" & x"84";--84
                when "0001101" => CpSv_Addr_o <= "000" & x"25";--25
                when "0001110" => CpSv_Addr_o <= "000" & x"86";--86
                when "0001111" => CpSv_Addr_o <= "000" & x"27";--27
                when "0010000" => CpSv_Addr_o <= "000" & x"68";--68
                when "0010001" => CpSv_Addr_o <= "000" & x"99";--99
                when "0010010" => CpSv_Addr_o <= "000" & x"6a";--6a
                when "0010011" => CpSv_Addr_o <= "000" & x"9b";--9b
                when "0010100" => CpSv_Addr_o <= "000" & x"64";--64
                when "0010101" => CpSv_Addr_o <= "000" & x"95";--95
                when "0010110" => CpSv_Addr_o <= "000" & x"66";--66
                when "0010111" => CpSv_Addr_o <= "000" & x"97";--97
                when "0011000" => CpSv_Addr_o <= "000" & x"98";--98
                when "0011001" => CpSv_Addr_o <= "000" & x"69";--69
                when "0011010" => CpSv_Addr_o <= "000" & x"9a";--9a
                when "0011011" => CpSv_Addr_o <= "000" & x"6b";--6b
                when "0011100" => CpSv_Addr_o <= "000" & x"94";--94
                when "0011101" => CpSv_Addr_o <= "000" & x"65";--65
                when "0011110" => CpSv_Addr_o <= "000" & x"96";--96
                when "0011111" => CpSv_Addr_o <= "000" & x"67";--67
                when "0100000" => CpSv_Addr_o <= "001" & x"28";--128
                when "0100001" => CpSv_Addr_o <= "001" & x"89";--189
                when "0100010" => CpSv_Addr_o <= "001" & x"2a";--12a
                when "0100011" => CpSv_Addr_o <= "001" & x"8b";--18b
                when "0100100" => CpSv_Addr_o <= "001" & x"24";--124
                when "0100101" => CpSv_Addr_o <= "001" & x"85";--185
                when "0100110" => CpSv_Addr_o <= "001" & x"26";--126
                when "0100111" => CpSv_Addr_o <= "001" & x"87";--187
                when "0101000" => CpSv_Addr_o <= "001" & x"88";--188
                when "0101001" => CpSv_Addr_o <= "001" & x"29";--129
                when "0101010" => CpSv_Addr_o <= "001" & x"8a";--18a
                when "0101011" => CpSv_Addr_o <= "001" & x"2b";--12b
                when "0101100" => CpSv_Addr_o <= "001" & x"84";--184
                when "0101101" => CpSv_Addr_o <= "001" & x"25";--125
                when "0101110" => CpSv_Addr_o <= "001" & x"86";--186
                when "0101111" => CpSv_Addr_o <= "001" & x"27";--127
                when "0110000" => CpSv_Addr_o <= "001" & x"68";--168
                when "0110001" => CpSv_Addr_o <= "001" & x"99";--199
                when "0110010" => CpSv_Addr_o <= "001" & x"6a";--16a
                when "0110011" => CpSv_Addr_o <= "001" & x"9b";--19b
                when "0110100" => CpSv_Addr_o <= "001" & x"64";--164
                when "0110101" => CpSv_Addr_o <= "001" & x"95";--195
                when "0110110" => CpSv_Addr_o <= "001" & x"66";--166
                when "0110111" => CpSv_Addr_o <= "001" & x"97";--197
                when "0111000" => CpSv_Addr_o <= "001" & x"98";--198
                when "0111001" => CpSv_Addr_o <= "001" & x"69";--169
                when "0111010" => CpSv_Addr_o <= "001" & x"9a";--19a
                when "0111011" => CpSv_Addr_o <= "001" & x"6b";--16b
                when "0111100" => CpSv_Addr_o <= "001" & x"94";--194
                when "0111101" => CpSv_Addr_o <= "001" & x"65";--165
                when "0111110" => CpSv_Addr_o <= "001" & x"96";--196
                when "0111111" => CpSv_Addr_o <= "001" & x"67";--167
                when "1000000" => CpSv_Addr_o <= "010" & x"28";--228
                when "1000001" => CpSv_Addr_o <= "010" & x"89";--289
                when "1000010" => CpSv_Addr_o <= "010" & x"2a";--22a
                when "1000011" => CpSv_Addr_o <= "010" & x"8b";--28b
                when "1000100" => CpSv_Addr_o <= "010" & x"24";--224
                when "1000101" => CpSv_Addr_o <= "010" & x"85";--285
                when "1000110" => CpSv_Addr_o <= "010" & x"26";--226
                when "1000111" => CpSv_Addr_o <= "010" & x"87";--287
                when "1001000" => CpSv_Addr_o <= "010" & x"88";--288
                when "1001001" => CpSv_Addr_o <= "010" & x"29";--229
                when "1001010" => CpSv_Addr_o <= "010" & x"8a";--28a
                when "1001011" => CpSv_Addr_o <= "010" & x"2b";--22b
                when "1001100" => CpSv_Addr_o <= "010" & x"84";--284
                when "1001101" => CpSv_Addr_o <= "010" & x"25";--225
                when "1001110" => CpSv_Addr_o <= "010" & x"86";--286
                when "1001111" => CpSv_Addr_o <= "010" & x"27";--227
                when "1010000" => CpSv_Addr_o <= "010" & x"68";--268
                when "1010001" => CpSv_Addr_o <= "010" & x"99";--299
                when "1010010" => CpSv_Addr_o <= "010" & x"6a";--26a
                when "1010011" => CpSv_Addr_o <= "010" & x"9b";--29b
                when "1010100" => CpSv_Addr_o <= "010" & x"64";--264
                when "1010101" => CpSv_Addr_o <= "010" & x"95";--295
                when "1010110" => CpSv_Addr_o <= "010" & x"66";--266
                when "1010111" => CpSv_Addr_o <= "010" & x"97";--297
                when "1011000" => CpSv_Addr_o <= "010" & x"98";--298
                when "1011001" => CpSv_Addr_o <= "010" & x"69";--269
                when "1011010" => CpSv_Addr_o <= "010" & x"9a";--29a
                when "1011011" => CpSv_Addr_o <= "010" & x"6b";--26b
                when "1011100" => CpSv_Addr_o <= "010" & x"94";--294
                when "1011101" => CpSv_Addr_o <= "010" & x"65";--265
                when "1011110" => CpSv_Addr_o <= "010" & x"96";--296
                when "1011111" => CpSv_Addr_o <= "010" & x"67";--267
                when others => CpSv_Addr_o <= "000" & x"28";
            end case;
        end if;
    end process;
    
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_Mems_noscan_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if(test_mode = '1') then
--                if (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 20) = x"2E0000") then
                if (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 0) = x"2E0000") then
                    CpSv_Mems_noscan_o <= '1';
                elsif (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 0) = x"2F0000") then 
                    CpSv_Mems_noscan_o <= '0';
                else  -- hold
                end if;
            else
                CpSv_Mems_noscan_o <= '0';
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            start1_close_en_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"F10000" and test_mode = '1') then
                start1_close_en_o <= '0';
            elsif (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"F90000" and test_mode = '1') then
                start1_close_en_o <= '1';
            else  -- hold
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            start2_close_en_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"F20000" and test_mode = '1') then
                start2_close_en_o <= '0';
            elsif (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"FA0000" and test_mode = '1') then
                start2_close_en_o <= '1';
            else  -- hold
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            start3_close_en_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"F30000" and test_mode = '1') then
                start3_close_en_o <= '0';
            elsif (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"FB0000" and test_mode = '1') then
                start3_close_en_o <= '1';
            else  -- hold
            end if;
        end if;
    end process;
    
    -- end generate Real_Data;
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_vxData_o <= (others => '0');
            CpSv_vyData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if(test_mode = '1') then
                if(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 20) = x"21") then
                    CpSv_vxData_o <= PrSv_RecvData_s(11 downto 0);
                elsif(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 20) = x"22") then
                    CpSv_vyData_o <= PrSv_RecvData_s(11 downto 0);
                else
                end if;
            else
                CpSv_vxData_o <= (others => '0');
                CpSv_vyData_o <= (others => '0');
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_WrVthData_o <= (others => '0');
				PrSl_WrVthTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if(test_mode = '1') then
                if(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 20) = x"8") then
                    CpSv_WrVthData_o <= PrSv_RecvData_s(11 downto 0);
                    PrSl_WrVthTrig_o <= '1';
                else
                    PrSl_WrVthTrig_o <= '0';
                end if;
            else
                CpSv_WrVthData_o <= (others => '0');
                PrSl_WrVthTrig_o <= '0';
            end if;
        end if;
    end process;
	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            send_trig_point_num_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if(test_mode = '1') then
                if(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 16) = x"23") then
                    send_trig_point_num_o <= PrSv_RecvData_s(15 downto 0);
                else
                end if;
            else
                send_trig_point_num_o <= (others => '0');
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            send_trig_close_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
		      if(test_mode = '1') then
	             if(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 16) = x"24") then
                    send_trig_close_o <= '0';
			       elsif(PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s(23 downto 16) = x"24") then 
                    send_trig_close_o <= '1';
				    end if;
				else
				    send_trig_close_o <= '0';
            end if;
        end if;
    end process;

    sft_rst_fpga_o <= '1' when (PrSv_FrameState_s = PrSv_FrameCheck_c and PrSv_RecvData_s = x"E00000") else '0';	 
	 
	 
	 
	 
	 
	 
    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            train_cmd_done <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if(PrSv_FrameState_s = PrSv_WAIT_c and state_wait_cnt >= 15 and cmd_flag = PrSv_CmdHead_c) then
                train_cmd_done <= "10";
            else
                train_cmd_done <= "00";
            end if;
        end if;
    end process;
	 
	 -- End
----------------------------------------
end arch_M_Net_ds_ctrl;