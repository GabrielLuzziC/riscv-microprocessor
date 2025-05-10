library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_tb is
end entity;

architecture a_mux8x1_tb of mux8x1_tb is
    component mux8x1 is
        port (
            sel_3, sel_2, sel_1 : in std_logic;
            in_2, in_4, in_6 : in std_logic;
            output : out std_logic
        );
    end component;
    signal sel_3, sel_2, sel_1 : std_logic;
    signal in_2, in_4, in_6 : std_logic;
    signal output : std_logic;
begin
    uut: mux8x1 port map (sel_3 => sel_3, sel_2 => sel_2, sel_1 => sel_1,
                          in_2 => in_2, in_4 => in_4, in_6 => in_6,
                          output => output);
    process 
    begin
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '0';
        sel_2 <= '0';
        sel_1 <= '0';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '1';
        sel_2 <= '0';
        sel_1 <= '0';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '0';
        sel_2 <= '1';
        sel_1 <= '0';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '1';
        sel_2 <= '1';
        sel_1 <= '0';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '0';
        sel_2 <= '0';
        sel_1 <= '1';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '1';
        sel_2 <= '0';
        sel_1 <= '1';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '0';
        sel_2 <= '1';
        sel_1 <= '1';
        wait for 50 ns;
        in_2 <= '0'; 
        in_4 <= '0'; 
        in_6 <= '0';
        sel_3 <= '1';
        sel_2 <= '1';
        sel_1 <= '1';
        wait for 50 ns;
        wait;
    end process;
end architecture;