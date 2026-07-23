# UART Communication in Verilog HDL:

A complete UART (Universal Asynchronous Receiver/Transmitter) implementation in Verilog HDL featuring a baud rate generator, FSM-based transmitter, FSM-based receiver with 16× oversampling, and full-duplex communication. The design targets FPGA implementation with a 50 MHz system clock and 115200 baud communication. It has been verified through simulation and is intended for FPGA-to-PC serial communication using terminal applications such as PuTTY.

Features
. FSM-based UART Transmitter
. FSM-based UART Receiver
. 16× Oversampling Receiver
. Baud Rate Generator
. Full-Duplex Communication
. 115200 Baud @ 50 MHz Clock
. Echo-back Communication
. FPGA Ready
. Simulation Testbench Included

# Module Description:

# 1. Baud Rate Generator (baudgen.v)
Generates enable pulses for both the transmitter and receiver.
System Clock: 50 MHz
UART Baud Rate: 115200 bps
TX Enable: Every 434 clock cycles
RX Enable: Every 27 clock cycles (16× oversampling)
Outputs
tx_en
rx_en

# 2. UART Transmitter (uart_tx.v)
Finite State Machine (FSM) based UART transmitter.
States:
IDLE
 ↓
START
 ↓
DATA
 ↓
STOP
 ↓
IDLE
Frame Format:
Idle | Start | D0 D1 D2 D3 D4 D5 D6 D7 | Stop
  1      0       8-bit Data (LSB First)   1

# 3. UART Receiver uart_rx.v)
FSM-based receiver implementing 16× oversampling for reliable data reception.
States:
IDLE
 ↓
START
 ↓
DATA
 ↓
STOP
 ↓
DONE
Features:
. Detects Start Bit
. Samples at the center of each bit
. 16× Oversampling
. Stores received byte
. Generates rx_done pulse after successful reception

# 4. Full Duplex Module (full_duplex.v)
It Integrates:
. Baud Generator
. UART Transmitter
. UART Receiver
This module provides simultaneous transmission and reception.

# 5. FPGA Top Module (top.v)
Implements UART Echo-back.
Operation:
1. Wait for a byte from the PC.
2. Store received byte.
3. Trigger transmitter.
4. Send the same byte back.
5. Display received data on LEDs.

# UART Configuration:
  Parameter          Value  
---------------      ------ 
 Clock Frequency     50 MHz 
 Baud Rate           115200 
 Data Bits           8      
 Parity              None   
 Stop Bits           1      
 Flow Control        None   
 Oversampling        16×    

 


