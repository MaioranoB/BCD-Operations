library ieee;
use ieee.std_logic_1164.all;

entity interface is
port (clk,reset,botaoA,botaoB : in std_logic;
		operacao: in std_logic;
		entradaA, entradaB: in  std_logic_vector (15 downto 0); -- switches
		resultadoDISPLAY  : out std_logic_vector(31 downto 0)
);
end interface;

architecture behav of interface is

	component somaBCD
		port (a,b      : in  std_logic_vector(15 downto 0);
				sum      : out std_logic_vector(19 downto 0)
		);
	end component;
	
	component multBCD
		port (a,b      : in  std_logic_vector(15 downto 0);
				clk 		: in std_logic;
				start		: in std_logic;
				mult     : out std_logic_vector(31 downto 0)
		);
	end component;
		
	signal A, B  : std_logic_vector(15 downto 0) := "0000000000000000";
	signal sum_result: std_logic_vector(19 downto 0);
	signal mult_result: std_logic_vector(31 downto 0);
	signal start_mult: std_logic := '0';
	
	type tipo_estado is (escolhendoA,escolhendoB, saida);
	signal estado : tipo_estado := escolhendoA;
	
begin
	sum: somaBCD port map (A, B, sum_result);
	mult: multBCD port map (A, B, clk, start_mult, mult_result);
	
	process(reset, botaoA, botaoB, operacao)
		begin
			if (reset = '0') then
				estado <= escolhendoA;
				A <= "0000000000000000";
				B <= "0000000000000000";
				resultadoDISPLAY <= A & B;
				start_mult <= '0';
			elsif (estado = escolhendoA and botaoA = '1') then --definindo A
				start_mult <= '0';
				resultadoDISPLAY <= ("0000000000000000" & entradaA);
				estado <= escolhendoA;
			elsif (estado = escolhendoA and botaoA = '0') then --A selecionado
				A <= entradaA;
				estado <= escolhendoB;
			elsif (estado = escolhendoB and botaoB = '1') then --definindo B
				resultadoDISPLAY <= (A & entradaB);
				estado <= escolhendoB;
			elsif (estado = escolhendoB and botaoB = '0') then --B selecionado
				B <= entradaB;
				estado <= saida;
				start_mult <= '1';
			elsif (estado = saida) then
				
					if operacao = '0' then
						resultadoDISPLAY <= "000000000000" & sum_result;
					else
						resultadoDISPLAY <= mult_result;
					end if;	
			end if;
	end process;
end behav;