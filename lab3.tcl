#set new simulation
set ns [new Simulator]

#set the trace file
set nt [open lab3.tr w]
set winfile [open winfile w]
$ns trace-all $nt

#set the namtrace file
set nf [open lab3.nam w]
$ns namtrace-all $nf

#set the color
$ns color 1 Blue
$ns color 2 Red

#finish procedure
proc finish {} {
	global ns nf nt
	$ns flush-trace
	exec nam lab3.nam &
	close $nf
	close $nt
	exit 0
}

#create six node
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#create a link and connection
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

$ns simplex-link $n2 $n3 0.3Mb 100ms DropTail
$ns simplex-link $n3 $n2 0.3Mb 100ms DropTail

set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC/802_3]

#Give orientation to the node 
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n3 $n2 orient right
$ns duplex-link-op $n2 $n3 orient left

#set queue limit
$ns queue-limit $n2 $n3 20

#create tcp and sink

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink

$ns connect $tcp $sink

$tcp set fid_ 1
$tcp set packetSize_ 552
$tcp set class_ 1

#create a ftp application
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#create tcp1 and sink1
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1

$ns connect $tcp1 $sink1

$tcp1 set fid_ 2
$tcp1 set packetSize_ 552
$tcp1 set class_ 2

#create a telnet application
set telnet [new Application/Telnet]
$telnet attach-agent $tcp1

#set congestion window 1
set outfile1 [open congestion1.xg w]
puts $outfile1 "TitleText: Congestion window--source_tcp"
puts $outfile1 "xUnitText: Simulation Time(sec)"
puts $outfile1 "yUnitText: Congestion Window Size"

#set congestion window 2

set outfile2 [open congestion2.xg w]
puts $outfile2 "TitleText: Congestion window--source_tcp1"
puts $outfile2 "xUnitText: Simulation Time(sec)"
puts $outfile2 "yUnitText: Congestion Window Size"

#define the plotWindow procedure
proc plotWindow {tcpSource outfile} {
	global ns
	set time 0.1
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $outfile "$now $cwnd"
	$ns at [expr $now + $time] "plotWindow $tcpSource $outfile"
}

$ns at 0.1 "plotWindow $tcp $winfile"
$ns at 0.0 "plotWindow $tcp $outfile1"
$ns at 0.1 "plotWindow $tcp $outfile2"

$ns at 0.3 "$ftp start"
$ns at 0.5 "$telnet start"

$ns at 49.0 "$ftp stop"
$ns at 49.1 "$telnet stop"

$ns at 50.0 "finish"

$ns run

