
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simplecalc is
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
end entity;

architecture arch of simplecalc is
	signal local_op1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal local_op2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);

	signal local_store_operand1_n : std_ulogic;
	signal local_store_operand2_n : std_ulogic;
begin

	--clk process with async low-active reset
	sync : process(clk, res_n) 
	begin 
		if res_n='0' then
			--reset all registers
			local_op1 <= (others=>'0');			
			local_op2 <= (others=>'0');			
			local_store_operand1_n <= '1';
			local_store_operand2_n <= '1';
		else 
			if rising_edge(clk) then 
				--read new data logic

				--detect operand1 transition
				--active-low signal so btn is pressed when last entry is 1 and current is 0 
				if local_store_operand1_n='1' and store_operand1='0' then 
					local_op1 <= operand_data_in;
				end if;

				--same for operand2 transition
				if local_store_operand2_n='1' and store_operand2='0' then 
					local_op1 <= operand_data_in;
				end if;

				--store the operand information 
				local_store_operand1_n <= store_operand1;
				local_store_operand2_n <= store_operand2;

				--calc and output logic
				operand1 <= local_op1;
				operand2 <= local_op2;

				if sub='1' then 
					result <= std_ulogic_vector(unsigned(local_op1) - unsigned(local_op2));
				else 
					result <= std_ulogic_vector(unsigned(local_op1) + unsigned(local_op2));
				end if;
			end if;
		end if;
	end process;
end architecture;