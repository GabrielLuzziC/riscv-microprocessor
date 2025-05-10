library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_e_subtrai_tb is 
end entity;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
    component soma_e_subtrai
         port ( x,y : in unsigned(7 downto 0);
            soma, sub : out unsigned (7 downto 0)
    );
    end component;
    signal x,y : unsigned(7 downto 0);
    signal soma, sub : unsigned (7 downto 0);
begin
    uut: soma_e_subtrai port map (x => x, y => y, soma => soma, sub => sub);
    process 
    begin
        x <= "00000000"; 
        y <= "00000000"; 
        wait for 50 ns;
        x <= "00000001"; 
        y <= "00000001"; 
        wait for 50 ns;
        x <= "00000010"; 
        y <= "00000010"; 
        wait for 50 ns;
        x <= "00000100"; 
        y <= "00000100"; 
        wait for 50 ns;
        x <= "00001000"; 
        y <= "00001000"; 
        wait for 50 ns;
        x <= "00010000"; 
        y <= "00010000"; 
        wait for 50 ns;
        x <= "00100000"; 
        y <= "00100000"; 
        wait for 50 ns;
        x <= "01100100";
        y <= "01100100";
        wait for 50 ns;
        x <= "11001000";
        y <= "11001000";
        wait for 50 ns;
        x <= "00000100";
        y <= "11111101";
        wait for 50 ns;
        wait;
    end process;

end architecture;