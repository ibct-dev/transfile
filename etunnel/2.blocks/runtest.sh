cleanDocker()
{
	CONTAINER=$1
	docker stop $CONTAINER
	docker rm $CONTAINER
}


printf "\n===================================\n"
read -p "1. Start producer - Run(Y/n) : " isRun
[ -z $isRun ] && isRun="Y"

[ "$isRun" != "n" ] && cleanDocker led
docker run -it -d --name led --net=host ibct/etunneltest:2.0.7 nodeos -d ~/eos.data/producer_node --config-dir ~/eos.data/producer_node -l ~/eos.data/logging.json --http-server-address 0.0.0.0:8888 -p led -e
MDIR=/home/dev001/LEDGIS/build
docker exec -it led mkdir -p $MDIR
docker cp /home/ubuntu/test/transfile/unittests led:$MDIR

printf "\n===================================\n"
read -p "2. Start receiver - Run(Y/n) : " isRun
[ -z $isRun ] && isRun="Y"

[ "$isRun" != "n" ] && cleanDocker led2
docker run -it -d --net=host --name led2 ibct/etunneltest:2.0.7 nodeos -d ~/eos.data/generator_node --config-dir ~/eos.data/generator_node -l ~/eos.data/logging.json --plugin eosio::txn_test_gen_plugin --plugin eosio::http_plugin --plugin eosio::chain_api_plugin --abi-serializer-max-time-ms 50000000 --chain-state-db-size-mb 32768 --reversible-blocks-db-size-mb 2048 --http-max-response-time-ms 1000 --p2p-peer-address localhost:9876 --p2p-listen-endpoint localhost:5555
MDIR=/home/dev001/LEDGIS/build
docker exec -it led2 mkdir -p $MDIR
docker cp /home/ubuntu/test/transfile/unittests led2:$MDIR

printf "\n===================================\n"
read -p "3. Create Wallet - press any key"
docker exec -it led2 cleos wallet create --to-console

printf "\n===================================\n"
read -p "4. Import Key  - press any key"
docker exec -it led2 cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

printf "\n===================================\n"
read -p "5. Initialize test - press any key"
curl --data-binary '["led", "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"]' http://127.0.0.1:8888/v1/txn_test_gen/create_test_accounts

printf "\n===================================\n"
read -p "6. Run test - press any key"
curl --data-binary '["", 20, 40]' http://127.0.0.1:8888/v1/txn_test_gen/start_generation

