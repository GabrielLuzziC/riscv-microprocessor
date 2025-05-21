LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_ULA_tb IS
END ENTITY;

ARCHITECTURE a_reg_ULA_tb OF reg_ULA_tb IS
  COMPONENT reg_ULA
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      wr_en : IN STD_LOGIC;
      boolean_flag : OUT STD_LOGIC;
      carry_flag : OUT STD_LOGIC;
      zero_flag : OUT STD_LOGIC;
      selec_reg_in : IN UNSIGNED(2 DOWNTO 0);
      selec_reg_out : IN UNSIGNED(2 DOWNTO 0);
      data_in : IN UNSIGNED(15 DOWNTO 0);
      data_out : OUT UNSIGNED(15 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL data_in, data_out : UNSIGNED(15 DOWNTO 0);
  SIGNAL clk, rst, wr_en : STD_LOGIC;
  SIGNAL selec_reg_in, selec_reg_out : UNSIGNED(2 DOWNTO 0);
  SIGNAL finished : STD_LOGIC := '0';
  CONSTANT period_time : TIME := 100 ns;
  SIGNAL boolean_flag, carry_flag, zero_flag : STD_LOGIC;
BEGIN
  uut : reg_ULA PORT MAP(
    clk => clk,
    rst => rst,
    wr_en => wr_en,
    selec_reg_in => selec_reg_in,
    selec_reg_out => selec_reg_out,
    data_in => data_in,
    data_out => data_out,
    boolean_flag => boolean_flag,
    carry_flag => carry_flag,
    zero_flag => zero_flag
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

  PROCESS
  BEGIN
    -- RESETA todo mundo em 0
    -- COLOCA 1, 2 e 3 nos registradores 1, 2 e 3
    -- SOMA 1 com o acumulador
    -- SOMA 2 com o acumulador
    -- SOMA 3 com o acumulador

    wr_en <= '1';
    selec_reg_out <= "000"; -- REG0 - para ficar somando com 0 o acumulador.

    selec_reg_in <= "001"; -- REG1
    data_in <= "0000000000000001"; -- 1
    WAIT FOR period_time;

    selec_reg_in <= "010"; -- REG1
    data_in <= "0000000000000010"; -- 2
    WAIT FOR period_time;

    selec_reg_in <= "011"; -- REG1
    data_in <= "0000000000000011"; -- 3
    WAIT FOR period_time;

    wr_en <= '0';
    WAIT FOR period_time;
    -- SOMA 1 com o acumulador
    selec_reg_out <= "001"; -- REG1
    WAIT FOR period_time;
    -- SOMA 1 com o acumulador
    selec_reg_out <= "010"; -- REG2
    WAIT FOR period_time;
    -- SOMA 1 com o acumulador
    selec_reg_out <= "011"; -- REG3
    WAIT FOR period_time;

    WAIT;
  END PROCESS;
END ARCHITECTURE;