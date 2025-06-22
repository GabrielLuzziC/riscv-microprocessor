LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY maquina_estados IS
    PORT (
        clk, rst : IN STD_LOGIC;
        exception : IN STD_LOGIC; -- novo sinal de exceção
        estado : OUT unsigned(1 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE a_maquina_estados OF maquina_estados IS
    SIGNAL estado_int : UNSIGNED(1 DOWNTO 0) := "00";
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            estado_int <= "00"; -- Reset to fetch state
        ELSIF rising_edge(clk) THEN
            IF exception = '1' THEN
                estado_int <= estado_int; -- Halt: stay in current state
            ELSE
                -- Normal state transitions
                CASE estado_int IS
                    WHEN "00" => estado_int <= "01"; -- Fetch -> Decode
                    WHEN "01" => estado_int <= "10"; -- Decode -> Execute
                    WHEN "10" => estado_int <= "00"; -- Execute -> Fetch
                    WHEN OTHERS => estado_int <= "00";
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    estado <= estado_int;
END ARCHITECTURE;