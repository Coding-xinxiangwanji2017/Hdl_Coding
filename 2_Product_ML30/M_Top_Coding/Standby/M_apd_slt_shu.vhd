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
-- �ļ�����  :  M_apd_slt.vhd
-- ��    ��  :  zhang shuqiang
-- ��    ��  :  shuqiang.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/12/31
-- ���ܼ���  :  Ocntrol Memory Data
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang shuqiang 2018/12/31
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

entity M_apd_slt is
    generic (
        PrSl_Sim_c                      : integer := 1                          -- Simulation
    );
    port (
        --------------------------------
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        Clk_40m_i                      : in  std_logic;                        -- single 40MHz.clock
        
        --------------------------------
        -- Rom Start Trig
        --------------------------------
        CpSl_apd_slt_en_i               : in  std_logic;                        -- Memory Add Trig
        ld_num_i                        : in std_logic_vector(1 downto 0) ;		  
CpSl_ApdVld_i                   : in  std_logic;                        -- Apd_Vld
        CpSv_Addr_o                     : out  std_logic_vector(10 downto 0)   -- Test_IO
    );
end M_apd_slt;

architecture arch_M_apd_slt of M_apd_slt is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
 --   constant PrSv_MemsCnt_c             : std_logic_vector(14 downto 0) := "100" & x"E1F"; -- 19999
    constant PrSv_MemsCnt_c             : std_logic_vector(14 downto 0) := "010" & x"70F"; -- 9999

    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    -- Memscan_X
    component rom_apd_slt is
    port (
        address		                    : IN  STD_LOGIC_VECTOR (14 DOWNTO 0);
        clock		                    : IN  STD_LOGIC := '1';
        q                               : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
    end component;
	 
	 signal group_cnt                 :   std_logic_vector(3 downto 0);
	 signal CpSl_apd_slt_en_d1        :   std_logic;
	 signal CpSl_apd_slt_en_d2        :   std_logic;
	 signal CpSl_apd_slt_en_d3        :   std_logic;
	 signal rd_rom_en        :   std_logic;
	 signal rd_rom_en_d1        :   std_logic;
	 signal rd_rom_en_d2        :   std_logic;
	 signal rd_rom_en_d3        :   std_logic;
	 signal rd_rom_en_d4        :   std_logic;
	 signal rd_rom_en_d5        :   std_logic;
	 signal rd_rom_en_d6        :   std_logic;
   signal ld_in_cnt           :   std_logic_vector(14 downto 0);
   signal PrSv_apd_num_lock   :   std_logic_vector(6 downto 0);
   signal ld_num              :   std_logic_vector(1 downto 0);
	
	 signal PrSv_RomAddr_s :                      STD_LOGIC_VECTOR (14 DOWNTO 0);
	 signal PrSv_apd_num_s :                      STD_LOGIC_VECTOR (7 DOWNTO 0);
   signal apd_chg_cnt    :                      STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
	 
    Real_apd_slt : if (PrSl_Sim_c = 1) generate
    U_rom_apd_slt : rom_apd_slt
    port map (
        address		                    => PrSv_RomAddr_s,                      -- IN STD_LOGIC_VECTOR (14 DOWNTO 0);  
        clock		                    => Clk_40m_i,                          -- IN STD_LOGIC  := '1';               
        q                               => PrSv_apd_num_s                      -- OUT STD_LOGIC_VECTOR (7 DOWNTO 0)  
	);
    end generate Real_apd_slt;
	 
	 Sim_apd_slt : if (PrSl_Sim_c = 0) generate
        PrSv_apd_num_s <= x"A5";
    end generate Sim_apd_slt;
    --gen delay signal 
    process (CpSl_Rst_iN,Clk_40m_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_apd_slt_en_d1 <= '0';
            CpSl_apd_slt_en_d2 <= '0';
            CpSl_apd_slt_en_d3 <= '0';
            rd_rom_en_d1 <= '0';
            rd_rom_en_d2 <= '0';
            rd_rom_en_d3 <= '0';
            rd_rom_en_d4 <= '0';
            rd_rom_en_d5 <= '0';
            rd_rom_en_d6 <= '0';
        elsif rising_edge(Clk_40m_i) then 
            CpSl_apd_slt_en_d1 <= CpSl_apd_slt_en_i;
            CpSl_apd_slt_en_d2 <= CpSl_apd_slt_en_d1;
            CpSl_apd_slt_en_d3 <= CpSl_apd_slt_en_d2;
            rd_rom_en_d1       <= rd_rom_en;
            rd_rom_en_d2       <= rd_rom_en_d1;
            rd_rom_en_d3       <= rd_rom_en_d2;
            rd_rom_en_d4       <= rd_rom_en_d3;
            rd_rom_en_d5       <= rd_rom_en_d4;
            rd_rom_en_d6       <= rd_rom_en_d5;
        end if;
    end process;

    process (CpSl_Rst_iN,Clk_40m_i) begin
        if (CpSl_Rst_iN = '0') then 
            rd_rom_en <= '0';
        elsif rising_edge(Clk_40m_i) then 
		      if (CpSl_apd_slt_en_d3 = '0' and CpSl_apd_slt_en_d2 = '1') then
                rd_rom_en          <= '1';
				else
				    rd_rom_en          <= '0';
			   end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN,Clk_40m_i) begin
        if (CpSl_Rst_iN = '0') then 
            ld_in_cnt <= (others => '0');
        elsif rising_edge(Clk_40m_i) then 
            if(rd_rom_en = '1' and ld_num = "10" and ld_num_i = "00" and ld_in_cnt >= 9999) then
                ld_in_cnt <= (others => '0');
            elsif (rd_rom_en = '1' and ld_num = "10" and ld_num_i = "00") then
                ld_in_cnt <= ld_in_cnt + '1';
            end if;
        end if;
    end process;

    process (CpSl_Rst_iN,Clk_40m_i) begin
        if (CpSl_Rst_iN = '0') then 
            ld_num <= (others => '0');
        elsif rising_edge(Clk_40m_i) then 
            if(rd_rom_en = '1') then
                ld_num <= ld_num_i;
            end if;
        end if;
    end process;
    
    process (CpSl_Rst_iN,Clk_40m_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_apd_num_lock <= (others => '0');
        elsif rising_edge(Clk_40m_i) then 
            if(rd_rom_en_d4 = '1') then
                PrSv_apd_num_lock <= PrSv_apd_num_s(6 downto 0);
            end if;
        end if;
    end process;    
    
    process (CpSl_Rst_iN,Clk_40m_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_RomAddr_s <= (others => '0');
        elsif rising_edge(Clk_40m_i) then 
            case(ld_num) is
				    when "00" => PrSv_RomAddr_s <= ld_in_cnt;
				    when "01" => PrSv_RomAddr_s <= ld_in_cnt + 10000;
				    when "10" => PrSv_RomAddr_s <= ld_in_cnt + 20000;
					 when others => PrSv_RomAddr_s <= ld_in_cnt;
            end case;
        end if;
    end process;    
    	 
  process(Clk_40m_i,CpSl_Rst_iN)
  begin
    if(CpSl_Rst_iN = '0')then
      CpSv_Addr_o(9 downto 0) <= (others => '0');
    elsif(Clk_40m_i'event and Clk_40m_i = '1')then
	   case PrSv_apd_num_lock is 
          when "0000000" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"28";--28
          when "0000001" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"89";--89
          when "0000010" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"2a";--2a
          when "0000011" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"8b";--8b
          when "0000100" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"24";--24
          when "0000101" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"85";--85
          when "0000110" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"26";--26
          when "0000111" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"87";--87
          when "0001000" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"88";--88
          when "0001001" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"29";--29
          when "0001010" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"8a";--8a
          when "0001011" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"2b";--2b
          when "0001100" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"84";--84
          when "0001101" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"25";--25
          when "0001110" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"86";--86
          when "0001111" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"27";--27
          when "0010000" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"68";--68
          when "0010001" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"99";--99
          when "0010010" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"6a";--6a
          when "0010011" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"9b";--9b
          when "0010100" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"64";--64
          when "0010101" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"95";--95
          when "0010110" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"66";--66
          when "0010111" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"97";--97
          when "0011000" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"98";--98
          when "0011001" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"69";--69
          when "0011010" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"9a";--9a
          when "0011011" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"6b";--6b
          when "0011100" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"94";--94
          when "0011101" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"65";--65
          when "0011110" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"96";--96
          when "0011111" =>  CpSv_Addr_o(9 downto 0) <= "00" & x"67";--67
          when "0100000" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"28";--128
          when "0100001" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"89";--189
          when "0100010" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"2a";--12a
          when "0100011" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"8b";--18b
          when "0100100" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"24";--124
          when "0100101" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"85";--185
          when "0100110" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"26";--126
          when "0100111" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"87";--187
          when "0101000" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"88";--188
          when "0101001" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"29";--129
          when "0101010" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"8a";--18a
          when "0101011" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"2b";--12b
          when "0101100" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"84";--184
          when "0101101" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"25";--125
          when "0101110" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"86";--186
          when "0101111" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"27";--127
          when "0110000" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"68";--168
          when "0110001" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"99";--199
          when "0110010" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"6a";--16a
          when "0110011" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"9b";--19b
          when "0110100" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"64";--164
          when "0110101" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"95";--195
          when "0110110" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"66";--166
          when "0110111" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"97";--197
          when "0111000" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"98";--198
          when "0111001" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"69";--169
          when "0111010" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"9a";--19a
          when "0111011" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"6b";--16b
          when "0111100" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"94";--194
          when "0111101" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"65";--165
          when "0111110" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"96";--196
          when "0111111" =>  CpSv_Addr_o(9 downto 0) <= "01" & x"67";--167
          when "1000000" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"28";--228
          when "1000001" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"89";--289
          when "1000010" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"2a";--22a
          when "1000011" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"8b";--28b
          when "1000100" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"24";--224
          when "1000101" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"85";--285
          when "1000110" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"26";--226
          when "1000111" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"87";--287
          when "1001000" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"88";--288
          when "1001001" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"29";--229
          when "1001010" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"8a";--28a
          when "1001011" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"2b";--22b
          when "1001100" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"84";--284
          when "1001101" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"25";--225
          when "1001110" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"86";--286
          when "1001111" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"27";--227
          when "1010000" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"68";--268
          when "1010001" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"99";--299
          when "1010010" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"6a";--26a
          when "1010011" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"9b";--29b
          when "1010100" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"64";--264
          when "1010101" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"95";--295
          when "1010110" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"66";--266
          when "1010111" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"97";--297
          when "1011000" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"98";--298
          when "1011001" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"69";--269
          when "1011010" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"9a";--29a
          when "1011011" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"6b";--26b
          when "1011100" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"94";--294
          when "1011101" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"65";--265
          when "1011110" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"96";--296
          when "1011111" =>  CpSv_Addr_o(9 downto 0) <= "10" & x"67";--267
			 when others => CpSv_Addr_o(9 downto 0) <= "00" & x"28";
		  end case;
    end if;
  end process;

  process(Clk_40m_i,CpSl_Rst_iN)
  begin
    if(CpSl_Rst_iN = '0')then
      CpSv_Addr_o(10) <= '0';
    elsif(Clk_40m_i'event and Clk_40m_i = '1')then
        if(rd_rom_en_d3 = '1') then
            CpSv_Addr_o(10) <= '1';
            apd_chg_cnt <= x"18";
        elsif(apd_chg_cnt /= x"00") then
            CpSv_Addr_o(10) <= '1';
            apd_chg_cnt <= apd_chg_cnt - '1';
        else 
            CpSv_Addr_o(10) <= '0';
            apd_chg_cnt <= apd_chg_cnt;
        end if;
    end if;
  end process;


----------------------------------------
-- End
----------------------------------------
end arch_M_apd_slt;