LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC_ROM IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : IN UNSIGNED(15 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        data_out : OUT UNSIGNED(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE a_PC_ROM OF PC_ROM IS
    SIGNAL data_temp_out : UNSIGNED(15 DOWNTO 0);
    SIGNAL rom_temp_out : UNSIGNED(14 DOWNTO 0);
    SIGNAL instrucao : UNSIGNED(14 DOWNTO 0);
    SIGNAL endereco : UNSIGNED(6 DOWNTO 0);
    COMPONENT PC_soma IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(15 DOWNTO 0);
            data_out : OUT UNSIGNED(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ROM IS
        PORT (
            clk : IN STD_LOGIC;
            endereco : IN UNSIGNED(6 DOWNTO 0);
            dado : OUT UNSIGNED(14 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    uut : PC_soma
    PORT MAP(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_temp_out
    );

    uut_rom : ROM
    PORT MAP(
        clk => clk,
        endereco => endereco,
        dado => instrucao
    );

    data_out <= data_temp_out;
    endereco <= data_temp_out(6 DOWNTO 0);
END ARCHITECTURE;