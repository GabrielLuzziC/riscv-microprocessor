library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity teste_tb is
end entity teste_tb;

architecture rtl of teste_tb is
    component teste is
        port
        (
            clk : IN STD_LOGIC ;
            rst : IN STD_LOGIC
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    
    signal CLK   : std_logic;
    signal RESET : std_logic;
begin

    uut: teste port map(CLK,RESET);
    
    reset_global: process
    begin
        RESET <= '1';
        wait for period_time*4;
        RESET <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

end architecture rtl;