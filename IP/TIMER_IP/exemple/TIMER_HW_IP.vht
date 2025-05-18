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
-- Generated on "08/15/2024 21:48:05"
                                                            
-- Vhdl Test Bench template for design  :  TIMER_HW_IP
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY TIMER_HW_IP_vhd_tst IS
END TIMER_HW_IP_vhd_tst;
ARCHITECTURE TIMER_HW_IP_arch OF TIMER_HW_IP_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL addr : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL cs_n : STD_LOGIC;
SIGNAL din : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL dout : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ledr : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL read_n : STD_LOGIC;
SIGNAL reset_n : STD_LOGIC;
SIGNAL write_n : STD_LOGIC;
COMPONENT TIMER_HW_IP
	PORT (
	addr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	clk : IN STD_LOGIC;
	cs_n : IN STD_LOGIC;
	din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	ledr : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	read_n : IN STD_LOGIC;
	reset_n : IN STD_LOGIC;
	write_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : TIMER_HW_IP
	PORT MAP (
-- list connections between master ports and signals
	addr => addr,
	clk => clk,
	cs_n => cs_n,
	din => din,
	dout => dout,
	ledr => ledr,
	read_n => read_n,
	reset_n => reset_n,
	write_n => write_n
	);
-- Clock generation
   clk_process : process
   begin
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
   end process clk_process;

   -- Reset sequence
   reset_process : process
   begin
      reset_n <= '0';
      wait for 20 ns;
      reset_n <= '1';
      wait;
   end process reset_process;

   -- Test sequence
   test_process : process
   begin
      -- Write to control register
      cs_n <= '0';
      addr <= "01";
      write_n <= '0';
      din <= "00000000000000000000000000001010"; -- Write 0x02 to control register
      wait for 20 ns;
      write_n <= '1';

      -- Read from timer register
      cs_n <= '0';
      addr <= "00";
      read_n <= '0';
      wait for 20 ns;
      read_n <= '1';

      -- Write to timer register
      cs_n <= '0';
      addr <= "00";
      write_n <= '0';
      din <= "00000000000000000000000001010101"; -- Write 0x55 to timer register
      wait for 20 ns;
      write_n <= '1';

      -- Read from timer register again
      cs_n <= '0';
      addr <= "00";
      read_n <= '0';
      wait for 20 ns;
      read_n <= '1'; 
WAIT;                                                        
END PROCESS;                                          
END TIMER_HW_IP_arch;
