dir /b *.v > FileList.txt
iverilog -Wimplicit -o multdiv_output.vvp -c FileList.txt -s my_multdiv_tb