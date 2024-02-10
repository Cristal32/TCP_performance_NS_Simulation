set terminal pngcairo enhanced font 
        "arial,10"
    set output "plr.png"
    set title "Packet Loss Ratio Comparison"
    set xlabel "Interval"
    set ylabel "Packet Loss Ratio"
    
    max_intervals = 30
    
    set xrange [1:max_intervals]
    
    plot "result_vegas.txt" 
        using ($2):($7) with lines title 
        "Data from TCP/Vegas", \
         "result_reno.txt" using ($2):($7) 
         with lines title "Data from 
         TCP/NewReno"
