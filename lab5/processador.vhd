LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY processador IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        wr_en : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE a_processador OF processador IS
    COMPONENT unidade_de_controle
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT reg_ULA
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC
        );
    END COMPONENT;
BEGIN

END ARCHITECTURE;