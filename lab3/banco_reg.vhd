LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY banco_reg IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        wr_en : IN STD_LOGIC;
        selec_reg_in : IN UNSIGNED(2 DOWNTO 0);
        selec_reg_out : IN UNSIGNED(2 DOWNTO 0);
        data_in : IN UNSIGNED(15 DOWNTO 0);
        data_out : OUT UNSIGNED(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE a_banco_reg OF banco_reg IS
    SIGNAL reg0, reg1, reg2, reg3, reg4, reg5, reg6 : UNSIGNED(15 DOWNTO 0);
    SIGNAL data_out_temp : UNSIGNED(15 DOWNTO 0);
    SIGNAL wr_en_0, wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6 : STD_LOGIC;

    COMPONENT reg16bits
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    data_out <= data_out_temp;

    data_out_temp <= reg0 WHEN (selec_reg_out = "000") ELSE
        reg1 WHEN (selec_reg_out = "001") ELSE
        reg2 WHEN (selec_reg_out = "010") ELSE
        reg3 WHEN (selec_reg_out = "011") ELSE
        reg4 WHEN (selec_reg_out = "100") ELSE
        reg5 WHEN (selec_reg_out = "101") ELSE
        reg6 WHEN (selec_reg_out = "110") ELSE
        (OTHERS => '0');

    wr_en_0 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "000") ELSE
        '0';
    wr_en_1 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "001") ELSE
        '0';
    wr_en_2 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "010") ELSE
        '0';
    wr_en_3 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "011") ELSE
        '0';
    wr_en_4 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "100") ELSE
        '0';
    wr_en_5 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "101") ELSE
        '0';
    wr_en_6 <= '1' WHEN (wr_en = '1' AND selec_reg_in = "110") ELSE
        '0';
    reg0_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_0,
        data_in => data_in,
        data_out => reg0
    );
    reg1_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_1,
        data_in => data_in,
        data_out => reg1
    );
    reg2_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_2,
        data_in => data_in,
        data_out => reg2
    );
    reg3_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_3,
        data_in => data_in,
        data_out => reg3
    );
    reg4_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_4,
        data_in => data_in,
        data_out => reg4
    );
    reg5_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_5,
        data_in => data_in,
        data_out => reg5
    );
    reg6_inst : reg16bits
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en_6,
        data_in => data_in,
        data_out => reg6
    );
END ARCHITECTURE;