library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        wr_en : in STD_LOGIC;
        selec_reg_in : in UNSIGNED(2 downto 0);
        selec_reg_out : in UNSIGNED(2 downto 0);
        data_in : in UNSIGNED(15 downto 0);
        data_out : out UNSIGNED(15 downto 0)
    );
end entity;

architecture a_banco_reg of banco_reg is
    signal reg0, reg1, reg2, reg3, reg4, reg5, reg6 : UNSIGNED(15 downto 0);
    signal data_out_temp : UNSIGNED(15 downto 0);
    signal wr_en_0, wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6 : STD_LOGIC;
    
    component reg16bits
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            wr_en : in STD_LOGIC;
            data_in : in UNSIGNED(15 downto 0);
            data_out : out UNSIGNED(15 downto 0)
        );
    end component;

begin
    data_out_temp <= reg0 when (selec_reg_out = "000") else
        reg1 when (selec_reg_out = "001") else
        reg2 when (selec_reg_out = "010") else
        reg3 when (selec_reg_out = "011") else
        reg4 when (selec_reg_out = "100") else
        reg5 when (selec_reg_out = "101") else
        reg6 when (selec_reg_out = "110") else
        (others => '0');
    
    wr_en_0 <= '1' when (wr_en =  '1' and selec_reg_out = "000") else '0';
    wr_en_1 <= '1' when (wr_en =  '1' and selec_reg_out = "001") else '0';
    wr_en_2 <= '1' when (wr_en =  '1' and selec_reg_out = "010") else '0';
    wr_en_3 <= '1' when (wr_en =  '1' and selec_reg_out = "011") else '0';
    wr_en_4 <= '1' when (wr_en =  '1' and selec_reg_out = "100") else '0';
    wr_en_5 <= '1' when (wr_en =  '1' and selec_reg_out = "101") else '0';
    wr_en_6 <= '1' when (wr_en =  '1' and selec_reg_out = "110") else '0';
    reg0_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_0,
            data_in => data_in,
            data_out => reg0
        );
    reg1_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_1,
            data_in => data_in,
            data_out => reg1
        );
    reg2_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_2,
            data_in => data_in,
            data_out => reg2
        );
    reg3_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_3,
            data_in => data_in,
            data_out => reg3
        );
    reg4_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_4,
            data_in => data_in,
            data_out => reg4
        );
    reg5_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_5,
            data_in => data_in,
            data_out => reg5
        );
    reg6_inst : reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en_6,
            data_in => data_in,
            data_out => reg6
        );
    
    process (selec_reg_out, selec_reg_in, clk, rst, wr_en)
    begin
        if(wr_en = '1') then
            case selec_reg_in is
                when "000" => reg0 <= data_in;
                when "001" => reg1 <= data_in;
                when "010" => reg2 <= data_in;
                when "011" => reg3 <= data_in;
                when "100" => reg4 <= data_in;
                when "101" => reg5 <= data_in;
                when "110" => reg6 <= data_in;
                when others => null;
            end case;
        end if;
    end process;
end architecture;