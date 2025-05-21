LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_ULA IS
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
        PORT(
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ULA IS
         PORT (
            selec_op : IN UNSIGNED (2 DOWNTO 0);
            in_1, in_2 : IN UNSIGNED (15 DOWNTO 0);
            boolean_flag : OUT STD_LOGIC;
            carry_flag : OUT STD_LOGIC;
            zero_flag : OUT STD_LOGIC; -- Talvez usar a zero_flag como boolean_flag??? 0 = false, 1 = true
            output : OUT UNSIGNED (15 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL data_out_reg, data_out_acc, data_out_ula : UNSIGNED(15 DOWNTO 0) := (others => '0');
    
BEGIN
    breg : banco_reg
        PORT MAP (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            selec_reg_in => selec_reg_in,
            selec_reg_out => selec_reg_out,
            data_in => data_in,
            data_out => data_out_reg
        );
    
    acc : acumulador
        PORT MAP (
            clk => clk,
            rst => rst,
            data_in => data_out_ula,
            data_out => data_out_acc
        );
    a_ula : ULA
        PORT MAP (
            selec_op => selec_op,
            in_1 => data_out_reg,
            in_2 => data_out_acc,
            boolean_flag => boolean_flag,
            carry_flag => carry_flag,
            zero_flag => zero_flag,
            output => data_out_ula
        );

    data_out <= data_out_ula;
END ARCHITECTURE;