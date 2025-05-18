 --------------------------------------------------------------------------------
 --                Sierra Real-Time Kernel
 --             
 --  $Workfile    :  Tesbank_rom_flag.vhd $ 
 -- 
 --  Company      :  Prevas AB
 --  Programmer(s):  Lennart Lindh 
 --               :  Susanna Nordström (SUNO)
 --               :  David Borgedahl (DABL)
 --  Date Created :  2003-02-17 
 --  
 --  Description  :  Sierra sem_top_sem TestBench 
 --  Notes        :  Test of Semaphores 
 -- 
 --  COPYRIGHT (C) $JustDate: 06-08-21 $ Prevas AB
 -- 
 --  All rights reserved. Prevas's source code is an unpublished work,
 --  and the use of a copyright notice does not imply otherwise. This
 --  source code contains confidential, trade-secret material of Prevas AB.
 --  Any attempt at or participation in deciphering, decoding, reverse
 --  engineering, or in any way altering the source code is strictly
 --  prohibited unless the prior written consent of Prevas AB is obtained.
 -- 
 --------------------------------------------------------------------------------

 -- Revision history (Prevas)   
 -- $Log: /Root/SierraRTOS/HDL/dvp4.01/TestBench/Testbank_rom_sem.vhd $ 
 -- 
 -- 1     06-08-21 14:06 Dabl
 -- Version 4.00 => 4.01
 -- 
 -- 1     06-07-20 17:37 Dabl
 -- 
 -- 
 --------------------------------------------------------------------------------

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY SIERRA_LIB;
USE SIERRA_LIB.definitions.all;
USE SIERRA_LIB.internals.all;

Package rom_pack is
	constant rom_width:integer:=19;
	constant rom_length:integer:=64;	-- test
subtype rom_word is std_logic_vector(rom_width -1 downto 0);
type rom_table is array (0 to rom_length-1) of rom_word;
---------------------------------------------------------------------------------
--------------------------------- For the program --------------------------------------
---------------------------------------------------------------------------------

	CONSTANT SVC_ACTION													: std_logic_vector := "000";
 	CONSTANT TSW_ON_ACTION										: std_logic_vector := "001";
 	CONSTANT TSW_OFF_ACTION									: std_logic_vector := "010"; 
 	CONSTANT Delay_1000_action						: std_logic_vector := "011";
 	CONSTANT Wait_IRQ_KPU_ACTION				: std_logic_vector := "100"; 
	CONSTANT Loop_for_ever_Simulation_ACTION	: std_logic_vector := "101";
	CONSTANT EXT_IRQ_action									: std_logic_vector := "110"; 

 	CONSTANT STOP_Simulation_action	: std_logic_vector := "111"; 

 	CONSTANT TSW_OFF_ACTION_inst											: std_logic_vector(18 downto 0)	:=(18=>'0',17=>'1',16=>'0',others=>'0');
 	CONSTANT TSW_ON_ACTION_inst												: std_logic_vector(18 downto 0)	:=(18=>'0',17=>'0',16=>'1',others=>'0');
 	CONSTANT Delay_1000_action_inst								: std_logic_vector(18 downto 0)	:=(18=>'0',17=>'1',16=>'1',others=>'0');
 	CONSTANT Wait_IRQ_KPU_ACTION_inst						: std_logic_vector(18 downto 0)	:=(18=>'1',17=>'0',16=>'0',others=>'0');
 	CONSTANT Loop_for_ever_Simulation_inst	: std_logic_vector(18 downto 0)	:=(18=>'1',17=>'0',16=>'1',others=>'0');

 	CONSTANT STOP_Simulation_inst			: std_logic_vector(18 downto 0)	:=(18=>'1',17=>'1',16=>'1',others=>'0');

 	CONSTANT EMPTY_noll							: std_logic_vector := "00000000"; 
 	CONSTANT Ready_state						: std_logic_vector := "1"; 
 	CONSTANT Blocked_state				: std_logic_vector := "0";

