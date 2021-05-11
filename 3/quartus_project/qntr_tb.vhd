library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pckg.all;

entity qntr_tb is
    generic (
        clks_amount : natural
    );
    port (
        clk_in : in std_logic;
        rst_in : in std_logic;

        en_out : out std_logic
    );
end entity;

architecture behav of qntr_tb is

    -- signal counter : unsigned ((log2c(clks_amount) - 1) downto 0);
    signal counter : std_logic_vector ((log2c(clks_amount) - 1) downto 0);
begin

-- counter reg, nslogic and output logic
    process (clk_in, rst_in)
    begin
        if rst_in = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk_in) then
            counter <= std_logic_vector (unsigned (counter) + 1);
            if counter = x"29" then
                counter <= (others => '0');
                en_out <= '1';
            end if;
        end if;
    end process;

end architecture behav;