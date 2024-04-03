# MultDiv

## Name
  **Alex Penne**
## Description of Design
*Multiplier*
I implemented the modified Booth's algorithm for the mulitplier. The muliplier uses a counter that goes to 16. If the cycle is just starting, it manually computes the correct input to the registers before using the loop. This is a way to make sure the register has the correct operands in the very first cycle, since registers initalize to 0. My control unit determines which number to add to the right half of the product. To maintain these numbers, I used two 32-bit registers and one DFFE rather than a 65-bit register. This way, I could use the modules I have previously made. To combat the shifting issue, I made a module that can shift it as if it were one big register. 
*Divider*
The divider, in a sense, is a much simpler multiplier with easier to follow rules. It uses a 32-cycle counter rather than 16. Like the multiplier, it computes the first register input manually. 
*Mult/Div*
To keep track of whether we are solving a multiplication or division problem, the control signal is stored in a DFFE. It only updates when the control signals are high. 
## Bugs
I did not have any bugs in the test cases I did myself.