-----------------------------------------------------------------------------
-- width 19
constant rom: rom_table:=rom_table'(
-- Program address
-- 0
Delay_1000_action_inst,
-- 1
Delay_1000_action_inst,

--Start Idle Task
SVC_ACTION&sch_svc&sch_create&"0000"&Ready_state&"111"&"00",

-- task_create READY, prio 1, T1
SVC_ACTION&sch_svc&sch_create&"00"&Ready_state&"001"&"0001",

-- task_create READY, prio 2, T2
SVC_ACTION&sch_svc&sch_create&"00"&Ready_state&"010"&"0010",

-- task_create READY, prio 3, T3
SVC_ACTION&sch_svc&sch_create&"00"&Ready_state&"011"&"0011",

-- task_create READY, prio 4, T4
SVC_ACTION&sch_svc&sch_create&"00"&Ready_state&"100"&"0100", 

-- task_create READY, prio 5, T5
SVC_ACTION&sch_svc&sch_create&"00"&Ready_state&"101"&"0101",

-- task_create READY, prio 6, T6
SVC_ACTION&sch_svc&sch_create&"00"&Ready_state&"110"&"0110",

-- write time_base_reg 9:0, 0x32=00_0011_0010
SVC_ACTION&tmq_svc&tmq_init_period_time&"00"&"0011"&"0010",

--Taskswitch on
TSW_ON_ACTION_inst,
Delay_1000_action_inst,

---------------------------------------------------------------------------
--Start testing sequence: 
---------------------------------------------------------------------------

--Sem take, twice by T1
SVC_ACTION&sem_svc&sem_take&"000000"&"0001",
Delay_1000_action_inst,    

SVC_ACTION&sem_svc&sem_take&"000000"&"0001",
Delay_1000_action_inst,
-->Taskswitch 

--Sem Take by T2
SVC_ACTION&sem_svc&sem_take&"000000"&"0001",
Delay_1000_action_inst, 
-->Taskswitch 

--Sem Take by T3
SVC_ACTION&sem_svc&sem_take&"000000"&"0001",
Delay_1000_action_inst,
-->Taskswitch 

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst,

--Sem1 is taken, and T1, T2 and T3 is waiting for the semaphore. T4 is now running. 

--Sem Release by T4
SVC_ACTION&sem_svc&sem_release&"00"&"0001"&"0001",
Delay_1000_action_inst,

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst,
Delay_1000_action_inst,
Delay_1000_action_inst,
--All task has been deleated from the sem-Qm, but the semaphore is still taken. T1 is running

--Sem Release by T1
SVC_ACTION&sem_svc&sem_release&"00"&"0001"&"0001",
Delay_1000_action_inst,
--No task is waiting for semaphore 1 and it is free. 

----------------------------------------------------------
----------------------------------------------------------
--T1 takes sem1
SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"0001",
Delay_1000_action_inst,

--T1 takes sem2 twice
SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"0010",
Delay_1000_action_inst,

SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"0010",
Delay_1000_action_inst,
-->Taskswitch

--T2 takes sem3
SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"0011",
Delay_1000_action_inst,

--T2 takes sem4 twice
SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"0100",
Delay_1000_action_inst,  

SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"0100",
Delay_1000_action_inst,  
-->Taskswitch
 
-->T3 Takes sem15
SVC_ACTION&sem_svc&sem_take&"00"&"0001"&"1111",
Delay_1000_action_inst,  

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst,

--sem1, sem2, sem3 sem4 and sem15 is taken.
--T1 is waiting for sem2 and T2 is waiting for sem4. 
--T3 is runnig task. 

--T3 Releases sem2
SVC_ACTION&sem_svc&sem_release&"00"&"0001"&"0010",
Delay_1000_action_inst,

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst,  

--T2 has been deleated from the sem-Q (T1 was waiting), and set to ready state. Alla semaphores is still taken.
--T1 is now running 

