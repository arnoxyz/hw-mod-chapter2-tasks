library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

architecture top_arch_simplecalc of top is
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

	constant DATA_WIDTH : natural := 8;
	signal local_operand1_output : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal local_operand2_output : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal local_result_output   : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	
begin

	simplecalc_init : simplecalc
	generic map(DATA_WIDTH => DATA_WIDTH)
	port map(
			clk    => clk,
			operand_data_in => switches(7 downto 0),
			sub => switches(17),
			res_n  => keys(0),
			store_operand1 => keys(1),
			store_operand2 => keys(2),
			operand1 => local_operand1_output,
			operand2 => local_operand2_output,
			result   => local_result_output
	);

	--Display operand1,operand2 and result with ssd
	hex7 <= to_segs(local_operand1_output(7 downto 4));
	hex6 <= to_segs(local_operand1_output(3 downto 0));

	hex5 <= to_segs(local_operand2_output(7 downto 4));
	hex4 <= to_segs(local_operand2_output(3 downto 0));

	hex3 <= to_segs(local_result_output(7 downto 4));
	hex2 <= to_segs(local_result_output(3 downto 0));

	hex1 <= to_segs("0000");
	hex0 <= to_segs("0000");
end architecture;
