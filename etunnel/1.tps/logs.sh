
printf "\n===================================\n"
read -p "1. Get producer/receiver logs - press any key"
#docker logs --tail 50 led  > producer
docker logs --tail 50 led2  > producer

printf "\n===================================\n"
read -p "2. View log file - press any key"
more producer

# info  2023-11-28T06:38:11.301 nodeos    producer_plugin.cpp:404       on_incoming_block    ] Received block 2303a22bd64b0404... #478 @ 2023-11-28T06:38:11.500 signed by led [trxs: 0, lib: 477, conf: 0, latency: -198 ms]
# info  2023-11-28T06:38:11 301 nodeos    producer_plugin cpp:404       on_incoming_block    ] Received block 2303a22bd64b0404... #478 @ 2023-11-28T06:38:11 500 signed by led [trxs: 0  lib: 477  conf: 0  latency: -198 ms]
printf "\n===================================\n"
read -p "3. Calc log file - press any key"
#awk '/producer_plugin.cpp:2134/{gsub(/[\.,]/, " "); print $2, $(NF-4)}' producer
awk '/producer_plugin.cpp:404/{gsub(/[\.,]/, " "); print $2, $(NF-7)}' producer

printf "\n===================================\n"
read -p "4. Calc log by time - press any key"
#awk '/producer_plugin.cpp:2134/{gsub(/[\.,]/, " "); trx[$2] += $(NF-4)} END{ for (p in trx){ printf "%s : %d\n", p, trx[p] } }' producer | sort
awk '/producer_plugin.cpp:404/{gsub(/[\.,]/, " "); trx[$2] += $(NF-7)} END{ for (p in trx){ printf "%s : %d\n", p, trx[p] } }' producer | sort

printf "\n===================================\n"
read -p "4. Get average time - press any key"
#awk '/producer_plugin.cpp:2134/ {gsub(/[\.,]/, " "); cnt[$2]++; trx[$2] += $(NF-7)} END{ 
awk '/producer_plugin.cpp:404/ {gsub(/[\.,]/, " "); cnt[$2]++; trx[$2] += $(NF-7)} END{ 
	for (p in trx){ 
		if(cnt[p]>1) {
			printf "%s : %d\n", p, trx[p]; 
			sum+=trx[p]; 
			calc_cnt++;
		} 
	}; 
	printf "\n\nSUM : %s\nCNT : %s\nAVG : %5.1f\n", sum, calc_cnt, sum/calc_cnt; 
    }' producer 
