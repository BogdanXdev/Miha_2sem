library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circular_shifter_left is 
port (
	input  : in std_logic_vector(15 downto 0);
	shift	 : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(15 downto 0)
);
end entity;

architecture behav of circular_shifter_left is 

	
begin 
	
	output <=  input 												 when (shift = "0000") else
				  input(14 downto 0) & input(15 downto 15) when (shift = "0001") else 
				  input(13 downto 0) & input(15 downto 14) when (shift = "0010") else 
				  input(12 downto 0) & input(15 downto 13) when (shift = "0011") else
				  input(11 downto 0) & input(15 downto 12) when (shift = "0100") else 
				  input(10 downto 0) & input(15 downto 11) when (shift = "0101") else
				  input(9 downto 0)  & input(15 downto 10) when (shift = "0110") else
				  input(8 downto 0)  & input(15 downto 9)  when (shift = "0111") else
				  input(7 downto 0)  & input(15 downto 8)  when (shift = "1000") else
				  input(6 downto 0)  & input(15 downto 7)  when (shift = "1001") else
				  input(5 downto 0)  & input(15 downto 6)  when (shift = "1010") else
				  input(4 downto 0)  & input(15 downto 5)  when (shift = "1011") else
				  input(3 downto 0)  & input(15 downto 4)  when (shift = "1100") else
				  input(2 downto 0)  & input(15 downto 3)  when (shift = "1101") else
				  input(1 downto 0)  & input(15 downto 2)  when (shift = "1110") else
				  input(0 downto 0)  & input(15 downto 1);
				
end architecture;