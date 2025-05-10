library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is 
    port (
        sel_1, sel_2, sel_3 : in std_logic;
        in_2, in_4, in_6 : in std_logic;
        output : out std_logic
);
end entity;

architecture a_mux8x1 of mux8x1 is
    signal in_0, in_1, in_5 : std_logic := '0';
    signal in_3, in_7 : std_logic := '1';
begin
    output <= in_0 when (sel_1 = '0' and sel_2 = '0' and sel_3 = '0') else
             in_1 when (sel_1 = '0' and sel_2 = '0' and sel_3 = '1') else
             in_2 when (sel_1 = '0' and sel_2 = '1' and sel_3 = '0') else
             in_3 when (sel_1 = '0' and sel_2 = '1' and sel_3 = '1') else
             in_4 when (sel_1 = '1' and sel_2 = '0' and sel_3 = '0') else
             in_5 when (sel_1 = '1' and sel_2 = '0' and sel_3 = '1') else
             in_6 when (sel_1 = '1' and sel_2 = '1' and sel_3 = '0') else
             in_7 when (sel_1 = '1' and sel_2 = '1' and sel_3 = '1') else
             '0';
end architecture;