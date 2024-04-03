# Processor
## NAME (NETID)
Alex Penne
adp69

## Description of Design
This processor uses bypassing and stalling to allow for any combination of instructions after one another in a 5 stage processor. The processor uses registers to pass values from stage to stage, with multiplexers to determine whether or not to bypass values. The biggest design choice I made was to maximize optimization by determining branches in the decode stage using additional ALU hardware. This minimized the number of flushes needed and allowed my processor to immediately branch. 

Here is a description of the five stages and how I implemented them:
Fetch: The fetch stage grabs the instruction in the memory that was set by the .mem file with the Wrapper. For test cases, I made my own assembly files and used the compiler to turn them into .mem files. The fetch stage additionally updated the PC counter by 1. The latches going into the next stage were controlled by stalls for control hazards or for pausing the processor when doing a multi-cycle multiply or divide.
Decode: The decode stage checked if branches were going to occur to prevent multiple flushings. This used multiple ALUs rather than using the ALU in the execute stage. Additionally, most of my bypassing occured here by looking forward to determine if the values I needed were currently being assigned in the memory or execute stage.
Execute: The execute stage performed the ALU operations and the multiplier and divide. When a new multiplication or division ON signal was sent, the entire processor stops updating latches and waits until the ready signal is activated. Then, the processor continues and sends data to the memory stage.
Memory: The memory stage determines if a memory write is necessary and then sends these values to the Wrapper to handle memory changes.
Writeback: Most of the logic in writeback (and memory) are using multiplexers to determine when to have write enables on. This occured by checking the opcode of the current instruction (which is passed through latches).

## Bypassing
I bypassed many types of instructions during this process. In order to do this, I utilized many multipliexers. My strategy was to use a one-hot encoding to determine which values should be moving to the next stage depending on the opcode of the instruction. 

## Stalling
The stalling occurs whenever an instruction needs to load a word that is currently being assigned (rs or rt) in the execute or memory stages. This is the only case in which I needed to stall. In order to stall, I used a wire that checked if the instructions were flagged as a load word with a changing value and used this to enable the register latches that change the PC and decode stages. This allowed the last three stages of the pipeline to continue and update the necessary values to the writeback stage. From here, I was able to bypass and take the load word value I needed, while the PC counter stayed constant to prevent using an "expired" value. 

## Optimizations
My processor uses the Modified Booth's algorithm for multiplication which optimizes data storage. My processor also uses more hardware in the decode stage (additional ALU units) to detect branches before they are taken. It is possible that this is why my sort test case is failing. I initially did this to reduce the number of flushes needed. 

## Bugs
My sort test case is failing. When I inspected the GTKWAVE file, it was in a never ending loop while mallocing. I was not able to determine why the loop was happening. When walking through, it seemed like my code was following the instrucutions correctly, which makes me think I didn't understand what the sort function was meant to be doing. If I had more time, I would have tried to understand what sort was accomplishing.
