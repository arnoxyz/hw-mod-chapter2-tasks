library ieee;
use ieee.std_logic_1164.all;

entity lfsr is
	generic (
		LFSR_WIDTH : integer;
		POLYNOMIAL : std_ulogic_vector
	);
	port (
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		load_seed_n : in std_ulogic;
		seed        : in std_ulogic_vector(LFSR_WIDTH-1 downto 0);
		prdata      : out std_ulogic
	);
end entity;

architecture arch of lfsr is
	-- Add signals as required
	signal x : std_ulogic_vector(LFSR_WIDTH-1 downto 0);
begin
	--4 bit linear feedback register
    process(clk, res_n) is 
	variable help : std_ulogic := '0';
    begin 
        if res_n = '0' then 
			x <= (others=>'0'); --async reset all ff to 0
        elsif rising_edge(clk) then 
			-- special case for x(0) 
			for i in 0 to LFSR_WIDTH-1  loop
				if POLYNOMIAL(i) = '1' then
					help := help xor x(i);
				end if;
			end loop;
			x(0) <= help;
			
			--shift register
			for i in 1 to LFSR_WIDTH-1 loop 
				x(i) <= x(i-1);
			end loop;

			--setting seed
			if load_seed_n = '1' then 
			 	prdata <= x(LFSR_WIDTH-1); 
			else 
		 		x <= seed;
			end if;
        end if;
    end process;
end architecture;
