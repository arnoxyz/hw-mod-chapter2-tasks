library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr_tb is
end entity;

architecture tb of lfsr_tb is
	signal clk, res_n : std_ulogic := '0';
	signal stop_clk : std_logic := '0';
	constant clk_period : time := 20 ns; --20ns = 50 MHz

	--Meaning of Max_poly?
	constant MAX_POLY_8  : std_ulogic_vector(7 downto 0)  := "10111000";
	constant POLY_8      : std_ulogic_vector(7 downto 0)  := "10100100";
	constant MAX_POLY_16 : std_ulogic_vector(15 downto 0) := "1101000000001000";
	constant POLY_16     : std_ulogic_vector(15 downto 0) := "1101001100001000";

	-- Change as required
	constant POLYNOMIAL : std_ulogic_vector := "0011"; --MAX_POLY_16;
	constant LFSR_WIDTH : integer := POLYNOMIAL'LENGTH;

	signal load_seed_n : std_ulogic;
	signal seed: std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');


	--en? signals
	--signal en : std_ulogic;
	--seq? signals
	--signal seq     : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');

	signal prdata : std_ulogic;
begin

	stimulus : process is
	begin
		-- Reset your module and apply stimuli
		res_n <= '0';
		wait for 5*clk_period;
		seed <= "0001"; 
		load_seed_n <= '1';


		res_n <= '1';
		wait until rising_edge(clk);
		
		--apply seed
		load_seed_n <= '0';
		wait for clk_period;
		wait for clk_period;
		load_seed_n <= '1';
		wait until rising_edge(clk);

		wait for 15*clk_period;
		stop_clk <= '1';
		wait;
	end process;

	uut : entity work.lfsr
	generic map (
		LFSR_WIDTH => LFSR_WIDTH,
		POLYNOMIAL => POLYNOMIAL
	)
	port map (
		clk => clk,
		res_n => res_n,
		load_seed_n => load_seed_n,
		seed => seed,
		prdata => prdata
	);

	clk_gen : process is
	begin
		-- generate a 50MHz clock signal
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		if stop_clk = '1' then 
			wait;
		end if;
	end process;
end architecture;
