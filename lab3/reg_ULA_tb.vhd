LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_ULA_tb IS
END ENTITY;

ARCHITECTURE a_reg_ULA_tb OF reg_ULA_tb IS
    COMPONENT reg_ULA
        PORT (
            clk   : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            selec_op : IN UNSIGNED(2 DOWNTO 0);
            boolean_flag : OUT STD_LOGIC;
            carry_flag : OUT STD_LOGIC;
            zero_flag : OUT STD_LOGIC;
            selec_reg_in : IN UNSIGNED(2 DOWNTO 0);
            selec_reg_out : IN UNSIGNED(2 DOWNTO 0);
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)  
        );
    END COMPONENT;
    -- define e inicializa os sinais
    SIGNAL data_in, data_out : UNSIGNED(15 DOWNTO 0) := (others => '0');
    SIGNAL selec_reg_in, selec_reg_out : UNSIGNED(2 DOWNTO 0) := (others => '0');
    SIGNAL finished, clk, rst, wr_en : STD_LOGIC := '0';
    CONSTANT period_time : TIME := 100 ns;
BEGIN 
    uut : reg_ULA
        PORT MAP(
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            selec_op => "000", -- Testando a ULA + Banco de Reg com a operação de soma
            boolean_flag => open,
            carry_flag => open,
            zero_flag => open,
            selec_reg_in => selec_reg_in,
            selec_reg_out => selec_reg_out,
            data_in => data_in,
            data_out => data_out
        );
    
    reset_global : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR period_time * 2;
        rst <= '0';
        WAIT;
    END PROCESS;

    sim_time_proc : PROCESS
    BEGIN
        WAIT FOR 10 us;
        finished <= '1';
        WAIT;
    END PROCESS sim_time_proc;

    clk_proc : PROCESS
    BEGIN
        WHILE finished /= '1' LOOP
            clk <= '0';
            WAIT FOR period_time/2;
            clk <= '1';
            WAIT FOR period_time/2;
        END LOOP;
        WAIT;
    END PROCESS clk_proc;

    PROCESS
    BEGIN 
        WAIT FOR 200 ns; -- TEMPO DE ESPERA PARA O INICIO DO TESTE
        -- Teste de Banco de Registradores + ULA
        data_in <= "0000000000000001";
        selec_reg_in <= "000";
        selec_reg_out <= "000";
        wr_en <= '1';
        WAIT FOR period_time;

        data_in <= "0000000000000010";
        selec_reg_in <= "000";
        selec_reg_out <= "000";
        wr_en <= '1';
        WAIT FOR period_time;

        data_in <= "0000000000000011";
        selec_reg_in <= "000";
        selec_reg_out <= "000"; -- registrador usado na entrada da ULA
        wr_en <= '1';
        WAIT FOR period_time;
        data_in <= "0000000000000100";
        selec_reg_in <= "000";
        selec_reg_out <= "000"; -- registrador usado na entrada da ULA
        wr_en <= '1';
        WAIT FOR period_time;

        WAIT;
    END PROCESS;

END ARCHITECTURE a_REG_ULA_tb;