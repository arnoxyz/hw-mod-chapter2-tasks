
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
begin

	--clk process with async low-active reset
	sync : process(clk, res_n) 
	begin 
		if res_n='0' then
			--reset all registers
			local_op1 <= (others=>'0');			
			local_op2 <= (others=>'0');			
		else 
			if rising_edge(clk) then 
				--read new data logic
				if store_operand1='1' then 
					local_op1 <= operand_data_in;
				end if;

				if store_operand2 ='1' then 
					local_op2 <= operand_data_in;
				end if;

				--calc and output logic
				operand1 <= local_op1;
				operand2 <= local_op2;

				if sub='1' then 
					result <= std_logic_vector(unsigned(local_op1) - unsigned(local_op2));
				else 
					result <= std_logic_vector(unsigned(local_op1) + unsigned(local_op2));
				end if;
			end if;
		end if;
	end process;
end architecture;