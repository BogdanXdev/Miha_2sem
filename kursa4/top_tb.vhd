library ieee;
use ieee.std_logic_1164.all;

entity top_tb is 
end entity;

architecture i2c_controller_top_tb is 

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal wr_tb  : std_logic;
    signal rd_tb  : std_logic;
    signal SCL_tb : std_logic;
    signal SDA_tb : std_logic; 

    constant half_period : natural := 100; -- ns
begin

    -- clk and rst gen
    clk_tb <= not clk_tb after half_period * 1 ns;
    rst_tb <= '1', '0' after 20 * half_period * 1 ns;
    
    -- device instantiation




end architecture;