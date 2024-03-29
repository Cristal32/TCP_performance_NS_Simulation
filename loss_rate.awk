BEGIN {
    seqno = -1; 
    droppedPackets = 0;
    receivedPackets = 0;
    count = 0;
    interval = 1; 
    current_interval = 0;
    total_intervals = 0;
}

function calculatePLR(received, generated) {
    if (generated == 0) {
        return 0;
    }
    return (generated - received) / generated;
}

{
    # packet delivery ratio
    if ($4 == "AGT" && $1 == "s" && seqno < $6) {
        seqno = $6;
    } else if (($4=="AGT") && ($1=="r")){
        receivedPackets++;
    } else if ($1 == "D" && $7 == "tcp" && 
        $8 > 512) {
        droppedPackets++; 
    }

    # end-to-end delay
    if ($4 == "AGT" && $1 == "s") {
        start_time[$6] = $2;
    } else if (($7=="tcp") && ($1=="r")){
        end_time[$6] = $2;
    } else if ($1 == "D" && $7 == "tcp") {
        end_time[$6] = -1;
    }
    
    if ($2 - current_interval >= interval){
        current_interval += interval;
        total_intervals++;
        plr = calculatePLR(receivedPackets, 
            seqno + 1);
        print "Interval " total_intervals ", 
            PLR for " FILENAME " = " plr;
        receivedPackets = 0;
        droppedPackets = 0;
    }
}

END { 
    for (i = 0; i <= seqno; i++) {
        if (end_time[i] > 0) {
            delay[i] = end_time[i] - 
                start_time[i];
            count++;
        } else {
            delay[i] = -1;
        }
    }

    for (i = 0; i < count; i++) {
        if (delay[i] > 0) {
            n_to_n_delay = n_to_n_delay + 
                delay[i];
        } 
    }

    n_to_n_delay = n_to_n_delay / count;

    print "\n";
    print "GeneratedPackets = " seqno + 1;
    print "ReceivedPackets = " 
        receivedPackets;
    printf "Packet Delivery Ratio=%.2f%%\n", 
        receivedPackets / (seqno + 1)*100;
    print "Total Dropped Packets = " 
        droppedPackets;
    printf "Average End-to-End Delay = 
        %.2f ms\n", n_to_n_delay * 1000;
    print "\n";
}
