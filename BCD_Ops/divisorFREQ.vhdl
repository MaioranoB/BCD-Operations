library ieee;
use ieee.std_logic_1164.all;

--clock da placa tem freq 50Mhz
--1seg: dividir o clk por 5*10^7 (49999999 na vdd)

entity divisorFREQ is
port (clk	: in std_logic;
		reset	: in std_logic;
		saida : out std_logic
);
end divisorFREQ;

architecture behav of divisorFREQ is

	signal saida_aux : std_logic;
	signal contador  : integer range 0 to 49999999 := 0;
	
begin
	div_freq : process(clk,reset) begin
	
		if reset = '0' then -- '0' indica que esta apertando o botao na placa!!
			saida_aux <= '0';
			contador <= 0;
			
		elsif rising_edge(clk) then
			if contador = 49999999 then--49999999 then
				contador <= 0;
				saida_aux <= not saida_aux; --inverte o valor anterior
			else	
				contador <= contador + 1;
			end if;
		end if;
	end process;
	
saida <= saida_aux;
end behav;