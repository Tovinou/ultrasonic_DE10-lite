 --------------------------------------------------------------------------------
 --                Sierra Real-Time Kernel simulation file
 --             
 --  $Workfile    :  _simulation_basic.vhd $ 
 -- 
 --  Company      :  AGSTU AB
 --  Programmer(s):  Lennart Lindh 
 --               :  
 --  Date Created :  2014-12-04
 --  
 --  Description  :  VHDL Package Header 
 --               :  The constants in this file is basic bus simulation and som other procedures for the test cases
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
--USE work.simulation_basic.all; 
--USE work.simulation_test_cases.all; 
USE work.internals.all; 

package simulation_basic is
  
-- clk period, 50 MHz
constant CLK_PERIOD_Sierra : time := 10 ns; 
  
--- simulation values
constant test_value_0101: std_logic_vector(31 downto 0) := X"55555555"; 
constant test_value_1010: std_logic_vector(31 downto 0) := X"AAAAAAAA"; 
constant test_value_0000: std_logic_vector(31 downto 0) := X"00000000"; 
constant test_value_0001: std_logic_vector(31 downto 0) := X"00000001";   
constant test_value_FFFF: std_logic_vector(31 downto 0) := X"FFFFFFFF"; 
  
procedure sim_reset(signal reset_n : out std_logic); 

procedure sim_read_reg(
constant addr_reg: in std_logic_vector(7 downto 0); 
--signal last_dout_from_sierra: out std_logic_vector(31 downto 0); 
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal dout: in std_logic_vector(31 downto 0));

procedure sim_write_reg(
constant addr_reg: in std_logic_vector(7 downto 0); 
constant din_to_sierra: in std_logic_vector(31 downto 0); 
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: out std_logic_vector(31 downto 0));

procedure sim_SVC_CALL(
constant din_SVC_sierra: in std_logic_vector(31 downto 0); -- Data from CPU
--variable dout_return_svc: out std_logic_vector(31 downto 0);
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: inout std_logic_vector(31 downto 0);
signal dout: in std_logic_vector(31 downto 0)
);

procedure sim_TSW_ON(
--constant addr_reg: in std_logic_vector(7 downto 0); -- address from CPU
--constant din_to_sierra: in std_logic_vector(31 downto 0); -- Data from CPU
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: out std_logic_vector(31 downto 0));

function prtstd( v : std_logic_vector ) return integer;

end package simulation_basic;

-----------------------------------------------------------------------

Package body simulation_basic is

-------------------------------------------------------
------------- reset_n ---------------------------
-- reset and wait to all rams is initiated
-------------------------------------------------------
procedure sim_reset(signal reset_n : out std_logic) is
begin
  reset_n <= '0'; 
  WAIT FOR 3*CLK_PERIOD_Sierra; -- Target running 
  reset_n <= '1';
  WAIT FOR (2**taskid + 4)*CLK_PERIOD_Sierra; -- Delay so all ram will be initated
  reset_n <= '1';
end sim_reset; 

-------------------------------------------------------
------------- read register ---------------------------
-- Bus read access for all registers
------------------------------------------------------
procedure sim_read_reg(
constant addr_reg: in std_logic_vector(7 downto 0); -- address from CPU
--signal last_dout_from_sierra: out std_logic_vector(31 downto 0); -- read value to CPU
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal dout: in std_logic_vector(31 downto 0)) is
begin
--  S_addr <= addr_reg_cpu after 5 ns;
  addr <= addr_reg;
  write_n <= '1';
  cs_n <= '0';
  WAIT FOR CLK_PERIOD_Sierra; -- denna ska optimeras bort
  WAIT FOR CLK_PERIOD_Sierra/2;
 -- last_dout_from_sierra <= dout;
  WAIT FOR CLK_PERIOD_Sierra/2;
  cs_n <= '1';
  end sim_read_reg;

-------------------------------------------------------
------------- Write register ---------------------------
-- Bus Write access for all registers
------------------------------------------------------
procedure sim_write_reg(
constant addr_reg: in std_logic_vector(7 downto 0); -- address from CPU
constant din_to_sierra: in std_logic_vector(31 downto 0); -- Data from CPU
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: out std_logic_vector(31 downto 0)) is
begin
--  S_addr <= addr_reg_cpu after 5 ns;
  addr <= addr_reg;
  din <= din_to_sierra;
  write_n <= '0';
  cs_n <= '0';
  WAIT FOR 2*CLK_PERIOD_Sierra; -- denna ska optimeras bort
  cs_n <= '1';
  write_n <= '1';
  WAIT FOR CLK_PERIOD_Sierra;
end sim_write_reg;

-------------------------------------------------------
------------- SVC Call ---------------------------
-- Write, read ACK and do it agine if needed (perhaps a report?)
------------------------------------------------------
-- Parameters SVC type, parameters
procedure sim_SVC_CALL(
constant din_SVC_sierra: in std_logic_vector(31 downto 0); -- Data from CPU
--variable dout_return_svc: out std_logic_vector(31 downto 0); -- return data to CPU
signal addr: inout std_logic_vector(7 downto 0);
signal write_n: inout std_logic;
signal cs_n: inout std_logic;
signal din: inout std_logic_vector(31 downto 0);
signal dout: in std_logic_vector(31 downto 0)
) is

begin
-- write SVC and parameters, din_to_sierra
sim_write_reg(sierra_service_request_addr,din_SVC_sierra,addr,write_n,cs_n,din);

-- Read ack and also return parmeters
WAIT UNTIL STATUS_register_a(0) = '1';
WAIT UNTIL STATUS_register_a(0) = '0';
sim_read_reg(sierra_status_a_addr, addr => addr, write_n => write_n, cs_n => cs_n, dout => dout);

WAIT FOR CLK_PERIOD_Sierra;
end sim_SVC_CALL;

-------------------------------------------------------
------------- SVC Call ---------------------------
-- TSW ON
------------------------------------------------------
procedure sim_TSW_ON(
--constant addr_reg: in std_logic_vector(7 downto 0); -- address from CPU
--constant din_to_sierra: in std_logic_vector(31 downto 0); -- Data from CPU
signal addr: inout std_logic_vector(7 downto 0); 
signal write_n: inout std_logic; 
signal cs_n: inout std_logic;
signal din: out std_logic_vector(31 downto 0)) is
begin
--void tsw_on(void)
--  CPU_CTRL_reg.ctrl_t.tswoff_req = 0;
--  CPU_CTRL_reg.ctrl_t.tsw_req_ack = 0;
sim_write_reg(sierra_control_addr,test_value_0000,addr,write_n,cs_n,din);

end sim_TSW_ON;


-------------------------------------------------------
------------- SVC Call ---------------------------
-- TSW OFF
------------------------------------------------------
--  CPU_CTRL_reg.ctrl_t.tswoff_req = 1;
--  CPU_CTRL_reg.ctrl_t.tsw_req_ack = 0;



-- foror printing std_logic_vector 
function prtstd( v : std_logic_vector ) return integer is 
variable s : string( 3 downto 1 ); 
variable r : string( (v'left+1) downto (v'right+1) ); 
begin 
    for i in v'left downto v'right loop 
    --report std_logic'image(v(i)); 
      s := std_logic'image(v(i)); 
    --string must start/stop at 1 
    --          '1' we need only the second character 
      r(i+1) := s(2); 
    end loop; 
    report "std_vector: " & r & " *************"; 
  return 0; 
end prtstd; 


end package body simulation_basic;

