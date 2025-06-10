LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC_ROM IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : IN UNSIGNED(6 DOWNTO 0); -- Address to jump to
        wr_en : IN STD_LOGIC; -- Enable PC increment
        jump_en : IN UNSIGNED(1 DOWNTO 0); -- 00=nenhum, 01=absoluto, 10=relativo
        data_out : OUT UNSIGNED(14 DOWNTO 0) -- Instruction output
    );
END ENTITY;

ARCHITECTURE a_PC_ROM OF PC_ROM IS
    SIGNAL rom_temp_out : UNSIGNED(14 DOWNTO 0);
    SIGNAL instrucao : UNSIGNED(14 DOWNTO 0);
    SIGNAL endereco : UNSIGNED(6 DOWNTO 0);
    COMPONENT PC_soma IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN UNSIGNED(6 DOWNTO 0);
            jump_en : IN UNSIGNED(1 DOWNTO 0); 
            data_out : OUT UNSIGNED(6 DOWNTO 0)
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
        jump_en => jump_en,
        data_in => data_in,
        data_out => endereco
    );

    uut_rom : ROM
    PORT MAP(
        clk => clk,
        endereco => endereco,
        dado => instrucao
    );

    data_out <= instrucao;
END ARCHITECTURE;