# TODOs
pls help


### Define address spaces for user and kernel land programs
_easy_

We need to define space for user and kernel land programs, currently I've decided that the 0x0200 - 0x02FF page is for kernel use exclusively, but the zero page still needs to be divvied up

### Move the readme into a proper docs page
_annoying_

the readme.md is getting too long. It needs its own proper wiki/documentation page.

### Read LCD routine
_medium_

Create a command that is able to read then print the data currently displayed on the included LCD and print to the serial console. Must support both 8-bit and 4-bit mode operation

### Improve fork syscall

the fork function only calls a pre-defined function. It should take an address either in registers or a pre-defined RAM location to jump to after the fork initlisation.

Also, before any of the interrupt frame is pushed onto the stack, a return address should be pushed so that a program can "rts" if it wants to end and be taken out of the scheduler and resources free'd

Moreover, there needs to be bounds checking to see if the computer even has the resources to fork at the moment, which it should then signal when it returns from fork() to the calling (parent/calling) program.
