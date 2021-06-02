library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity synchr_edge_det is
    port (
        clk, reset : in std_logic;
        in_async : in std_logic;
        out_sync : out std_logic
    );
end entity;

architecture rtl of synchr_edge_det is
    signal meta_reg, sync_reg : std_logic;
    signal meta_next, sync_next : std_logic;
begin

    process (clk. reset) begin
        if (reset =  '1') then
            meta_reg <= '0;
            sync_reg <= '0;
        elsif rising_edge(clk) then
            meta_redg <= meta_next;
            sync_reg <= sync_next;
        end if;
    end process;

    meta_next <= in_async;
    sync_next <= meta_reg;

    out_sync <= sync_reg;

end architecture;