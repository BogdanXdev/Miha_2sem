
library ieee;
use ieee.std_logic_1164.all;

entity avalon_ST_export_bridge is

	generic (
		data_width : natural := 32
	);

	port (

		clk_i : in std_logic;
		--sink

		i_sti_reset : in std_logic;
		o_sti_ready : out std_logic;
		i_sti_data  : in std_logic_vector(data_width - 1 downto 0);
		i_sti_valid : in std_logic;
		o_sti_reset : out std_logic;
		i_sti_eof   : in std_logic;
		i_sti_sof   : in std_logic;

		--source
		i_sto_reset : in std_logic;
		i_sto_ready : in std_logic;
		o_sto_data  : out std_logic_vector(data_width - 1 downto 0);
		o_sto_valid : out std_logic;
		o_sto_reset : out std_logic;
		o_sto_eof   : out std_logic;
		o_sto_sof   : out std_logic

	);

end entity;

architecture behav of avalon_ST_export_bridge is
begin

	o_sto_data  <= i_sti_data;
	o_sto_valid <= i_sti_valid;
	o_sti_ready <= i_sto_ready;
	o_sto_reset <= i_sto_reset;
	o_sti_reset <= i_sti_reset;

	o_sto_eof <= i_sti_eof;
	o_sto_sof <= i_sti_sof;

end architecture;