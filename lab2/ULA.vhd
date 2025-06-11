LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- OPERAÇÕES
-- 000 -> soma
-- 001 -> subtração
-- 100 -> diferente
-- 101 -> operações de carregar valores em registradores
-- 111 -> comparação com imediato (CMPI)
ENTITY ULA IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        exec_en : IN STD_LOGIC; -- Enable writing to flag registers during execute stage
        selec_op : IN UNSIGNED (2 DOWNTO 0);
        in_1, in_2 : IN UNSIGNED (15 DOWNTO 0);
        carry_flag : OUT STD_LOGIC;
        zero_flag : OUT STD_LOGIC;
        output : OUT UNSIGNED (15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE a_ULA OF ULA IS
    SIGNAL in_1_temp, in_2_temp, out_temp : UNSIGNED (16 DOWNTO 0);
    SIGNAL result : UNSIGNED (15 DOWNTO 0);
    -- SIGNAL boolean_flag : STD_LOGIC;
    SIGNAL carry_flag_tmp, zero_flag_tmp : STD_LOGIC;

    COMPONENT flag_registers
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            carry_flag_in : IN STD_LOGIC;
            zero_flag_in : IN STD_LOGIC;
            carry_flag_out : OUT STD_LOGIC;
            zero_flag_out : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN
    -- Calculate CMPI result
    -- soma & sub --
    result <= in_1 + in_2 WHEN (selec_op = "000") ELSE
        in_1 - in_2 WHEN (selec_op = "001" OR selec_op = "111") ELSE
        "0000000000000000";

    output <= result;

    -- Simplified boolean_flag logic - removed greater/less than operations
    -- boolean_flag <= '1' WHEN (selec_op = "100" AND in_1 /= in_2) ELSE
    --     '1' WHEN (selec_op = "111" AND in_1 < in_2)
    --     ELSE
    --     '0';
    -- carry flag --
    in_1_temp <= '0' & in_1;
    in_2_temp <= '0' & in_2;

    out_temp <= in_1_temp + in_2_temp WHEN (selec_op = "000") ELSE
        in_1_temp - in_2_temp WHEN (selec_op = "001" OR selec_op = "111") ELSE
        "00000000000000000";

    carry_flag_tmp <= '1' WHEN ((selec_op = "001") AND (in_1 < in_2)) ELSE -- For SUB
        '1' WHEN ((selec_op = "111") AND (in_1 >= in_2)) ELSE -- For CMPI (note the change)
        out_temp(16) WHEN selec_op = "000" ELSE -- For ADD
        '0';

    -- Zero flag logic - make sure it's correctly set for CMPI
    zero_flag_tmp <= '1' WHEN ((result = "0000000000000000") OR
        (selec_op = "111" AND in_1 = in_2)) ELSE
        '0';

    -- Flag register instantiation
    flags : flag_registers
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => exec_en, -- Only update flags during execute stage
        carry_flag_in => carry_flag_tmp,
        zero_flag_in => zero_flag_tmp,
        carry_flag_out => carry_flag,
        zero_flag_out => zero_flag
    );
END ARCHITECTURE;