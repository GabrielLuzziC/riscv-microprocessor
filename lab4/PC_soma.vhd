LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC_soma IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        wr_en : IN STD_LOGIC;
        jump_en : IN STD_LOGIC;
        data_in : IN UNSIGNED(6 DOWNTO 0);
        data_out : OUT UNSIGNED(6 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE a_PC_soma OF PC_soma IS
    SIGNAL data_temp, data_temp_out : UNSIGNED(6 DOWNTO 0);
    COMPONENT PC IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(6 DOWNTO 0);
            data_out : OUT UNSIGNED(6 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    uut : PC
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_temp,
        data_out => data_temp_out
    );

    data_temp <= data_temp_out + 1 WHEN jump_en = '0' ELSE
        data_in; -- If jump_en is high, use data_in for jump
    data_out <= data_temp_out;
END ARCHITECTURE;