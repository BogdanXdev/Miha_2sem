
library ieee;
use ieee.std_logic_1164.all;

entity avalon_MM_export_bridge is

	generic
	(
		addr_width : natural := 5
	);

	port 
	(
		clk_i		: in std_logic;
		clk_o		: out std_logic;
		
		i_reset : in std_logic;
		i_mmi_write : in std_logic;
		i_mmi_read : in std_logic;
		i_mmi_address : in std_logic_vector(addr_width - 1 downto 0);
		i_mmi_writedata : in std_logic_vector(31 - 1 downto 0);
		i_mmi_byteenable : in std_logic_vector(3 downto 0);
		o_mmi_readdata : out std_logic_vector(31 - 1 downto 0);
		
		o_reset : out std_logic;
		o_mmO_write : out std_logic;
		o_mmO_read : out std_logic;
		o_mmO_address : out std_logic_vector(addr_width - 1 downto 0);
		o_mmO_writedata : out std_logic_vector(31 - 1 downto 0);
		o_mmO_byteenable : out std_logic_vector(3 downto 0);
		i_mmO_readdata : in std_logic_vector(31 - 1 downto 0)
		
	);

end entity;

architecture rtl of avalon_MM_export_bridge is

begin

	o_reset <= i_reset;
	clk_o <= clk_i ;
	
	o_mmo_address <= i_mmi_address;
	o_mmo_byteenable <= i_mmi_byteenable;
	o_mmo_writedata <= i_mmi_writedata;
	o_mmo_write <= i_mmi_write;
	o_mmo_read <= i_mmi_read;
	o_mmi_readdata <= i_mmo_readdata;
	
end rtl;
