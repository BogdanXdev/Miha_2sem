library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk_in : in std_logic;
        rst_in : in std_logic;
        async_in : in std_logic;
        state_out : out std_logic_vector(7 downto 0)
    );

end entity;

architecture rtl of top is

    signal state_reg : std_logic_vector (7 downto 0) ;
    signal state_next : std_logic_vector (7 downto 0);
    signal enable : std_logic;
begin

    asynchr_help: entity work.synchr_edge_det 
    port map (
        clk => clk_in,
        reset => rst_in,
        in_async => async_in,
        en_out => enable
    );

    --register with async reset
    process (all) begin
        if (rst_in = '1') then
            state_reg <= x"12";
        elsif (rising_edge(clk_in)) then
            state_reg <= state_next;
        end if;
    end process;

    -- next state logic
    process (all) begin

        if (enable = '1') then

            if (state_reg = x"1D") then
                state_next <= x"0A";
            elsif (state_reg = x"17") then
                state_next <= x"0B";
            elsif (state_reg = x"0A") then
                state_next <= x"17";
            elsif (state_reg = x"10") then
                state_next <= x"1B";
            else 
                state_next <= std_logic_vector (unsigned(state_reg) + 1);
            end if;

        else
            state_next <= state_reg;
        end if;
    end process;

    -- output logic 
    state_out <= state_reg;

end rtl;