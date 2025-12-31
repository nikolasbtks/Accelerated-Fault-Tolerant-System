library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;        
        A : in std_logic_vector(7 downto 0); --signed
        B : in std_logic_vector(7 downto 0); --signed
        OP : in std_logic_vector(2 downto 0); --unsigned
        C : out std_logic_vector(7 downto 0) 
    );
end ALU;

architecture Behavioral of ALU is
    --signal a_reg : std_logic_vector(7 downto 0); --signed
    --signal b_reg : std_logic_vector(7 downto 0); --signed
    --signal op_reg : std_logic_vector(2 downto 0); --unsigned
    signal c_reg : std_logic_vector(7 downto 0); --signed
begin 

    --process(clk)
    --begin
    --    if rising_edge(clk) then
    --        if rst = '1' or ce = '0' then
    --            a_reg <= (others => '0');
    --            b_reg <= (others => '0');
    --            op_reg <= (others => '0');
    --        elsif ce = '1' then
    --            a_reg <= A;  
    --            b_reg <= B;  
    --            op_reg <= OP;         
    --        end if;
    --    end if;
    --end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                c_reg <= (others => '0');
            elsif ce = '1' then
                case OP is
                when "000" => c_reg <= std_logic_vector(signed(A) + signed(B));
                when "001" => c_reg <= std_logic_vector(signed(A) - signed(B));
                when "010" => c_reg <= std_logic_vector(signed(A) - 1);
                when "011" => c_reg <= std_logic_vector(signed(A) + 1);
                when "100" => c_reg <= not A;
                when "101" => c_reg <= A and B;
                when "110" => c_reg <= A or B;
                when "111" => c_reg <= A xor B;
                when others => c_reg <= (others => '0');
                end case;      
            end if;
        end if;
    end process; 
    
   C <= c_reg;

end Behavioral;
