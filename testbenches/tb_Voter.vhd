library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Voter is
end tb_Voter;

architecture Behavioral of tb_Voter is
    constant CLK_PERIOD : time := 1.55 ns;
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ce : std_logic := '0';
    signal A : std_logic_vector(7 downto 0) := (others => '0');
    signal B : std_logic_vector(7 downto 0) := (others => '0');
    signal C : std_logic_vector(7 downto 0) := (others => '0');  
    signal error_flag : std_logic;
    signal Y : std_logic_vector(7 downto 0);
    
begin

    uut : entity work.Voter
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            A => A,
            B => B,
            C => C,  
            error_flag => error_flag,
            Y => Y      
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
        
        A <= std_logic_vector(to_signed(1,8));
        B <= std_logic_vector(to_signed(1,8));
        C <= std_logic_vector(to_signed(1,8));
        wait until rising_edge(clk);
        
        A <= std_logic_vector(to_signed(6,8));
        B <= std_logic_vector(to_signed(2,8));
        C <= std_logic_vector(to_signed(2,8));
        wait until rising_edge(clk);        

        A <= std_logic_vector(to_signed(3,8));
        B <= std_logic_vector(to_signed(1,8));
        C <= std_logic_vector(to_signed(7,8));
        wait until rising_edge(clk);   
        
        ce <= '0';
        A <= std_logic_vector(to_signed(5,8));
        B <= std_logic_vector(to_signed(2,8));
        C <= std_logic_vector(to_signed(2,8));
        wait until rising_edge(clk);               
        wait;      
      end process;
end Behavioral;
