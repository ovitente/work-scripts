#!/usr/local/bin/bash

# TODO:
# 1. Get json with all volumes id and instances id
# 2. Add row with vol id to associative array
# 3. Go through array and echo instance id that associated with it from json source

# aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{ID:SnapshotId,CreationTime:StartTime,Source:VolumeId,Size:VolumeSize,IsEncrypted:Encrypted, Tags:Tags[]}" --output text | column -t
# jq -r '.[0].Attachments[].InstanceId, .[0].Attachments[].VolumeId' test.json # echoes two values for one index


# Get list of all instances
# read -a INSTANCES_ID_LIST <<< "$(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"
# read -a VOLUMES_ID_LIST <<< "$(aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{VolumeId:VolumeId}" --output text | tr '\n' ' ')"


# for instance_id in ${INSTANCES_ID_LIST[*]}; do
#   # InstanceVolumeArray[$instance_id]="WOOOOW"
#   InstanceVolumeArray[$instance_id]=$(aws ec2 describe-volumes --query "Volumes[*].Attachments[?InstanceId=='$instance_id'].{VolumeId:VolumeId}" --output text)
#   # ПОЛУЧИТЬ ЧЕРЕЗ ДЖЕЙСОН С ФАЙЛА, ПАРА УЖЕ есть
# done

# -------------------------------------------

# Сначала создать два массива для волюмов и инстансов
# а затем внести их в один ассоциативный массив


declare -A InstanceVolumeArray # Array that will combine both indexed arrays
JSON_SOURCE="volumes.json"
aws ec2 describe-volumes --query "Volumes[*]" > $JSON_SOURCE
ARRAY_INDEX=$(grep -o -i Attachments $JSON_SOURCE | wc -l)
i=0
while [ $i -ne $ARRAY_INDEX ]
do
  lo_volume=$(jq '.['"$i"'].Attachments[].InstanceId' -r $JSON_SOURCE)
  lo_instance=$(jq '.['"$i"'].Attachments[].InstanceId' -r $JSON_SOURCE)
  InstanceVolumeArray[$lo_volume]=$lo_instance
  i=$(($i+1))
done

# SAMPLE - aws ec2 describe-volumes --query 'Volumes[*].Attachments[?InstanceId==`i-06203b72c61a233e4`].{VolumeId:VolumeId}' --output text
# For every key in the associative array..
echo " --- Instance | Volume ---------------------------------"
# Этот цикл читает уже по авс аутпуту столбца с повторяющимися волюмами и ассайнит инстанс айди
for instance_id in "${!InstanceVolumeArray[@]}"; do
  # Print the instance_id value
  echo "$instance_id | ${InstanceVolumeArray[$instance_id]}"
done
