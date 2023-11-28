cleanDocker()
{
	CONTAINER=$1
	docker stop $CONTAINER
	docker rm $CONTAINER
}
export NODE_NAME=led

printf "\n===================================\n"
read -p "1. Start producer - Run(Y/n) : " isRun
[ -z $isRun ] && isRun="Y"

[ "$isRun" != "n" ] && cleanDocker $NODE_NAME
[ "$isRun" != "n" ] && docker run -it -d --name $NODE_NAME --net=host \
	ibct/ledgis-test:2.0.7 nodeos \
	-d ~/eos.data/producer_node \
	--config-dir ~/eos.data/producer_node \
	-l ~/eos.data/logging.json \
	--plugin eosio::http_plugin \
	--plugin eosio::chain_api_plugin \
	--abi-serializer-max-time-ms 50000000 \
	--chain-state-db-size-mb 32768 \
	--reversible-blocks-db-size-mb 2048 \
	--http-max-response-time-ms 1000 \
	--http-validate-host=false \
	--http-server-address 0.0.0.0:8888 \
    	-p $NODE_NAME -e


printf "\n===================================\n"
read -p "2. Create Wallet - Run(Y/n) : " isRun
[ -z $isRun ] && isRun="Y"

[ "$isRun" != "n" ] && docker exec -it $NODE_NAME cleos wallet create --to-console

printf "\n===================================\n"
read -p "3. Import Key - Run(Y/n) : " isRun
[ -z $isRun ] && isRun="Y"

[ "$isRun" != "n" ] && docker exec -it $NODE_NAME cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 

printf "\n===================================\n"
echo "4. Start test loop"

while true; do
	read -p "New transactions - Run(Y/n) : " isRun
	[ -z $isRun ] && isRun="Y"
	[ "$isRun" != "Y" ] && break

	read -p "New account name : " accountName

	CMD=$(printf "{\"creator\":\"led\",\"name\":\"%s\",\"owner\":{\"threshold\":1,\"keys\":[{\"key\":\"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV\",\"weight\":1}],\"accounts\":[],\"waits\":[]},\"active\":{\"threshold\":1,\"keys\":[{\"key\":\"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV\",\"weight\":1}],\"accounts\":[],\"waits\":[]}}" "$accountName")
	docker exec -it $NODE_NAME cleos push action led newaccount "${CMD}" -p led -d --return-packed | tee packed

	read -p "Push transaction from Localhost? - Run(Y/n) : " isRun
	[ -z $isRun ] && isRun="Y"
	[ "$isRun" != "Y" ] && continue

	printf "\nTransaction Start : %s\n\n" $(date +"%Y-%m-%dT%T.%3N") && curl -s -XPOST  -d @packed -H "Content-Type: application/json" http://127.0.0.1:8888/v1/chain/push_transaction | tee res
	cat res | jq | grep block_time
done



