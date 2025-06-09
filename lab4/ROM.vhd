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
        -- A. LI R3, 5
        B"0101_011_000_00101", -- 0: LI R3, 5

        -- B. LI R4, 8
        B"0101_100_000_01000", -- 1: LI R4, 8

        -- C. LI A, 0
        B"0101_111_000_00000", -- 2: LI A, 0

        --    ADD A, R3
        B"1000_111_011_00000", -- 3: ADD A, R3

        --    ADD A, R4
        B"1000_111_100_00000", -- 4: ADD A, R4

        --    MOV R5, A
        B"1101_101_111_00000", -- 5: MOV R5, A

        -- D. SUBI A, 1
        B"0010_111_000_00001", -- 6: SUBI A, 1

        --    MOV R5, A
        B"1101_101_111_00000", -- 7: MOV R5, A

        -- E. JUMP 20
        B"0111_000_000_10100", -- 8: JUMP 20

        -- F. LI R5, 0 (nunca será executado)
        B"0101_101_000_00000", -- 9: LI R5, 0

        -- G. MOV A, R3 (endereço 20)
        B"0000_000_000_00000", -- 10: NOP
        B"0000_000_000_00000", -- 11: NOP
        B"0000_000_000_00000", -- 12: NOP
        B"0000_000_000_00000", -- 13: NOP
        B"0000_000_000_00000", -- 14: NOP
        B"0000_000_000_00000", -- 15: NOP
        B"0000_000_000_00000", -- 16: NOP
        B"0000_000_000_00000", -- 17: NOP
        B"0000_000_000_00000", -- 18: NOP
        B"0000_000_000_00000", -- 19: NOP

        -- 20: MOV A, R5
        B"1101_111_101_00000", -- 20: MOV A, R5

        --    MOV R3, A
        B"1101_011_111_00000", -- 21: MOV R3, A

        -- H. JUMP (Endereço C)
        B"0111_000_000_00010", -- 22: JUMP 2

        -- I. LI R3, 0 (nunca será executada)
        B"0101_011_000_00000", -- 23: LI R3, 0

        -- Preenche o restante com NOPs
        OTHERS => "000000000000000"
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