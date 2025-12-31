library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ECC is
end tb_ECC;

architecture Behavioral of tb_ECC is
    constant CLK_PERIOD : time := 1.55 ns;
        
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ce : std_logic := '0'; 
    signal we : std_logic := '0';
    signal din : std_logic_vector(7 downto 0) := (others => '0');
    signal dout : std_logic_vector(7 downto 0);
begin
    uut : entity work.ECC    
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            we => we,
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
    
    stimulus : process
    begin
        rst <= '1';
        ce <= '0';
        we <= '0';
        wait until rising_edge(clk);
        rst <= '0';
        ce <= '1';
        we <= '1';  
        
        din <= std_logic_vector(to_signed(3,8));    
        wait until rising_edge(clk);
        
        din <= std_logic_vector(to_signed(8,8)); 
        wait until rising_edge(clk); 
        
        din <= std_logic_vector(to_signed(1,8)); 
        wait until rising_edge(clk); 
        
        wait;       
    end process;
    
end Behavioral;
