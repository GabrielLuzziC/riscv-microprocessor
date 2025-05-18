library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador is
    port(
        clk : in std_logic;
        rst : in std_logic;
        data_in : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity acumulador;

architecture a_acumulador of acumulador is
    signal wr_en : std_logic := '1'; --sempre escreve nele
    component reg16bits
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0)
        );
    end component;
begin
    uut: reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
        );
end architecture;