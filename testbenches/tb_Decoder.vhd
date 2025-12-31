library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Decoder is
end tb_Decoder;

architecture Behavioral of tb_Decoder is
    constant CLK_PERIOD : time := 1.55 ns;
    
     signal clk : std_logic := '0';
     signal rst : std_logic := '1';
     signal ce : std_logic := '0';
     signal din : std_logic_vector(12 downto 0) := (others => '0');
     signal dout : std_logic_vector(7 downto 0);    
begin

    uut : entity work.Decoder
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            din => din,
            dout => dout
        );
    
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD;
            clk <= '1';
            wait for CLK_PERIOD;
        end loop;
    end process;
    
    stim_process : process
    begin
        rst <= '1';
        ce <= '0';
        wait until rising_edge(clk);
        rst <= '0';
        ce <= '1';
        
        din <= "1001100111101"; --1
        wait until rising_edge(clk);
        
        din <= "0011011001010"; --2
        wait until rising_edge(clk);        

        din <= "1001100111100"; --1 parity flip
        wait until rising_edge(clk);   
   
         din <= "1011011001010"; --2 data flip
        wait until rising_edge(clk);    

        din <= "0001100111100"; --1 parity and data flip
        wait until rising_edge(clk);            
        
        din <= "0011011001010"; --2
        wait until rising_edge(clk);  
        
        din <= "1011111001010"; --2 data and data flip
        wait until rising_edge(clk);          
        wait;            
    end process;
end Behavioral;
