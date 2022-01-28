library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top4 is 
	port (
		a : in unsigned (15 downto 0);
		--b : in unsigned (15 downto 0):= "0000000000000001";
		y : out unsigned (16 downto 0)
	);
end entity;

architecture struct of top4 is
	
begin
	y <= ('0'&a) + ('0'&"1000000000000000");

end architecture;