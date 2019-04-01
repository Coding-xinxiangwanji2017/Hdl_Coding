library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vector_integer is
port(
	VECTOR_SIG		:	IN STD_LOGIC_VECTOR(6 DOWNTO 0);
	INTEGER_SIG		:	OUT integer range 0 to 95

);

end vector_integer;
architecture bev of vector_integer is
signal				INTEGER_SIG_i	:	integer range 0 to 95;
begin

	INTEGER_SIG	<= 95-INTEGER_SIG_i;
	process(VECTOR_SIG)
	begin
		case VECTOR_SIG is
			when	"0000000"	=>	INTEGER_SIG_i	<= 0;
			when	"0000001"	=>	INTEGER_SIG_i	<= 1;
			when	"0000010"	=>	INTEGER_SIG_i	<= 2;
			when	"0000011"	=>	INTEGER_SIG_i	<= 3;
			when	"0000100"	=>	INTEGER_SIG_i	<= 4;
			when	"0000101"	=>	INTEGER_SIG_i	<= 5;
			when	"0000110"	=>	INTEGER_SIG_i	<= 6;
			when	"0000111"	=>	INTEGER_SIG_i	<= 7;
			when	"0001000"	=>	INTEGER_SIG_i	<= 8;
			when	"0001001"	=>	INTEGER_SIG_i	<= 9;
			when	"0001010"	=>	INTEGER_SIG_i	<= 10;
			when	"0001011"	=>	INTEGER_SIG_i	<= 11;
			when	"0001100"	=>	INTEGER_SIG_i	<= 12;
			when	"0001101"	=>	INTEGER_SIG_i	<= 13;
			when	"0001110"	=>	INTEGER_SIG_i	<= 14;
			when	"0001111"	=>	INTEGER_SIG_i	<= 15;
			
			when	"0010000"	=>	INTEGER_SIG_i	<= 16;
			when	"0010001"	=>	INTEGER_SIG_i	<= 17;
			when	"0010010"	=>	INTEGER_SIG_i	<= 18;
			when	"0010011"	=>	INTEGER_SIG_i	<= 19;
			when	"0010100"	=>	INTEGER_SIG_i	<= 20;
			when	"0010101"	=>	INTEGER_SIG_i	<= 21;
			when	"0010110"	=>	INTEGER_SIG_i	<= 22;
			when	"0010111"	=>	INTEGER_SIG_i	<= 23;
			when	"0011000"	=>	INTEGER_SIG_i	<= 24;
			when	"0011001"	=>	INTEGER_SIG_i	<= 25;
			when	"0011010"	=>	INTEGER_SIG_i	<= 26;
			when	"0011011"	=>	INTEGER_SIG_i	<= 27;
			when	"0011100"	=>	INTEGER_SIG_i	<= 28;
			when	"0011101"	=>	INTEGER_SIG_i	<= 29;
			when	"0011110"	=>	INTEGER_SIG_i	<= 30;
			when	"0011111"	=>	INTEGER_SIG_i	<= 31;
			
			when	"0100000"	=>	INTEGER_SIG_i	<= 32;
			when	"0100001"	=>	INTEGER_SIG_i	<= 33;
			when	"0100010"	=>	INTEGER_SIG_i	<= 34;
			when	"0100011"	=>	INTEGER_SIG_i	<= 35;
			when	"0100100"	=>	INTEGER_SIG_i	<= 36;
			when	"0100101"	=>	INTEGER_SIG_i	<= 37;
			when	"0100110"	=>	INTEGER_SIG_i	<= 38;
			when	"0100111"	=>	INTEGER_SIG_i	<= 39;
			when	"0101000"	=>	INTEGER_SIG_i	<= 40;
			when	"0101001"	=>	INTEGER_SIG_i	<= 41;
			when	"0101010"	=>	INTEGER_SIG_i	<= 42;
			when	"0101011"	=>	INTEGER_SIG_i	<= 43;
			when	"0101100"	=>	INTEGER_SIG_i	<= 44;
			when	"0101101"	=>	INTEGER_SIG_i	<= 45;
			when	"0101110"	=>	INTEGER_SIG_i	<= 46;
			when	"0101111"	=>	INTEGER_SIG_i	<= 47;
			
			when	"0110000"	=>	INTEGER_SIG_i	<= 48;
			when	"0110001"	=>	INTEGER_SIG_i	<= 49;
			when	"0110010"	=>	INTEGER_SIG_i	<= 50;
			when	"0110011"	=>	INTEGER_SIG_i	<= 51;
			when	"0110100"	=>	INTEGER_SIG_i	<= 52;
			when	"0110101"	=>	INTEGER_SIG_i	<= 53;
			when	"0110110"	=>	INTEGER_SIG_i	<= 54;
			when	"0110111"	=>	INTEGER_SIG_i	<= 55;
			when	"0111000"	=>	INTEGER_SIG_i	<= 56;
			when	"0111001"	=>	INTEGER_SIG_i	<= 57;
			when	"0111010"	=>	INTEGER_SIG_i	<= 58;
			when	"0111011"	=>	INTEGER_SIG_i	<= 59;
			when	"0111100"	=>	INTEGER_SIG_i	<= 60;
			when	"0111101"	=>	INTEGER_SIG_i	<= 61;
			when	"0111110"	=>	INTEGER_SIG_i	<= 62;
			when	"0111111"	=>	INTEGER_SIG_i	<= 63;
			
			when	"1000000"	=>	INTEGER_SIG_i	<= 64;
			when	"1000001"	=>	INTEGER_SIG_i	<= 65;
			when	"1000010"	=>	INTEGER_SIG_i	<= 66;
			when	"1000011"	=>	INTEGER_SIG_i	<= 67;
			when	"1000100"	=>	INTEGER_SIG_i	<= 68;
			when	"1000101"	=>	INTEGER_SIG_i	<= 69;
			when	"1000110"	=>	INTEGER_SIG_i	<= 70;
			when	"1000111"	=>	INTEGER_SIG_i	<= 71;
			when	"1001000"	=>	INTEGER_SIG_i	<= 72;
			when	"1001001"	=>	INTEGER_SIG_i	<= 73;
			when	"1001010"	=>	INTEGER_SIG_i	<= 74;
			when	"1001011"	=>	INTEGER_SIG_i	<= 75;
			when	"1001100"	=>	INTEGER_SIG_i	<= 76;
			when	"1001101"	=>	INTEGER_SIG_i	<= 77;
			when	"1001110"	=>	INTEGER_SIG_i	<= 78;
			when	"1001111"	=>	INTEGER_SIG_i	<= 79;
			
			when	"1010000"	=>	INTEGER_SIG_i	<= 80;
			when	"1010001"	=>	INTEGER_SIG_i	<= 81;
			when	"1010010"	=>	INTEGER_SIG_i	<= 82;
			when	"1010011"	=>	INTEGER_SIG_i	<= 83;
			when	"1010100"	=>	INTEGER_SIG_i	<= 84;
			when	"1010101"	=>	INTEGER_SIG_i	<= 85;
			when	"1010110"	=>	INTEGER_SIG_i	<= 86;
			when	"1010111"	=>	INTEGER_SIG_i	<= 87;
			when	"1011000"	=>	INTEGER_SIG_i	<= 88;
			when	"1011001"	=>	INTEGER_SIG_i	<= 89;
			when	"1011010"	=>	INTEGER_SIG_i	<= 90;
			when	"1011011"	=>	INTEGER_SIG_i	<= 91;
			when	"1011100"	=>	INTEGER_SIG_i	<= 92;
			when	"1011101"	=>	INTEGER_SIG_i	<= 93;
			when	"1011110"	=>	INTEGER_SIG_i	<= 94;
			when	"1011111"	=>	INTEGER_SIG_i	<= 95;
			
