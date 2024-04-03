dir /s /b *.v > FileList.txt
iverilog -Wimplicit -o processor_output.vvp -c FileList.txt -s Wrapper_tb -P Wrapper_tb.FILE=\"nop\"
