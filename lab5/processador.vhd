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
            zero_flag : IN STD_LOGIC;
            exception : IN STD_LOGIC; -- Novo sinal de exceção
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
            use_immediate : IN STD_LOGIC; -- signal to indicate if immediate value is used
            data_out_acc : OUT UNSIGNED(15 DOWNTO 0); -- Output for accumulator data
            data_out_reg : OUT UNSIGNED(15 DOWNTO 0) -- Output for register bank data
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

    COMPONENT RAM
        PORT (
            clk : IN STD_LOGIC;
            endereco : IN unsigned(7 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            dado_in : IN unsigned(15 DOWNTO 0);
            dado_out : OUT unsigned(15 DOWNTO 0)
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

    SIGNAL ram_endereco : UNSIGNED(7 DOWNTO 0);
    SIGNAL ram_wr_en : STD_LOGIC;
    SIGNAL ram_data_in : UNSIGNED(15 DOWNTO 0);
    SIGNAL ram_data_out : UNSIGNED(15 DOWNTO 0);
    SIGNAL is_ram_operation : STD_LOGIC;

    SIGNAL data_out_acc, data_out_reg : UNSIGNED(15 DOWNTO 0); -- Outputs for accumulator and register bank data

    SIGNAL exception : STD_LOGIC;

BEGIN
    uc : unidade_de_controle
    PORT MAP(
        clk => clk,
        rst => rst,
        carry_flag => carry_flag, -- Sinal de carry
        zero_flag => zero_flag, -- Sinal de zero
        exception => exception, -- New exception input
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
        use_immediate => is_operation_with_immediate, -- to handle immediate operations
        data_out_acc => data_out_acc, -- Connect accumulator output
        data_out_reg => data_out_reg -- Connect register bank output
    );

    c_instrucao : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_reg_instrucao,
        data_in => reg_instrucao_in,
        data_out => reg_instrucao_out
    );

    c_ram : ram
    PORT MAP(
        clk => clk,
        endereco => ram_endereco,
        wr_en => ram_wr_en,
        dado_in => ram_data_in,
        dado_out => ram_data_out
    );

    reg_instrucao_in <= ('0' & uc_instrucao);

    wr_en_reg_instrucao <= '1' WHEN uc_estado = "01" ELSE
        '0'; -- Decode

    wr_en_reg_ULA <= '1' WHEN (uc_estado = "10" AND NOT -- Só escreve nos registradores da ULA quando não é branch
        (opcode = "1111" OR (opcode = "0111" AND (reg_instrucao_out(10 DOWNTO 8) = "010" OR reg_instrucao_out(10 DOWNTO 8) = "001" OR
        reg_instrucao_out(10 DOWNTO 8) = "000")))) ELSE
        '0'; -- Execute

    opcode <= reg_instrucao_out(14 DOWNTO 11); -- 4 MSB da instrução

    is_operation_with_immediate <= '1' WHEN (opcode = "0101" OR opcode = "0001" OR opcode = "1111") ELSE
        '0'; -- LI or SUBI or CMPI

    imediato <= (15 DOWNTO 8 => reg_instrucao_out(7)) & reg_instrucao_out(7 DOWNTO 0); -- Extensão de sinal 8 LSB da instrução 

    reg_ULA_data_in <= imediato WHEN (is_operation_with_immediate = '1') ELSE
        ram_data_out WHEN (is_ram_operation = '1' AND opcode = "1110") ELSE -- LW operation
        (OTHERS => '0'); -- Dados de entrada para ULA

    -- ADD: 1000, SUB: 1001, SUBI: 0001, CMPI: 1111
    exec_en <= '1' WHEN ((uc_estado = "10") AND -- Only during execute stage
        (opcode = "1000" OR -- ADD
        opcode = "1001" OR -- SUB
        opcode = "0001" OR -- SUBI
        opcode = "1111")) -- CMPI
        ELSE
        '0';

    -- RAM control logic
    is_ram_operation <= '1' WHEN (opcode = "1110" OR opcode = "0010") ELSE
        '0'; -- LW or SW

    ram_endereco <= data_out_acc(7 DOWNTO 0) WHEN is_ram_operation = '1' ELSE
        (OTHERS => '0'); -- Always the 7 LSB of accumulator

    -- RAM data input for SW operations
    ram_data_in <= data_out_reg; -- Data from register bank for SW operations

    -- RAM write enable for SW operations
    ram_wr_en <= '1' WHEN (opcode = "0010" AND uc_estado = "10") ELSE
        '0'; -- SW in execute stage

    exception <= '1' WHEN (is_ram_operation = '1' AND uc_estado = "10" AND
        data_out_acc > 127) ELSE
        '0';

END ARCHITECTURE;