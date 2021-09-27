library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is

  port (
    clk, rst    : in std_logic;
    wr, rd      : in std_logic;
    SCL         : out std_logic;
    SDA         : inout std_logic;
    wr_data     : in std_logic_vector (7 downto 0);
    rd_data     : out std_logic_vector (7 downto 0);
    pointer_out : out std_logic_vector (7 downto 0)
  );

end entity;

architecture I2C_controller_behav of top is

  signal wr_en, rd_en : std_logic;
  signal p            : natural range 0 to 40;

  type state_type is (zero, writing, end_write, reading, end_read);
  signal state_reg, state_next : state_type;

  -- for tb file easyness some constants will be placed here, so controller will work
  -- with only specified slave address , but tb will be more obvious
  constant SLAVE_ADDRESS : std_logic_vector(6 downto 0) := "0110101";
begin
  pointer_out <= std_logic_vector(to_unsigned (p, 8));

  reg : process (all)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        state_reg <= zero;
      else
        state_reg <= state_next;
      end if;
    end if;
  end process reg;

  process (all)
  begin
    if rst = '1' then
      state_next <= zero;
    elsif rising_edge(clk) then
      case state_reg is
        when zero =>
          if wr = '1' and rd = '0' then
            state_next <= writing;
            wr_en      <= '1';
            rd_en      <= '0';
            p          <= p + 1;
          elsif rd = '1' and wr = '0' then
            state_next <= reading;
            wr_en      <= '0';
            rd_en      <= '1';
            p          <= p + 1;
          else
            state_next <= zero;
            wr_en      <= '0';
            rd_en      <= '0';
            p          <= 0;
          end if;
        when writing =>
          if p = 38 then
            state_next <= end_write;
            wr_en      <= '1';
            rd_en      <= '0';
            p          <= p;
          else
            state_next <= writing;
            wr_en      <= '1';
            rd_en      <= '0';
            p          <= p + 1;
          end if;
        when end_write =>
          if wr = '0' then
            state_next <= zero;
            wr_en      <= '0';
            rd_en      <= '0';
            p          <= 0;
          else
            state_next <= end_write;
            wr_en      <= '1';
            rd_en      <= '0';
            p          <= p;
          end if;
        when reading =>
          if p = 38 then
            state_next <= end_read;
            wr_en      <= '0';
            rd_en      <= '1';
            p          <= p;
          else
            state_next <= reading;
            wr_en      <= '0';
            rd_en      <= '1';
            p          <= p + 1;
          end if;
        when end_read =>
          if rd = '0' then
            state_next <= zero;
            wr_en      <= '0';
            rd_en      <= '0';
            p          <= 0;
          else
            state_next <= end_read;
            wr_en      <= '0';
            rd_en      <= '1';
            p          <= p;
          end if;
      end case;
    end if;
  end process;

  SCL_SDA : process (all)
  begin
    if wr_en = '1' and rd_en = '0' then
      case p is
          -- idle 
        when 0 =>
          SDA <= '1';
          -- start 
        when 1 =>
          SDA <= '0';
          -- data packet - address
        when 2 to 8 =>
          SDA <= SLAVE_ADDRESS(8 - p);
          -- write bit
        when 9 =>
          SDA <= '0';
          -- slave shows ack bit here
        when 10 =>
          SDA <= 'Z';
          -- data packet - CR0
        when 11 to 18 =>
          SDA <= wr_data(18 - p);
          -- slave shows ack bit here
        when 19 =>
          SDA <= 'Z';
          -- data packet - CR1
        when 20 to 27 =>
          SDA <= wr_data(27 - p);
          -- slave shows ack bit here
        when 28 =>
          SDA <= 'Z';
          -- data packet - CR2
        when 29 to 36 =>
          SDA <= wr_data(36 - p);
        when 37 =>
          SDA <= 'Z';
          --stop
        when 38 =>
          SDA <= '0';
        when others =>
          SDA <= '1';
      end case;

      case p is
        when 0 | 1 =>
          SCL <= '1';
        when others =>
          SCL <= clk;
      end case;
      
    elsif rd_en = '1' and wr_en = '0' then
      case p is
        when 0 | 1  => SCL  <= '1';
        when others => SCL <= clk;
      end case;
      case p is
          -- idle
        when 0 => SDA <= '1';
          -- start 
        when 1 => SDA <= '0';
          -- data packet - address
        when 2 to 8 => SDA <= SLAVE_ADDRESS(8 - p);
          -- read bit 
        when 9 => SDA <= '1';
          --ack
        when 10 => SDA <= 'Z';
          -- slave drives the line with CR0 data
        when 11 to 18 => SDA <= 'Z';
          -- ack bit
        when 19 => SDA <= '0';
          -- slave drives the line with CR1 data
        when 20 to 27 => SDA <= 'Z';
          -- ack bit 
        when 28 => SDA <= '0';
          -- slave drives the line with CR2 data
        when 29 to 36 => SDA <= 'Z';
          --nack bit
        when 37 => SDA <= '1';
          -- stop
        when 38     => SDA     <= '0';
        when others => SDA <= '1';
      end case;
    else
      SDA <= '1';
      SCL <= '1';
    end if;
  end process SCL_SDA;

  read_data_reg : process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        rd_data <= (others => '0');
      else
        if rd_en = '1' then
          case p is
            when 11 to 18 => rd_data(18 - p) <= SDA;
            when 20 to 27 => rd_data(27 - p) <= SDA;
            when 29 to 36 => rd_data(36 - p) <= SDA;
            when others => rd_data           <= (others => '0');
          end case;
        end if;
      end if;
    end if;
  end process read_data_reg;
end architecture;