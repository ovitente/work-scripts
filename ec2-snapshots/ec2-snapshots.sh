#!/usr/bin/env bash

# Used tools: aws, grep, jq, cut, wc


CREATOR_ID="self"

JSON_SOURCE="snapshots.json"
ARRAY_INDEX=""

# Cleaning before new start
# rm -rf $JSON_SOURCE
# Get json with spanshots
# aws ec2 describe-snapshots \
#   --owner-ids ${CREATOR_ID} \
#   --query "Snapshots[*].{ID:SnapshotId,CreationTime:StartTime,Source:VolumeId,Size:VolumeSize}" > ${JSON_SOURCE}

# Count elements in the json starting with [0]
ARRAY_INDEX=$(grep -o -i ID ${JSON_SOURCE} | wc -l)

# Execute cycle that go through every snapshot
echo "-----------------------|---------------------|-----------------------|---------"
echo "      Snapshot ID      |    Creation Time    |     Source Volume     |   Size  "
echo "-----------------------|---------------------|-----------------------|---------"
i=0
while [ $i -ne $ARRAY_INDEX ]
do
  # id=$(cat ${JSON_SOURCE}            | jq .[$i].ID -r)
  # creation_time=$(cat ${JSON_SOURCE} | jq .[$i].CreationTime -r | cut -b 1-19)
  # snap_source=$(cat ${JSON_SOURCE}   | jq .[$i].Source -r)
  # size=$(cat ${JSON_SOURCE}          | jq .[$i].Size -r)

  jq -r '[.['"$i"'].ID, .['"$i"'].CreationTime, .['"$i"'].Source, .['"$i"'].Size] | @tsv' snapshots.json

  # echo "$id | $creation_time | $snap_source | $size"

  i=$(($i+1))
done
