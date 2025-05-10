library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_e_subtrai is 
    port ( x,y : in unsigned(7 downto 0);
            soma, sub : out unsigned (7 downto 0)
    );
end entity;

architecture a_soma_e_subrtrai of soma_e_subtrai is
begin
    soma <= x+y;
    sub <= x-y;
end architecture;