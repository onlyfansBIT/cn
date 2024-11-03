#Set the new simulator
set ns [new Simulator]

#open the trace file
set nt [open lab1.tr w]
$ns trace-all $nt

#open the nam trace file
set nf [open lab1.nam w]
$ns namtrace-all $nf

#set the color class
$ns color 1 Blue
$ns color 2 Red

#set the nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#label the nodes
$n0 label "Source/Udp0"
$n1 label "Source/Udp1"
$n2 label "Router"
$n3 label "Destination/Null"

#create a link
$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 100kb 300ms DropTail

#set up the queue limit
$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 20

#create a Udp agent
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null3 [new Agent/UDP]
$ns attach-agent $n3 $null3

#create a cbr application
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

#connect the udp agent
$ns connect $udp0 $null3
$ns connect $udp1 $null3

#set up the color schema for udp
$udp0 set class_ 1
$udp1 set class_ 2

#set the packet size and interval for the cbr1
$cbr1 set packetSize_ 500Mb
$cbr1 set interval_ 0.005

#set finish procedure

proc finish {} {
	global ns nf nt
	$ns flush-trace
	exec nam lab1.nam &
	close $nf
	close $nt
	exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 10.0 "finish"
$ns run

