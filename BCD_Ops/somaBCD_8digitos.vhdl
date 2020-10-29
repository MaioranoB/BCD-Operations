library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity somaBCD_8digitos is
port (a,b : in  std_logic_vector(31 downto 0);
		sum : out std_logic_vector(31 downto 0) --maior resultado possivel: 9999*9999 = 99980001
);
end somaBCD_8digitos;

architecture structure of somaBCD_8digitos is
	
	type BCDarray  is array (7 downto 0) of std_logic_vector(3 downto 0);

	signal arrayA   : BCDarray := (a(31 downto 28), a(27 downto 24), a(23 downto 20), a(19 downto 16), a(15 downto 12),a(11 downto 8),a(7 downto 4),a(3 downto 0));
	signal arrayB   : BCDarray := (b(31 downto 28), b(27 downto 24), b(23 downto 20), b(19 downto 16), b(15 downto 12),b(11 downto 8),b(7 downto 4),b(3 downto 0));
	signal arraySUM : BCDarray;
	
	signal c_aux1,c_aux2,c_aux3,c_aux4, c_aux5, c_aux6, c_aux7, c_aux8 : std_logic; --cary's das somas parciais
	
	component somaBCD_1digito
		port (a,b      : in  std_logic_vector(3 downto 0);
				sum      : out std_logic_vector(3 downto 0);
				carryIN  : in  std_logic;
				carryOUT : out std_logic
		);
	end component;
	
	begin
	S0:somaBCD_1digito port map(arrayA(0), arrayB(0), arraySUM(0), '0', c_aux1);
	S1:somaBCD_1digito port map(arrayA(1), arrayB(1), arraySUM(1), c_aux1, c_aux2);
	S2:somaBCD_1digito port map(arrayA(2), arrayB(2), arraySUM(2), c_aux2, c_aux3);
	S3:somaBCD_1digito port map(arrayA(3), arrayB(3), arraySUM(3), c_aux3, c_aux4);
	S4:somaBCD_1digito port map(arrayA(4), arrayB(4), arraySUM(4), c_aux4, c_aux5);
	S5:somaBCD_1digito port map(arrayA(5), arrayB(5), arraySUM(5), c_aux5, c_aux6);
	S6:somaBCD_1digito port map(arrayA(6), arrayB(6), arraySUM(6), c_aux6, c_aux7);
	S7:somaBCD_1digito port map(arrayA(7), arrayB(7), arraySUM(7), c_aux7, c_aux8);
	
	sum <= arraySUM(7) & arraySUM(6) & arraySUM(5) & arraySUM(4) & arraySUM(3) & arraySUM(2) & arraySUM(1) & arraySUM(0);
end structure;