--T1 Releases sem1 
SVC_ACTION&sem_svc&sem_release&"00"&"0001"&"0001",
Delay_1000_action_inst, 

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst,   

--T1 Releases sem2 
SVC_ACTION&sem_svc&sem_release&"00"&"0001"&"0010",
Delay_1000_action_inst, 

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst,

--sem3 sem4 and sem15 is taken.
--T2 is waiting for sem4. 
--T1 is runnig task. 

--T1 Releases sem15 
SVC_ACTION&sem_svc&sem_release&"00"&"0001"&"1111",
Delay_1000_action_inst, 

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst, 

--sem3 sem4 is taken.
--T2 is waiting for sem4. 
--T? is runnig task. 

--Wait
Delay_1000_action_inst,
Delay_1000_action_inst 
 
---------------------------------------------------------------------------
--End testing sequence: 
--------------------------------------------------------------------------- 
 
);

end;

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY SIERRA_LIB;
USE SIERRA_LIB.definitions.all;
USE SIERRA_LIB.internals.all;
USE ieee.std_logic_unsigned.ALL;
Use work.rom_pack.ALL;

ENTITY Sierra_tb IS
-- Declarations

END Sierra_tb ;

ARCHITECTURE testbank OF Sierra_tb IS

  -- Constants: system clock is 20 MHz
  CONSTANT clock_period : time := 50 ns;

-- Internal signal declarations
  SIGNAL iclk 						: std_logic := '0';
  SIGNAL ireset_n 		: std_logic := '0';
	SIGNAL iaddr   	 	: std_logic_vector (CPU_Adress_enable_bits - 1 DOWNTO 0) ;
	SIGNAL ics_n   		 : std_logic  ;
	SIGNAL idin    		 : std_logic_vector (register_length-1 DOWNTO 0) ;
	SIGNAL iextirq_n		: std_logic_vector (2**nrof_irq_bits-1 downto 0) ;
	SIGNAL iwrite_n		 : std_logic  ;
	SIGNAL idout   		 : std_logic_vector (register_length-1 DOWNTO 0) ;
	SIGNAL iirq_n   		: std_logic;
--- ROM
	SIGNAL program_adress  		: std_logic_vector (6 DOWNTO 0) ;
	SIGNAL Next_action							: std_logic_vector (2 DOWNTO 0) ;
	SIGNAL SVC_DATA										: std_logic_vector (15 DOWNTO 0) ;

	SIGNAL running_task						: std_logic_vector (taskid-1 DOWNTO 0) ;
	SIGNAL SVC_return 							: std_logic_vector (15 DOWNTO 0) ;

	TYPE state_type IS (
		 Start_state, 
		 Get_next_instruction_state,
		 Read_status_register_state,
		 Count_upp_state
	);
  SIGNAL current_state : state_type ;

COMPONENT S16_top
   PORT(
      addr     : IN     std_logic_vector (CPU_Adress_enable_bits - 1 DOWNTO 0) ;
      clk      : IN     std_logic  ;
      cs_n     : IN     std_logic  ;
      din      : IN     std_logic_vector (register_length-1 DOWNTO 0) ;
      extirq_n : IN     std_logic_vector (2**nrof_irq_bits-1 downto 0) ;
      reset_n  : IN     std_logic  ;
      write_n  : IN     std_logic  ;
      dout     : OUT    std_logic_vector (register_length-1 DOWNTO 0) ;
      irq_n    : OUT    std_logic
   );
END COMPONENT;

BEGIN
   -- Instance port mappings.
   s16 : S16_top
      PORT MAP (
				 addr    	 =>		iaddr,
				 clk     	 =>		iclk,
				 cs_n    	 =>		ics_n,
				 din     	 =>		idin,
				 extirq_n	 =>		iextirq_n,
				 reset_n 	 =>		ireset_n,
				 write_n 	 =>		iwrite_n,
				 dout    	 =>		idout,
				 irq_n   	 =>		iirq_n
	   );

  clk_proc : PROCESS
  BEGIN
    iclk<='1';
    wait for clock_period/2;
    iclk<='0';
    wait for clock_period/2;
  END PROCESS clk_proc;

   -- **********************************
  reset_proc : PROCESS
  BEGIN
    ireset_n <= '0';
    wait for 5*clock_period;
    ireset_n <= '1';
    wait;
  END PROCESS reset_proc;
