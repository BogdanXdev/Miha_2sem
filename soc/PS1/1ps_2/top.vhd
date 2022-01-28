library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
	port (
		a : in unsigned (15 downto 0);
		b : in unsigned (15 downto 0);
		y : out unsigned (16 downto 0)
	);
end entity;

architecture struct of top is
	
begin
	y <= ('0'&a) + ('0'&b);

end architecture;