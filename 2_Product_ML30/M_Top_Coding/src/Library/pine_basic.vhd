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
-- �ļ�����  :  pine_basic.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/05/17
-- ���ܼ���  :  
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package pine_basic is

    -- type define
    type type_byte_array is array (Natural range<>) of std_logic_vector( 7 downto 0);
    type type_word_array is array (Natural range<>) of std_logic_vector(15 downto 0);

    ------------------------------------
    -- PC <---> FPGA
    ------------------------------------
    constant PrSv_RxCmdAdd_c            : std_logic_vector(11 downto 0) := x"232";	-- PC Command
    constant PrSv_RxCmdStart_c          : std_logic_vector(15 downto 0) := x"CFEB";	-- Start
    constant PrSv_RxCmdEnd_c            : std_logic_vector(15 downto 0) := x"EBCF";	-- End

    constant PrSv_UDPTxAdd_c            : std_logic_vector(11 downto 0) := x"234";	-- Tx Data Address
    constant PrSv_UDPTxSucc_c           : std_logic_vector(15 downto 0) := x"A5CF"; -- UdpRx Data Succssful
    constant PrSv_UDPTxFail_c           : std_logic_vector(15 downto 0) := x"B4EB"; -- UdpRx Data Failed

    ------------------------------------
    -- ethernet
    ------------------------------------
    constant Img_Package_Size           : std_logic_vector(16 downto 0) := '0'&X"0400"; --'0'&X"8000"; --LPackage--'0' & X"0400";	-- ͼ�����ݰ��Ĵ�С��1024�ֽ�
    constant IMG_PACKAGE_BEGIN          : std_logic_vector(31 downto 0) := x"EB9009BE";
    constant IMG_PACKAGE_END            : std_logic_vector(31 downto 0) := x"BE0990EB";

    ------------------------------------
    -- Command
    ------------------------------------
    constant CMD_QJ                     : std_logic_vector(15 downto 0) := x"146F";	-- ȡ��Уʱָ��
    constant CMD_BY                     : std_logic_vector(15 downto 0) := x"14F6";	-- �ع���ѹ������ָ��

    constant CMD_FLAG_REG_WR            : std_logic_vector( 7 downto 0) := x"AA";	-- д�ڲ��Ĵ�����־
    constant CMD_FLAG_AUTO_EXPOSURE     : std_logic_vector( 7 downto 0) := x"AA";	-- �Զ��ع���־
    constant CMD_FLAG_MANUAL_EXPOSURE   : std_logic_vector( 7 downto 0) := x"55";	-- �ֶ��ع���־

    constant CMD_DATA_COUNT_MAX         : integer := 64;
    constant CMD_QJ_COUNT               : integer := 6 - 1;	                        -- ��ȥָ��ͷ�����ݸ���
    constant CMD_BY_COUNT               : integer := 38 - 1;	                    -- ��ȥָ��ͷ�����ݸ���
    constant CMD_TIMEOUT_MAX            : std_logic_vector(11 downto 0) := x"B5D";	-- (8.68*11+50)*2=2909,-1, 290.9 us

    ------------------------------------
    -- Common Reg Configuration
    ------------------------------------
    constant W5300_MR                   : std_logic_vector(11 downto 0) := x"000";	        -- ģʽ�Ĵ���
    constant W5300_IR                   : std_logic_vector(11 downto 0) := x"002";	        -- �жϼĴ���
    constant W5300_IMR                  : std_logic_vector(11 downto 0) := x"004";	        -- �ж���μĴ���
    constant W5300_SHAR                 : std_logic_vector(11 downto 0) := x"008";	        -- ����Ӳ����ַ�Ĵ���0��1
    constant W5300_SHAR2                : std_logic_vector(11 downto 0) := x"00A";	        -- ����Ӳ����ַ�Ĵ���2��3
    constant W5300_SHAR4                : std_logic_vector(11 downto 0) := x"00C";	        -- ����Ӳ����ַ�Ĵ���4��5
    constant W5300_GAR                  : std_logic_vector(11 downto 0) := x"010";          -- ���ص�ַ�Ĵ���0��1
    constant W5300_GAR2                 : std_logic_vector(11 downto 0) := x"012";          -- ���ص�ַ�Ĵ���2��3
    constant W5300_SUBR                 : std_logic_vector(11 downto 0) := x"014";	        -- ���������Ĵ���0��1
    constant W5300_SUBR2                : std_logic_vector(11 downto 0) := x"016";	        -- ���������Ĵ���2��3
    constant W5300_SIPR                 : std_logic_vector(11 downto 0) := x"018";	        -- ����IP��ַ�Ĵ���0��1
    constant W5300_SIPR2                : std_logic_vector(11 downto 0) := x"01A";	        -- ����IP��ַ�Ĵ���2��3
    constant W5300_RTR                  : std_logic_vector(11 downto 0) := x"01C";	        -- ��ʱ����ֵ�Ĵ����ʱ�������´���
    constant W5300_RCR                  : std_logic_vector(11 downto 0) := x"01E";	        -- ���´��������Ĵ����8λ��Ч
    constant W5300_TMS01R               : std_logic_vector(11 downto 0) := x"020";	        -- �˿�0��1�����洢����С���üĴ���
    constant W5300_TMS23R               : std_logic_vector(11 downto 0) := x"022";	        -- �˿�2��3�����洢����С���üĴ���
    constant W5300_TMS45R               : std_logic_vector(11 downto 0) := x"024";	        -- �˿�4��5�����洢����С���üĴ���
    constant W5300_TMS67R               : std_logic_vector(11 downto 0) := x"026";	        -- �˿�6��7�����洢����С���üĴ���
    constant W5300_RMS01R               : std_logic_vector(11 downto 0) := x"028";	        -- �˿�0��1���մ洢����С���üĴ���
    constant W5300_RMS23R               : std_logic_vector(11 downto 0) := x"02A";	        -- �˿�2��3���մ洢����С���üĴ���
    constant W5300_RMS45R               : std_logic_vector(11 downto 0) := x"02C";	        -- �˿�4��5���մ洢����С���üĴ���
    constant W5300_RMS67R               : std_logic_vector(11 downto 0) := x"02E";	        -- �˿�6��7���մ洢����С���üĴ���
    constant W5300_MTYPER               : std_logic_vector(11 downto 0) := x"030";	        -- �洢��Ԫ���ͼĴ���

    constant PrSv_W5300MRRst_c          : std_logic_vector(15 downto 0) := x"0090";         -- WR_RstW5300_NotPing
    constant PrSv_W5300MRData_c         : std_logic_vector(15 downto 0) := x"BC00";         -- WR_Data
    constant PrSv_W5300IRData_c         : std_logic_vector(15 downto 0) := x"FFFF";         -- IR_Data
    --constant PrSv_W5300IMRData_c        : std_logic_vector(15 downto 0) := x"0001";         -- IMR_Data
    constant PrSv_W5300IMRData_c        : std_logic_vector(15 downto 0) := x"0003";         -- IMR_Data
    constant PrSv_W5300ShaRData_c       : std_logic_vector(47 downto 0) := x"0013D3880016";	-- 0013D3880016
    constant PrSv_W5300GaRData_c        : std_logic_vector(31 downto 0) := x"C0A80A01";     -- 192.168.10.1 ����
    constant PrSv_W5300SubRData_c       : std_logic_vector(31 downto 0) := x"FFFFFF00";     -- 255.255.255.0 ��������
    constant PrSv_W5300SiPRData_c       : std_logic_vector(31 downto 0) := x"C0A80A6C";     -- 192.168.10.108 ����IP
    --constant PrSv_W5300TMS01Data_c      : std_logic_vector(15 downto 0) := x"4000";         -- TMS01_Data
    constant PrSv_W5300TMS01Data_c      : std_logic_vector(15 downto 0) := x"2020";         -- TMS01_Data
    constant PrSv_W5300TMS23Data_c      : std_logic_vector(15 downto 0) := x"0000";         -- TMS23_Data
    constant PrSv_W5300TMS45Data_c      : std_logic_vector(15 downto 0) := x"0000";         -- TMS45_Data
    constant PrSv_W5300TMS67Data_c      : std_logic_vector(15 downto 0) := x"0000";	        -- TMS45_Data
    --constant PrSv_W5300RMS01Data_c      : std_logic_vector(15 downto 0) := x"4000";         -- RMS01_Data
    constant PrSv_W5300RMS01Data_c      : std_logic_vector(15 downto 0) := x"2020";         -- RMS01_Data
    constant PrSv_W5300RMS23Data_c      : std_logic_vector(15 downto 0) := x"0000";         -- RMS23_Data
    constant PrSv_W5300RMS45Data_c      : std_logic_vector(15 downto 0) := x"0000";         -- RMS45_Data
    constant PrSv_W5300RMS67Data_c      : std_logic_vector(15 downto 0) := x"0000";	        -- RMS45_Data
    constant PrSv_W5300MTypeData_c      : std_logic_vector(15 downto 0) := x"00FF";	        -- MType_Data('1' : TxReg; '0' : RxReg)
    
    ------------------------------------
    -- Socket Reg Configuration
    ------------------------------------
    -- Socket0 :  
    constant W5300_S0_MR                : std_logic_vector(11 downto 0) := x"200";	-- SOCKET0ģʽ�Ĵ���
    constant W5300_S0_CR                : std_logic_vector(11 downto 0) := x"202";	-- SOCKET0�����Ĵ���
    constant W5300_S0_IMR               : std_logic_vector(11 downto 0) := x"204";	-- SOCKET0�ж���μĴ���
    constant W5300_S0_IR                : std_logic_vector(11 downto 0) := x"206";	-- SOCKET0�жϼĴ���
    constant W5300_S0_SSR               : std_logic_vector(11 downto 0) := x"208";	-- SOCKET0״̬�Ĵ���
    constant W5300_S0_PORTR             : std_logic_vector(11 downto 0) := x"20A";	-- SOCKET0�˿ں�
    constant W5300_S0_DHAR              : std_logic_vector(11 downto 0) := x"20C";	-- SOCKET0Ŀ��MAC��ַ
    constant W5300_S0_DHAR2             : std_logic_vector(11 downto 0) := x"20E";	-- SOCKET0Ŀ��MAC��ַ
    constant W5300_S0_DHAR4             : std_logic_vector(11 downto 0) := x"210";	-- SOCKET0Ŀ��MAC��ַ
    constant W5300_S0_DPORTR            : std_logic_vector(11 downto 0) := x"212";  -- SOCKET0Ŀ�Ķ˿ںŵ�ַ�Ĵ���
    constant W5300_S0_DIPR              : std_logic_vector(11 downto 0) := x"214";	-- SOCKET0Ŀ��IP��ַ�Ĵ���
    constant W5300_S0_DIPR2             : std_logic_vector(11 downto 0) := x"216";	-- SOCKET0Ŀ��IP��ַ�Ĵ���
    constant W5300_S0_MSSR              : std_logic_vector(11 downto 0) := x"218";  -- SOCKET0������Ƭ�ֽڳ��ȼĴ���
    constant W5300_S0_TX_WRSR           : std_logic_vector(11 downto 0) := x"220";	-- SOCKET0��TXд���ֽڳ��ȼĴ���
    constant W5300_S0_TX_WRSR2          : std_logic_vector(11 downto 0) := x"222";	-- SOCKET0��TXд���ֽڳ��ȼĴ���
    constant W5300_S0_TX_FSR            : std_logic_vector(11 downto 0) := x"224";	-- SOCKET0��TXʣ���ֽڳ��ȼĴ���
    constant W5300_S0_TX_FSR2           : std_logic_vector(11 downto 0) := x"226";	-- SOCKET0��TXʣ���ֽڳ��ȼĴ���
    constant W5300_S0_RX_RSR            : std_logic_vector(11 downto 0) := x"228";	-- SOCKET0��RX���������ֽڳ��ȼĴ���
    constant W5300_S0_RX_RSR2           : std_logic_vector(11 downto 0) := x"22A";	-- SOCKET0��RX���������ֽڳ��ȼĴ���
    constant W5300_S0_TX_FIFOR          : std_logic_vector(11 downto 0) := x"22E";	-- SOCKET0��Tx Fifo�Ĵ���
    constant W5300_S0_RX_FIFOR          : std_logic_vector(11 downto 0) := x"230";	-- SOCKET0��Rx Fifo�Ĵ���
    
    constant PrSv_S0MR_UDP_c            : std_logic_vector(15 downto 0) := x"0002"; -- S0MR_UDP
    constant PrSv_S0CR_Open_c           : std_logic_vector(15 downto 0) := x"0001";	-- Socket_Open
    constant PrSv_S0CR_Close_c          : std_logic_vector(15 downto 0) := x"0010";	-- Socket_Close 
    constant PrSv_S0CR_Send_c           : std_logic_vector(15 downto 0) := x"0020";	-- Socket_Send
    constant PrSv_S0CR_SendMac_c        : std_logic_vector(15 downto 0) := x"0021";	-- Socket_SendMac
    constant PrSv_S0CR_Recv_c           : std_logic_vector(15 downto 0) := x"0040";	-- Socket_Recv
    constant PrSv_S0IMRData_c           : std_logic_vector(15 downto 0) := x"0018"; -- IMR_Data 
    constant PrSv_S0IRData_c            : std_logic_vector(15 downto 0) := x"FFFF"; -- IR_Data
    constant PrSv_ClrS0IRData_c         : std_logic_vector(15 downto 0) := x"00FF"; -- Clear IR
    constant PrSv_S0PortR_c             : std_logic_vector(15 downto 0) := x"0DAC"; -- SOCKETnԴ�˿ںżĴ���(3500)
    constant PrSv_S0SSR_UDP_c           : std_logic_vector( 7 downto 0) := x"22";	-- SocketState_UDP_Module
    constant PrSv_S0DPortRData_c        : std_logic_vector(15 downto 0) := x"0DAC"; -- Dst_Port
    -- Socket1 :  
    constant W5300_S1_MR                : std_logic_vector(11 downto 0) := x"240";	-- SOCKET1ģʽ�Ĵ���
    constant W5300_S1_CR                : std_logic_vector(11 downto 0) := x"242";	-- SOCKET1�����Ĵ���
    constant W5300_S1_IMR               : std_logic_vector(11 downto 0) := x"244";	-- SOCKET1�ж���μĴ���
    constant W5300_S1_IR                : std_logic_vector(11 downto 0) := x"246";	-- SOCKET1�жϼĴ���
    constant W5300_S1_SSR               : std_logic_vector(11 downto 0) := x"248";	-- SOCKET1״̬�Ĵ���
    constant W5300_S1_PORTR             : std_logic_vector(11 downto 0) := x"24A";	-- SOCKET1�˿ں�
    constant W5300_S1_DHAR              : std_logic_vector(11 downto 0) := x"24C";	-- SOCKET1Ŀ��MAC��ַ
    constant W5300_S1_DHAR2             : std_logic_vector(11 downto 0) := x"24E";	-- SOCKET1Ŀ��MAC��ַ
    constant W5300_S1_DHAR4             : std_logic_vector(11 downto 0) := x"250";	-- SOCKET1Ŀ��MAC��ַ
    constant W5300_S1_DPORTR            : std_logic_vector(11 downto 0) := x"252";  -- SOCKET1Ŀ�Ķ˿ںŵ�ַ�Ĵ���
    constant W5300_S1_DIPR              : std_logic_vector(11 downto 0) := x"254";	-- SOCKET1Ŀ��IP��ַ�Ĵ���
    constant W5300_S1_DIPR2             : std_logic_vector(11 downto 0) := x"256";	-- SOCKET1Ŀ��IP��ַ�Ĵ���
    constant W5300_S1_MSSR              : std_logic_vector(11 downto 0) := x"258";  -- SOCKET1������Ƭ�ֽڳ��ȼĴ���
    constant W5300_S1_TX_WRSR           : std_logic_vector(11 downto 0) := x"260";	-- SOCKET1��TXд���ֽڳ��ȼĴ���
    constant W5300_S1_TX_WRSR2          : std_logic_vector(11 downto 0) := x"262";	-- SOCKET1��TXд���ֽڳ��ȼĴ���
    constant W5300_S1_TX_FSR            : std_logic_vector(11 downto 0) := x"264";	-- SOCKET1��TXʣ���ֽڳ��ȼĴ���
    constant W5300_S1_TX_FSR2           : std_logic_vector(11 downto 0) := x"266";	-- SOCKET1��TXʣ���ֽڳ��ȼĴ���
    constant W5300_S1_RX_RSR            : std_logic_vector(11 downto 0) := x"268";	-- SOCKET1��RX���������ֽڳ��ȼĴ���
    constant W5300_S1_RX_RSR2           : std_logic_vector(11 downto 0) := x"26A";	-- SOCKET1��RX���������ֽڳ��ȼĴ���
    constant W5300_S1_TX_FIFOR          : std_logic_vector(11 downto 0) := x"26E";	-- SOCKET1��Tx Fifo�Ĵ���
    constant W5300_S1_RX_FIFOR          : std_logic_vector(11 downto 0) := x"270";	-- SOCKET1��Rx Fifo�Ĵ���
    
    constant PrSv_S1MR_TCP_c            : std_logic_vector(15 downto 0) := x"0001"; -- S1MR_TCP
    constant PrSv_S1PortR_c             : std_logic_vector(15 downto 0) := x"0BB8"; -- SOCKETnԴ�˿ںżĴ���(3000)
    constant PrSv_S1CR_Open_c           : std_logic_vector(15 downto 0) := x"0001";	-- Socket_Open
    constant PrSv_S1CR_listen_c         : std_logic_vector(15 downto 0) := x"0002";	-- Socket_listen
    constant PrSv_S1CR_connect_c        : std_logic_vector(15 downto 0) := x"0004";	-- Socket_connect
    constant PrSv_S1CR_discon_c         : std_logic_vector(15 downto 0) := x"0008";	-- Socket_discon
    constant PrSv_S1CR_Close_c          : std_logic_vector(15 downto 0) := x"0010";	-- Socket_Close 
    constant PrSv_S1CR_Send_c           : std_logic_vector(15 downto 0) := x"0020";	-- Socket_Send
    constant PrSv_S1CR_SendMac_c        : std_logic_vector(15 downto 0) := x"0021";	-- Socket_SendMac
    constant PrSv_S1CR_Sendkeep_c       : std_logic_vector(15 downto 0) := x"0022";	-- Socket_Sendkeep
    constant PrSv_S1CR_Recv_c           : std_logic_vector(15 downto 0) := x"0040";	-- Socket_Recv
    constant PrSv_S1IMRData_c           : std_logic_vector(15 downto 0) := x"0018"; -- IMR_Data 
    constant PrSv_S1IRData_c            : std_logic_vector(15 downto 0) := x"FFFF"; -- IR_Data
    constant PrSv_ClrS1IRData_c         : std_logic_vector(15 downto 0) := x"00FF"; -- Clear IR

    constant PrSv_S1SSR_CLOSED_c        : std_logic_vector( 7 downto 0) := x"00";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_INIT_c          : std_logic_vector( 7 downto 0) := x"13";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_LISTEN_c        : std_logic_vector( 7 downto 0) := x"14";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_ESTABLISHED_c   : std_logic_vector( 7 downto 0) := x"17";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_CLOSE_WAIT_c    : std_logic_vector( 7 downto 0) := x"1C";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_SYNSENT_c       : std_logic_vector( 7 downto 0) := x"15";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_SYNRECV_c       : std_logic_vector( 7 downto 0) := x"16";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_FIN_WAIT_c      : std_logic_vector( 7 downto 0) := x"18";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_TIME_WAIT_c     : std_logic_vector( 7 downto 0) := x"1B";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_LAST_ACK_c      : std_logic_vector( 7 downto 0) := x"1D";	-- SocketState_TCP_Module
    constant PrSv_S1SSR_ARP_c           : std_logic_vector( 7 downto 0) := x"01";	-- SocketState_TCP_Module
    constant PrSv_S1DPortRData_c        : std_logic_vector(15 downto 0) := x"0BB8"; -- Dst_Port


    ----------------------------------------------------------------------------
    -- State Describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- PrSv_ComState_s
    ------------------------------------
    constant PrSv_ComStateIdle_c        : std_logic_vector( 4 downto 0) := "00000"; -- Config Common State Idle
    constant PrSv_ComStateRstW5300_c    : std_logic_vector( 4 downto 0) := "00001"; -- Config Common State Reset W5300
    constant PrSv_ComState200us_c       : std_logic_vector( 4 downto 0) := "00010"; -- Config Common State wait 200us
    constant PrSv_ComStateMR_c          : std_logic_vector( 4 downto 0) := "00011"; -- Config Common State MR
    constant PrSv_ComStateIR_c          : std_logic_vector( 4 downto 0) := "00100"; -- Config Common State IR
    constant PrSv_ComStateIMR_c         : std_logic_vector( 4 downto 0) := "00101"; -- Config Common State IMR
    constant PrSv_ComStateShaReg_c      : std_logic_vector( 4 downto 0) := "00110"; -- Config Common State ShaReg
    constant PrSv_ComStateShaReg2_c     : std_logic_vector( 4 downto 0) := "00111"; -- Config Common State ShaReg2
    constant PrSv_ComStateShaReg4_c     : std_logic_vector( 4 downto 0) := "01000"; -- Config Common State ShaReg4
    constant PrSv_ComStateGAR_c         : std_logic_vector( 4 downto 0) := "01001"; -- Config Common State GAR
    constant PrSv_ComStateGAR2_c        : std_logic_vector( 4 downto 0) := "01010"; -- Config Common State GAR2
    constant PrSv_ComStateSUBR_c        : std_logic_vector( 4 downto 0) := "01011"; -- Config Common State SUBR
    constant PrSv_ComStateSUBR2_c       : std_logic_vector( 4 downto 0) := "01100"; -- Config Common State SUBR2
    constant PrSv_ComStateSIPR_c        : std_logic_vector( 4 downto 0) := "01101"; -- Config Common State SIPR
    constant PrSv_ComStateSIPR2_c       : std_logic_vector( 4 downto 0) := "01110"; -- Config Common State SIPR2
    constant PrSv_ComStateTMS01R_c      : std_logic_vector( 4 downto 0) := "01111"; -- Config Common State TMS01R
    constant PrSv_ComStateTMS23R_c      : std_logic_vector( 4 downto 0) := "10000"; -- Config Common State TMS23R
    constant PrSv_ComStateTMS45R_c      : std_logic_vector( 4 downto 0) := "10001"; -- Config Common State TMS45R
    constant PrSv_ComStateTMS67R_c      : std_logic_vector( 4 downto 0) := "10010"; -- Config Common State TMS67R
    constant PrSv_ComStateRMS01R_c      : std_logic_vector( 4 downto 0) := "10011"; -- Config Common State RMS01R
    constant PrSv_ComStateRMS23R_c      : std_logic_vector( 4 downto 0) := "10100"; -- Config Common State RMS23R
    constant PrSv_ComStateRMS45R_c      : std_logic_vector( 4 downto 0) := "10101"; -- Config Common State RMS45R
    constant PrSv_ComStateRMS67R_c      : std_logic_vector( 4 downto 0) := "10110"; -- Config Common State RMS67R
    constant PrSv_ComStateMTYPER_c      : std_logic_vector( 4 downto 0) := "10111"; -- Config Common State MTYPER
    constant PrSv_ComStateRTR_c         : std_logic_vector( 4 downto 0) := "11000"; -- Config Common State RTR
    constant PrSv_ComStateRCR_c         : std_logic_vector( 4 downto 0) := "11001"; -- Config Common State RCR
    constant PrSv_ComStateEnd_c         : std_logic_vector( 4 downto 0) := "11010"; -- Config Common State End

    ------------------------------------
    -- PrSv_SocketState_s
    ------------------------------------
    constant PrSv_SocketStateIdle_c       : std_logic_vector( 4 downto 0) := "00000";  -- Config Socket State Idle
    constant PrSv_SocketStateS0MR_c       : std_logic_vector( 4 downto 0) := "00001";  -- Config Socket State SO_MR
    constant PrSv_SocketStateS0IMR_c      : std_logic_vector( 4 downto 0) := "00010";  -- Config Socket State SO_IMR
    constant PrSv_SocketStateS0IR_c       : std_logic_vector( 4 downto 0) := "00011";  -- Config Socket State S0_IR
    constant PrSv_SocketStateS0PortReg_c  : std_logic_vector( 4 downto 0) := "00100";  -- Config Socket State SO_PortReg
    constant PrSv_SocketStateS0DPortReg_c : std_logic_vector( 4 downto 0) := "00101";  -- Config Socket State SO_PortReg
    constant PrSv_SocketStateS0CR_c       : std_logic_vector( 4 downto 0) := "00110";  -- Config Socket State SO_CR
    constant PrSv_SocketStateS0SSR_c      : std_logic_vector( 4 downto 0) := "00111";  -- Config Socket State SO_SSR
    constant PrSv_SocketStateS0UDP_c      : std_logic_vector( 4 downto 0) := "01000";  -- Config Socket State UDP Module
    constant PrSv_SocketStateS1MR_c       : std_logic_vector( 4 downto 0) := "01001";  -- Config Socket State S1_MR
    constant PrSv_SocketStateS1IMR_c      : std_logic_vector( 4 downto 0) := "01010";  -- Config Socket State S1_IMR
    constant PrSv_SocketStateS1IR_c       : std_logic_vector( 4 downto 0) := "01011";  -- Config Socket State S1_IR
    constant PrSv_SocketStateS1PortReg_c  : std_logic_vector( 4 downto 0) := "01100";  -- Config Socket State S1_PortReg
    constant PrSv_SocketStateS1DPortReg_c : std_logic_vector( 4 downto 0) := "01101";  -- Config Socket State S1_PortReg
    constant PrSv_SocketStateS1CR_OPEN_c  : std_logic_vector( 4 downto 0) := "01110";  -- Config Socket State S1_CR
    constant PrSv_SocketStateS1CR_LISTEN_c: std_logic_vector( 4 downto 0) := "01111";  -- Config Socket State S1_CR
    constant PrSv_SocketStateS1SSR_c      : std_logic_vector( 4 downto 0) := "10000";  -- Config Socket State S1_SSR
    constant PrSv_SocketStateS1TCP_c      : std_logic_vector( 4 downto 0) := "10001";  -- Config Socket State TCP Module
    constant PrSv_SocketStateEnd_c        : std_logic_vector( 4 downto 0) := "10010";  -- Config Socket State End

    ------------------------------------
    -- PrSv_UdpTxState_s
    ------------------------------------
    constant PrSv_RxTxIdle_c                  : std_logic_vector( 5 downto 0) := "000000"; -- Config TcpRx State Idle
    constant PrSv_TcpRxS1CR_OPEN_c            : std_logic_vector( 5 downto 0) := "000001"; 
    constant PrSv_TcpRxS1CR_LISTEN_c          : std_logic_vector( 5 downto 0) := "000010"; 
    constant PrSv_TcpRxS1SSR_c         		 : std_logic_vector( 5 downto 0) := "000011"; 
    constant PrSv_TcpRxS1TCP_c        			 : std_logic_vector( 5 downto 0) := "000100"; 
    constant PrSv_TcpRxStart_c       			 : std_logic_vector( 5 downto 0) := "000101"; 
    constant PrSv_TcpRxS1RxRSR_c         		 : std_logic_vector( 5 downto 0) := "000110"; 
    constant PrSv_TcpRxS1RxRSR2_c        		 : std_logic_vector( 5 downto 0) := "000111"; 
    constant PrSv_TcpRxRSRCnt_c        		 : std_logic_vector( 5 downto 0) := "001000"; 
    constant PrSv_TcpRxHeadCnt_c           	 : std_logic_vector( 5 downto 0) := "001001"; 
    constant PrSv_TcpRxHeadData_c  				 : std_logic_vector( 5 downto 0) := "001010"; 
    constant PrSv_TcpRxData_c      				 : std_logic_vector( 5 downto 0) := "001011"; 
    constant PrSv_TcpRxS1CRRecv_c             : std_logic_vector( 5 downto 0) := "001100"; 
	 constant PrSv_wait_proc_done_c            : std_logic_vector( 5 downto 0) := "001101"; 
    constant PrSv_TcpTxS1wWrsr_c              : std_logic_vector( 5 downto 0) := "001110"; 
    constant PrSv_TcpTxS1wWrsr2_c             : std_logic_vector( 5 downto 0) := "001111"; 
    constant PrSv_TcpTxS1Wfifor_c             : std_logic_vector( 5 downto 0) := "010000"; 
    constant PrSv_TcpS1CRSend_c               : std_logic_vector( 5 downto 0) := "010001"; 
    constant PrSv_TcpRxS1Close_c              : std_logic_vector( 5 downto 0) := "010010"; 
    constant PrSv_TcpRxS1discon_c             : std_logic_vector( 5 downto 0) := "010011"; 


    constant PrSv_UdpTxStart_c          : std_logic_vector( 5 downto 0) := "100010"; -- Config UdpTx State Start
    constant PrSv_UdpTxS0DHAR_c         : std_logic_vector( 5 downto 0) := "100011"; -- Config UdpTx State S0DHAR 
    constant PrSv_UdpTxS0DHAR2_c        : std_logic_vector( 5 downto 0) := "100100"; -- Config UdpTx State S0DHAR2  
    constant PrSv_UdpTxS0DHAR4_c        : std_logic_vector( 5 downto 0) := "100101"; -- Config UdpTx State S0DHAR4
    constant PrSv_UdpTxS0DPortR_c       : std_logic_vector( 5 downto 0) := "100110"; -- Config UdpTx State S0DPortR 
    constant PrSv_UdpTxS0DIPR_c         : std_logic_vector( 5 downto 0) := "100111"; -- Config UdpTx State S0DIPR 
    constant PrSv_UdpTxS0DIPR2_c        : std_logic_vector( 5 downto 0) := "101000"; -- Config UdpTx State S0DIPR2 
    constant PrSv_UdpTxFstSend_c        : std_logic_vector( 5 downto 0) := "101001"; -- Config UdpTx State First_Send 
    constant PrSv_UdpTxFSR_c            : std_logic_vector( 5 downto 0) := "101010"; -- Config UdpTx State Read_Tx_FSR
    constant PrSv_UdpTxFSR2_c           : std_logic_vector( 5 downto 0) := "101011"; -- Config UdpTx State Read_Tx_FSR2 
    constant PrSv_UdpCmpTxFSR_c         : std_logic_vector( 5 downto 0) := "101100"; -- Config UdpTx State Compare_TxFSR_Blank 
    constant PrSv_UdpTxRdFifo_c         : std_logic_vector( 5 downto 0) := "101101"; -- Config UdpTx State RdFifo_Data
    constant PrSv_UdpTxRecvData_c       : std_logic_vector( 5 downto 0) := "101110"; -- Config UdpTx State Recv Data
    constant PrSv_UdpTxFifo_c           : std_logic_vector( 5 downto 0) := "101111"; -- Config UdpTx State W5300_TxFifo_High16_bits 
    constant PrSv_UdpTxFifo2_c          : std_logic_vector( 5 downto 0) := "110000"; -- Config UdpTx State W5300_TxFifo_Low16_bits 
    constant PrSv_UdpTxPackageNum_c     : std_logic_vector( 5 downto 0) := "110001"; -- Config UdpTx State PackageNum  
    constant PrSv_UdpTxWRSR_c           : std_logic_vector( 5 downto 0) := "110010"; -- Config UdpTx State WRSR 
    constant PrSv_UdpTxWRSR2_c          : std_logic_vector( 5 downto 0) := "110011"; -- Config UdpTx State WRSR2 
    constant PrSv_UdpTxS0CRSend_c       : std_logic_vector( 5 downto 0) := "110100"; -- Config UdpTx State S0_CR_Send 
    constant PrSv_UdpTxRdS0IR_c         : std_logic_vector( 5 downto 0) := "110101"; -- Config UdpTx State Rd_S0IR
    constant PrSv_UdpTxClrS0IR_c        : std_logic_vector( 5 downto 0) := "110110"; -- Config UdpTx State Clear_S0IR  
    constant PrSv_UdpTxSendOk_c         : std_logic_vector( 5 downto 0) := "110111"; -- Config UdpTx State S0_SendOk
    constant PrSv_UdpTxPackageCnt_c     : std_logic_vector( 5 downto 0) := "111000"; -- Config UdpTx State PackageCnt
    constant PrSv_UdpTxPackageEnd_c     : std_logic_vector( 5 downto 0) := "111001"; -- Config UdpTx State Package_End
    constant PrSv_UdpTxStopTrig_c       : std_logic_vector( 5 downto 0) := "111010"; -- Config UdpTx State StopTrig
    constant PrSv_UdpTxS0SendClose_c    : std_logic_vector( 5 downto 0) := "111011"; -- Config UdpTx State S0SendClose
    constant PrSv_UdpTxStop_c           : std_logic_vector( 5 downto 0) := "111100"; -- Config UdpTx State Stop
    constant PrSv_UdpTxWait_c           : std_logic_vector( 5 downto 0) := "111101"; -- Config UdpTx Wait Time

    ------------------------------------
    -- PrSv_UdpRxState_s
    ------------------------------------
