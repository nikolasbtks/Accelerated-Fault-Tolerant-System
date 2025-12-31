library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is
    constant CLK_PERIOD : time := 1.55 ns;
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ce : std_logic := '0';        
    signal A : std_logic_vector(7 downto 0) := ( others => '0');
    signal B : std_logic_vector(7 downto 0) := ( others => '0');
    signal OP : std_logic_vector(2 downto 0) := ( others => '0');
    signal C : std_logic_vector(7 downto 0);  
begin
     uut : entity work.ALU
        port map(
             clk => clk,
             rst => rst,
             ce => ce,       
             A => A,
             B => B,
             OP => OP,
             C => C            
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
        
        A <= std_logic_vector(to_signed(3,8));
        B <= std_logic_vector(to_signed(1,8));
        OP <= "001";
        
        wait until rising_edge(clk);   
        
        A <= std_logic_vector(to_signed(1,8));
        B <= std_logic_vector(to_signed(1,8));
        OP <= "101";    
        
        wait until rising_edge(clk);       
        A <= std_logic_vector(to_signed(7,8));
        B <= std_logic_vector(to_signed(4,8));
        OP <= "000";
        
        wait until rising_edge(clk);       
        A <= std_logic_vector(to_signed(1,8));
        B <= std_logic_vector(to_signed(1,8));
        OP <= "111";
        wait;
        
        wait until rising_edge(clk);       
        ce <= '0';
        A <= std_logic_vector(to_signed(1,8));
        B <= std_logic_vector(to_signed(1,8));
        OP <= "110";
        wait;
     end process; 
        
end Behavioral;
