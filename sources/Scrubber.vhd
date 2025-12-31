library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Scrubber is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        
        user_we : in std_logic;
        user_addr : in std_logic_vector(7 downto 0);
        
        b_addr : out std_logic_vector(7 downto 0);
        b_din : out std_logic_vector(12 downto 0);
        b_dout : in std_logic_vector(12 downto 0);
        b_we : out std_logic     
    );
end Scrubber;

architecture Behavioral of Scrubber is
    type state_t is (IDLE, READ, DECODE, WRITE);
    signal state : state_t := IDLE;
    
    signal pending_addr : std_logic_vector(7 downto 0) := (others => '0');
    signal have_pending : std_logic := '0';
    
    signal corrected_word : std_logic_vector(12 downto 0);
    signal derror_reg : std_logic;
    signal double_error_reg : std_logic;   
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                have_pending <= '0';
            elsif ce = '1' then
                if user_we = '1' and have_pending = '0' then --new request for scrubber
                    pending_addr <= user_addr;
                    have_pending <= '1';
                elsif state = WRITE then --completed scrub
                    have_pending <= '0';
                end if;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                b_we <= '0';
                b_addr <= (others => '0');
            else
                b_we <= '0';
                case state is
                when IDLE =>
                  if have_pending = '1' then
                    b_addr <= pending_addr;
                    state <= READ;
                  end if;  
                when READ =>
                    state <= DECODE;
                when DECODE =>
                   if derror_reg = '1' and double_error_reg = '0' then
                        b_addr <= pending_addr;
                        b_din <= corrected_word;
                        state <= WRITE;
                   else
                        state <= IDLE;
                   end if;
                when WRITE =>
                    b_addr <= pending_addr;
                    b_din <= corrected_word;
                    b_we <= '1';
                    state <= IDLE;
                end case;
            end if;
        end if;        
    end process;

    ErrorCorrector_inst : entity work.ErrorCorrector
        port map(
            din => b_dout,
            derror => derror_reg,
            double_error => double_error_reg,
            dout => corrected_word
        );

end Behavioral;