--    constant PrSv_UdpRxIdle_c           : std_logic_vector( 4 downto 0) := "00000"; -- Config UdpRx State Idle
--    constant PrSv_UdpRxCmd_c            : std_logic_vector( 4 downto 0) := "00001"; -- UdpTx State Read_RxCmd
--    constant PrSv_UdpRxCmpCmd_c         : std_logic_vector( 4 downto 0) := "00010"; -- Config UdpRx State Compare Command
--    constant PrSv_UdpRxStart_c          : std_logic_vector( 4 downto 0) := "00011"; -- Config UdpRx State Start
--    constant PrSv_UdpRxS0RxRSR_c        : std_logic_vector( 4 downto 0) := "00100"; -- UdpRx State Read_S0_Rx_RSR
--    constant PrSv_UdpRxS0RxRSR2_c       : std_logic_vector( 4 downto 0) := "00101"; -- UdpRx State Read_S0_Rx_RSR2
--    constant PrSv_UdpRxRSRCnt_c         : std_logic_vector( 4 downto 0) := "00110"; -- UdpRx State RSRCnt
--    constant PrSv_UdpRxHeadCnt_c        : std_logic_vector( 4 downto 0) := "00111"; -- UdpRx State Read_UDP_Head
--    constant PrSv_UdpRxHeadData_c       : std_logic_vector( 4 downto 0) := "01000"; -- UdpRx State Read_UDP_Data
--    constant PrSv_UdpRxData_c           : std_logic_vector( 4 downto 0) := "01001"; -- UdpRx State Read_Data
--    constant PrSv_UdpRxPackageSizeCnt_c : std_logic_vector( 4 downto 0) := "01010"; -- UdpRx State PackageSize Cnt
--    constant PrSv_UdpRxPackageCnt_c     : std_logic_vector( 4 downto 0) := "01011"; -- UdpRx State Package Cnt
--    constant PrSv_UdpRxEnd_c            : std_logic_vector( 4 downto 0) := "01100"; -- UdpRx State End
--    constant PrSv_UdpRxStop_c           : std_logic_vector( 4 downto 0) := "01101"; -- UdpRx State Stop

end pine_basic;