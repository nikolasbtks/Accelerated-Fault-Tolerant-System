library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryBlock is
    generic (
        DATA_WIDTH : integer := 13;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        ce : in std_logic;
        
        --Port A
        a_we : in std_logic;
        a_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        a_din : in std_logic_vector(DATA_WIDTH-1 downto 0);
        a_dout : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        --Port B 
        b_we : in std_logic;
        b_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        b_din : in std_logic_vector(DATA_WIDTH-1 downto 0);
        b_dout : out std_logic_vector(DATA_WIDTH-1 downto 0)        
    );
end MemoryBlock;

architecture Behavioral of MemoryBlock is
    type ram_type is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_type := (others => (others => '0'));
    
    attribute ram_style : string;
    attribute ram_style of ram : signal is "block";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if ce = '1' then 
                if a_we = '1' then
                    ram(to_integer(unsigned(a_addr))) <= a_din;
                    a_dout <= a_din;
                else
                    a_dout <= ram(to_integer(unsigned(a_addr)));
                end if;
            end if; 
         end if;   
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then 
            if ce = '1' then
                if b_we = '1' and ce = '1' then
                    ram(to_integer(unsigned(b_addr))) <= b_din;
                    b_dout <= b_din;
                else 
                    b_dout <= ram(to_integer(unsigned(b_addr)));
                end if;
            end if;
         end if;   
    end process;    
end Behavioral;
