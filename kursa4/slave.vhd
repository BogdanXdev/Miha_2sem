library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slave is

    port (
        clk   : in std_logic;
        reset : in std_logic;
        SCL   : in std_logic;
        SDA   : inout std_logic
    );
end entity;

architecture behav of slave is
    signal CR0_reg, CR0_next         : std_logic_vector(7 downto 0);
    signal pointer_reg, pointer_next : std_logic_vector(7 downto 0);
    type statetype is (idle, start, writing);
    signal state_reg, state_next : statetype;
    signal pointer               : integer;
    --regs and signals for catching start condition
    signal SDA_reg, SDA_next                    : std_logic;
    signal SCL_reg, SCL_next                    : std_logic;
    signal SDA_start, SCL_start, start_counting : std_logic;
    constant  SLAVE_ADRESS : std_logic_vector(6 downto 0):= "0110101";
    
begin

    SCL_next <= SCL;
    SDA_next <= SDA;
    pointer  <= to_integer(unsigned(pointer_reg));

    regs : process (all)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                CR0_reg     <= (others => '0');
                pointer_reg <= (others => '0');
                SDA_reg     <= '0';
                SCL_reg     <= '0';
                state_reg   <= idle;
            else
                CR0_reg     <= CR0_next;
                pointer_reg <= pointer_next;
                SDA_reg     <= SDA_next;
                SCL_reg     <= SCL_next;
                state_reg   <= state_next;
            end if;
        end if;
    end process regs;

    -- start conditions for SDA and SCL
    SDA_start      <= SDA_reg and not SDA;
    SCL_start      <= SCL_reg and SCL;
    start_counting <= SDA_start and SCL_start;

    process (all)
    begin
        case state_reg is
            when idle =>
                if start_counting = '1' then
                    state_next   <= writing;
                    pointer_next <= std_logic_vector(unsigned(pointer_reg) + to_unsigned(2, 8));
                else
                    state_next   <= idle;
                    pointer_next <= (others => '0');
                end if;
                SDA <= 'Z';
            when start =>
                state_next   <= writing;
                pointer_next <= std_logic_vector(unsigned(pointer_reg) + to_unsigned(1, 8));
                SDA          <= 'Z';
            when writing =>
                -- default assignements
                state_next   <= writing;
                pointer_next <= std_logic_vector(unsigned(pointer_reg) + to_unsigned(1, 8));
                SDA          <= 'Z';
                CR0_next <= CR0_reg;
                case pointer is
                    when 2 to 8 =>
                        -- slave address check
                        if SDA = SLAVE_ADRESS(8 - pointer ) then
                            state_next <= writing;
                        else
                            state_next   <= idle;
                            pointer_next <= (others => '0');
                        end if;
                    when 9 =>
                        -- write operation check
                        if SDA = '0' then
                            state_next <= writing;
                        else
                            state_next   <= idle; -- read operation required
                            pointer_next <= (others => '0');
                        end if;
                    when 10 =>
                        -- ack
                        SDA <= '0';
                    when 11 to 18 => 
                        -- writing to reg
                        CR0_next(18 - pointer) <= SDA;
                    when 19 =>
                        --ack 
                        SDA <= '0';
                    when others =>
                        SDA <= 'Z';
                end case;
        end case;
    end process;

end architecture;