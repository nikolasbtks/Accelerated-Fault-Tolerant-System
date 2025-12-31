library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ErrorCorrector is
end tb_ErrorCorrector;

architecture Behavioral of tb_ErrorCorrector is
     signal din : std_logic_vector(12 downto 0) := (others => '0');
     signal derror : std_logic;
     signal double_error : std_logic;
     signal dout : std_logic_vector(12 downto 0);
begin

    uut : entity work.ErrorCorrector
        port map(
            din => din,
            derror => derror,
            double_error => double_error,
            dout => dout
        );
    
    stimulus : process
    begin
        din <= "1001100111101";
        wait for 20ns;
        
        din <= "1001100111101" xor "0001000000000";
        wait for 20ns;        

        din <= "1001100111101" xor "0000000000001";
        wait for 20ns;   
 
        din <= "1001100111101" xor "0010000000001";
        wait for 20ns; 
        
        wait;
    end process;
end Behavioral;
