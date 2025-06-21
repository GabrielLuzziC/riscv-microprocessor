LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY unidade_de_controle IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    carry_flag : IN STD_LOGIC; -- sinal de carry
    zero_flag : IN STD_LOGIC; -- sinal de zero
    estado : OUT unsigned(1 DOWNTO 0); -- estado da maquina de estados;
    instrucao : OUT UNSIGNED(14 DOWNTO 0) -- instrução a ser executada
  );
END ENTITY;

ARCHITECTURE a_unidade_de_controle OF unidade_de_controle IS
  SIGNAL rom_temp_out : UNSIGNED(14 DOWNTO 0);
  SIGNAL write_on_pc : STD_LOGIC;
  SIGNAL jump_en : UNSIGNED(1 DOWNTO 0); -- agora 2 bits: 00=nenhum, 01=absoluto, 10=relativo
  SIGNAL func3 : UNSIGNED(2 DOWNTO 0);
  SIGNAL estado_int : UNSIGNED(1 DOWNTO 0); -- estado da maquina de estado
  SIGNAL instrucao_int : UNSIGNED(14 DOWNTO 0);
  SIGNAL constante : UNSIGNED(6 DOWNTO 0);
  SIGNAL opcode : UNSIGNED(3 DOWNTO 0);

  COMPONENT PC_ROM IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in : IN UNSIGNED(6 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      jump_en : IN UNSIGNED(1 DOWNTO 0); -- alterado para 2 bits
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
    data_out => instrucao_int
  );

  maq_estados : maquina_estados
  PORT MAP(
    clk => clk,
    rst => rst,
    estado => estado_int
  );

  opcode <= instrucao_int(14 DOWNTO 11); -- 4 MSB
  write_on_pc <= '1' WHEN estado_int = "10" ELSE
    '0';

  func3 <= instrucao_int(10 DOWNTO 8) WHEN opcode = "0111" ELSE
    "000"; -- func3 = 000 salto direto, 001 salto relativo

  -- jump_en: 00 = nenhum salto, 01 = salto absoluto, 10 = salto relativo
  jump_en <= "01" WHEN (opcode = "0111" AND func3 = "000") ELSE
    "10" WHEN ((opcode = "0111" AND func3 = "001" AND carry_flag = '0') OR  -- BCC
    (opcode = "0111" AND func3 = "010" AND zero_flag = '0')) ELSE   -- BNE
    "00";

  constante <= instrucao_int(6 DOWNTO 0); -- 7 LSB
  instrucao <= instrucao_int;
  estado <= estado_int;
END ARCHITECTURE;