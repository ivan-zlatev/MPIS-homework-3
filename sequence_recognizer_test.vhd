library ieee;
use ieee.std_logic_1164.all;
  
entity sequence_recognizer_test is
end sequence_recognizer_test;
  
architecture test1 of sequence_recognizer_test is 
    constant CLOCK_PERIOD : time := 10 ns;
    signal clock_run : boolean := true;
    
    signal clock, reset, input, output : std_logic;
begin
   uut: entity work.sequence_recognizer(arch1)
      port map (
         clock => clock,
         reset => reset,
         input => input,
         output => output
      );
 
    clock_process :process
    begin
    if clock_run then
        clock <= '0';
        wait for CLOCK_PERIOD/2;
        clock <= '1';
        wait for CLOCK_PERIOD/2;
    else
        wait;
    end if;
    end process;
  
    stim_proc: process
        procedure apply_and_check(constant stimulus, expected: in std_logic; signal actual, clock: in std_logic) is
        begin
            input <= stimulus;
            wait until falling_edge(clock);
            assert expected = actual report "expected:" & std_logic'image(expected);
        end;
    begin  
        -- test 1 - reset
        input <= '0';
        reset <= '1';
        wait until rising_edge(clock);
        assert output = '0' report "test 1 - reset failed";
       
        -- test 2 - 00000
        reset <= '0';
        for i in 1 to 5 loop
            wait until rising_edge(clock);
            assert output = '0' report "test 2 - output must be '0'";            
        end loop;

        -- test 3 - input: 0110 output: 0001
        wait until falling_edge(clock);
        input <= '0';
        wait until falling_edge(clock);
        assert output = '0' report "test 3/1 - output must be '0'";
        
        input <= '1';
        wait until falling_edge(clock);
        assert output = '0' report "test 3/2 - output must be '0'";
        
        input <= '1';
        wait until falling_edge(clock);
        assert output = '0' report "test 3/2 - output must be '0'"; 
 
        input <= '0';
        wait until falling_edge(clock);
        assert output = '1' report "test 3/4 - output must be '1'";  
        
        -- test 3bis - input: 0110 output: 0001
        apply_and_check('0','0',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('0','1',output,clock);
        
        -- test 4 - input: 11110111 output: 0000100
        apply_and_check('1','0',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('0','1',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('1','0',output,clock);
        apply_and_check('1','0',output,clock);
        
      clock_run <= false;
      wait;
   end process;
end;