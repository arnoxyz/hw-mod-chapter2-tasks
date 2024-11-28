library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity simplecalc_tb is
end entity;

architecture bench of simplecalc_tb is
	constant DATA_WIDTH : natural := 8;	

	--clock stuff
	constant clk_period : time := 2 ns; --50 ns =same as the fpga board clk
	signal clk 	        : std_ulogic := '0';
	signal clk_stop     : std_ulogic := '0';

	--in signals
	signal res_n  		   : std_ulogic;
	signal operand_data_in : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal store_operand1  : std_ulogic;
	signal store_operand2  : std_ulogic;
	signal sub 			   : std_ulogic;

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


	--enum for valid btns
	type btn_t is (btn_operand1, btn_operand2);

begin

	-- Instantiate the unit under test
	UUT : simplecalc
	generic map(DATA_WIDTH => DATA_WIDTH)
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
		--procedure simulate_btn_press(btn); 
		procedure press_btn(btn : btn_t) is 
		begin 
			case btn is 
				when btn_operand1 => 
					report "btn1_pressed";
					store_operand1 <= '0';
					wait for clk_period*10;
					store_operand1 <= '1';
					wait for clk_period*5;

				when btn_operand2 => 
					report "btn2_pressed";
					store_operand2 <= '0';
					wait for clk_period*20;
					store_operand2 <= '1';
					wait for clk_period*5;

				when others =>  report "invalid input for btn";
			end case;
		end procedure;

		procedure uut_add(input1 : integer; input2 : integer) is 
			constant local_input1_vec : std_ulogic_vector(DATA_WIDTH-1 downto 0) := std_ulogic_vector(std_ulogic_vector(to_unsigned(input1,8)));
			constant local_input2_vec : std_ulogic_vector(DATA_WIDTH-1 downto 0) := std_ulogic_vector(std_ulogic_vector(to_unsigned(input2,8)));
			constant local_result : integer := input1+input2;
		begin 
			--btn1 press and store input1
			report "store data in input1";
			operand_data_in <= local_input1_vec;
			press_btn(btn_operand1);
			assert operand1 = local_input1_vec report "failed storing input1 into operand1 = " & to_string(operand1) & " /= " & to_string(local_input1_vec);

			--btn2 press and store input2
			report "store data in input2";
			operand_data_in <= local_input2_vec;
			press_btn(btn_operand2);
			assert operand2 = local_input2_vec report "failed storing input2 into operand2 = " & to_string(operand2) & " /= " & to_string(local_input2_vec);

			--check if addition works
			sub <= '0';
			wait for clk_period*2;
			report "check addition";
			assert result = std_ulogic_vector(to_unsigned(local_result,8)) report "failed to calculate the addition, result=" & to_string(result) & " /= " & to_string(local_result);
		end procedure;

		procedure uut_sub(input1 : integer; input2 : integer) is 
			constant local_input1_vec : std_ulogic_vector(DATA_WIDTH-1 downto 0) := std_ulogic_vector(std_ulogic_vector(to_unsigned(input1,8)));
			constant local_input2_vec : std_ulogic_vector(DATA_WIDTH-1 downto 0) := std_ulogic_vector(std_ulogic_vector(to_unsigned(input2,8)));
			constant local_result : integer := input1-input2;
		begin 
			--btn1 press and store input1
			report "store data in input1";
			operand_data_in <= local_input1_vec;
			press_btn(btn_operand1);
			assert operand1 = local_input1_vec report "failed storing input1 into operand1 = " & to_string(operand1) & " /= " & to_string(local_input1_vec);

			--btn2 press and store input2
			report "store data in input2";
			operand_data_in <= local_input2_vec;
			press_btn(btn_operand2);
			assert operand2 = local_input2_vec report "failed storing input2 into operand2 = " & to_string(operand2) & " /= " & to_string(local_input2_vec);

			--check if subraction works
			sub <= '1';
			wait for clk_period*2;
			report "check subtraction";
			assert result = std_ulogic_vector(to_unsigned(local_result,8)) report "failed to calculate the subtraction, result=" & to_string(result) & " /= " & to_string(local_result);
		end procedure;

		procedure reset is 
		begin 
			wait for 5*clk_period;
			report "start reset";
			--reset
			res_n <= '0';
			wait for 5*clk_period;
			wait until rising_edge(clk); 

			report "reset off";
			operand_data_in <= (others=>'0');
			res_n <= '1';
			store_operand1 <= '1';
			store_operand2 <= '1';
			sub <= '0';
			wait for 5*clk_period;
			wait until rising_edge(clk); 
		end procedure;

	begin
		report "start sim";
		--reset
		reset;

		--simulate add/sub
		uut_add(10,10);
		uut_add(15,5);
		uut_add(19,8);
		uut_add(100,1);

		uut_sub(10,10);
		uut_sub(15,5);
		uut_sub(19,8);
		uut_sub(5,11);


		--grindiger counter
		report "start grindiger counter";
		for i in 0 to 10 loop
			uut_add(i,0);
		end loop;

		--grindiger countdown
		report "start grindiger countdown";
		for j in 0 to 10 loop
			uut_sub(10,j);
		end loop;

		
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