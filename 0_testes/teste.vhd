library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity teste is
    port(
        clk, rst: in STD_LOGIC
    );
end entity teste;

architecture rtl of teste is
    signal counter, negativo : UNSIGNED(3 downto 0) := "0000";
    signal pulso             : STD_LOGIC := '0';
begin

    contagem: process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= "0000";
                pulso <= '0';
            elsif counter < "1111" then
                counter <= counter + 1;
                pulso <= '0';
            else
                counter <= "0000";
                pulso <= '1';
            end if;
        end if;
    end process contagem;

    negativo <= 0 - counter;
end architecture rtl;
