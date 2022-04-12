
library ieee;
use ieee.std_logic_1164.all;

entity avalon_ST_export_bridge is 

	generic
	(
		data_width : natural := 32
	);

	port 
	(
	--sink
		
		i_sti_reset : in std_logic;
		o_sti_ready : out std_logic;
		i_sti_data : in std_logic_vector(data_width - 1 downto 0);
		i_sti_valid : in std_logic;
		o_sti_reset : out std_logic;
			
--source
	
			
		i_sto_reset : in std_logic;
		i_sto_ready : in std_logic;
		o_sto_data : out std_logic_vector(data_width - 1 downto 0);
		o_sto_valid : out std_logic;
		o_sto_reset : out std_logic;
		
	);

end entity;