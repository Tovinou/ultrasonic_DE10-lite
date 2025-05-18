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
-- Generated on "07/12/2024 22:22:48"
                                                            
-- Vhdl Test Bench template for design  :  vga_ip
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY vga_ip_vhd_tst IS
END vga_ip_vhd_tst;
ARCHITECTURE vga_ip_arch OF vga_ip_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL addr : STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL clk_25 : STD_LOGIC;
SIGNAL CLOCK_50 : STD_LOGIC;
SIGNAL cs_n : STD_LOGIC;
SIGNAL din : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL dout : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL read_n : STD_LOGIC;
SIGNAL reset_n : STD_LOGIC;
SIGNAL VGA_B : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL VGA_G : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL VGA_HS : STD_LOGIC;
SIGNAL VGA_R : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL VGA_VS : STD_LOGIC;
SIGNAL we_n : STD_LOGIC;
COMPONENT vga_ip
	PORT (
	   CLOCK_50          : in std_logic:= '0';
      reset_n           : in std_logic:= '0';
      clk_25            : in std_logic:= '0';
      VGA_VS            : out std_logic;
      VGA_HS            : out std_logic;
      VGA_R             : out std_logic_vector(3 downto 0);
      VGA_G             : out std_logic_vector(3 downto 0);
      VGA_B             : out std_logic_vector(3 downto 0);
      cs_n              : in std_logic:= '1';
      read_n            : in std_logic:= '1';
      we_n              : in std_logic:= '1';
      addr              : in std_logic_vector(16 downto 0):= (others => '0');
      din               : in std_logic_vector(31 downto 0):= (others => '0');
      dout              : out std_logic_vector(31 downto 0)
	   );
END COMPONENT;
BEGIN
	i1 : vga_ip
	PORT MAP (
-- list connections between master ports and signals
	addr => addr,
	clk_25 => clk_25,
	CLOCK_50 => CLOCK_50,
	cs_n => cs_n,
	din => din,
	dout => dout,
	read_n => read_n,
	reset_n => reset_n,
	VGA_B => VGA_B,
	VGA_G => VGA_G,
	VGA_HS => VGA_HS,
	VGA_R => VGA_R,
	VGA_VS => VGA_VS,
	we_n => we_n
	);
	
-- Clock generation
   CLOCK_50_process : process
   begin
      CLOCK_50 <= '0';
      wait for 10 ns;
      CLOCK_50 <= '1';
      wait for 10 ns;
   end process CLOCK_50_process;

   clk_25_process : process
   begin
      clk_25 <= '0';
      wait for 20 ns;
      clk_25 <= '1';
      wait for 20 ns;
   end process clk_25_process;

   -- Reset sequence
   reset_process : process
   begin
      reset_n <= '0';
      wait for 10 ns;
      reset_n <= '1';
		wait for 10 ns;
   end process reset_process;

   -- Test sequence
   test_process : process
   begin
      -- Write to VGA memory
      cs_n <= '0';
      addr <= "00000000000000000";
      we_n <= '0';
      din <= "00000000000000000000000001010101"; -- Write 0x55 to VGA memory
      wait for 20 ns;
      we_n <= '1';

      -- Read from VGA memory
      cs_n <= '0';
      addr <= "00000000000000000";
      read_n <= '0';
      wait for 20 ns;
      read_n <= '1';

      -- Change VGA mode
      cs_n <= '0';
      addr <= "00000000000000001";
      we_n <= '0';
      din <= "00000000000000000000000000000010"; -- Change VGA mode
      wait for 20 ns;
      we_n <= '1';
 
WAIT;                                                        
END PROCESS;                                          
END vga_ip_arch;
