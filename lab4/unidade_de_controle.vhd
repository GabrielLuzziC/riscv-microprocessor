LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY unidade_de_controle IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC
  );
END ENTITY;

ARCHITECTURE a_unidade_de_controle OF unidade_de_controle IS
  SIGNAL rom_temp_out : UNSIGNED(14 DOWNTO 0);
  SIGNAL estado : unsigned(1 DOWNTO 0);
  SIGNAL write_on_pc : STD_LOGIC;
  SIGNAL jump_en : STD_LOGIC;
  SIGNAL instrucao : UNSIGNED(14 DOWNTO 0);
  SIGNAL constante : UNSIGNED(6 DOWNTO 0);
  SIGNAL opcode : UNSIGNED(3 DOWNTO 0);

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

  COMPONENT maquina_estados IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      estado : OUT unsigned(1 DOWNTO 0)
    );
  END COMPONENT;
BEGIN
  u_pc_rom : PC_ROM
  PORT MAP(
    clk => clk,
    rst => rst,
    wr_en => write_on_pc,
    jump_en => jump_en,
    data_in => constante,
    data_out => instrucao
  );

  maq_estados : maquina_estados
  PORT MAP(
    clk => clk,
    rst => rst,
    estado => estado
  );

  opcode <= instrucao(14 DOWNTO 11); -- 4 MSB
  write_on_pc <= '1' WHEN estado = "01" ELSE
    '0';

  jump_en <= '1' WHEN opcode = "1111" ELSE
    '0';

  constante <= instrucao(6 DOWNTO 0); -- 7 LSB
END ARCHITECTURE;