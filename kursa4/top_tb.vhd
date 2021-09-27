library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity;

architecture sim of top_tb is

  -- i2c controller interface
  signal clk_tb        : std_logic := '0';             --signal driven by tb
  signal rst_tb        : std_logic := '0';             --signal driven by tb
  signal wr_tb         : std_logic;                    --signal driven by tb
  signal rd_tb         : std_logic;                    --signal driven by tb
  signal SCL_tb        : std_logic;                    --signal driven by controller
  signal SDA_tb        : std_logic;                    --signal driven by controller
  signal write_data_tb : std_logic_vector(7 downto 0); --signal driven by tb
  signal read_data_tb  : std_logic_vector(7 downto 0); --signal driven by controller
  signal pointer_tb    : std_logic_vector(7 downto 0);

  constant half_period      : integer := 10;
  signal pointer            : integer;
  signal read_process_start : std_logic;

  --  slave emulation
  -- 7 bits for data because 1 bit reserved for write/read command
  signal CR0          : std_logic_vector(7 downto 0) := "11111111"; -- slave' 0 config register
  signal CR1          : std_logic_vector(7 downto 0) := "11111110"; -- slave' 1 config register
  signal CR2          : std_logic_vector(7 downto 0) := "11111100"; -- slave' 2 config register
  signal data_for_CR0 : std_logic_vector(7 downto 0) := "11111111";
  signal data_for_CR1 : std_logic_vector(7 downto 0) := "10000000";
  signal data_for_CR2 : std_logic_vector(7 downto 0) := "11000000";

begin

  pointer <= to_integer(unsigned(pointer_tb));

  -- stimuli generator 
  -- clk and rst gen
  clk_tb <= not clk_tb after half_period * 1 ns;
  rst_tb <= '1', '0' after 20 * half_period * 1 ns;
  process (all)
  begin
    if wr_tb = '1' and rd_tb = '0' then
      if pointer = 10 then
        SDA_tb        <= '0';
        write_data_tb <= data_for_CR0;
      elsif pointer = 19 then
        SDA_tb        <= '0';
        write_data_tb <= data_for_CR1;
      elsif pointer = 28 then
        SDA_tb        <= '0';
        write_data_tb <= data_for_CR2;
      elsif pointer = 37 then
        SDA_tb <= '0';
      else
        SDA_tb <= 'Z';
      end if;
    elsif wr_tb = '0' and rd_tb = '1' then
      -- SDA_tb <= 'Z';
      case pointer is
        when 11 to 18 => SDA_tb <= CR0(18 - pointer);
        when 20 to 27 => SDA_tb <= CR1(27 - pointer);
        when 29 to 36 => SDA_tb <= CR2(36 - pointer);
        when others   => SDA_tb   <= 'Z';
      end case;
    else
      SDA_tb <= 'Z';
    end if;
  end process;

  write_and_read_sequence : process
  begin
    wr_tb <= '0';
    rd_tb <= '0';
    wait until rst_tb = '0';
    wr_tb <= '1';
    wait for 10 * half_period * 2 ns;
    wait for 9 * half_period * 2 ns;
    wait for 9 * half_period * 2 ns;
    wait for 9 * half_period * 2 ns;
    wr_tb <= '0';
    rd_tb <= '0';
    wait for 5 * half_period * 2 ns; -- idle time
    rd_tb <= '1';
    wait for 10 * half_period * 2 ns;
    wait for 9 * half_period * 2 ns;
    wait for 9 * half_period * 2 ns;
    wait for 9 * half_period * 2 ns;
    wr_tb <= '0';
    rd_tb <= '0';
    wait for 5 * half_period * 2 ns; -- idle time
    wait;
  end process write_and_read_sequence;

  dut : entity work.top
    port map(
      clk         => clk_tb,
      rst         => rst_tb,
      wr          => wr_tb,
      rd          => rd_tb,
      SCL         => SCL_tb,
      SDA         => SDA_tb,
      wr_data     => write_data_tb,
      rd_data     => read_data_tb,
      pointer_out => pointer_tb

    );

  dut1 : entity work.slave
    port map(
      clk   => clk_tb,
      reset => rst_tb,
      SCL   => SCL_tb,
      SDA   => SDA_tb
    );
end architecture;