---------------------------------------
--- Testbank processor ----------
-----------------------------

testproc : PROCESS
Variable TEMP : std_logic_vector (18 DOWNTO 0) ;

  BEGIN
     IF (ireset_n='0') THEN
        current_state <= Start_state;
	 			iaddr <= (others=>'0');
			idin <= (others=>'0');
			iwrite_n <= '1';
			ics_n <= '1';

         -- Reset Values
	Program_adress <= (others =>'0');
	iextirq_n <= (others=>'0');
	TEMP := rom(conv_integer(program_adress));
	SVC_DATA <= TEMP( 15 downto 0);
	Next_action <= TEMP(18 downto 16);
    	wait for 1*clock_period;

   wait for 50*clock_period;
	
      ELSE
-- Transition Actions for internal signals only
	TEMP := rom(conv_integer(program_adress));
	SVC_DATA <= TEMP( 15 downto 0);
	Next_action <= TEMP(18 downto 16);
	wait for 1*clock_period;
	CASE current_state IS
--------------------------------
---------- Start State ----------
---------------------------------
	WHEN Start_state =>
   wait for 50*clock_period;
---------------------------------------------------------------------------
     current_state <= Get_next_instruction_state;
    wait for 1*clock_period;

------------------------------------------------------------------------------
-----------------------------------------------------------------------------
---------- Get_next_instruction_state --------
------------------------------------------------
WHEN Get_next_instruction_state =>

IF iirq_n = '1' THEN
-- SVC_Action
wait for 5*clock_period;
-- Read status bit from control reg.
	iaddr <= sierra_status_b_addr;
	iwrite_n <= '1';
    	wait for 1*clock_period;
	ics_n <= '0';
	wait for 2*clock_period;
	SVC_return <= idout(15 downto 0);
	ics_n <= '1';
	wait for 1*clock_period;
  IF SVC_return(0) = '1' THEN 
--
-- Write to control reg (end of irq req.)
-- ack to irq
	iaddr <= sierra_control_addr;
	idin(1 downto 0) <= "01";
	iwrite_n <= '0';
    	wait for 1*clock_period;
	ics_n <= '0';
	wait for 1*clock_period;
	ics_n <= '1';
	wait for 1*clock_period;
	iwrite_n <= '1';	
--
-- Read status reg for interrrupt req and new taskid.
	iaddr <= sierra_status_b_addr;
	iwrite_n <= '1';
    	wait for 1*clock_period;
	ics_n <= '0';
	wait for 2*clock_period;
	SVC_return <= idout(15 downto 0);
	running_task <= idout(taskid downto 1);
	ics_n <= '1';
	wait for 1*clock_period;

-- Write to control reg (end of irq req.)
-- nack to irq
	iaddr <= sierra_control_addr;
	idin(1 downto 0) <= "00";
	iwrite_n <= '0';
    	wait for 1*clock_period;
	ics_n <= '0';
	wait for 1*clock_period;
	ics_n <= '1';
	wait for 1*clock_period;
	iwrite_n <= '1';	
	
--
	  assert false
	  report "IRQ_Sierra TSW"
	  severity Note;
     	wait for 1*clock_period;
  ELSE
	  assert false
	  report "IRQ_Sierra TSW var tvungen att abslutas"
	  severity Note;
     	wait for 1*clock_period;

  END IF;

