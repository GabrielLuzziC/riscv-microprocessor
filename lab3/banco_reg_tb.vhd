LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY banco_reg_tb IS
END ENTITY;

ARCHITECTURE a_banco_reg_tb OF banco_reg_tb IS
  COMPONENT banco_reg
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      wr_en : IN STD_LOGIC;
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
BEGIN
  uut : banco_reg
  PORT MAP(
    clk => clk,
    rst => rst,
    wr_en => wr_en,
    selec_reg_in => selec_reg_in,
    selec_reg_out => selec_reg_out,
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

  PROCESS
  BEGIN
    -- COLOCA UM VALOR DIFERENTE EM CADA REGISTRADOR
    -- PRIMEIRO MOSTRA O VALOR DO REGISTRADOR, ATUALIZA O VALOR, MOSTRA O VALOR NOVO
    wr_en <= '0';
    selec_reg_in <= "000"; -- REG0
    selec_reg_out <= "000"; -- REG0
    data_in <= "0000000000000000"; -- 0
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    wr_en <= '0';
    selec_reg_in <= "001"; -- REG1
    selec_reg_out <= "001"; -- REG1
    data_in <= "0000000000000001"; -- 1
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    wr_en <= '0';
    selec_reg_in <= "010"; -- REG2
    selec_reg_out <= "010"; -- REG2
    data_in <= "0000000000000010"; -- 2
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    wr_en <= '0';
    selec_reg_in <= "011"; -- REG3
    selec_reg_out <= "011"; -- REG3
    data_in <= "0000000000000011"; -- 3
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    wr_en <= '0';
    selec_reg_in <= "100"; -- REG4
    selec_reg_out <= "100"; -- REG4
    data_in <= "0000000000000100"; -- 4
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    wr_en <= '0';
    selec_reg_in <= "101"; -- REG5
    selec_reg_out <= "101"; -- REG5
    data_in <= "0000000000000101"; -- 5
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    wr_en <= '0';
    selec_reg_in <= "110"; -- REG6
    selec_reg_out <= "110"; -- REG6
    data_in <= "0000000000000110"; -- 6
    WAIT FOR period_time;
    wr_en <= '1'; -- ativa o write
    WAIT FOR period_time; -- espera um ciclo

    WAIT;
  END PROCESS;
END ARCHITECTURE;