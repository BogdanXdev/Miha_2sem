library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity top_tb is
end entity;

architecture sim of top_tb is
    constant TEST_COUNT : natural := 50;
    constant CLK_PERIOD : time    := 10 ns;

    signal clk_tb      : std_logic := '0';
    signal start_tb    : std_logic := '0';
    signal divident_tb : std_logic_vector(15 downto 0);
    signal divisor_tb  : std_logic_vector(15 downto 0);
    signal done_tb     : std_logic;
    signal quotient_tb : std_logic_vector(15 downto 0);
    signal reminder_tb : std_logic_vector(15 downto 0);
    -- impure function random_slv (len : natural) return std_logic_vector is
    --     variable r                      : real;
    --     variable slv                    : std_logic_vector(len - 1 downto 0);
    --     variable SEED2                  : integer := 221;
    --     variable SEED1                  : integer := 120;
    -- begin
    -- for i in slv'range loop
    --     uniform(SEED1, SEED2, r);
    --     slv(i) := '1' when r > 0.5 else
    --     '0';
    -- end loop;
    --     return slv;
    -- end function;

begin

    DUT : entity work.top
        port map(
            clk      => clk_tb,
            start    => start_tb,
            divident => divident_tb,
            divisor  => divisor_tb,
            done     => done_tb,
            quotient => quotient_tb,
            reminder => reminder_tb
        );

    clk_tb <= not clk_tb after CLK_PERIOD / 2;

    process
        variable dut_quotient : std_logic_vector(quotient_tb'range) := (others => '0');
        variable dut_reminder : std_logic_vector(reminder_tb'range) := (others => '0');

        procedure update_input(s1, s2 : in integer) is
            variable r                    : real;
            -- variable slv                  : std_logic_vector(divident_tb'lenght - 1 downto 0);
        begin

            for i in divident_tb'range loop
                uniform(s1, s2, r);
                divident_tb <= '1' when r > 0.5 else
                '0';
                divisor_tb <= '1' when r > 0.4 else
                    '0';
            end loop;
            -- divident_tb <= random_slv(divident_tb'length);
            -- divisor_tb  <= random_slv(divisor_tb'length);
        end procedure;

        procedure update_dut is -- result we wait;
        begin
            dut_quotient :=
                std_logic_vector(to_unsigned(
                to_integer(unsigned(divident_tb)) / to_integer(unsigned(divisor_tb)),
                dut_quotient'length));
            dut_reminder :=
                std_logic_vector(to_unsigned(
                to_integer(unsigned(divident_tb)) rem to_integer(unsigned(divisor_tb)),
                dut_reminder'length));
        end procedure;

        procedure check_dut is
        begin
            report
                "Expression: "
                & integer'image(to_integer(unsigned(divident_tb))) & " / "
                & integer'image(to_integer(unsigned(divisor_tb))) & "; " &
                "Expected: "
                & integer'image(to_integer(unsigned(dut_quotient))) & " (rem: "
                & integer'image(to_integer(unsigned(dut_reminder))) & " ); " &
                "Got: "
                & integer'image(to_integer(unsigned(quotient_tb))) & " (rem: "
                & integer'image(to_integer(unsigned(reminder_tb))) & " ); ";

            if (dut_quotient /= quotient_tb) or (dut_reminder /= reminder_tb) then
                report "FAILURE (NO MATCH): the expected and modelled outputs do not match."
                    severity FAILURE;
            end if;
        end procedure;

    begin
        for i in 0 to TEST_COUNT - 1 loop
            update_input(i,i);

            wait for CLK_PERIOD;
            start_tb <= '1';
            wait for CLK_PERIOD;
            start_tb <= '0';

            update_dut;
            wait until rising_edge(done_tb);
            check_dut;

        end loop;
        report"TEST SUCCESSFUL";
        wait;
    end process;

end architecture;