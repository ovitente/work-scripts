#!/usr/bin/env bash
#!/usr/local/bin/bash

read -a VOLUMES_ID_ARRAY <<< $(aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{VolumeId:VolumeId}" --output text | tr '\n' ' ')

declare -A InstanceVolumeArray # Array that will combine both indexed arrays
JSON_SOURCE="volumes.json"
aws ec2 describe-volumes --query "Volumes[*]" > $JSON_SOURCE
ARRAY_INDEX=$(grep -o -i Attachments $JSON_SOURCE | wc -l)
i=0
while [ $i -ne $ARRAY_INDEX ]
do
  lo_volume=$(jq '.['"$i"'].Attachments[].VolumeId' -r $JSON_SOURCE)
  lo_instance=$(jq '.['"$i"'].Attachments[].InstanceId' -r $JSON_SOURCE)
  InstanceVolumeArray[$lo_volume]=$lo_instance
  i=$(($i+1))
done

for volume in "${VOLUMES_ID_ARRAY[@]}"
do
  # echo "$volume"

  for key in "${!InstanceVolumeArray[@]}"; do
    if [ $volume = $key ]; then
      echo "$volume | ${InstanceVolumeArray[$key]}"
    fi
  done
done
