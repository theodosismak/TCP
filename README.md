TCP
Experimentation with Linux TCP versions
---------------------------------------

We study the behavior of different TCP congestion control algorithms according to different network performance
parameters. Specifically, it is tested how different TCP versions react to the traffic congestion considering
transmission delay of 10 ms, packet loss of 0.1% and packet duplication of 0.5%

To simulate real world scenario we use traffic control tools called tc and netem and then we shape the traffic.
After the traffic is shaped, we use iperf to establish a bulk data transfer between the two hosts. Default iperf
setting is used where a single session runs for 10 seconds. Then we do a series of 5 bulk transfers so that it
can use some cached information. Next we prepare one more data session and we use tcpprobe to collect the detailed
tcp information. Finally, we start the session and capture the data of the last iperf for latter analysis.
