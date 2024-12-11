library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity simple_dp_ram_tb is
end entity;


architecture tb of simple_dp_ram_tb is
	constant ADDR_WIDTH : natural := 4;
	constant DATA_WIDTH : natural := 2;

	--clk stuff
	constant CLK_PERIOD : TIME := 20 ns;
	signal clk, res_n, clk_stop : std_ulogic := '0';

	--tb signals (in)
	signal rd_addr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0) := (others=>'0');
	signal wr_addr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0) := (others=>'0');
	signal wr_data : std_ulogic_vector(DATA_WIDTH - 1 downto 0) := (others=>'0');
	signal wr_en     : std_ulogic := '0';

	--tb signals (out)
	signal rd_data : std_ulogic_vector(DATA_WIDTH - 1 downto 0);


begin
	-- Instantiate the unit under test
	UUT : entity work.simple_dp_ram(beh)
		generic map(
			ADDR_WIDTH => ADDR_WIDTH,
			DATA_WIDTH => DATA_WIDTH
		)	
		port map(
			clk    => clk,
			res_n  => res_n,
			rd_addr => rd_addr,
			rd_data => rd_data,
			wr_en => wr_en,
			wr_addr => wr_addr,
			wr_data => wr_data
		);

	-- Implementation with a reset
	/*
	UUT2_RESET : entity work.simple_dp_ram(beh_reset)
		generic map(
			addr_width => ADDR_WIDTH,
			data_width => DATA_WIDTH
		)	
		port map(
			clk    => clk,
			res_n  => res_n,
			rd_addr => rd_addr,
			rd_data => rd_data,
			wr_en => wr_en,
			wr_addr => wr_addr,
			wr_data => wr_data
		);
	*/

	-- Stimulus process to handle file I/O and write to RAM
	stimulus : process
	begin
		res_n <= '0';
		wait for 10 ns;
		--start reading from File 
		-- End simulation
		std.env.stop;
	end process;



	clock_gen : process
	begin 
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
		if(clk_stop = '1') then 
			wait;
		end if;
	end process;
end architecture;