LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_ULA IS
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
        is_mov : IN STD_LOGIC -- Sinal para indicar se a operação é MOV
    );
END ENTITY;

ARCHITECTURE a_reg_ULA OF reg_ULA IS
    COMPONENT banco_reg
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            selec_reg_in : IN UNSIGNED(2 DOWNTO 0);
            selec_reg_out : IN UNSIGNED(2 DOWNTO 0);
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT acumulador
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ULA IS
        PORT (
            selec_op : IN UNSIGNED (2 DOWNTO 0);
            in_1, in_2 : IN UNSIGNED (15 DOWNTO 0);
            carry_flag : OUT STD_LOGIC;
            zero_flag : OUT STD_LOGIC;
            output : OUT UNSIGNED (15 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL data_out_reg, data_out_acc, data_out_ula : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mux_reg_imediato : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0'); -- Sinal para o mux do acumulador com valor constante
    SIGNAL mux_acc : UNSIGNED(15 DOWNTO 0); -- Sinal para o mux do acumulador
    SIGNAL load_reg_acc : STD_LOGIC; -- Sinal para carregar o registrador acumulador
    SIGNAL load_acc : STD_LOGIC; -- Sinal para carregar ou não o acumulador
    SIGNAL data_in_acc : UNSIGNED(15 DOWNTO 0); -- Sinal de entrada do acumulador
    SIGNAL data_in_imediato : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0'); -- Sinal de entrada do imediato

BEGIN
    breg : banco_reg
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        selec_reg_in => selec_reg_in,
        selec_reg_out => selec_reg_out,
        data_in => mux_acc,
        data_out => data_out_reg
    );

    acc : acumulador
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in_acc,
        data_out => data_out_acc
    );
    a_ula : ULA
    PORT MAP(
        selec_op => selec_op,
        in_1 => data_out_acc,
        in_2 => mux_reg_imediato,
        carry_flag => carry_flag,
        zero_flag => zero_flag,
        output => data_out_ula
    );

    data_out <= data_out_ula;
    load_acc <= '1' WHEN (selec_reg_in = "111" AND selec_op = "101" AND is_mov = '0') ELSE
        '0'; -- Carrega o acumulador se o registrador de entrada for o acumulador e a operação for LOAD
    data_in_acc <= data_out_ula WHEN load_acc = '0' ELSE
        data_in;
    load_reg_acc <= '1' WHEN (selec_reg_out = "111" AND selec_op = "101") ELSE
        '0'; -- Carrega o registrador acumulador se o registrador de entrada for o acumulador e a operação não for LOAD
    mux_acc <= data_out_acc WHEN load_reg_acc = '1' ELSE 
        data_in; -- Se o registrador de saída for o acumulador, usa o valor do acumulador, caso contrário, usa a entrada

    mux_reg_imediato <= data_in_imediato WHEN (selec_op = "010") ELSE
        data_out_reg; -- Se a operação for com imediato, usa o valor do imediato, caso contrário, usa o valor do registrador de saída
END ARCHITECTURE;