library ieee;
use ieee.std_logic_1164.all;

entity decoder_tb is
end;

architecture a_decoder_tb of decoder_tb is
    component decoder is 
        port (  in_1 : in std_logic;
                in_2 : in std_logic;
                out_1 : out std_logic;
                out_2 : out std_logic;
                out_3 : out std_logic;
                out_4 : out std_logic
        );
    end component;
    signal in_1, in_2, out_1, out_2, out_3, out_4 : std_logic;
begin
    uut: decoder port map (in_1 => in_1, in_2 => in_2, out_1 => out_1, out_2 => out_2, out_3 => out_3, out_4 => out_4);

    process
    begin
        in_1 <= '0';
        in_2 <= '0';
        wait for 50 ns;
        in_1 <= '0';
        in_2 <= '1';
        wait for 50 ns;
        in_1 <= '1';
        in_2 <= '0';
        wait for 50 ns;
        in_1 <= '1';
        in_2 <= '1';
        wait for 50 ns;
        wait;
    end process;
end architecture a_decoder_tb;