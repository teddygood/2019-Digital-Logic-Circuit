module _dff_rs_sync_async(clk, set_n, reset_n, d, q_sync, q_async); // Synchronous/Asynchronous Set/Resettable D flip flop
    input clk, set_n, reset_n, d; // clock, set, reset, d
    output q_sync, q_async; // Synchronous q, Asynchronous q 

    _dff_rs_sync U0_dff_rs_sync(.clk(clk), .set_n(set_n), .reset_n(reset_n), .d(d), .q(q_sync)); // instance Synchronous Set/Resettable D flip flop
    _dff_rs_async U1_dff_rs_async(.clk(clk), .set_n(set_n), .reset_n(reset_n), .d(d), .q(q_async)); // instance Asynchronous Set/Resettable D flip flop

endmodule