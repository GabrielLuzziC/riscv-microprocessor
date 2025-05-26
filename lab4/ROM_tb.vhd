LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM_tb IS
END ENTITY;

ARCHITECTURE a_ROM_tb of ROM_tb IS
    COMPONENT ROM
        PORT (
            clk : IN STD_LOGIC;
            endereco : UNSIGNED (6 DOWNTO 0);
            dado : OUT UNSIGNED (14 DOWNTO 0)
        );
    END COMPONENT;

    -- define e inicializa os sinais
    SIGNAL endereco : UNSIGNED (6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dado : UNSIGNED (14 DOWNTO 0) := (OTHERS => '0');
    SIGNAL finished, clk : STD_LOGIC := '0';
    CONSTANT period_time : TIME := 100 ns;
BEGIN
    uut : ROM
    PORT MAP(
        clk => clk,
        endereco => endereco,
        dado => dado
    );

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

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            endereco <= endereco + 1;
        END IF;
    END PROCESS;
END ARCHITECTURE;