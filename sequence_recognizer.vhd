library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequence_recognizer is
	generic (
		N: integer := 3; -- number of bits to store in the internal_register
		X: integer := 6); -- integer number to look for in the internal_register
	port (
		input : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		output : out std_logic);
end sequence_recognizer;

architecture arch1 of sequence_recognizer is
	type state_type is (init, reading_state);
	signal current_state, next_state : state_type;
	signal output_int : std_logic;
	shared variable internal_register : std_logic_vector(N-1 downto 0);
	signal input_int : std_logic;
begin
	output <= output_int;
	input_int <= input;

	state_reg : process(clock, reset)
	begin
		if reset = '1' then
			current_state <= init;
		else
			current_state <= reading_state;
		end if;
	end process;
	
	next_state_logic : process(clock)
	begin	
		case current_state is
			when init =>	-- when current_state is init => set all outputs to zero
				output_int <= '0';
				internal_register := (others=>'0');
			when reading_state => -- when current_state is reading_state
				if rising_edge(clock) then	-- and the clock signal is rising
					internal_register := internal_register(N-2 downto 0) & input_int; -- shift the current internal register one bit to the right and set the current input as the LSB
					if (internal_register = std_logic_vector(to_unsigned(X,N))) then -- if internal_register equals to the number X we are looking for
						output_int <= '1'; -- set the output to 1
					else
						output_int <= '0'; -- if it isn't, set the output to zero
					end if;
				end if;
		end case;
	end process;
end;