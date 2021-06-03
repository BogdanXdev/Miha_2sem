library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;
use ieee.math_real.floor;

entity top_tb is
end entity;

architecture sim of top_tb is

    --  random function for async button process imitation
    impure function rand_slv(len : integer) return std_logic_vector is
        variable r : real;
        variable slv : std_logic_vector(len - 1 downto 0);
    begin
        for i in slv'range loop
            uniform(seed1, seed2, r);
            slv(i) := '1' when r > 0.5 else
            '0';
        end loop;
        return slv;
    end function;

    signal fast_clk_tb : std_logic := '0';
    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal enable_tb : std_logic := '0';
    signal state_out_tb : std_logic_vector (7 downto 0);
    signal async_tb : std_logic := '0';

    constant half_period : natural := 15; 
    constant fast_half_period : natural := 2; -- for button imitation
begin

    -- clk and reset gener
    fast_clk_tb <= not fast_clk_tb after fast_half_period * 1 ns; -- for button imitation
    clk_tb <= not clk_tb after half_period * 1 ns;
    rst_tb <= '1' after half_period * 1 ns, '0' after half_period * 8 ns;

    async_button_pattern : process (all)
        variable seed1 : positive := 777;
        variable seed2 : positive := 777;
    begin
        button_pattern <= rand_slv(10);
    end process async_button_pattern;

    button_imitation: process   
    begin
        for i in button_pattern'range loop 
            async_tb <= button_pattern(i);
            wait for fast_half_period * 2 ns;
        end loop;
            async_tb <= '0';
            wait for fast_half_period * 200 ns;
    end process button_imitation;

    dut : entity work.top
        port map(
            clk_in => clk_tb,
            rst_in => rst_tb,
            async_in => async_tb,
            state_out => state_out_tb
        );

end architecture sim;