library ieee;
use ieee.std_logic_1164.all;

entity det_par_tb is 
end;

architecture a_det_par_tb of det_par_tb is
    -- defino os componentes que serao utilizados
    component det_par is
        port (  in_1 : in std_logic;
                in_2 : in std_logic;
                in_3 : in std_logic;
                output : out std_logic
        );
    end component;

    signal in_1, in_2, in_3, output : std_logic;
begin
    utt: det_par port map (in_1 => in_1, in_2 => in_2, in_3 => in_3, output => output);

    process
    begin
        in_1 <= '0';
        in_2 <= '0';
        in_3 <= '0';
        wait for 50 ns;
        in_1 <= '0';
        in_2 <= '0';
        in_3 <= '1';
        wait for 50 ns;
        in_1 <= '0';
        in_2 <= '1';
        in_3 <= '0';
        wait for 50 ns;
        in_1 <= '0';
        in_2 <= '1';
        in_3 <= '1';
        wait for 50 ns;
        in_1 <= '1';
        in_2 <= '0';
        in_3 <= '0';
        wait for 50 ns;
        in_1 <= '1';
        in_2 <= '0';
        in_3 <= '1';
        wait for 50 ns;
        in_1 <= '1';
        in_2 <= '1';
        in_3 <= '0';
        wait for 50 ns;
        in_1 <= '1';
        in_2 <= '1';
        in_3 <= '1';
        wait for 50 ns;
        wait;
    end process;
end architecture;