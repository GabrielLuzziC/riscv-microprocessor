LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY unidade_de_controle IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_out : OUT UNSIGNED(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE a_unidade_de_controle OF unidade_de_controle IS
  SIGNAL data_temp, data_temp_out : UNSIGNED(15 DOWNTO 0);
  SIGNAL rom_temp_out : UNSIGNED(14 DOWNTO 0);
  SIGNAL endereco : UNSIGNED(6 DOWNTO 0);
  SIGNAL estado : STD_LOGIC;
  SIGNAL write_on_pc : STD_LOGIC;

  COMPONENT PC_ROM IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      wr_en : IN STD_LOGIC;
      data_in : IN UNSIGNED(15 DOWNTO 0);
      data_out : OUT UNSIGNED(15 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT maquina_estados IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      estado : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  u_pc_rom : PC_ROM
  PORT MAP(
    clk => clk,
    rst => rst,
    wr_en => write_on_pc,
    data_in => data_temp,
    data_out => data_temp_out
  );

  maq_estados : maquina_estados
  PORT MAP(
    clk => clk,
    rst => rst,
    estado => estado
  );

  data_out <= data_temp_out;
  endereco <= data_temp_out(6 DOWNTO 0);
  write_on_pc <= '1' WHEN estado = '1' ELSE
    '0';
END ARCHITECTURE;