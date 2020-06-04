#!/bin/bash
shopt -s expand_aliases

SLEEP=5
alias hc0='HARNESS_SERVER_ADDRESS=harness0 HARNESS_SERVER_PORT=9090 harness-cli'
alias hc1='HARNESS_SERVER_ADDRESS=harness1 HARNESS_SERVER_PORT=9091 harness-cli'
alias diff='diff -iBbw --strip-trailing-cr'

# wait for elasticsearch to be ready for communication
hc0 status engines
hc1 status engines

hc0 delete engine0
hc0 delete engine1

sleep $SLEEP

E0=$(diff <(hc0 add /harness-cli-data/engine0.json | grep ' created') <(echo '    "comment": "EngineId: engine0 created"') )
E1=$(diff <(hc1 add /harness-cli-data/engine1.json | grep ' created') <(echo '    "comment": "EngineId: engine1 created"') )
if [ "$E0" != "" ]
then
  echo "ERROR: failed to add engine to harness0 instance"
  echo $E0
  exit 1
elif [ "$E1" != "" ]
then
  echo "ERROR: failed to add engine to harness1 instance"
  echo $E1
  exit 1
fi

sleep $SLEEP

DIFF=$(diff <(hc0 status engines | grep engineId) <(hc1 status engines | grep engineId))
if [ "$DIFF" != "" ]
then
  echo "ERROR: engines not in sync at different harness instances"
  echo $DIFF
  exit 1
fi

DEL1=$(diff <(hc0 delete engine1) <(echo 'Deleted engine-id: engine1'))
DEL0=$(diff <(hc1 delete engine0) <(echo 'Deleted engine-id: engine0'))
if [ "$DEL0" != "" ]
then
  echo "ERROR: delete engine 0 problem"
  echo $DEL0
  exit 1
elif [ "$DEL1" != "" ]
then
  echo "ERROR: delete engine 1 problem"
  echo $DEL1
  exit 1
fi

sleep $SLEEP

DIFF_DEL=$(diff <(hc0 status engines | grep engineId) <(hc1 status engines | grep engineId))
if [ "$DIFF_DEL" != "" ]
then
  echo "ERROR: engines not in sync at different harness instances (after delete)"
  echo $DIFF_DEL
  exit 1
fi

echo "SUCCESS: Add engines test passed"
