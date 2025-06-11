LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Componentes
-- Atualizar código e testbench nas pastas adequadas

-- reg_ULA
-- unidade_de_controle (PC_ROM e maquina de estados está dentro)
-- reg_instrucao

ENTITY processador IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE a_processador OF processador IS
    COMPONENT unidade_de_controle
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            carry_flag : IN STD_LOGIC; -- Sinal de carry
            estado : OUT UNSIGNED(1 DOWNTO 0); -- Estado da máquina de estados
            instrucao : OUT UNSIGNED(14 DOWNTO 0) -- Instrução a ser executada
        );
    END COMPONENT;

    COMPONENT reg_ULA
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            selec_op : IN UNSIGNED(2 DOWNTO 0);
            carry_flag : OUT STD_LOGIC;
            zero_flag : OUT STD_LOGIC;
            selec_reg_in : IN UNSIGNED(2 DOWNTO 0);
            selec_reg_out : IN UNSIGNED(2 DOWNTO 0);
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0);
            exec_en : IN STD_LOGIC;
            use_immediate : IN STD_LOGIC -- signal to indicate if immediate value is used
        );
    END COMPONENT;

    COMPONENT reg16bits
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL reg_instrucao_out, reg_instrucao_in : UNSIGNED(15 DOWNTO 0);
    SIGNAL reg_ULA_data_in, reg_ULA_data_out : UNSIGNED(15 DOWNTO 0);
    SIGNAL uc_estado : UNSIGNED(1 DOWNTO 0); -- Estado da máquina de estados
    SIGNAL uc_instrucao : UNSIGNED(14 DOWNTO 0); -- Instrução a ser executada
    SIGNAL wr_en_reg_instrucao, wr_en_reg_ULA : STD_LOGIC;
    SIGNAL carry_flag, zero_flag : STD_LOGIC;
    SIGNAL opcode : UNSIGNED(3 DOWNTO 0); -- 4 MSB da instrução
    SIGNAL imediato : UNSIGNED(15 DOWNTO 0);
    SIGNAL is_operation_with_immediate : STD_LOGIC;
    SIGNAL exec_en : STD_LOGIC; -- NEW: to enable flag updates

BEGIN
    uc : unidade_de_controle
    PORT MAP(
        clk => clk,
        rst => rst,
        carry_flag => carry_flag, -- Sinal de carry
        estado => uc_estado,
        instrucao => uc_instrucao
    );

    c_reg_ULA : reg_ULA
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_reg_ULA,
        selec_op => reg_instrucao_out(13 DOWNTO 11), -- Bits 13 ao 11 da instrução
        carry_flag => carry_flag,
        zero_flag => zero_flag,
        selec_reg_in => reg_instrucao_out(10 DOWNTO 8), -- Bits 10 ao 8 da instrução
        selec_reg_out => reg_instrucao_out(7 DOWNTO 5), -- Bits 7 ao 5 da instrução
        data_in => reg_ULA_data_in, -- Dados de entrada
        data_out => reg_ULA_data_out, -- Dados de saída
        exec_en => exec_en, -- Connection to enable flag updates
        use_immediate => is_operation_with_immediate -- to handle immediate operations
    );

    c_instrucao : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_reg_instrucao,
        data_in => reg_instrucao_in,
        data_out => reg_instrucao_out
    );

    reg_instrucao_in <= ('0' & uc_instrucao);

    wr_en_reg_instrucao <= '1' WHEN uc_estado = "01" ELSE
    '0'; -- Decode

    wr_en_reg_ULA <= '1' WHEN uc_estado = "10" ELSE
    '0'; -- Execute

    opcode <= reg_instrucao_out(14 DOWNTO 11); -- 4 MSB da instrução

    is_operation_with_immediate <= '1' WHEN (opcode = "0101" OR opcode = "0001") ELSE
    '0'; -- MOV or SUBI

    imediato <= (15 DOWNTO 8 => reg_instrucao_out(7)) & reg_instrucao_out(7 DOWNTO 0); -- Extensão de sinal 5 LSB da instrução 

    reg_ULA_data_in <= imediato WHEN (is_operation_with_immediate = '1' OR opcode = "1111") ELSE -- REVER ISSO
    (OTHERS => '0'); -- Dados de entrada para ULA

    -- Identify which operations should update flags based on opcode
    -- ADD: 1000, SUB: 1001, SUBI: 0001, CMPI: 1111
    exec_en <= '1' WHEN ((uc_estado = "10") AND -- Only during 
    (opcode = "1000" OR -- ADD
    opcode = "1001" OR -- SUB
    opcode = "0001" OR -- SUBI
    opcode = "1111")) -- CMPI
    ELSE
    '0';

END ARCHITECTURE;