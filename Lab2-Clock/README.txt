Since c16 was giving errors while compiling,
we had to resort to putting in actual 16 bit
address values of Labels in all branch instructions.
Code is commented with original label names, if needed.

Usage
-----
For running the clock, go to 9000H. Type in hrs and min
on address field and press next. Type secs in data field.
Press next to start the clock.

For using alarm.asm, do the exact same steps mentioned above,
then in the end type alarm hrs and min in address field and press next.
When alarm is triggerd, the data field will clear itself.(though second will
keep on incrementing). After 1 minute, clock resumes as normal.