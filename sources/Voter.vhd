library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Voter is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        A : in std_logic_vector(7 downto 0); --signed
        B : in std_logic_vector(7 downto 0); --signed
        C : in std_logic_vector(7 downto 0); --signed 
        error_flag : out std_logic;
        Y : out std_logic_vector(7 downto 0)  --signed
    );
end Voter;

architecture Behavioral of Voter is
    signal y_reg : std_logic_vector(7 downto 0); --signed
    signal flag_reg : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                y_reg <= (others => '0');
                flag_reg <= '0';
            elsif ce = '1' then              
                if A = B then
                    y_reg <= A; 
                    flag_reg <= '0';
                elsif A = C then
                    y_reg <= A; 
                    flag_reg <= '0';  
                elsif B = C then
                    y_reg <= B;
                    flag_reg <= '0';   
                else
                    y_reg <= (others => '0');
                    flag_reg <= '1';
                end if;                
            end if;
        end if;
    end process;
    
    Y <= y_reg;
    error_flag <= flag_reg;
    
end Behavioral;
