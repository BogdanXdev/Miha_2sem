library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity;

architecture i2c_controller_top_tb is

    -- i2c controller interface
    signal clk_tb : std_logic := '0';                           --signal driven by tb
    signal rst_tb : std_logic := '0';                           --signal driven by tb
    signal wr_tb : std_logic;                                   --signal driven by tb
    signal rd_tb : std_logic;                                   --signal driven by tb
    signal SCL_tb : std_logic;                          --signal driven by controller
    signal SDA_tb : std_logic;                          --signal driven by controller
    signal write_data_tb : std_logic_vector(7 downto 0);        --signal driven by tb
    signal read_data_tb : std_logic_vector(7 downto 0); --signal driven by controller

    constant half_period : integer := 20;

    --  slave emulation
    constant SLAVE_ADDRESS : std_logic_vector(6 downto 0) := "0110101";
    -- 7 bits for data because 1 bit reserved for write/read command
    signal CR0 : std_logic_vector(6 downto 0);          -- slave' 0 config register
    signal CR1 : std_logic_vector(6 downto 0);          -- slave' 1 config register
    signal CR2 : std_logic_vector(6 downto 0);          -- slave' 2 config register
    signal CR0_next : std_logic_vector(6 downto 0);
    signal CR1_next : std_logic_vector(6 downto 0);
    signal CR2_next : std_logic_vector(6 downto 0);
    signal data_for_CR0 : std_logic_vector(6 downto 0) := "0000001";
    signal data_for_CR1 : std_logic_vector(6 downto 0) := "1000000";
    signal data_for_CR2 : std_logic_vector(6 downto 0) := "1111110";

    -- Registers to store read results and make comparison
    signal CompareReg0 : std_logic_vector(6 downto 0);
    signal CompareReg1 : std_logic_vector(6 downto 0);
    signal CompareReg2 : std_logic_vector(6 downto 0);
    signal CompareReg0_next : std_logic_vector(6 downto 0);
    signal CompareReg1_next : std_logic_vector(6 downto 0);
    signal CompareReg2_next : std_logic_vector(6 downto 0);
    signal start_the_comparison : std_logic;

    constant 3_REGS_WRITE : integer :=  ;   -- need to precise how mcuh 
    constant 3_REGS_READ : integer :=  ; 

    begin

    regs : process (all)
    begin
        if rising_edge(clk_tb) then
            if rst_tb = '1' then
                CR0 <= (others => '0');
                CR1 <= (others => '0');
                CR2 <= (others => '0');
                CompareReg0 <= (others => '0');
                CompareReg1 <= (others => '0');
                CompareReg2 <= (others => '0');
            else
                CR0 <= CR0_next;
                CR1 <= CR1_next;
                CR2 <= CR2_next;
                CompareReg0 <= CompareReg0_next; 
                CompareReg1 <= CompareReg1_next;
                CompareReg2 <= CompareReg2_next;
            end if;
        end if;
    end process regs;

    -- stimuli generator 
    -- clk and rst gen
    clk_tb <= not clk_tb after half_period * 1 ns;
    rst_tb <= '1', '0' after 20 * half_period * 1 ns;

    write_and_read_sequence: process 
    begin
        wr_tb <= '0';
        rd_tb <= '0';
        wait until rst_tb = '0';
        wr_tb <= '1'; 
        wait for 3_REGS_WRITE * half_period * 2 ns;
        wr_tb <= '0'; 
        rd_tb <= '1';
        wait for 3_REGS_READ * half_period * 2 ns;
        wr_tb <= '0'; 
        rd_tb <= '0';
        start_the_comparison <= '1';
        wait;
    end process write_and_read_sequence;
    
    write_Data_sended_to_i2c_controller: process
    begin
        
    end process write_Data_sended_to_i2c_controller;

    -- template generator
    read_register_to_comparison_reg_copying: process
    begin
        wait until first_read_pack_intrance = '1';
        CompareReg0_next <= read_data_tb  ;
        wait until second_read_pack_intrance = '1';
        CompareReg1_next <= read_data_tb  ;
        wait until third_read_pack_intrance = '1';
        CompareReg2_next <= read_data_tb  ;
    end process read_register_to_comparison_reg_copying;

    -- comparison module 
    write_Data_and_comparison_registers_check: process
    begin
        assert report ...
    end process write_Data_and_comparison_registers_check;
end architecture;