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
	signal y : std_ulogic_vector(LFSR_WIDTH-1 downto 0);
begin
	--4 bit linear feedback register
    process(clk, res_n) is 
    begin 
        if res_n = '0' then 
			--async reset all ff to 0
			x <= (others=>'0');
        elsif rising_edge(clk) then 

			-- special case for x(0) 
				-- generate from polynomial
				--loop through polynomial and xor if entry is '1' and do nothing if entry is '0'
				--Poly wants a cracker = 0011
				--x(0) <= x(3) xor x(2);
				-- for i in POLYNOMIAL'range loop
				-- 	report to_string(i);
				-- 	-- if i = '1' then 
				-- 	-- 	y(i) <= x(i);
				-- 	-- end if;
				-- end loop;

				-- for i in POLYNOMIAL loop
				-- 	if i = '1' then 
				-- 		x(0) <= y(i) xor y(i-1);
				-- 	end if;
				-- end loop;

				x(0) <= x(2) xor x(3);
				--Polynomial "0001"
				--x(0) <= x(3)
			
			-- other cases for x(1) until x(LFSR_WIDTH-1)
				-- generate from LFSR_WIDTH, 
				--	starting with i=1 until LFSR_WIDTH-1
				-- 	x(i) <= x(i-1)
				-- for i in 1 to LFSR_WIDTH-1 loop
				-- 	report to_string(i);
				-- 	x(i) <= x(i-1);
				-- 	-- x(1) <= x(0);
				-- 	-- x(2) <= x(1);
				-- 	-- x(3) <= x(2);
				-- end loop;
				x(0) <= x(1);
				x(1) <= x(0);
				x(2) <= x(1);
				x(3) <= x(2);

			--seed stuff
				--output seed
				if load_seed_n = '1' then 
					prdata <= x(LFSR_WIDTH-1);
				end if;
				-- apply seed 
				if load_seed_n = '0' then 
					x <= seed;
				end if;
        end if;
    end process;
end architecture;
