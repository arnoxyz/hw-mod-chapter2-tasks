library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--some code is from the design guide
--Refer to the design recommendations for inferring RAM functions from HDL Code (Section 1.4.1) for (Intel FPGA) implementation guidelines on memories.
--1.4.1.6. Single-Clock Synchronous RAM with New Data Read-During-Write Behavior


entity simple_dp_ram is
    generic (
        ADDR_WIDTH : natural := 8;
        DATA_WIDTH : natural := 32
    );
    port (
        clk    : in std_ulogic;
        res_n  : in std_ulogic;

        rd_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
        rd_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);

        wr_en     : in std_ulogic;
        wr_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
        wr_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity;


architecture beh of simple_dp_ram is
    TYPE MEM IS ARRAY(0 to ADDR_WIDTH-1) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); 
    SIGNAL ram_block : MEM; 
begin

    PROCESS (clk) 
    --Variable ram_block : MEM;
    BEGIN
            --ram
            IF (rising_edge(clk)) THEN
                IF (wr_en = '1') THEN
                    ram_block(to_integer(unsigned(wr_addr))) <= wr_data;
                end IF;

            END IF;
    END PROCESS;


    process(all)
    begin
        IF(to_integer(unsigned(rd_addr)) = 0) then
            rd_data <= (others=>'0');
        elsif(wr_addr = rd_addr) then  
            rd_data <= wr_data;
        else 
            rd_data <= ram_block(to_integer(unsigned(rd_addr)));
        end IF;
    end process;


end architecture;


architecture beh_reset of simple_dp_ram is
    TYPE MEM IS ARRAY(0 to ADDR_WIDTH-1) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); 
    SIGNAL ram_block : MEM; 
begin

    PROCESS (clk, res_n) 
    BEGIN
        IF(res_n = '0') then 
            --loop res_n adresses
            ram_block <= (others => (others => '0'));
            /*
            FOR idx in ram_block'Range loop
                ram_block(idx) <= (others=>'0');
            end Loop;
            */

        else
            IF (rising_edge(clk)) THEN
                IF (wr_en = '1') THEN
                    ram_block(to_integer(unsigned(wr_addr))) <= wr_data;
                end IF;

            END IF;
        end IF;
    END PROCESS;


    process(all)
    begin
        IF(to_integer(unsigned(rd_addr)) = 0) then
            rd_data <= (others=>'0');
        elsif(wr_addr = rd_addr) then  
            rd_data <= wr_data;
        else 
            rd_data <= ram_block(to_integer(unsigned(rd_addr)));
        end IF;
    end process;
end architecture;