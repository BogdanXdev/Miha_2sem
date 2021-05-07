
library ieee;
use ieee.std_logic_1164.all;

entity top is

	port 
	(
		D0		: in std_logic;
		D1		: in std_logic;
		D2		: in std_logic;
		P0		: out std_logic;
		P1		: out std_logic;
		P2		: out std_logic
	);

end entity;

architecture behav of top is

begin

	P0 <= (D2 and D1 and (not D0)) or ((not D2) and D1 and D0) or ((not D2) and (not D1)  and D0) ;
	P1 <= (not D2) and (not D1)  and D0 ;
	P2 <= (D2 and (not D1) and (not D0)) or (D2 and (not D1) and D0) or ((not D2) and (not D1) and (not D0));

end behav;
