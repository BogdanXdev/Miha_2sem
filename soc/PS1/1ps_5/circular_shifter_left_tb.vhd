library ieee;
--library rtu;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
--use rtu.random.all;

entity circular_shifter_left_tb is
end entity;

architecture sim of circular_shifter_left_tb is
  -- Test constants
  constant TEST_COUNT : natural := 1000;

  -- DUT signals
  signal input_tb  : std_logic_vector(15 downto 0) := (others => '0');
  signal shift_tb  : std_logic_vector(3 downto 0)  := (others => '0');
  signal output_tb : std_logic_vector(15 downto 0) := (others => '0');

  -- Generate random std_logic
  impure function random_slv return std_logic is
    variable r            : real;
    variable sl           : std_logic;
    variable SEED2                  : integer := 100;
    variable SEED1                  : integer := 100;
  begin
    uniform(SEED1, SEED2, r);
    sl := '1' when r > 0.5 else
      '0';
    return sl;
  end function;

  -- Generate random std_logic_vector
  impure function random_slv (len : natural) return std_logic_vector is
    variable r                      : real;
    variable slv                    : std_logic_vector(len - 1 downto 0);
    variable SEED2                  : integer := 120;
    variable SEED1                  : integer := 120;
  begin
    for i in slv'range loop
      uniform(SEED1, SEED2, r);
      slv(i) := '1' when r > 0.5 else
      '0';
    end loop;
    return slv;
  end function;

begin

  ------------------------------------------------------------------------------
  -- Instantianate DUT
  ------------------------------------------------------------------------------
  DUT : entity work.circular_shifter_left
    port map(
      input  => input_tb,
      shift  => shift_tb,
      output => output_tb);

  ------------------------------------------------------------------------------
  -- Model-based test
  ------------------------------------------------------------------------------
  process
    --variable random 		 : random_t;
    variable dut_output : std_logic_vector(output_tb'range) := (others => '0');

    procedure update_dut is
      variable dut_shift : natural := to_integer(unsigned(shift_tb));
    begin
      dut_output(dut_output'high downto dut_shift)
      := input_tb(dut_output'high - dut_shift downto 0);
      if (unsigned(shift_tb) > 0) then
        dut_output((dut_shift - 1) downto 0)
        := input_tb(dut_output'high downto dut_output'high - (dut_shift - 1));
      end if;
    end procedure;

    procedure update_input is
    begin
      --input_tb 	<= random.random_slv(input_tb'length);
      --shift_tb <= random.random_slv(shift_tb'length);

      input_tb <= random_slv(input_tb'length);
      shift_tb <= random_slv(shift_tb'length);
    end procedure;

    procedure check_dut is
    begin
      if output_tb /= dut_output then
        report "TEST FAILED, " &
          "Expecting: " & integer'image(to_integer(unsigned(dut_output))) & "; " &
          "Got: " & integer'image(to_integer(unsigned(output_tb)))
          severity FAILURE;
      end if;
    end procedure;
  begin

    for i in 0 to TEST_COUNT - 1 loop
      update_input;
      wait for 10 ns;
      update_dut;
      check_dut;
    end loop;
    report"TEST SUCCESSFUL";
    wait;
  end process;

end architecture;