library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity somaBCD_1digito is
port (a,b      : in  std_logic_vector(3 downto 0);
		sum      : out std_logic_vector(3 downto 0);
		carryIN  : in  std_logic;
		carryOUT : out std_logic
);
end somaBCD_1digito;

architecture structure of somaBCD_1digito is
	signal sum_aux : std_logic_vector(4 downto 0);
	signal sum_6 : std_logic_vector(4 downto 0);
begin
	sum_aux <= ('0' & a) + ('0' & b) + ("0000" & carryIN); 
	sum_6 <= sum_aux + "00110";

	sum <= sum_6(3 downto 0) when sum_aux > 9 else sum_aux(3 downto 0);
	carryOUT <= '1' when sum_aux > 9 else '0';
end structure;