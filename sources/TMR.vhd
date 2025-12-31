library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TMR is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        A : in std_logic_vector(7 downto 0); --signedso
        B : in std_logic_vector(7 downto 0); --signed
        OP : in std_logic_vector(2 downto 0); --unsigned
        flag : out std_logic;
        result : out std_logic_vector(7 downto 0) --signed
    );
end TMR;

architecture Behavioral of TMR is        
    type array_t is array (0 to 2) of std_logic_vector(7 downto 0); --signed
    signal core_output : array_t;
    
    --Fault Independence, one is down the other Cores use the good data
    type signed_array_t is array (0 to 2) of std_logic_vector(7 downto 0); --signed
    type unsigned_array_t is array (0 to 2) of std_logic_vector(2 downto 0); --unsigned
    signal a_reg : signed_array_t;
    signal b_reg : signed_array_t;
    signal op_reg : unsigned_array_t;
    
    signal error_flag_reg : std_logic;
    signal y_reg : std_logic_vector(7 downto 0);
begin    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                for i in 0 to 2 loop
                    a_reg(i) <= (others => '0');
                    b_reg(i) <= (others => '0');
                    op_reg(i) <= (others => '0');
                end loop;
            elsif ce = '1' then
                for i in 0 to 2 loop
                    a_reg(i) <= A;
                    b_reg(i) <= B;
                    op_reg(i) <= OP;                
                end loop;
            end if;
        end if;
    end process;

    GEN_CORE: for i in 0 to 2 generate
        ALU_inst : entity work.ALU
            port map(
                clk => clk,
                rst => rst,
                ce => ce,    
                A => a_reg(i),
                B => b_reg(i),
                OP => op_reg(i),
                C => core_output(i)              
            );
    end generate;

    Voter_inst : entity work.Voter
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            A => core_output(0),
            B => core_output(1),
            C => core_output(2),
            error_flag => error_flag_reg,
            Y => y_reg
        );
    
    flag <= error_flag_reg;
    result <= y_reg;
end Behavioral;
