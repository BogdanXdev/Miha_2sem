library ieee;
use ieee.std_logic_1164.all;

entity lab is
	port (
		clk : in std_logic;
		-- avalon-mm interface
		writereq  : in std_logic;
		address   : in std_logic_vector(1 downto 0);
		writedata : in std_logic_vector(7 downto 0);
		-- outputs for 7segment displayes
		val0 : out std_logic_vector(7 downto 0);
		val1 : out std_logic_vector(7 downto 0);
		val2 : out std_logic_vector(7 downto 0)
	);
end entity;

architecture RTL of lab is
	signal data_reg : std_logic_vector(7 downto 0);
	signal data_next : std_logic_vector(7 downto 0);
	signal address_reg : std_logic_vector(1 downto 0);
	signal address_next : std_logic_vector(1 downto 0);
	type statetype is (waiting_req, sending);
begin
	-- reg-state logic
	-- <LAB: your code goes here>
	process (clk)
	begin
		if rising_edge(clk) then
			data_reg <= data_next;
			address_reg <= address_next;
		end if;
	end process;

	-- next-state logic
	-- <LAB: your code goes here>
	

	-- if request then 
	-- if address = 0 
		-- val0 = data_reg 
	-- if address = 1
		-- val1 = data_reg
	-- if address = 2 
		-- val2 = data_reg

	-- outputs

	-- <LAB: your code goes here>

end architecture;