fpga-notes/sdramcontroller
==========================

Papilio pro sdram controller. Fairly simple, no pipelining, just read/write a byte

Contains a simple sdram controller in VHDL for the micron chip on a papilio pro and a test that writes a number to memory, then reads it back and displays it on the LEDs of a mega wing, increments it in memory and does it all over again.
