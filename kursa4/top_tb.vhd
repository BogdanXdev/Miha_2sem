library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity;

architecture i2c_controller_top_tb is

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal wr_tb : std_logic;
    signal rd_tb : std_logic;
    signal SCL_tb : std_logic;
    signal SDA_tb : std_logic;

    -- signals for data patterns and their storage 
    signal write_data_storage : std_logic_vector(7 downto 0) := "11100010"; -- just signal for the beginning
    signal store_data_after_read_next : std_logic_vector(7 downto 0);
    signal store_data_after_read_reg : std_logic_vector(7 downto 0);

    constant half_period : natural := 100; -- ns
    constant clock_stretch : natural := 4;

begin

    -- clk and rst gen
    clk_tb <= not clk_tb after half_period * 1 ns;
    rst_tb <= '1', '0' after 20 * half_period * 1 ns;

    regs: process(clk_tb, rst_tb)
    begin
        if rst_tb = '0' then
            store_data_after_read_reg <= (others => '0');            
        elsif rising_edge(clk_tb) then
            store_data_after_read_reg <= store_data_after_read_next; 
        end if;
    end regs;

    -- read data pattern 
    -- read data store 


    -- master  

    -- slave0, address = 11110000
    slave0: process(all)
    begin
        if addres_on_bus = slave0_address then 
        
        end if;

        -- clock stretch


    end process slave0;

    
end architecture;