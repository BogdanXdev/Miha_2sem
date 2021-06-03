library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchr_edge_det is
    port (
        clk : in std_logic;
        reset : in std_logic;
        in_async : in std_logic;
        en_out : out std_logic
    );
end entity;

architecture rtl of synchr_edge_det is

    signal meta_reg : std_logic;
    signal sync_reg : std_logic;
    signal meta_next : std_logic;
    signal sync_next : std_logic;
    signal edge_det_next : std_logic;
    signal edge_det_reg : std_logic;

begin

    process (all) begin
        if (reset =  '1') then
            meta_reg <= '0';
            sync_reg <= '0';
            edge_det_reg <= '0';
        elsif rising_edge(clk) then
            meta_redg <= meta_next;
            sync_reg <= sync_next;
            edge_det_reg <= edge_det_next;
        end if;
    end process;

    -- 2FF synchronizer
    meta_next <= in_async;
    sync_next <= meta_reg;

    -- edge detector 
    edge_det_next <= sync_reg;
    en_out <= (not edge_det_reg) and edge_det_next;

end architecture;