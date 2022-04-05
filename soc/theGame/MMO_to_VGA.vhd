ibrary ieee;
use ieee.std_logic_1164.all;

entity MMO_to_VGA is 
	generic (
	Hpulse  :=;
	HBP	  :=;
	HFP     :=;
	Hactive :=;
	
	Vpulse  :=;
	VBP	  :=;
	VFP     :=;
	Vactive :=
	);

port (
	clk : in std_logic;
	mmo_readdata   : in std_logic_vector(31 downto 0);
	mmo_address    :in std_logic_vector(4 downto 0);
	mmo_byteenable : in std_logic_vector(3 downto 0); 
	mmo_write 		: in std_logic;
	mmo_read 		: in std_logic;

	
	R, G, B : out std_logic_vector(7 downto 0) ;
	Hsync, Vsync : out std_logic
	
);

architecture rtl of MMO_to_VGA is 

begin

	


end architecture;