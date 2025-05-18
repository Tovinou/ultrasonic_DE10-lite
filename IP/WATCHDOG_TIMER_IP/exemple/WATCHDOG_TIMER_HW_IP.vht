-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "08/22/2024 14:48:40"
                                                            
-- Vhdl Test Bench template for design  :  WATCHDOG_TIMER_HW_IP
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY WATCHDOG_TIMER_HW_IP_vhd_tst IS
END WATCHDOG_TIMER_HW_IP_vhd_tst;
ARCHITECTURE WATCHDOG_TIMER_HW_IP_arch OF WATCHDOG_TIMER_HW_IP_vhd_tst IS
-- constants 
   constant clk_period : time := 10 ns;                                                
-- signals                                                   
   signal clk       : std_logic := '0';
   signal reset_n   : std_logic := '0';
   signal cs_n      : std_logic := '1';
   signal addr      : std_logic_vector(1 downto 0) := (others => '0');
   signal write_n   : std_logic := '1';
   signal read_n    : std_logic := '1';
   signal din       : std_logic_vector(31 downto 0) := (others => '0');
   signal dout      : std_logic_vector(31 downto 0);
   signal reset_out : std_logic;
	
COMPONENT WATCHDOG_TIMER_HW_IP
	PORT (
	clk        : in std_logic;
   reset_n    : in std_logic;
   cs_n       : in std_logic;  --IP component address
   addr       : in std_logic_vector(1 downto 0);  --offset address
   write_n    : in std_logic;
   read_n     : in std_logic;
   din        : in std_logic_vector(31 downto 0);  -- data in
   dout       : out std_logic_vector(31 downto 0); -- data out
   reset_out  : out std_logic -- signal to wdt reset
	);
END COMPONENT;
BEGIN
	i1 : WATCHDOG_TIMER_HW_IP
	PORT MAP (
-- list connections between master ports and signals
	addr => addr,
	clk => clk,
	cs_n => cs_n,
	din => din,
	dout => dout,
	read_n => read_n,
	reset_n => reset_n,
	reset_out => reset_out,
	write_n => write_n
	);
	
   clk <= not clk after clk_period / 2;	
	
	-- Stimulus Process
   stimulus: process
   begin
      -- Initial reset
      reset_n <= '0';
      wait for 5 ns;
      reset_n <= '1';
      wait for clk_period * 2;
      
      -- Write control register (timer start)
      cs_n <= '0';
      addr <= "01";
      write_n <= '0';
      din <= x"c0000000";  -- Writing "11" to the control register
      wait for 1000 ns;
      write_n <= '1';
      cs_n <= '1';
      wait for 1000 ns; -- Wait for a few clock cycles
      
      -- Read timer data
      cs_n <= '0';
      addr <= "00";
      read_n <= '0';
      wait for 1000 ns;
      read_n <= '1';
      cs_n <= '1';
      wait for 1000 ns;
      
      -- Write control register (timer reset)
      cs_n <= '0';
      addr <= "01";
      write_n <= '0';
      din <= x"40000000";  -- Writing "01" to the control register
      wait for 1000 ns;
      write_n <= '1';
      cs_n <= '1';
      wait for 1000 ns; -- Wait for a few clock cycles

      -- Read timer data
      cs_n <= '0';
      addr <= "00";
      read_n <= '0';
      wait for 1000 ns;
      read_n <= '1';
      cs_n <= '1';
      --wait for clk_period;
		
      WAIT;                                                        
   END PROCESS;                                          
END WATCHDOG_TIMER_HW_IP_arch;
