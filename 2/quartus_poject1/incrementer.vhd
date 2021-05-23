library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incrementer is

	generic (
		width : natural := 8 
	);

	port 
	(
		a	    : in std_logic_vector (width - 1 downto 0);
		result : out std_logic_vector (width - 1 downto 0)
	);
end entity;

architecture behav of incrementer is
	
begin
	
	process (a)  begin 
		result <= std_logic_vector (unsigned(a) + 1);
	end process;

end behav;
