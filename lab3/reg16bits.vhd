library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits is 
    port ( clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            wr_en : in STD_LOGIC;
            data_in : in UNSIGNED(15 downto 0);
            data_out : out UNSIGNED(15 downto 0)
    );
end entity;

architecture a_reg16bits of reg16bits is
    signal registro : UNSIGNED(15 downto 0);
begin
    process (clk, rst, wr_en)
    begin
        if rst = '1' then
            registro <= (others => '0');
        elsif wr_en = '1' then
            if (rising_edge(clk)) then
                registro <= data_in;
            end if;
        end if;
    end process;

    data_out <= registro;
end architecture;