library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multBCD is
port (a,b      : in  std_logic_vector(15 downto 0); --2 numeros de ate 4 algarismos (4*4 = 16bits)
		mult      : out std_logic_vector(31 downto 0) --maior resultado possivel: 9999*9999 = 99.980.001 (8*4 = 32bits)
);
end multBCD;

architecture structure of multBCD is



end structure;