export HARNESS_LOGS=/tmp
export CLI_DATA=/tmp
export HARNESS_HTTP_TIMEOUT="10 seconds"
docker-compose -f docker-compose.yml -f two-harness-instances.yml up &

# sleep 20

# docker exec harness-services_harness-cli_1 run-2instances-test.sh
