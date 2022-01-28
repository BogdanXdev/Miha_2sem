library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
port (
	a : in unsigned (7 downto 0);
	b: in unsigned (7 downto 0);
	c: in unsigned (7 downto 0);
	y: out unsigned (8 downto 0)
	);
end entity;
architecture behav of top is 

begin

y <= ('0'&a) - ('0'&b) when (a > b) else 
	  ('0'&a) - ('0'&c) when (a > c) else 
	  ('0'&a) + ('0'&"00000001");

end architecture;