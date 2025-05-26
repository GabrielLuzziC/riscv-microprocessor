LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY maquina_estados IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        estado : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE a_maquina_estados OF maquina_estados IS
    SIGNAL registro : STD_LOGIC;
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            registro <= '0';    
        ELSIF (rising_edge(clk)) THEN
            registro <= NOT registro;
        END IF;
    END PROCESS;

    estado <= registro;
END ARCHITECTURE;