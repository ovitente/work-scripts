#!/usr/local/bin/bash
#!/usr/bin/env bash

# declare -a VOLUMES_ID_ARRAY
# VOLUMES_ID_ARRAY=($(aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{VolumeId:VolumeId}" --output text | tr '\n' ' '))
read -a VOLUMES_ID_ARRAY <<< $(aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{VolumeId:VolumeId}" --output text | tr '\n' ' ')
# VOLUMES_ID_ARRAY=("vol-08f583eb5eb254e3b" "vol-0f2fc06447ab757ea" "vol-08f583eb5eb254e3b" "vol-0f2fc06447ab757ea" "vol-0f2fc06447ab757ea" "vol-08f583eb5eb254e3b")
# echo "${VOLUMES_ID_ARRAY[@]}"

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

echo "----- Volume ID ------| --- Instance ID ---"
for instance_id in "${!InstanceVolumeArray[@]}"; do
  echo "$instance_id | ${InstanceVolumeArray[$instance_id]}"
done

for i in "${VOLUMES_ID_ARRAY[@]}"
do
  # echo "${VOLUMES_ID_ARRAY[$i]}"
  echo "$i"

done
