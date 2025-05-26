LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;   

ENTITY maquina_estados_tb IS
END ENTITY;

ARCHITECTURE a_maquina_estados_tb OF maquina_estados_tb IS
    COMPONENT maquina_estados
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            estado : OUT STD_LOGIC
        );
    END COMPONENT;

    -- define e inicializa os sinais
    SIGNAL clk, rst, wr_en, estado : STD_LOGIC := '0';
    SIGNAL finished : STD_LOGIC := '0';
    CONSTANT period_time : TIME := 100 ns;

BEGIN
    uut : maquina_estados
    PORT MAP(
        clk => clk,
        rst => rst,
        estado => estado
    );

    reset_global : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR period_time * 2;
        rst <= '0';
        WAIT;
    END PROCESS;
    
    sim_time_proc : PROCESS
    BEGIN
        WAIT FOR 10 us;
        finished <= '1';
        WAIT;
    END PROCESS sim_time_proc;

    clk_proc : PROCESS
    BEGIN
        WHILE finished /= '1' LOOP
        clk <= '0';
        WAIT FOR period_time/2;
        clk <= '1';
        WAIT FOR period_time/2;
        END LOOP;
        WAIT;
    END PROCESS clk_proc;

END ARCHITECTURE;