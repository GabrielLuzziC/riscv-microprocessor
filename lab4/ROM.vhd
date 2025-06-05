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
        B"0101_011_000_00101", -- LI R3, 5
        B"0101_100_000_01000", -- LI R4, 8
        B"0101_111_000_00000", -- LI A, 0 -> Testar outro valor para ver funcionando
        B"1000_111_011_00000", -- ADD A, R3
        B"1000_111_100_00000", -- ADD A, R4
        B"1101_101_111_00000", -- MOV R5, A
        B"0010_111_000_00001", -- SUBI A, 1
        --B"1101_101_111_00000", -- MOV R5, A
        --B"0111_000_000_10100", -- JUMP 20
        --B"0101_101_000_00000", -- LI R5, 0
        --B"1101_101_011_00000", -- MOV R5, R3
        --B"0111_000_000_00011", -- JUMP endereço C
        --"0101_011_000_00000", -- LI R3, 0 - NUNCA SERA EXECUTADO
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

-- LAB 4
-- CONSTANT conteudo_rom : mem := (
--     "111100000000010", -- JUMP para o endereco 2
--     "000000000000001", -- 1
--     "000000000000010", -- 2
--     "000000000000011", -- 3
--     "000000000000100", -- 4
--     "000000000000101", -- 5
--     "000000000001110", -- 6
--     "111110000000000", -- JUMP para o endereco 0
--     OTHERS => "000000000000000" -- 7 a 127
-- );