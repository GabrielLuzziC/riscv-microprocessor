LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM IS
    PORT (
        clk : IN STD_LOGIC;
        endereco : UNSIGNED (6 DOWNTO 0);
        dado : OUT UNSIGNED (14 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE a_ROM OF ROM IS
    TYPE mem IS ARRAY (0 TO 127) OF UNSIGNED (14 DOWNTO 0);
    CONSTANT conteudo_rom : mem := (
        "111100000000010", -- JUMP para o endereco 2
        "000000000000001", -- 1
        "000000000000010", -- 2
        "000000000000011", -- 3
        "000000000000100", -- 4
        "000000000000101", -- 5
        "000000000001110", -- 6
        "111110000000000", -- JUMP para o endereco 0
        OTHERS => "000000000000000" -- 7 a 127
    );
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            dado <= conteudo_rom(to_integer(endereco));
        END IF;
    END PROCESS;
END ARCHITECTURE;