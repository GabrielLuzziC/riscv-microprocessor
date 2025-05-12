library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is 
    port ( selec_op : in unsigned (2 downto 0);
           in_1, in_2 : in unsigned (15 downto 0);
           boolean_flag : out std_logic;
           carry_flag : out std_logic;
           zero_flag : out std_logic;
           output : out unsigned (15 downto 0)
    );
end entity;

architecture a_ULA of ULA is
    signal in_1_temp, in_2_temp, out_temp : unsigned (16 downto 0);

begin   
    output <= in_1 + in_2 when (selec_op = "000") else
              in_1 - in_2 when (selec_op = "001") else
              "0000000000000000";
           
    boolean_flag <= '1' when (selec_op = "010" and in_1 > in_2) else
                    '1' when (selec_op = "011" and in_1 < in_2) else
                    '1' when (selec_op = "100" and in_1 /= in_2) else
                    '0';

    in_1_temp <= '0' & in_1;
    in_2_temp <= '0' & in_1;
    out_temp <= in_1_temp + in_2_temp;
    carry_flag <= '1' when (out_temp(16) = '1') else
                  '0';
    zero_flag <= '1' when (output = "0000000000000000") else
                 '0';
end architecture;