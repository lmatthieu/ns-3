#!/bin/bash
# Stop on error
set -e

# where is the data dir (has to be a volume to persist the info if is the first run or not)
DATA_DIR=/data

source /scripts/wait_for_linked_lxc.sh
wait_for_container

if [[ -e $DATA_DIR/firstrun ]]; then
  source /scripts/normal_run.sh
else
  source /scripts/first_run.sh
fi

pre_start_action

post_start_action

# Start Process
echo "Starting my_process.sh..."
my_process.sh
