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
        exec_en : IN STD_LOGIC; -- Enable writing to flag registers during execute stage
        use_immediate : IN STD_LOGIC; -- New signal to indicate if immediate value is used
        selec_reg_in : IN UNSIGNED(2 DOWNTO 0);
        selec_reg_out : IN UNSIGNED(2 DOWNTO 0);
        data_in : IN UNSIGNED(15 DOWNTO 0);
        data_out : OUT UNSIGNED(15 DOWNTO 0)
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
            exec_en : IN STD_LOGIC; -- Enable writing to flag registers during execute stage
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
    SIGNAL wr_en_acc : STD_LOGIC;
    SIGNAL is_mov_op : STD_LOGIC; -- New signal to detect MOV operations

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
        wr_en => wr_en_acc,
        data_in => data_in_acc,
        data_out => data_out_acc
    );
    a_ula : ULA
    PORT MAP(
        selec_op => selec_op,
        in_1 => data_out_acc,
        in_2 => mux_reg_imediato,
        exec_en => exec_en, -- Enable flag updates during execution
        carry_flag => carry_flag,
        zero_flag => zero_flag,
        output => data_out_ula
    );

    -- THE FIXED PART - Update these signal assignments
    -- Detect MOV operation (opcode 101)
    is_mov_op <= '1' WHEN selec_op = "101" ELSE
        '0';

    -- Output the ULA result
    data_out <= data_out_ula;

    -- Logic for writing to accumulator in MOV operation
    -- If it's a MOV operation and the destination is accumulator (111)
    load_acc <= '1' WHEN (selec_reg_in = "111" AND is_mov_op = '1') ELSE
        '0';

    -- Data input for accumulator comes from:
    -- 1. If it's a MOV to accumulator: use data_out_reg (from register bank)
    -- 2. Otherwise: use ULA output
    data_in_acc <= data_out_reg WHEN (load_acc = '1') ELSE
        data_out_ula;

    -- Logic for using accumulator as source in MOV operation
    -- If the source register is accumulator (111), use accumulator value
    load_reg_acc <= '1' WHEN (selec_reg_out = "111") ELSE
        '0';

    -- Data input for register bank:
    -- If source is accumulator, use accumulator value
    mux_acc <= data_out_acc WHEN load_reg_acc = '1' ELSE
        data_in;

    -- Select register bank or immediate value for ULA
    mux_reg_imediato <= data_in WHEN (use_immediate = '1') ELSE
        data_out_reg;

    -- Enable writing to accumulator:
    -- 1. Enable when destination is accumulator and it's a MOV operation
    -- 2. Enable when it's a regular operation (non-MOV)
    -- 3. Disable when it's a MOV from accumulator to register
    wr_en_acc <= '1' WHEN (selec_reg_in = "111" AND is_mov_op = '1' AND wr_en = '1') ELSE -- Enable for MOV TO accumulator
        '0' WHEN (selec_reg_out = "111" AND is_mov_op = '1' AND wr_en = '1') ELSE -- Disable for MOV FROM accumulator
        wr_en; -- Normal operations
END ARCHITECTURE;