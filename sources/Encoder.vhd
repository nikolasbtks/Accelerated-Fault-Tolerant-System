library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Encoder is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        din : in std_logic_vector(7 downto 0);
        dout : out std_logic_vector(12 downto 0)
    );
end Encoder;

architecture Behavioral of Encoder is
    signal dout_reg : std_logic_vector(12 downto 0);
begin
    --8 data bits , 4 Hamming parity bits, 1 overall parity bit
    process(clk)
        variable p1,p2,p4,p8,p0 : std_logic;
    begin
        if rising_edge(clk) then
            if rst = '1' or ce = '0' then
                dout_reg <= (others => '0');
            elsif ce = '1' then
                p1 := din(7) xor din(6) xor din(4) xor din(3) xor din(1);
                p2 := din(7) xor din(5) xor din(4) xor din(2) xor din(1);
                p4 := din(6) xor din(5) xor din(4) xor din(0);
                p8 := din(3) xor din(2) xor din(1) xor din(0);
                p0 := p1 xor p2 xor din(7) xor p4 xor din(6) xor din(5) xor din(4) xor 
                      p8 xor din(3) xor din(2) xor din(1) xor din(0);
                      
                dout_reg(12) <= p1;  
                dout_reg(11) <= p2;   
                dout_reg(10) <= din(7);
                dout_reg(9) <= p4;
                dout_reg(8) <= din(6);
                dout_reg(7) <= din(5);
                dout_reg(6) <= din(4);
                dout_reg(5) <= p8;
                dout_reg(4) <= din(3);
                dout_reg(3) <= din(2);
                dout_reg(2) <= din(1);
                dout_reg(1) <= din(0);     
                dout_reg(0) <= p0;

            end if;
         end if;   
    end process;
    
    dout <= dout_reg; 
end Behavioral;
