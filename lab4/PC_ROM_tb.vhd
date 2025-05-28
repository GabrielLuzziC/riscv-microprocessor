LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC_ROM_tb IS
END ENTITY;

ARCHITECTURE a_PC_ROM_tb OF PC_ROM_tb IS
  SIGNAL clk, finished : STD_LOGIC := '0';
  SIGNAL rst : STD_LOGIC := '0';
  SIGNAL data_out : UNSIGNED(14 DOWNTO 0);

  CONSTANT period_time : TIME := 100 ns;
  COMPONENT PC_ROM IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in : IN UNSIGNED(6 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      jump_en : IN STD_LOGIC;
      data_out : OUT UNSIGNED(14 DOWNTO 0)
    );
  END COMPONENT;
BEGIN
  uut : PC_ROM
  PORT MAP(
    clk => clk,
    rst => rst,
    data_in => (OTHERS => '0'), -- Assuming no input data for this test
    jump_en => '0', -- Assuming jump_en is always disabled for this test
    wr_en => '0', -- Assuming wr_en is always enabled for this test
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