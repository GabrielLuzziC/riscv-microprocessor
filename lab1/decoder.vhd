library ieee;
use ieee.std_logic_1164.all;

entity decoder is 
    port (  in_1 : in std_logic;
            in_2 : in std_logic;
            out_1 : out std_logic;
            out_2 : out std_logic;
            out_3 : out std_logic;
            out_4 : out std_logic
);
end entity;

architecture a_decoder of decoder is 
begin
    out_1 <= not in_1 and not in_2;
    out_2 <= not in_1 and in_2;
    out_3 <= in_1 and not in_2;
    out_4 <= in_1 and in_2;
end architecture;