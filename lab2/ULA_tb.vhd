LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ULA_tb IS
END ENTITY;

ARCHITECTURE a_ULA_tb OF ULA_tb IS
  COMPONENT ULA
    PORT (
      selec_op : IN signed (2 DOWNTO 0);
      in_1, in_2 : IN signed (15 DOWNTO 0);
      boolean_flag : OUT STD_LOGIC;
      carry_flag : OUT STD_LOGIC;
      zero_flag : OUT STD_LOGIC;
      output : OUT signed (15 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL select_op : signed(2 DOWNTO 0) := "000";
  SIGNAL in_1, in_2 : signed(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL boolean_flag : STD_LOGIC := '0';
  SIGNAL carry_flag : STD_LOGIC := '0';
  SIGNAL zero_flag : STD_LOGIC := '0';
  SIGNAL output : signed(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
  uut : ULA PORT MAP(
    selec_op => select_op,
    in_1 => in_1,
    in_2 => in_2,
    boolean_flag => boolean_flag,
    carry_flag => carry_flag,
    zero_flag => zero_flag,
    output => output
  );
  PROCESS
  BEGIN
    -- Wait a little to avoid initial metavalues
    WAIT FOR 10 ns;
    -- ###########  SOMAS ###########
    -- TESTES DE SOMA COM NúMEROS POSITIVOS

    -- Teste de soma (zero)
    select_op <= "000"; -- SOMA
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "0000000000000000"; -- 0
    WAIT FOR 50 ns; -- 0 + 0 = 0

    -- Teste de Soma 2
    select_op <= "000"; -- SOMA
    in_1 <= "0000000000000001"; -- 1
    in_2 <= "0000000000000001"; -- 1
    WAIT FOR 50 ns; -- 1 + 1 = 2

    -- Teste de Soma (CARRY)
    select_op <= "000"; -- SOMA
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "0111111111111111"; -- 32767
    WAIT FOR 50 ns; -- 32767 + 32767 = 111111111111110 mais carry flag

    -- TESTES DE SOMA COM NúMEROS Positivos e Negativos

    -- Teste de Soma (Zero)
    select_op <= "000"; -- SOMA
    in_1 <= "0000000000000001"; -- 1
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- 1 + (-1) = 0 com zero flag

    -- Teste de Soma - Resultado Positivo
    select_op <= "000"; -- SOMA
    in_1 <= "0000000000001001"; -- 9
    in_2 <= "1111111111111010"; -- -6
    WAIT FOR 50 ns; -- 9 + (-6) = 3

    -- Teste de Soma - Resultado Negativo
    select_op <= "000"; -- SOMA
    in_1 <= "1111111111110010"; -- -14
    in_2 <= "0000000000001001"; -- 9
    WAIT FOR 50 ns; -- -14 + 9 = -5

    -- TESTES DE SOMA COM NúMEROS Negativos e Negativos

    -- Teste de Soma (-2)
    select_op <= "000"; -- SOMA
    in_1 <= "1111111111111111"; -- -1
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- -1 + (-1) = -2 

    -- Teste de Soma - Estorando o limite no máximo
    select_op <= "000"; -- SOMA
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- -32768 + -32768 = 0 com carry flag - pensa que é unsigned 

    -- Teste de Soma - Resultado Negativo
    select_op <= "000"; -- SOMA
    in_1 <= "1100000000000000"; -- -16384
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- -16384 + -32768 = 16384 com carry flag - pensa que é unsigned 

    -- ###########  SUBTRAÇÕES ###########
    -- TESTES DE SUBTRAÇÃO COM NÚMEROS POSITIVOS
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "0000000000000000"; -- 0
    WAIT FOR 50 ns; -- 0 - 0 = 0 com zero flag

    -- Teste de Subtração Simples
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0000000000000010"; -- 2
    in_2 <= "0000000000000001"; -- 1
    WAIT FOR 50 ns; -- 2 - 1 = 1

    -- Teste de Subtração com Números Grandes
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "0000000000000001"; -- 1
    WAIT FOR 50 ns; -- 32767 - 1 = 32766

    -- TESTES DE SUBTRAÇÃO COM NÚMEROS Positivos e Negativos

    -- Teste de Subtração (Resultado Positivo Maior)
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0000000000000001"; -- 1
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- 1 - (-1) = 2

    -- Teste de Subtração - Resultado Positivo
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0000000000001001"; -- 9
    in_2 <= "1111111111111010"; -- -6
    WAIT FOR 50 ns; -- 9 - (-6) = 15

    -- Teste de Subtração - Resultado Negativo
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0000000000001001"; -- 9
    in_2 <= "0000000000001111"; -- 15
    WAIT FOR 50 ns; -- 9 - 15 = -6

    -- TESTES DE SUBTRAÇÃO COM NÚMEROS Negativos

    -- Teste de Subtração (Negativos)
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "1111111111111110"; -- -2
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- -2 - (-1) = -1

    -- Teste de Subtração - Números Negativos Grandes
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "1000000000000001"; -- -32767
    WAIT FOR 50 ns; -- -32768 - (-32767) = -1

    -- Teste de Subtração - Estourando Limite
    select_op <= "001"; -- SUBTRAÇÃO
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- 32767 - (-32768) = 65535 com carry flag

    -- ###########  MAIOR QUE ###########

    -- TESTES DE MAIOR QUE COM NÚMEROS Positivos
    
    -- Teste de Maior Que - zero
    select_op <= "010"; -- MAIOR QUE 
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "0000000000000000"; -- 0
    WAIT FOR 50 ns; -- 0 > 0 = 0

    -- Teste de Maior Que - limites
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "0000000000000001"; -- 1
    WAIT FOR 50 ns; -- 32767 > 1 = 1

    -- Teste de Maior Que - falso
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "0000000000000001"; -- 1
    in_2 <= "0000000000000010"; -- 2
    WAIT FOR 50 ns; -- 1 > 2 = 0

    -- TESTES DE MAIOR QUE COM NÚMEROS Negativos

    -- Teste de Maior Que - zero
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "1111111111111111"; -- -1
    in_2 <= "0000000000000000"; -- 0
    WAIT FOR 50 ns; -- -1 > 0 = 0

    -- Teste de Maior Que - limites
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "1111111111111111"; -- -1
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- -1 > -32768 = 1

    -- Teste de Maior Que - falso
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- -32768 > -1 = 0

    -- TESTES DE MAIOR QUE COM NÚMEROS Positivos e Negativos

    -- Teste de Maior Que - limites neg/pos
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "0111111111111111"; -- 32767
    WAIT FOR 50 ns; -- -32768 > 32767 = 0

    -- Teste de Maior Que - limites pos/neg
    select_op <= "010"; -- MAIOR QUE
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- 32767 > -32768 = 1

    -- ###########  MENOR QUE ###########

    -- TESTES DE MENOR QUE COM NÚMEROS Positivos

    -- Teste de Menor Que - zero
    select_op <= "011"; -- MENOR QUE
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "0000000000000000"; -- 0
    WAIT FOR 50 ns; -- 0 < 0 = 0

    -- Teste de Menor Que - limites
    select_op <= "011"; -- MENOR QUE
    in_1 <= "0000000000000001"; -- 1
    in_2 <= "0111111111111111"; -- 32767
    WAIT FOR 50 ns; -- 1 < 32767 = 1

    -- Teste de Menor Que - falso
    select_op <= "011"; -- MENOR QUE
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "0000000000000001"; -- 1
    WAIT FOR 50 ns; -- 32767 < 1 = 0

    -- TESTES DE MENOR QUE COM NÚMEROS Negativos 

    -- Teste de Menor Que - zero
    select_op <= "011"; -- MENOR QUE
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- 0 < -1 = 0

    -- Teste de Menor Que - limites
    select_op <= "011"; -- MENOR QUE
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- -32768 < -1 = 1

    -- Teste de Menor Que - falso
    select_op <= "011"; -- MENOR QUE
    in_1 <= "1111111111111111"; -- -1
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- -1 < -32768 = 0

    -- TESTES DE MENOR QUE COM NÚMEROS Positivos e Negativos

    -- Teste de Menor Que - limites pos/neg
    select_op <= "011"; -- MENOR QUE
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- 32767 < -32768 = 0

    -- Teste de Menor Que - limites neg/pos
    select_op <= "011"; -- MENOR QUE
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "0111111111111111"; -- 32767
    WAIT FOR 50 ns; -- -32768 < 32767 = 1

    -- ###########  DIFERENTE ###########

    -- TESTES DE DIFERENTE COM NÚMEROS Positivos

    -- Teste de Diferente - zero
    select_op <= "100"; -- DIFERENTE
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "0000000000000000"; -- 0
    WAIT FOR 50 ns; -- 0 != 0 = 0

    -- Teste de Diferente - limites
    select_op <= "100"; -- DIFERENTE
    in_1 <= "0111111111111111"; -- 32767
    in_2 <= "0000000000000001"; -- 1
    WAIT FOR 50 ns; -- 32767 != 1 = 1

    -- TESTES DE DIFERENTE COM NÚMEROS Negativos

    -- Teste de Diferente - diferentes
    select_op <= "100"; -- DIFERENTE
    in_1 <= "0000000000000000"; -- 0
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- 0 != -1 = 1

    -- Teste de Diferente - iguais
    select_op <= "100"; -- DIFERENTE
    in_1 <= "1111111111111111"; -- -1
    in_2 <= "1111111111111111"; -- -1
    WAIT FOR 50 ns; -- -1 != -1 = 0

    -- TESTES DE DIFERENTE COM NÚMEROS Positivos e Negativos

    -- Teste de Diferente - diferentes
    select_op <= "100"; -- DIFERENTE
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "0111111111111111"; -- 32767
    WAIT FOR 50 ns; -- -32768 != 32767 = 1

    -- Teste de Diferente - iguais
    select_op <= "100"; -- DIFERENTE  
    in_1 <= "1000000000000000"; -- -32768
    in_2 <= "1000000000000000"; -- -32768
    WAIT FOR 50 ns; -- -32768 != -32768 = 0

    WAIT;
  END PROCESS;
END ARCHITECTURE;