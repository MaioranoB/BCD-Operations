library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity somaBCD is
port (a,b : in  std_logic_vector(15 downto 0); --2 numeros de ate 4 algarismos (4*4 = 16bits)
		sum : out std_logic_vector(19 downto 0) --maior resultado possivel: 9999+9999 = 19.998 (5*4 = 20bits)
);
end somaBCD;

architecture structure of somaBCD is
	
	type BCDarray  is array (3 downto 0) of std_logic_vector(3 downto 0);

	signal arrayA   : BCDarray := (a(15 downto 12),a(11 downto 8),a(7 downto 4),a(3 downto 0));
	signal arrayB   : BCDarray := (b(15 downto 12),b(11 downto 8),b(7 downto 4),b(3 downto 0));
	signal arraySUM : BCDarray;
	
	signal c_aux1,c_aux2,c_aux3,c_aux4 : std_logic; --cary's das somas parciais
	
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
	
	sum <= ("000" & c_aux4) & arraySUM(3) & arraySUM(2) & arraySUM(1) & arraySUM(0);
end structure;
