library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MemoryBlock is
end tb_MemoryBlock;

architecture Behavioral of tb_MemoryBlock is
        constant CLK_PERIOD : time := 1.55 ns;
        
        signal clk : std_logic := '0';
        signal ce : std_logic := '1';
        
        signal a_we : std_logic := '0';
        signal a_addr : std_logic_vector(7 downto 0);
        signal a_din : std_logic_vector(12 downto 0);
        signal a_dout : std_logic_vector(12 downto 0);
        
        signal b_we : std_logic := '0';
        signal b_addr : std_logic_vector(7 downto 0);
        signal b_din : std_logic_vector(12 downto 0);
        signal b_dout : std_logic_vector(12 downto 0);
begin
    uut : entity work.MemoryBlock
        port map(
            clk => clk,
            ce => ce,
            a_we => a_we,
            a_addr => a_addr,
            a_din => a_din,
            a_dout => a_dout,
            b_we => b_we,
            b_addr => b_addr,
            b_din => b_din,
            b_dout => b_dout 
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
        wait until rising_edge(clk);
        
        a_we <= '1';
        a_addr <= x"01";
        a_din <= std_logic_vector(to_unsigned(5,13));
        wait until rising_edge(clk);
        a_we <= '0';        
        wait until rising_edge(clk);
        
        ----------------------
        
        b_we <= '1';
        b_addr <= x"02";
        b_din <= std_logic_vector(to_unsigned(30,13));
        wait until rising_edge(clk);
        b_we <= '0';        
        wait until rising_edge(clk);  
        
        ----------------------
        
        a_addr <= x"03";
        a_din <= std_logic_vector(to_unsigned(36,13));
        a_we <= '1';
        b_addr <= x"04";
        b_din <= std_logic_vector(to_unsigned(40,13));     
        b_we <= '1';     
        wait until rising_edge(clk);
        a_we <= '0';    
        b_we <= '0';     
        wait until rising_edge(clk); 
        
        ----------------------
        a_addr <= x"01";
        wait until rising_edge(clk);
        b_addr <= x"02";
        wait until rising_edge(clk);        
        ---------------------- 
        
        wait;
    end process;
end Behavioral;
