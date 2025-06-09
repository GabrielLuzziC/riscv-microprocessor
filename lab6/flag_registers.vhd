LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY flag_registers IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    wr_en : IN STD_LOGIC;
    carry_flag_in : IN STD_LOGIC;
    zero_flag_in : IN STD_LOGIC;
    carry_flag_out : OUT STD_LOGIC;
    zero_flag_out : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE a_flag_registers OF flag_registers IS
  COMPONENT reg1bits
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      wr_en : IN STD_LOGIC;
      data_in : IN STD_LOGIC;
      data_out : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  carry_reg : reg1bits
  PORT MAP(
    clk => clk,
    rst => rst,
    wr_en => wr_en,
    data_in => carry_flag_in,
    data_out => carry_flag_out
  );

  zero_reg : reg1bits
  PORT MAP(
    clk => clk,
    rst => rst,
    wr_en => wr_en,
    data_in => zero_flag_in,
    data_out => zero_flag_out
  );
END ARCHITECTURE;