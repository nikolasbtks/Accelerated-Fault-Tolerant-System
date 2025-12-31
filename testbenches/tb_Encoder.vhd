library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Encoder is
end tb_Encoder;

architecture Behavioral of tb_Encoder is
    constant CLK_PERIOD : time := 1.55 ns;
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ce : std_logic := '0';
    signal din : std_logic_vector(7 downto 0) := (others => '0');
    signal dout : std_logic_vector(12 downto 0);
begin
    uut: entity work.Encoder
        port map(
            clk => clk, 
            rst => rst,
            ce => ce,
            din => din,
            dout => dout           
        );
        
    clock_process : process
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
        
        din <= "10100111";
        wait until rising_edge(clk); 
        
        din <= "10110101";
        wait until rising_edge(clk); 
        
        din <= "01001110";
        wait until rising_edge(clk); 
        wait;       
    end process;
end Behavioral;