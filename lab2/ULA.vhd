LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- OPERAÇÕES
-- 000 -> soma
-- 001 -> subtração
-- 010 -> maior que
-- 011 -> menor que
-- 100 -> diferente
ENTITY ULA IS
    PORT (
        selec_op : IN unsigned (2 DOWNTO 0);
        in_1, in_2 : IN unsigned (15 DOWNTO 0);
        boolean_flag : OUT STD_LOGIC;
        carry_flag : OUT STD_LOGIC;
        zero_flag : OUT STD_LOGIC;
        output : OUT unsigned (15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE a_ULA OF ULA IS
    SIGNAL in_1_temp, in_2_temp, out_temp : unsigned (16 DOWNTO 0);
    SIGNAL result : unsigned (15 DOWNTO 0);

BEGIN
    result <= in_1 + in_2 WHEN (selec_op = "000") ELSE
        in_1 - in_2 WHEN (selec_op = "001") ELSE
        "0000000000000000";

    output <= result;

    boolean_flag <= '1' WHEN (selec_op = "010" AND in_1 > in_2) ELSE
        '1' WHEN (selec_op = "011" AND in_1 < in_2) ELSE
        '1' WHEN (selec_op = "100" AND in_1 /= in_2) ELSE
        '0';

    in_1_temp <= '0' & in_1;
    in_2_temp <= '0' & in_2;
    out_temp <= in_1_temp + in_2_temp;

    carry_flag <= '1' WHEN (out_temp(16) = '1') ELSE
        '0';

    zero_flag <= '1' WHEN (result = "0000000000000000") ELSE
        '0';
END ARCHITECTURE;