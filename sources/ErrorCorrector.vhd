library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ErrorCorrector is
    port(
        din : in std_logic_vector(12 downto 0);
        derror : out std_logic;
        double_error : out std_logic;
        dout : out std_logic_vector(12 downto 0)
    );
end ErrorCorrector;

architecture Behavioral of ErrorCorrector is
    signal s1,s2,s4,s8 : std_logic;
    signal pcheck : std_logic;
    signal syndrome : unsigned(3 downto 0);
begin
    s1 <= din(12) xor din(10) xor din(8) xor din(6) xor din(4) xor din(2);  
    s2 <= din(11) xor din(10) xor din(7) xor din(6) xor din(3) xor din(2); 
    s4 <= din(9) xor din(8) xor din(7) xor din(6) xor din(1);  
    s8 <= din(5) xor din(4) xor din(3) xor din(2) xor din(1);  
            
    pcheck <= din(12) xor din(11) xor din(10) xor din(9) xor din(8) xor din(7) xor 
                          din(6) xor din(5) xor din(4) xor din(3) xor din(2) xor din(1) xor din(0);

    syndrome <= (3 => s8,
                 2 => s4,
                 1 => s2,
                 0 => s1);                 
    
    process(syndrome, pcheck, din)
        variable temporary : std_logic_vector(12 downto 0);
    begin
        temporary := din;
        
        if(syndrome = 0 and pcheck = '0') then
            dout <= din;
            derror <= '0';
            double_error <= '0';
        elsif (syndrome /= 0 and pcheck = '1') then
            temporary(13 - to_integer(syndrome)) := not din(13 - to_integer(syndrome));
            dout <= temporary;
            derror <= '1';
            double_error <= '0';
        elsif (syndrome = 0 and pcheck = '1') then
            temporary(0) := not din(0);
            dout <= temporary;
            derror <= '1';
            double_error <= '0';           
        else
            dout <= "0000000000000";
            derror <= '1';
            double_error <= '1';    
        end if;
    end process;
end Behavioral;