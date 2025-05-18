library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_ULA is
    port (
        clk   : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        boolean_flag : out std_logic;
        carry_flag : out std_logic;
        zero_flag : out std_logic;
        selec_reg_in : in UNSIGNED(2 downto 0);
        selec_reg_out : in UNSIGNED(2 downto 0);
        data_in : in UNSIGNED(15 downto 0);
        data_out : out UNSIGNED(15 downto 0)  
    );
end entity;

architecture a_reg_ULA of reg_ULA is
    component banco_reg
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            wr_en : in STD_LOGIC;
            selec_reg_in : in UNSIGNED(2 downto 0);
            selec_reg_out : in UNSIGNED(2 downto 0);
            data_in : in UNSIGNED(15 downto 0);
            data_out : out UNSIGNED(15 downto 0)
        );
    end component;
    component acumulador
        port(
            clk : in std_logic;
            rst : in std_logic;
            data_in : in UNSIGNED(15 downto 0);
            data_out : out UNSIGNED(15 downto 0)
        );
    end component;
    component  ULA IS
         PORT (
            selec_op : IN UNSIGNED (2 DOWNTO 0);
            in_1, in_2 : IN UNSIGNED (15 DOWNTO 0);
            boolean_flag : OUT STD_LOGIC;
            carry_flag : OUT STD_LOGIC;
            zero_flag : OUT STD_LOGIC; -- Talvez usar a zero_flag como boolean_flag??? 0 = false, 1 = true
            output : OUT UNSIGNED (15 DOWNTO 0)
        );
    end component;
    signal data_out_reg, data_out_acc : UNSIGNED(15 downto 0);
    
begin
    breg : banco_reg
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            selec_reg_in => selec_reg_in,
            selec_reg_out => selec_reg_out,
            data_in => data_in,
            data_out => data_out_reg
        );
    
    acc : acumulador
        port map (
            clk => clk,
            rst => rst,
            data_in => data_out,
            data_out => data_out_acc
        );
    a_ula : ULA
        port map (
            selec_op => "000", -- Adição
            in_1 => data_out_reg,
            in_2 => data_in,
            boolean_flag => boolean_flag,
            carry_flag => carry_flag,
            zero_flag => zero_flag,
            output => data_out
        );
    

    

end architecture;