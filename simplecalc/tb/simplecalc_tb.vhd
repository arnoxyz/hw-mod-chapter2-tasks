library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity simplecalc_tb is
end entity;

architecture bench of simplecalc_tb is
	constant DATA_WIDTH : natural := 8;	

	--clock stuff
	constant clk_period : time := 2 ns; --50 ns =same as the fpga board clk
	signal clk : std_ulogic := '0';
	signal clk_stop : std_ulogic := '0';

	--in signals
	signal res_n  			: std_ulogic;
	signal operand_data_in : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal store_operand1  : std_ulogic;
	signal store_operand2  : std_ulogic;
	signal sub 			: std_ulogic;

	--out signals
	signal operand1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal operand2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal result   : std_ulogic_vector(DATA_WIDTH-1 downto 0);

	--component
	component simplecalc is
		generic (
			DATA_WIDTH : natural := 8
		);
		port(
			clk    : in std_ulogic;
			res_n  : in std_ulogic;

			operand_data_in : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
			store_operand1  : in std_ulogic;
			store_operand2  : in std_ulogic;

			sub : in std_ulogic;

			operand1 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
			operand2 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
			result   : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
		);
	end component;

begin

	-- Instantiate the unit under test
	UUT : simplecalc
	generic map( DATA_WIDTH => DATA_WIDTH)
	port map(
			clk    => clk,
			res_n  => res_n,
			operand_data_in => operand_data_in,
			store_operand1 => store_operand1,
			store_operand2 => store_operand2,
			sub => sub,
			operand1 => operand1,
			operand2 => operand2,
			result   => result
	);

	-- Stimulus process
	stimulus: process
	begin
		report "simulation start";
		--reset
		res_n <= '0';
		wait until rising_edge(clk); 
		wait until rising_edge(clk); 
		wait until rising_edge(clk); 


		--apply inputs
		operand_data_in <= (others=>'0');
		store_operand1 <= '0';
		store_operand2 <= '0';
		sub <= '0';
		wait until rising_edge(clk); 

		--start 
		res_n <= '1';
		wait until rising_edge(clk); 

		--store operand1
		operand_data_in <= (0=>'1',others=>'0');
		store_operand1 <= '1';
		wait until rising_edge(clk); 
		wait until rising_edge(clk); 

		--store operand2
		operand_data_in <= (2=>'1',others=>'0');
		store_operand1 <= '0';
		store_operand2 <= '1';
		wait until rising_edge(clk); 
		wait until rising_edge(clk); 

		--sub operand1 and operand2
		sub <= '1';
		wait until rising_edge(clk); 

		--wait loooong
		wait for 50 ns;

		--assert 1 = 0 report "Test x failed" severity error;

		--stop sim
		clk_stop <= '1';
		report "simulation done";
		-- End simulation
		wait;
	end process;

	-- Gen Clk
	gen_clk : process
	begin 
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		if clk_stop='1' then 
			wait;
		end if;
	end process;
end architecture;