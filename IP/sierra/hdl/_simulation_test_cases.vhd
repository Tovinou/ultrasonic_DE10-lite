 --------------------------------------------------------------------------------
 --                Sierra Real-Time Kernel simulation file
 --             
 --  $Workfile    :  _simulation_test_cases.vhd $ 
 -- 
 --  Company      :  AGSTU AB
 --  Programmer(s):  Lennart Lindh 
 --               :  
 --  Date Created :  2014-12-04
 --  
 --  Description  :  VHDL Package Header 
 --               :  This is the test cases for Sierra
 --  Notes        :  Do not change these constants whithout having access to the
 --               :  complete vhdl source code. 
 -- 
 -- COPYRIGHT (C) 2014
 -- 
 -- COPYRIGHT (C) 2006 - 2014 AGSTU AB
 -- All rights reserved. AGSTU's source code is an unpublished 
 -- work, and the use of a copyright notice does not imply otherwise. This 
 -- source code contains confidential, trade-secret material of AGSTU AB. 
 -- Any attempt at or participation in deciphering, decoding, reverse 
 -- engineering, or in any way altering the source code is strictly 
 -- prohibited unless the prior written consent of AGSTU AB is obtained.
 -- Disclaimer
 -- All code in this file are provided "as is" and without any warranties 
 -- expressed or implied, including but not limited to implied warranties 
 -- of merchantability and fitness for a particular purpose. In no event 
 -- should the author be liable for any damages whatsoever (including without 
 -- limitation, damages for loss of business profits, business interruption, 
 -- loss of business information, or any other pecuniary loss) arising out 
 -- of the use or inability to use information (including software, designs 
 -- and files) provided on this site.
 -- 
 --------------------------------------------------------------------------------
 -- Revision history    
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
LIBRARY work;
USE work.internal_global.all;
USE work.simulation_basic.all; 
USE work.internals.all;

package simulation_test_cases is
  
procedure test_case_0_version_register(
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal dout: in std_logic_vector(31 downto 0));

procedure test_case_1_timer_register(
--constant din_to_sierra: in std_logic_vector(31 downto 0); 
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: out std_logic_vector(31 downto 0));

procedure test_case_3_create_task(
--constant din_to_sierra: in std_logic_vector(31 downto 0); 
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: inout std_logic_vector(31 downto 0);
signal dout: in std_logic_vector(31 downto 0));

end package simulation_test_cases;

-----------------------------------------------------------------------

Package body simulation_test_cases is

-------------------------------------------------------------------
----- Test_case 0 test of version register ------------------------
-- 
procedure test_case_0_version_register(
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal dout: in std_logic_vector(31 downto 0))is

begin
  
  
REPORT "*****************************test_case_0_version_register*********************************";

sim_read_reg(sierra_version_addr, addr => addr, write_n => write_n, cs_n => cs_n, dout => dout);

-- Check sierra vesrion
ASSERT  Sierra_VHDL_VERSION = dout
REPORT "wrong version register"
SEVERITY failure;
end test_case_0_version_register;
----------------- end   Test_case 0 test of version register ----------------------

-------------------------------------------------------------------
----- Test_case 1 test of timer register ------------------------
-- Test to write to timer register
procedure test_case_1_timer_register(
--constant din_to_sierra: in std_logic_vector(31 downto 0); 
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: out std_logic_vector(31 downto 0)) is
begin

REPORT "***************************** test_case_1_timer_register *********************************";

sim_write_reg(sierra_time_base_addr ,test_value_0101,addr,write_n,cs_n,din);
-- Check write
ASSERT  time_base_register = test_value_0101(cofiguration_base_time_divider downto 0)
report "Timer Register is " & integer'image(prtstd(time_base_register))
SEVERITY failure;

sim_write_reg(sierra_time_base_addr ,test_value_0001,addr,write_n,cs_n,din);
-- Check write
ASSERT  time_base_register = test_value_0001(cofiguration_base_time_divider downto 0)
report "Timer Register is " & integer'image(prtstd(time_base_register))
SEVERITY failure;

-- Check 1000 timer puls *** Måste göras!!

end test_case_1_timer_register;
------------- end TEST_case 1 --------------------------------------
--------------
--------------------------------------------------------------------
------------- Test CASE 3 Create task
procedure test_case_3_create_task(
--constant din_to_sierra: in std_logic_vector(31 downto 0); 
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: inout std_logic_vector(31 downto 0);
--signal dout_return_svc: out std_logic_vector(31 downto 0);
signal dout: in std_logic_vector(31 downto 0)) is

--variable dout_return_svc : std_logic_vector(31 downto 0);
constant create_ideal_task : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111111" & "000000000000";
constant create_task_1 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111110" & "000000000001";
constant create_task_2 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111101" & "000000000010";
constant create_task_3 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111100" & "000000000011";
constant create_task_4 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111011" & "000000000100";
constant create_task_5 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111010" & "000000000101";
constant create_task_6 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111001" & "000000000110";
constant create_task_7 : std_logic_vector(31 downto 0) := sch_svc & sch_create & "U1" & "111111111000" & "000000000111";
begin
------------------------------
--    task_create
---------------------------------
--   struct {
--     unsigned int taskID:12;   
--     unsigned int priority:12;
--     unsigned int state:1;
--     unsigned int :1;
--     unsigned short int type:6;
--   } task_create;

REPORT "***************************** test_case_3_Create task *********************************";

-- create ideal task (in sch_svc(3)&sch_create(3)&'x'&'1'(state flag, run)&task prio(12)&task_id (12)
sim_SVC_CALL(create_ideal_task,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_1,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_2,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_3,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_4,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_5,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_6,addr,write_n,cs_n,din,dout);
sim_SVC_CALL(create_task_7,addr,write_n,cs_n,din,dout);

WAIT FOR 2*CLK_PERIOD_Sierra;

-- TSW_on
sim_TSW_ON(addr,write_n,cs_n,din);

-- cpu control register, first IRQ
WAIT UNTIL STATUS_register_b(0) = '1';
WAIT FOR 2*CLK_PERIOD_Sierra;

-- ACK
sim_write_reg(sierra_control_addr,"00000000000000000000000000000001",addr,write_n,cs_n,din);
WAIT FOR 2*CLK_PERIOD_Sierra;

-- read teask id
sim_read_reg(sierra_status_b_addr, addr => addr, write_n => write_n, cs_n => cs_n, dout => dout);
WAIT FOR 2*CLK_PERIOD_Sierra;

-- Check task 7 starts
ASSERT  STATUS_register_b(3 downto 1) = "111"
report "Error wrong task starts " & integer'image(prtstd(STATUS_register_b))
SEVERITY failure;

-- Finich IRQ, ACK low
sim_write_reg(sierra_control_addr,"00000000000000000000000000000000",addr,write_n,cs_n,din);

-- Skriv denna testcase generisk (task), först skapa tasken och därefter avsluta dem med IRQ (utan ideal)

end test_case_3_create_task;

-- Task_change_prio


end package body simulation_test_cases;

