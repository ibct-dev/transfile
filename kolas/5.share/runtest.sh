
URL="https://myselfdata-did.identitydatahub.com/idhaccount/createPermissionCommit"
printf "\n===================================\n"
echo "Start test loop"

while true; do
	read -p "New Share transactions - Run(Y/n) : " isRun
	[ -z $isRun ] && isRun="Y"
	[ "$isRun" != "Y" ] && break

	printf "\nTransaction Start : %s\n\n" $(date +"%Y-%m-%dT%T.%3N") 
	time curl -s -XPOST  -d @share-req.json -H "Content-Type: application/json" $URL | tee res
	printf "\nTransaction End   : %s\n\n" $(date +"%Y-%m-%dT%T.%3N") 
	cat res | jq 
done



