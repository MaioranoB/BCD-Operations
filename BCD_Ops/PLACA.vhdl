library ieee;
use ieee.std_logic_1164.all;

entity PLACA is
port (CLOCK_50 : in std_logic; 
		V_BT     : in std_logic_vector(2 downto 0); --V_BT(0)=reset V_BT(1)=botaoA V_BT(2)=botaoB
		V_SW  : in  std_logic_vector(17 downto 0); --switches
		G_HEX7: out std_logic_vector(6 downto 0); -- A digito1
		G_HEX6: out std_logic_vector(6 downto 0); -- A digito2
		G_HEX5: out std_logic_vector(6 downto 0); -- A digito3
		G_HEX4: out std_logic_vector(6 downto 0); -- A digito4
		G_HEX3: out std_logic_vector(6 downto 0); -- B digito1
		G_HEX2: out std_logic_vector(6 downto 0); -- B digito2
		G_HEX1: out std_logic_vector(6 downto 0); -- B digito3
		G_HEX0: out std_logic_vector(6 downto 0); -- B digito4
		G_LEDR: out std_logic_vector(1 downto 0)   --redLED mostra o estado da maquina
);
end PLACA;

architecture behav of PLACA is

	component interface
		port (clk,reset,botaoA,botaoB : in std_logic;
				operacao: in std_logic;
				entradaA, entradaB: in  std_logic_vector (15 downto 0);
				saidaA,saidaB     : out std_logic_vector (15 downto 0);
				resultadoDISPLAY  : out std_logic_vector(31 downto 0);
				estadoLED         : out std_logic_vector(1 downto 0)
		);
	end component;
	
	component decodificadorBCD7seg
		port (data_in  :in std_logic_vector (3 downto 0); --V_SW   : in std_logic_vector(3 downto 0);
				data_out :out std_logic_vector (6 downto 0) --G_HEX0 : out std_logic_vector(6 downto 0)
		);
	end component;

	component divisorFREQ
		port (clk	: in std_logic;
				reset	: in std_logic;
				saida : out std_logic
		);
	end component;
		
	signal clk1seg  : std_logic;
	
	signal resultado:std_logic_vector(31 downto 0);
	signal displayA : std_logic_vector(15 downto 0);
	signal displayB : std_logic_vector(15 downto 0);
	
begin

	DIVfreq: divisorFREQ port map (CLOCK_50,V_BT(0),clk1seg);
	
	ITERF  : interface port map (clk1seg,V_BT(0),V_BT(1),V_BT(2), -- chaveSEL V_SW(17)
										  V_SW(17), --operacao
										  V_SW(15 downto 0),V_SW(15 downto 0), --A,B
										  displayA,displayB,resultado, --displayAeb nao tao servindo pra nd
										  G_LEDR);
										  
	DECOD0 : decodificadorBCD7seg port map (resultado(3 downto 0), G_HEX0); --A --desse jeito sempre que mudar o sw, vai mudar os valores de AeB mas nao muda o resultado da ULA ate apertar o botao de sel
	DECOD1 : decodificadorBCD7seg port map (resultado(7 downto 4), G_HEX1);
	DECOD2 : decodificadorBCD7seg port map (resultado(11 downto 8), G_HEX2);
	DECOD3 : decodificadorBCD7seg port map (resultado(15 downto 12), G_HEX3);
	DECOD4 : decodificadorBCD7seg port map (resultado(19 downto 16), G_HEX4);
	DECOD5 : decodificadorBCD7seg port map (resultado(23 downto 20), G_HEX5);
	DECOD6 : decodificadorBCD7seg port map (resultado(27 downto 24), G_HEX6);
	DECOD7 : decodificadorBCD7seg port map (resultado(31 downto 28), G_HEX7);
end behav;