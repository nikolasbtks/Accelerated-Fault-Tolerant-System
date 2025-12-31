library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
    port (
       clk : in std_logic;
       rst : in std_logic;
       ce : in std_logic; 
       we : in std_logic;  
       A : in std_logic_vector(7 downto 0); 
       B : in std_logic_vector(7 downto 0); 
       OP : in std_logic_vector(2 downto 0); 
       --flip_en : in std_logic;
       result : out std_logic_vector(7 downto 0) 
    );
end Top;

architecture Behavioral of Top is
    signal A_reg : std_logic_vector(7 downto 0);
    signal B_reg : std_logic_vector(7 downto 0);
    signal OP_reg  : std_logic_vector(2 downto 0);
    
    signal dis_reg : std_logic;
    
    signal flag_raw : std_logic;
    signal result_tmr_raw : std_logic_vector(7 downto 0);
    
    signal flag_reg : std_logic;
    signal result_tmr_reg : std_logic_vector(7 downto 0);     
    
    signal result_ecc_raw : std_logic_vector(7 downto 0);  
    signal result_ecc_reg : std_logic_vector(7 downto 0);    
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                A_reg <= (others => '0');
                B_reg <= (others => '0');
                OP_reg <= (others => '0');
            elsif ce = '1' then
                A_reg <= A;
                B_reg <= B;
                OP_reg <= OP;
            end if;
        end if;
    end process;  
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                result_tmr_reg <= (others => '0');
                flag_reg <= '0';
                dis_reg <= '0';
            elsif ce = '1' then
                result_tmr_reg <= result_tmr_raw;
                flag_reg <= flag_raw;
                
                if flag_reg = '1' then
                    dis_reg <= '1';
                else
                    dis_reg <= ce;
                end if;
            end if;
        end if;
    end process;  
    
    TMR_inst : entity work.TMR
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            A => A_reg,
            B => B_reg,
            OP => OP_reg,
            flag => flag_raw,
            result => result_tmr_raw          
        );

    ECC_inst : entity work.ECC
        port map(
            clk => clk,
            rst => rst,
            ce => dis_reg,
            we => we,
            din => result_tmr_reg,
            --flip_en => flip_en,
            dout => result_ecc_raw        
        );
        
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                result_ecc_reg <= (others => '0');
            elsif ce = '1' then
                result_ecc_reg <= result_ecc_raw;
            end if;
        end if;
    end process;     
    
    result <= result_ecc_reg;
    
end Behavioral;
