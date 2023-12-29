module Branch_flush(
    Predict_i, 
    Predict_wrong_i, 
    Branch_i,  
    Flush_o
);

input Predict_i;
input Predict_wrong_i;
input Branch_i;

output Flush_o;

assign Flush_o = ((Predict_i && Branch_i) || Predict_wrong_i) ? 1 : 0;

endmodule