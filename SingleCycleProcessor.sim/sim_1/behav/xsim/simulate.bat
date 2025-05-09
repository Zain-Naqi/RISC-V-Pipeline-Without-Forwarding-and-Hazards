@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Thu Apr 17 09:42:50 +0500 2025
REM SW Build 2902540 on Wed May 27 19:54:49 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim RISC_V_Processor_tb_behav -key {Behavioral:sim_1:Functional:RISC_V_Processor_tb} -tclbatch RISC_V_Processor_tb.tcl -view E:/Pictures/Random Codes/SingleCycleProcessor/SingleCycleProcessor.srcs/sim_1/imports/SingleCycleProcessor/Processor_Test_behav.wcfg -log simulate.log"
call xsim  RISC_V_Processor_tb_behav -key {Behavioral:sim_1:Functional:RISC_V_Processor_tb} -tclbatch RISC_V_Processor_tb.tcl -view E:/Pictures/Random Codes/SingleCycleProcessor/SingleCycleProcessor.srcs/sim_1/imports/SingleCycleProcessor/Processor_Test_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
