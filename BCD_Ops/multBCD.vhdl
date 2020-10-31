library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multBCD is
port (a,b        : in  std_logic_vector(15 downto 0); --2 numeros de ate 4 algarismos (4*4 = 16bits)
		clk, start : in std_logic;
		mult       : out std_logic_vector(31 downto 0) --maior resultado possivel: 9999*9999 = 99.980.001 (8*4 = 32bits)
);
end multBCD;

architecture structure of multBCD is
	component somaBCD_8digitos
		port (a,b      : in  std_logic_vector(31 downto 0);
				sum      : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component somaBCD
		port (a,b : in std_logic_vector(15 downto 0);
				sum : out std_logic_vector(19 downto 0)
		);
	end component;
	
	type tipo_estado is (calculando, esperando);
	signal estado : tipo_estado := esperando;
	
	signal counter : std_logic_vector(15 downto 0);
	signal counter_res : std_logic_vector(19 downto 0);
	signal A8dig : std_logic_vector(31 downto 0);
	signal aux_mult : std_logic_vector(31 downto 0);
	signal aux_res : std_logic_vector(31 downto 0);

begin
	aux_sum: somaBCD_8digitos port map (aux_mult, A8dig, aux_res);
	aux_counter: somaBCD port map (counter, "0000000000000001", counter_res);
	
	process(clk)
		begin
		if rising_edge(clk) then
			if (start = '0') then
				A8dig <= "0000000000000000" & a;
				aux_mult <= "00000000000000000000000000000000";
				counter <= "0000000000000000";
				estado <= calculando;
			elsif (estado = calculando and counter = b) then
				mult <= aux_mult;
				estado <= esperando;
			elsif (estado = calculando) then
				aux_mult <= aux_res;
				counter <= counter_res(15 downto 0);
			end if;
		end if;
	end process;		
end structure;
