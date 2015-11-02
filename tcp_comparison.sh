#! /bin/sh

p=0

run_iperf_1(){
        iperf -c 10.1.105.101
}

run_iperf_2(){
	for i in `seq 5`
	do
		run_iperf_1
	done   
}

#remove the previous traffic control rules
del_rule(){
        sudo tc qdisc del dev eth0 root
}

tcp_version=$1

add_delay(){
	echo "Now delay is added ..."
	del_rule
	sudo tc qdisc add dev eth0 root netem delay 10ms
	run_iperf_2
	sudo cat /proc/net/tcpprobe > $tcp_version"_delay.out" &
	p=$!
	run_iperf_1
	sudo kill $p
}

add_pkt_lss(){
	echo "Now packet loss is added ..."
	del_rule
	sudo tc qdisc change dev eth0 root netem loss 0.1%
	run_iperf_2
	sudo cat /proc/net/tcpprobe > $tcp_version"_packet_loss.out" &
        p=$!
	run_iperf_1
	sudo kill $p
}

add_dupl(){
	echo "Now packet duplication is added ..."
	del_rule
	tc qdisc change dev eth0 root netem duplicate 0.5%
	run_iperf_2
	sudo cat /proc/net/tcpprobe > $tcp_version"_packet_duplication.out" &
        p=$!
	run_iperf_1
	sudo kill $p
}


#set the tcp version
sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp_version
echo "TCP "$tcp_version" is selected..."

#read the options for network parameters
sudo modprobe tcp_probe port=5001 full=1 #set the tcp probe in probemod ; full=1 means tcpprobe will record all the traffic on the port

add_delay
add_pkt_lss
add_dupl













