library ieee;
use ieee.std_logic_1164.all;

--estadoLED:
--00 entrando A
--01 entrando B
--10 mostrando AeB (com os dois ja selecionados)
--11 operaçao

entity interface is
port (clk,reset,botaoA,botaoB : in std_logic;
		operacao: in std_logic;
		entradaA, entradaB: in  std_logic_vector (15 downto 0); -- switches
		saidaA,saidaB     : out std_logic_vector (15 downto 0);
		resultadoDISPLAY  : out std_logic_vector(31 downto 0);
		estadoLED         : out std_logic_vector(1 downto 0) --
);
end interface;

architecture behav of interface is

	component somaBCD
		port (a,b      : in  std_logic_vector(15 downto 0);
				sum      : out std_logic_vector(19 downto 0)
		);
	end component;
		
	signal A, B  : std_logic_vector(15 downto 0) := "0000000000000000";
	signal sum_result: std_logic_vector(19 downto 0);
	signal mult_result: std_logic_vector(31 downto 0);
	
	type tipo_estado is (escolhendoA,escolhendoB, saida);
	signal estado : tipo_estado := escolhendoA;
	
begin
	sum: somaBCD port map (A, B, sum_result);
	
	-- resultadoDISPLAY <= result;
	--	estadoLED <= estado_aux;
	
	process(reset,botaoA,botaoB,operacao)
		begin
			if (reset = '0') then
				estado <= escolhendoA;
				A <= "0000000000000000";
				B <= "0000000000000000";
				saidaA <= "0000000000000000";
				saidaB <= "0000000000000000";
			elsif (estado = escolhendoA and botaoA = '1') then --definindo A
				resultadoDISPLAY <= ("0000000000000000" & entradaA);
				saidaA <= entradaA;
				estado <= escolhendoA;
			elsif (estado = escolhendoA and botaoA = '0') then --A selecionado
				A <= entradaA;
				estado <= escolhendoB;
			elsif (estado = escolhendoB and botaoB = '1') then --definindo B
				resultadoDISPLAY <= (A & entradaB);
				saidaB <= entradaB;
				estado <= escolhendoB;
			elsif (estado = escolhendoB and botaoB = '0') then --B selecionado
				B <= entradaB;
				estado <= saida;
			elsif (estado = saida) then
				
					if operacao = '0' then
						resultadoDISPLAY <= sum_result;
					else
						resultadoDISPLAY <= mult_result; -- pq caralhas entrando aqui????? entra dps que seleciona o A
					end if;
			--else	
			end if;
	end process;
end behav;