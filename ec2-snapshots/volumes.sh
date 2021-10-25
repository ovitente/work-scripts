#!/usr/local/bin/bash

# TODO:
# 1. Get json with all volumes id and instances id
# 2. Add 5th row with vol id to associative array
# 3. Go through array and echo instance id that associated with it from json source

# aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{ID:SnapshotId,CreationTime:StartTime,Source:VolumeId,Size:VolumeSize,IsEncrypted:Encrypted, Tags:Tags[]}" --output text | column -t

# Get list of all instances
read -a INSTANCES_ID_LIST <<< "$(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"

declare -A InstanceVolumeArray

for instance_id in ${INSTANCES_ID_LIST[*]}; do
  # InstanceVolumeArray[$instance_id]="WOOOOW"
  InstanceVolumeArray[$instance_id]=$(aws ec2 describe-volumes --query "Volumes[*].Attachments[?InstanceId=='$instance_id'].{VolumeId:VolumeId}" --output text)
done

# SAMPLE - aws ec2 describe-volumes --query 'Volumes[*].Attachments[?InstanceId==`i-06203b72c61a233e4`].{VolumeId:VolumeId}' --output text

# For every key in the associative array..
echo "--------------------------------------------------"
  echo "Instance | Volume"
for instance_id in "${!InstanceVolumeArray[@]}"; do
  # Print the instance_id value
  echo "$instance_id | ${InstanceVolumeArray[$instance_id]}"
done
