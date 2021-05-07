library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is

	--generic (
	--	width : natural := 8 -- input signal width
	--);

	port 
	(
		a	    : in std_logic_vector (7 downto 0);
		b 		 : in std_logic_vector (7 downto 0);
		result : out std_logic
	);

end entity;

architecture behav of comparator is
begin

	process (a, b)  begin 
		if (a = b) then 
			result <= '1';  
		else 
			result <= '0' ;
		end if;
	end process;

end behav;
