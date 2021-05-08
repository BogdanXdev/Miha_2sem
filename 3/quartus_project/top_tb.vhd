library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity;

architecture sim of top_tb is

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal enable_tb : std_logic := '0';
    signal state_out_tb : std_logic_vector (7 downto 0);

    constant half_period : natural := 15;
begin

    -- clk and reset gener
    clk_tb <= not clk_tb after half_period * 1 ns;
    rst_tb <= '1' after half_period * 1 ns, '0' after half_period * 8 ns;

    enable_logic: process begin
        wait for half_period * 10 ns ;
        enable_tb <= '1';
        -- wait for half_period * 10 ns ;
        -- enable_tb <= '0';
        -- wait for half_period * 5 ns ;
        -- enable_tb <= '1';
    end process enable_logic;

    dut : entity work.top
        port map(
            clk_in => clk_tb,
            rst_in => rst_tb,
            enable_in => enable_tb,
            state_out => state_out_tb
        );

end architecture sim;