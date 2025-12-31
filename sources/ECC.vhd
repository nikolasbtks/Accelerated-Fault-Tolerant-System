library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ECC is
    generic (
        ADDR_WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        we : in std_logic;
        din : in std_logic_vector(7 downto 0);
        dout : out std_logic_vector(7 downto 0)           
    );
end ECC;

architecture Behavioral of ECC is
    signal index : unsigned(ADDR_WIDTH-1 downto 0);
    
    signal input_reg : std_logic_vector(7 downto 0);
    
    signal encoder_reg : std_logic_vector(12 downto 0);
    signal encoder_raw : std_logic_vector(12 downto 0);
    
    signal a_out_raw : std_logic_vector(12 downto 0);
    signal a_out_reg : std_logic_vector(12 downto 0);

    signal b_addr_reg : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal b_addr_raw : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal b_din_reg : std_logic_vector(12 downto 0);
    signal b_din_raw : std_logic_vector(12 downto 0);
    signal b_we_reg : std_logic;
    signal b_we_raw : std_logic;
    signal b_dout_raw : std_logic_vector(12 downto 0);
    signal b_dout_reg : std_logic_vector(12 downto 0);
    
    signal dout_raw : std_logic_vector(7 downto 0);
    signal dout_reg : std_logic_vector(7 downto 0);
    
    --signal cw_mem : std_logic_vector(12 downto 0);
    --signal mem_din : std_logic_vector(12 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                input_reg <= (others => '0');
                encoder_reg <= (others => '0');
                dout_reg <= (others => '0');
                a_out_reg <= (others => '0');
            elsif ce = '1' then
                input_reg <= din;
                encoder_reg <= encoder_raw;
                dout_reg <= dout_raw;
                a_out_reg <= a_out_raw;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                index <= (others => '0');
            elsif ce = '1' and we = '1' then
                index <= index + 1;
            end if;
        end if;    
    end process;
    
    Encoder_inst : entity work.Encoder
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            din => input_reg,
            dout => encoder_raw
        );
    
    --cw_mem <= encoder_reg when flip_en = '0' else
    --          encoder_reg xor "0000000001000";  
    --mem_din <= cw_mem;            
        
    MemoryBlock_inst : entity work.MemoryBlock
        port map(
            clk => clk,
            ce => ce,
            
            --Port A
            a_we => we,
            a_addr => std_logic_vector(index),
            a_din => encoder_reg, --mem_din,
            a_dout => a_out_raw,
            
            --Port B 
            b_we => b_we_reg,
            b_addr => b_addr_reg,
            b_din => b_din_reg,
            b_dout => b_dout_raw    
        );    
        
    Decoder_inst : entity work.Decoder
        port map(
            clk => clk,
            rst => rst,
            ce => ce, 
            din => a_out_reg,
            dout => dout_raw
        );    
    
    Scrubber_inst : entity work.Scrubber
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            
            user_we => we,
            user_addr => std_logic_vector(index),
            
            b_addr => b_addr_raw,
            b_din => b_din_raw,
            b_dout => b_dout_reg,
            b_we => b_we_raw
        );
        
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                b_addr_reg <= (others => '0');
                b_din_reg <= (others => '0');
                b_we_reg <= '0';
                b_dout_reg <= (others => '0');
            elsif ce = '1' then
                b_addr_reg <= b_addr_raw;
                b_din_reg <= b_din_raw;
                b_we_reg <= b_we_raw; 
                b_dout_reg <= b_dout_raw;             
            end if;
        end if;
    end process;
    
    dout <= dout_reg when we = '0' else (others => '0');
end Behavioral;
