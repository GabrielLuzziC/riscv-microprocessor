LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY unidade_de_controle_tb IS
END ENTITY;

ARCHITECTURE a_unidade_de_controle_tb OF unidade_de_controle_tb IS
  SIGNAL clk, finished : STD_LOGIC := '0';
  SIGNAL rst : STD_LOGIC := '0';
  SIGNAL data_out : UNSIGNED(15 DOWNTO 0);

  CONSTANT period_time : TIME := 100 ns;
  COMPONENT unidade_de_controle IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC
    );
  END COMPONENT;
BEGIN
  u_unidade_de_controle : unidade_de_controle
  PORT MAP(
    clk => clk,
    rst => rst
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