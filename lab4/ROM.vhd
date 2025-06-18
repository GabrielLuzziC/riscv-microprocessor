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
        -- SHORT RAM TEST - Updated for LW Rd, A and SW Rs, A format
        -- Teste endereço inválido --
        B"0101_011_101_11111", -- 5: LI R3, 191 -- Endereço inválido
        B"0101_111_000_00000", -- 6: LI A, 0
        B"1000_111_011_00000", -- 7: ADD A, R3
        B"0010_011_111_00000", -- 8: SW R3, A   -- R3 no endereço A
        B"1110_100_111_00000", -- 9: LW R4, A

        -- Initialize with interesting values
        B"0101_001_001_00101", -- 0: LI R1, 37    (prime number)
        B"0101_010_001_01011", -- 1: LI R2, 75    (3 * 5^2)
        B"0101_011_000_01101", -- 2: LI R3, 13    (another prime)

        -- Store values at different memory addresses
        B"0101_111_000_01010", -- 3: LI A, 10     (address 10)
        B"0010_001_111_00000", -- 4: SW R1, A     (store R1 at address A)

        B"0101_111_000_10101", -- 5: LI A, 21     (address 21)
        B"0010_010_111_00000", -- 6: SW R2, A     (store R2 at address A)

        -- Load values back and perform arithmetic
        B"0101_111_000_01010", -- 7: LI A, 10     (address 10)
        B"1110_100_111_00000", -- 8: LW R4, A     (load from address A into R4)

        B"0101_111_000_10101", -- 9: LI A, 21     (address 21)
        B"1110_101_111_00000", -- 10: LW R5, A    (load from address A into R5)

        -- Add the loaded values (37 + 75 = 112)
        B"0101_111_000_00000", -- 11: LI A, 0     (clear accumulator)
        B"1000_111_100_00000", -- 12: ADD A, R4   (A = 37)
        B"1000_111_101_00000", -- 13: ADD A, R5   (A = 112)

        -- Store the result
        B"1101_110_111_00000", -- 14: MOV R6, A   (R6 = A for backup)
        B"0101_111_000_11111", -- 15: LI A, 31    (address 31)
        B"0010_110_111_00000", -- 16: SW R6, A    (store R6 at address A)

        -- Verify by loading the result back
        B"1110_011_111_00000", -- 17: LW R3, A    (load from address A into R3)

        -- Simple memory swap test
        B"0101_111_000_01010", -- 18: LI A, 10    (address 10)
        B"1110_001_111_00000", -- 19: LW R1, A    (load from address A into R1)
        B"0101_111_000_10101", -- 20: LI A, 21    (address 21)
        B"1110_010_111_00000", -- 21: LW R2, A    (load from address A into R2)

        -- Swap them
        B"0101_111_000_01010", -- 22: LI A, 10    (address 10)
        B"0010_010_111_00000", -- 23: SW R2, A    (store R2 at address A)
        B"0101_111_000_10101", -- 24: LI A, 21    (address 21)
        B"0010_001_111_00000", -- 25: SW R1, A    (store R1 at address A)

        -- Verify swap worked
        B"0101_111_000_01010", -- 26: LI A, 10    (address 10)
        B"1110_100_111_00000", -- 27: LW R4, A    (should now be 75)

        -- End with infinite loop
        B"0111_000_000_11011", -- 28: JUMP 27     (infinite loop)

        -- Fill remaining with NOPs
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

-- LAB 6

-- CONSTANT conteudo_rom : mem := (
--     -- A. LI R3, 0
--     B"0101_011_000_00000", -- 0: LI R3, 0
--     -- B. LI R4, 0
--     B"0101_100_000_00000", -- 1: LI R4, 0
--     -- C. LI A, 0
--     B"0101_111_000_00000", -- 2: LI A, 0
--     --    ADD A, R3
--     B"1000_111_011_00000", -- 3: ADD A, R3
--     --    ADD A, R4
--     B"1000_111_100_00000", -- 4: ADD A, R4
--     --    MOV R4, A
--     B"1101_100_111_00000", -- 5: MOV R4, A
--     -- D. LI R6, 1
--     B"0101_110_000_00001", -- 6: LI R6, 1
--     --    MOV A, R3
--     B"1101_111_011_00000", -- 7: MOV A, R3
--     --    ADD A, R6
--     B"1000_111_110_00000", -- 8: ADD A, R6
--     -- MOV R3, A
--     B"1101_011_111_00000", -- 9: MOV R3, A
--     -- E. CMPI A, 30
--     B"1111_111_000_11110", -- 10: CMPI A, 30
--     --    BCC -9
--     B"0111_001_111_10111", -- 11: BCC -9 (endereço 2)
--     -- F. MOV A, R4
--     B"1101_111_100_00000", -- 12: MOV A, R4
--     --    MOV R5, A
--     B"1101_101_111_00000", -- 13: MOV R5, A

--     -- Preenche o restante com NOPs
--     OTHERS => "000000000000000"
-- );
-- LAB 5

-- CONSTANT conteudo_rom : mem := (
--         -- A. LI R3, 5
--         B"0101_011_000_00101", -- 0: LI R3, 5

--         -- B. LI R4, 8
--         B"0101_100_000_01000", -- 1: LI R4, 8

--         -- C. LI A, 0
--         B"0101_111_000_00000", -- 2: LI A, 0

--         --    ADD A, R3
--         B"1000_111_011_00000", -- 3: ADD A, R3

--         --    ADD A, R4
--         B"1000_111_100_00000", -- 4: ADD A, R4

--         --    MOV R5, A
--         B"1101_101_111_00000", -- 5: MOV R5, A

--         -- D. SUBI A, 1
--         B"0001_111_000_00001", -- 6: SUBI A, 1

--         --    MOV R5, A
--         B"1101_101_111_00000", -- 7: MOV R5, A

--         -- E. JUMP 20
--         B"0111_000_000_10100", -- 8: JUMP 20

--         -- F. LI R5, 0 (nunca será executado)
--         B"0101_101_000_00000", -- 9: LI R5, 0

--         -- G. MOV A, R3 (endereço 20)
--         B"0000_000_000_00000", -- 10: NOP
--         B"0000_000_000_00000", -- 11: NOP
--         B"0000_000_000_00000", -- 12: NOP
--         B"0000_000_000_00000", -- 13: NOP
--         B"0000_000_000_00000", -- 14: NOP
--         B"0000_000_000_00000", -- 15: NOP
--         B"0000_000_000_00000", -- 16: NOP
--         B"0000_000_000_00000", -- 17: NOP
--         B"0000_000_000_00000", -- 18: NOP
--         B"0000_000_000_00000", -- 19: NOP

--         -- 20: MOV A, R5
--         B"1101_111_101_00000", -- 20: MOV A, R5

--         --    MOV R3, A
--         B"1101_011_111_00000", -- 21: MOV R3, A

--         -- H. JUMP (Endereço C)
--         B"0111_000_000_00010", -- 22: JUMP 2

--         -- I. LI R3, 0 (nunca será executada)
--         B"0101_011_000_00000", -- 23: LI R3, 0

--         -- Preenche o restante com NOPs
--         OTHERS => "000000000000000"
--     );
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