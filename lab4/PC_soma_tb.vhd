LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC_soma_tb IS
END ENTITY;

ARCHITECTURE a_PC_soma_tb OF PC_soma_tb IS
    SIGNAL clk, finished : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL wr_en : STD_LOGIC := '1';
    SIGNAL data_in : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : UNSIGNED(15 DOWNTO 0);

    CONSTANT period_time : TIME := 100 ns;
    COMPONENT PC_soma
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    uut : PC_soma
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
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