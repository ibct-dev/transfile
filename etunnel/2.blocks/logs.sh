
printf "\n===================================\n"
read -p "1. Get producer/receiver logs - press any key"
docker logs --tail 50 led  > producer
docker logs --tail 50 led2 > receiver

printf "\n===================================\n"
read -p "2. Merge log file - press any key"
cp producer logs
cat receiver >> logs 
sort logs > sort.log

printf "\n===================================\n"
read -p "3. View Sorted log file - press any key"
more sort.log

