library ieee;
use ieee.std_logic_1164.all;

entity det_par is
    port (  in_1 : in std_logic;
            in_2 : in std_logic;
            in_3 : in std_logic;
            output : out std_logic
    );
end entity;

architecture a_det_par of det_par is  
begin
    output <= (in_1 xor in_2 xor in_3);
end architecture;