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
    signal write_data : std_logic_vector(7 downto 0) := "11100010";

    signal store_data_after_read_next : std_logic_vector(7 downto 0);
    signal store_data_after_read_reg : std_logic_vector(7 downto 0);

    -- 3 slaves addresses array
    signal slaves_addresses_array is array (3 donwto 0)
    of std_logic_vector(7 downto 0) :=
    ("00000001", "00000010", "00000100");
    signal read_slave0_data_array is array (2 downto 0)
    of std_logic_vector(7 downto 0) :=
    ("11110000", "11001100", "00110011");

    -- emulating slave0. slave0 has its own address and 3 addresses inside it
    --      (in memory mapped manner)
    -- signal read_slave0_addresses_array is array (2 downto 0)
    -- of std_logic_vector(7 downto 0) :=
    -- (x"08", x"0F", x"80");
    -- signal read_slave0_data_array is array (2 downto 0)
    -- of std_logic_vector(7 downto 0) :=
    -- ("11110000", "11001100", "00110011");

    signal address_on_bus : std_logic_vector(7 downto 0);
    signal reg_address_on_bus : std_logic_vector(7 downto 0);

    --counters for controlling FSM state timings purposes
    signal counter0 : unsigned (15 downto 0);
    signal counter1 : unsigned (15 downto 0);
    signal counter2 : unsigned (15 downto 0);

    constant half_period : natural := 100; -- ns
    constant clock_stretch : natural := 4;

begin

    -- clk and rst gen
    clk_tb <= not clk_tb after half_period * 1 ns;
    rst_tb <= '1', '0' after 20 * half_period * 1 ns;

    regs : process (clk_tb, rst_tb)
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

    slaves : process (all)
    begin
        case address_on_bus is
            when slaves_addresses_array(0) =>
                
                -- clock stretch
            when slaves_addresses_array(1) =>

            when slaves_addresses_array(2) =>

            when others =>

        end case;
    end process slaves;

    -- be sure of what is going on i2c bus

    timings_fsm : process (sensitivity_list)
    begin

    end process fsm_with_counters;
end architecture;