library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is port (
    clk      : in std_logic;
    start    : in std_logic;
    divident : in std_logic_vector(15 downto 0);
    divisor  : in std_logic_vector(15 downto 0);

    done     : out std_logic;
    quotient : out std_logic_vector(15 downto 0);
    reminder : out std_logic_vector(15 downto 0)
);
end entity;

architecture behav of top is

    signal divident_reg          : std_logic_vector(15 downto 0):= (others => '0') ;
    signal divident_next         : std_logic_vector(15 downto 0);
    signal divisor_reg           : std_logic_vector(15 downto 0):= (others => '0');
    signal divisor_next          : std_logic_vector(15 downto 0);
    signal quotient_reg          : std_logic_vector(15 downto 0):= (others => '0');
    signal quotient_next         : std_logic_vector(15 downto 0);
    signal reminder_reg          : std_logic_vector(15 downto 0):= (others => '0');
    signal reminder_next         : std_logic_vector(15 downto 0);
    signal inbetween_result_reg  : std_logic_vector(15 downto 0):= (others => '0');
    signal inbetween_result_next : std_logic_vector(15 downto 0);
    signal count_divisions_reg   : std_logic_vector(15 downto 0):= (others => '0');
    signal count_divisions_next  : std_logic_vector(15 downto 0);
    signal actual_divisor_reg    : std_logic_vector(15 downto 0):= (others => '0');
    signal actual_divisor_next   : std_logic_vector(15 downto 0);
    signal actual_divident_reg   : std_logic_vector(15 downto 0):= (others => '0');
    signal actual_divident_next  : std_logic_vector(15 downto 0);

    type statetype is (new_load, divide_process, result);
    signal state_reg  : statetype := new_load;
    signal state_next : statetype;
begin
    regs : process (clk)
    begin
        if rising_edge(clk) then
            divident_reg         <= divident_next;
            divisor_reg          <= divisor_next;
            quotient_reg         <= quotient_next;
            reminder_reg         <= reminder_next;
            inbetween_result_reg <= inbetween_result_next;
            state_reg            <= state_next;
            actual_divisor_reg   <= actual_divisor_next;
            actual_divident_reg  <= actual_divident_next;
            count_divisions_reg  <= count_divisions_next;
        end if;
    end process regs;

    divident_next <= divident;
    divisor_next  <= divisor;
    quotient      <= quotient_reg;
    reminder      <= reminder_reg;

    process (all)
    begin
        state_next <= state_reg;
        -- divident_next         <= divident_reg;
        -- divisor_next          <= divisor_reg;
        quotient_next         <= quotient_reg;
        inbetween_result_next <= inbetween_result_reg;
        count_divisions_next  <= count_divisions_reg;
        actual_divisor_next   <= actual_divisor_reg;
        actual_divident_next  <= actual_divident_reg;
        reminder_next         <= reminder_reg;
        done                  <= '0';
        case state_reg is
            when new_load =>
                if start then

                    if to_integer(unsigned(divisor_reg)) >
                        to_integer(unsigned(divident_reg)) then
                        quotient_next <= (others => '0');
                        reminder_next <= divident_reg;
                        state_next    <= result;
                    else
                        actual_divident_next  <= divident_reg; -- need to save for reminder searching 
                        inbetween_result_next <= divident_reg; -- need to save for division process
                        actual_divisor_next   <= divisor_reg;
                        state_next            <= divide_process;
                    end if;
                else
                end if;

            when divide_process =>
                inbetween_result_next <= std_logic_vector(unsigned(inbetween_result_reg)
                    - unsigned(actual_divisor_reg));
                count_divisions_next <= std_logic_vector(unsigned(count_divisions_reg)
                    + to_unsigned(1, count_divisions_next'length));
                if (to_integer(unsigned(inbetween_result_reg)) = 0) then
                    quotient_next <= count_divisions_reg;
                    reminder_next <= (others => '0');
                    state_next    <= result;
                elsif (to_integer(unsigned(inbetween_result_reg))) <
                    (to_integer(unsigned(actual_divisor_reg))) then
                    quotient_next <= count_divisions_reg;
                    reminder_next <= std_logic_vector (resize((resize(unsigned(actual_divident_reg), 32)
                        - unsigned(count_divisions_reg) * unsigned(actual_divisor_reg)), reminder_next'length));
                    state_next <= result;
                else
                end if;
            when result =>
                done <= '1';
                count_divisions_next <= (others => '0'); 
                if start then
                    if to_integer(unsigned(divisor_reg)) >
                        to_integer(unsigned(divident_reg)) then
                        quotient_next <= (others => '0');
                        reminder_next <= divident_reg;
                    else
                        actual_divident_next  <= divident_reg; -- need to save for reminder searching 
                        inbetween_result_next <= divident_reg; -- need to save for division process
                        actual_divisor_next   <= divisor_reg;
                        state_next            <= divide_process;
                    end if;
                else
                end if;

            when others =>
        end case;
    end process;
end architecture;