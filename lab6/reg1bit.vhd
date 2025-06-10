LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY reg1bits IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    wr_en : IN STD_LOGIC;
    data_in : IN STD_LOGIC;
    data_out : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE a_reg1bits OF reg1bits IS
  SIGNAL registro : STD_LOGIC := '0'; -- sinal interno para armazenar o valor do registro
BEGIN
  -- Fixed process with proper edge detection for clock and reset precedence
  PROCESS (clk, rst, wr_en)
  BEGIN
    IF rst = '1' THEN
      registro <= '0';
      ELSIF rising_edge(clk) THEN
      IF wr_en = '1' THEN
        registro <= data_in;
      END IF;
    END IF;
  END PROCESS;

  data_out <= registro; -- conexao direta, fora do processo
END ARCHITECTURE;