ELSIF Next_action = SVC_action THEN
			iaddr <= sierra_service_request_addr;
			idin <= SVC_DATA;
			iwrite_n <= '0';
    	wait for 1*clock_period;
			ics_n <= '0';
			wait for 1*clock_period;
			ics_n <= '1';
			wait for 1*clock_period;
			iwrite_n <= '1';
-- wait for Sierra to be ready with svc
	  current_state <= Read_status_register_state;
    	wait for 1*clock_period;
--
-------------------------------------------------------------------------
-- External IRQ
------------------------------------------------------------------------
ELSIF Next_action = EXT_IRQ_action THEN
 	--iextirq_n <= SVC_DATA(taskid-1 downto 0);        OBS! SN
      current_state <= Count_upp_state;
     	wait for 1*clock_period;
--
-------------------------------------------------------------------------
-- Delay 1000
------------------------------------------------------------------------
ELSIF Next_action = Delay_1000_action THEN
 wait for 100*clock_period;
      current_state <= Count_upp_state;
     	wait for 1*clock_period;
--
-------------------------------------------------------------------------
-- start Sierra => TSW ON
--------------------------------------------------------------------------
ELSIF Next_action = TSW_ON_ACTION THEN
			iaddr <= sierra_control_addr;
			idin(1 downto 0) <= "00";
			iwrite_n <= '0';
    	wait for 1*clock_period;
			ics_n <= '0';
			wait for 1*clock_period;
			ics_n <= '1';
			wait for 1*clock_period;
			iwrite_n <= '1';
          current_state <= Count_upp_state;
     	wait for 1*clock_period;
ELSIF Next_action = TSW_OFF_ACTION THEN
---------------------------------------------------------------------------
-- Priority mask to TSW off
---------------------------------------------------------------------------
			iaddr <= sierra_control_addr;
			idin(1 downto 0) <= "10";
			iwrite_n <= '0';
    	wait for 1*clock_period;
			ics_n <= '0';
			wait for 1*clock_period;
			ics_n <= '1';
			wait for 1*clock_period;
			iwrite_n <= '1';
        current_state <= Count_upp_state;
     	wait for 1*clock_period;
---------------------------------------------------------------------------
ELSIF Next_action = Loop_for_ever_Simulation_action THEN
	  wait for 5*clock_period;

---------------------------------------------------------------------------
ELSIF Next_action = STOP_Simulation_action THEN
	  assert false
	  report "Stopping simulation"
	  severity Failure;
     	wait for 1000*clock_period;

ELSE
	  wait for 1*clock_period;
	  assert false
	  report "föstår inte ROM instructionen"
	  severity Error;
        current_state <= Get_next_instruction_state;
END IF;


---------------------------------------------
---------- Get_next_instruction_state --------
------------------------------------------------
	WHEN Read_status_register_state =>
-- Read status reg for Sierra svc ack
			iaddr <= sierra_status_a_addr;
			iwrite_n <= '1';
    	wait for 1*clock_period;
			ics_n <= '0';
	wait for 2*clock_period;
			SVC_return <= "00" & idout(15 downto 2);
			ics_n <= '1';
	   wait for 1*clock_period;
	  IF idout(0) = '1' Then			-- Busy?
		 current_state <= Read_status_register_state;
		wait for 1*clock_period;
	  ELSE
		  current_state <= Count_upp_state;
		  wait for 1*clock_period;
	  END IF;

---------------------------------------------
---------- Count_instruction_state --------
------------------------------------------------
	WHEN Count_upp_state =>
	If program_adress /= "111111" THEN
	  program_adress <= program_adress +1;
	ELSE
	  wait for 2*clock_period;
	END IF;
	  wait for 2*clock_period;
	  current_state <= Get_next_instruction_state;
	  assert false
	  report "Next Instruction"
	  severity Note;
      WHEN OTHERS => NULL; wait for 1*clock_period;

     END CASE;
---------------------------------------------------------------------------
  END IF;
  END PROCESS testproc;

END testbank;

--------------------------------------------------------------------
----------- END Testbank ------------------------------------------
--------------------------------------------------------------------





