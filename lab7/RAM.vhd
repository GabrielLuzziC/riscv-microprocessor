LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram IS
  PORT (
    clk : IN STD_LOGIC;
    endereco : IN unsigned(6 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    dado_in : IN unsigned(15 DOWNTO 0);
    dado_out : OUT unsigned(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE a_ram OF ram IS
  TYPE mem IS ARRAY (0 TO 127) OF unsigned(15 DOWNTO 0);
  SIGNAL conteudo_ram : mem;
BEGIN
  PROCESS (clk, wr_en)
  BEGIN
    IF rising_edge(clk) THEN
      IF wr_en = '1' THEN
        conteudo_ram(to_integer(endereco)) <= dado_in;
      END IF;
    END IF;
  END PROCESS;
  dado_out <= conteudo_ram(to_integer(endereco));
END ARCHITECTURE;