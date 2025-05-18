library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits_tb of reg16bits_tb is
    component reg16bits
        port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               wr_en : in STD_LOGIC;
               data_in : in UNSIGNED(15 downto 0);
               data_out : out UNSIGNED(15 downto 0)
        );
    end component;
    signal data_in, data_out : UNSIGNED(15 downto 0);
    signal clk, rst, wr_en : STD_LOGIC;
    signal finished : STD_LOGIC := '0';
    constant period_time : TIME := 100 ns;
begin
    uut: reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
        );
    
    reset_global: process 
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
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
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process 
    begin 
        wait for 200 ns;
        wr_en <= '0';
        data_in <= (others => '1');
        wait for 200 ns;
        wr_en <= '1';
        data_in <= (others => '1');
        wait for 200 ns;
        wr_en <= '0';
        data_in <= (others => '0');
        wait for 200 ns;
        wait;
    end process;
end architecture;