--			when	"1100000"	=>	INTEGER_SIG_i	<= 96;
--			when	"1100001"	=>	INTEGER_SIG_i	<= 97;
--			when	"1100010"	=>	INTEGER_SIG_i	<= 98;
--			when	"1100011"	=>	INTEGER_SIG_i	<= 99;
--			when	"1100100"	=>	INTEGER_SIG_i	<= 100;
--			when	"1100101"	=>	INTEGER_SIG_i	<= 101;
--			when	"1100110"	=>	INTEGER_SIG_i	<= 102;
--			when	"1100111"	=>	INTEGER_SIG_i	<= 103;
--			when	"1101000"	=>	INTEGER_SIG_i	<= 104;
--			when	"1101001"	=>	INTEGER_SIG_i	<= 105;
--			when	"1101010"	=>	INTEGER_SIG_i	<= 106;
--			when	"1101011"	=>	INTEGER_SIG_i	<= 107;
--			when	"1101100"	=>	INTEGER_SIG_i	<= 108;
--			when	"1101101"	=>	INTEGER_SIG_i	<= 109;
--			when	"1101110"	=>	INTEGER_SIG_i	<= 110;
--			when	"1101111"	=>	INTEGER_SIG_i	<= 111;
--			
--			when	"1110000"	=>	INTEGER_SIG_i	<= 112;
--			when	"1110001"	=>	INTEGER_SIG_i	<= 113;
--			when	"1110010"	=>	INTEGER_SIG_i	<= 114;
--			when	"1110011"	=>	INTEGER_SIG_i	<= 115;
--			when	"1110100"	=>	INTEGER_SIG_i	<= 116;
--			when	"1110101"	=>	INTEGER_SIG_i	<= 117;
--			when	"1110110"	=>	INTEGER_SIG_i	<= 118;
--			when	"1110111"	=>	INTEGER_SIG_i	<= 119;
--			when	"1111000"	=>	INTEGER_SIG_i	<= 120;
--			when	"1111001"	=>	INTEGER_SIG_i	<= 121;
--			when	"1111010"	=>	INTEGER_SIG_i	<= 122;
--			when	"1111011"	=>	INTEGER_SIG_i	<= 123;
--			when	"1111100"	=>	INTEGER_SIG	<= 124;
--			when	"1111101"	=>	INTEGER_SIG	<= 125;
--			when	"1111110"	=>	INTEGER_SIG	<= 126;
--			when	"1111111"	=>	INTEGER_SIG	<= 127;
			
			when	 others		=> INTEGER_SIG_i	<= 0;
		end case;
	end process;

end bev;