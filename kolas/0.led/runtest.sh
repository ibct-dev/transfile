HOSTIP=10.100.2.248
TEST_HOME=/home/ubuntu/tips-network

CUR_DIR=$(pwd)
cd $TEST_HOME

printf "\n===================================\n"
read -p "1. Run genesis - press any key"
./scripts/run-genesis-node.sh --name genesis --host $HOSTIP --http-port 44444 --peer-port 44445 --signature-provider EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

printf "\n===================================\n"
printf "2. Run node #1 - press any key"
./scripts/run-node.sh --name node1 --http-port 33333 --peer-port 33334 --signature-provider EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 --nsp-endpoint $HOSTIP:30000 --peer-endpoint 10.100.2.248:44445

printf "\n===================================\n"
printf "3. Run approve #1 - press any key"
./scripts/approve.sh --name genesis --proposer-name genesis --proposal-name node1

printf "\n===================================\n"
printf "4. Run node #2 - press any key"
./scripts/run-node.sh --name node2 --http-port 33343 --peer-port 33344 --signature-provider EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 --nsp-endpoint $HOSTIP:30000 --peer-endpoint 10.100.2.248:44445

printf "\n===================================\n"
printf "5. Run approve #2 - press any key"
./scripts/approve.sh --name node1 --proposer-name genesis --proposal-name node2

cd $CUR_DIR
