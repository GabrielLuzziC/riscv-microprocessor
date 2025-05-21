LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY acumulador IS
    PORT(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : IN UNSIGNED(15 DOWNTO 0);
        data_out : OUT UNSIGNED(15 DOWNTO 0)
    );
END ENTITY acumulador;

ARCHITECTURE a_acumulador OF acumulador IS
    SIGNAL wr_en : STD_LOGIC := '1'; --sempre escreve nele
    COMPONENT reg16bits
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    uut: reg16bits
        PORT map (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
        );
END ARCHITECTURE;