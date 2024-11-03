#set simulation
set ns [new Simulator]

#open the trace file
set nt [open lab2.tr w]
$ns trace-all $nt

#open the namtrace file
set nf [open lab2.nam w]
$ns namtrace-all $nf

#set the color class 
$ns color 2 Blue
$ns color 3 Red
$ns color 4 Yellow
$ns color 5 Green

#set the nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#Label the nodes
$n0 label "Ping0"
$n1 label "Ping1"
$n2 label "Ping2"
$n3 label "Ping3"
$n4 label "Ping4"
$n5 label "Router"

#set up the link 
$ns duplex-link $n0 $n5 1Mb 10ms DropTail
$ns duplex-link $n1 $n5 1Mb 10ms DropTail
$ns duplex-link $n2 $n5 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail

#set the queuelimit
$ns queue-limit $n0 $n5 5
$ns queue-limit $n1 $n5 5
$ns queue-limit $n2 $n5 2
$ns queue-limit $n3 $n5 5
$ns queue-limit $n4 $n5 2

#create the recv procedure
Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "Node {node_ id} received ping response message from $from in round trip time $rtt"
}

#create ping and attach
set p0 [new Agent/Ping]
$ns attach-agent $n0 $p0
$p0 set class_ 1

set p1 [new Agent/Ping]
$ns attach-agent $n1 $p1
$p1 set class_ 2

set p2 [new Agent/Ping]
$ns attach-agent $n2 $p2
$p2 set class_ 3

set p3 [new Agent/Ping]
$ns attach-agent $n3 $p3
$p3 set class_ 4

set p4 [new Agent/Ping]
$ns attach-agent $n4 $p4
$p4 set class_ 5

#connect the two agent
$ns connect $p2 $p4
$ns connect $p3 $p4
$ns connect $p1 $p4

#define the sendPingPacket 
proc sendPingPacket { } {
	global ns p1 p2 p3
	set interval 0.001
	set now [$ns now]
	
	$ns at [expr $now + $interval] "$p1 send"
	$ns at [expr $now + $interval] "$p2 send"
	$ns at [expr $now + $interval] "$p3 send"
	$ns at [expr $now + $interval] "sendPingPacket"
}

#define finish procesure
proc finish {} {
	global ns nf nt
	$ns flush-trace
	exec nam lab2.nam &
	close $nf
	close $nt
	exit 0
	
}

$ns at 0.1 "sendPingPacket"
$ns at 2.0 "finish"
$ns run
