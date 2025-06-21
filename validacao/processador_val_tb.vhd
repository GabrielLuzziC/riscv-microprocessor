LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Só Deixa rodar

ENTITY processador_val_tb IS
END ENTITY;

ARCHITECTURE a_processador_val_tb OF processador_val_tb IS
  COMPONENT processador
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC
    );
  END COMPONENT;

  SIGNAL finished, clk : STD_LOGIC := '0';
  SIGNAL rst : STD_LOGIC := '0';
  CONSTANT period_time : TIME := 100 ns;
BEGIN
  uut : processador
  PORT MAP(
    clk => clk,
    rst => rst
  );

  reset_global : PROCESS
  BEGIN
    rst <= '1';
    WAIT FOR period_time / 2;
    rst <= '0';
    WAIT;
  END PROCESS;

  sim_time_proc : PROCESS
  BEGIN
    WAIT FOR 100 us;
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