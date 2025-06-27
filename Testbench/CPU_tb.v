module CPU_tb(

    );
    
      reg clk;
    wire [15:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7;
    wire Current_Zero_OUT, Current_Carry_OUT;
    
    // Instantiate the CPU module
    CPU uut (
        .clk(clk),
        .output_dummy(),
        .Reg0(Reg0),
        .Reg1(Reg1),
        .Reg2(Reg2),
        .Reg3(Reg3),
        .Reg4(Reg4),
        .Reg5(Reg5),
        .Reg6(Reg6),
        .Reg7(Reg7),
        .Current_Zero_OUT(Current_Zero_OUT),
        .Current_Carry_OUT(Current_Carry_OUT)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Simulation control
    initial begin
        // Dump waveform file
        $dumpfile("CPU_tb.vcd");
        $dumpvars(0, CPU_tb);
        
        // Display messages
        $display("Starting CPU simulation...");
        
        // Run the simulation for a fixed duration
        #70;
        
        $display("Final Register Values:");
        $display("Reg0: %h", Reg0);
        $display("Reg1: %h", Reg1);
        $display("Reg2: %h", Reg2);
        $display("Reg3: %h", Reg3);
        $display("Reg4: %h", Reg4);
        $display("Reg5: %h", Reg5);
        $display("Reg6: %h", Reg6);
        $display("Reg7: %h", Reg7);
        
        $display("Current Zero Flag: %b", Current_Zero_OUT);
        $display("Current Carry Flag: %b", Current_Carry_OUT);
        
        $display("Simulation complete.");
        $finish;
    end
endmodule