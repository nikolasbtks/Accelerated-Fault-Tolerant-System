library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        din : in std_logic_vector(12 downto 0);
        dout : out std_logic_vector(7 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
    signal din_reg : std_logic_vector(12 downto 0);
    signal dout_reg : std_logic_vector(7 downto 0);
    
    signal corrected_word : std_logic_vector(12 downto 0);
    signal derror_reg : std_logic;
    signal double_error_reg : std_logic;      
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                din_reg <= (others => '0'); 
            elsif  ce = '1' then
                 din_reg <= din;
           end if;
        end if;
    end process;

    ErrorCorrector_inst : entity work.ErrorCorrector
        port map(
            din => din_reg,
            derror => derror_reg,
            double_error => double_error_reg,
            dout => corrected_word
        );   

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                dout_reg <= (others => '0'); 
            elsif  ce = '1' then
                 dout_reg(7) <= corrected_word(10);
                 dout_reg(6) <= corrected_word(8);
                 dout_reg(5) <= corrected_word(7);
                 dout_reg(4) <= corrected_word(6);
                 dout_reg(3) <= corrected_word(4);
                 dout_reg(2) <= corrected_word(3);
                 dout_reg(1) <= corrected_word(2);
                 dout_reg(0) <= corrected_word(1);
           end if;
        end if;
    end process;
    dout <= dout_reg;
end Behavioral;
