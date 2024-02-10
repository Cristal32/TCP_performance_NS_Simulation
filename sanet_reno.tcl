set val(chan) Channel/WirelessChannel;
set val(prop) Propagation/TwoRayGround;
set val(netif) Phy/WirelessPhy;
set val(mac) Mac/802_11;
set val(ifq) Queue/DropTail/PriQueue;
set val(ll) LL;
set val(ant) Antenna/OmniAntenna;
set val(ifqlen) 50;
set val(nn) 7;
set val(rp) DSDV;
set val(x) 500
set val(y) 500

set ns_         [new Simulator]
set tracefd     [open sanet_vegas.tr w]
$ns_ trace-all $tracefd

set namtrace [open sanet_vegas.nam w]

$ns_ namtrace-all-wireless $namtrace $val(x) 
$val(y)

set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

set chan_1_ [new $val(chan)]
set chan_2_ [new $val(chan)]

$ns_ node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace ON \
                -movementTrace OFF \
                -channel $chan_1_ 

 for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i$) [$ns_ node]
    $node_($i$) random-motion 0
    $ns_ initial_node_pos $node_($i) 20
 }

$node_(0) set X_ 2.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 2.0
$node_(1) set Y_ 252.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 102.0
$node_(2) set Y_ 125.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 212.0
$node_(3) set Y_ 125.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 312.0
$node_(4) set Y_ 125.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 412.0
$node_(5) set Y_ 2.0
$node_(5) set Z_ 0.0

$node_(6) set X_ 412.0
$node_(6) set Y_ 252.0
$node_(6) set Z_ 0.0

$ns_ at 3.0 "$node_(0) setdest 2.0 2.0 0.0"
$ns_ at 3.0 "$node_(1) setdest 2.0 252.0 
0.0"
$ns_ at 3.0 "$node_(2) setdest 102.0 125.0 
0.0"
$ns_ at 3.0 "$node_(3) setdest 212.0 125.0 
0.0"
$ns_ at 3.0 "$node_(4) setdest 312.0 125.0 
0.0"
$ns_ at 3.0 "$node_(5) setdest 412.0 2.0 
0.0"
$ns_ at 3.0 "$node_(6) setdest 412.0 252.0 
0.0"

set tcp1 [new Agent/TCP/Vegas]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp1
$ns_ attach-agent $node_(5) $sink1
$ns_ connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 3.0 "$ftp1 start" 

set tcp2 [new Agent/TCP/Vegas]
$tcp2 set class_ 2
set sink2 [new Agent/TCPSink]
$ns_ attach-agent $node_(1) $tcp2
$ns_ attach-agent $node_(6) $sink2
$ns_ connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2 
$ns_ at 3.0 "$ftp2 start"

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 30.0 "$node_($i) reset";
}
$ns_ at 30.0 "stop"
$ns_ at 30.01 "puts \"NS EXITING...\" ; 
$ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

puts "Starting Simulation..."
$ns_ run
