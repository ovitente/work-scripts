#!/usr/bin/env bash

# aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{ID:SnapshotId,CreationTime:StartTime,Source:VolumeId,Size:VolumeSize,IsEncrypted:Encrypted, Tags:Tags[]}" --output text | column -t

# read -a InstanceVolumeArray <<< "$(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"
declare -A InstanceVolumeArray
read -a InstanceVolumeArray <<< "$(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"
# echo "${InstanceVolumeArray[@]}"

# Надо сразу делать ассоциативный массив, для этого надо сразу получать инстанс айди и волюм, отформатировать вывод авс кли или jq получать в нужном виде.

for instance_id in ${InstanceVolumeArray[@]}
do
  echo $instance_id
  # jq '.[] | select(.InstanceId=="'"$instance_id"'") .VolumeId' -r volumes.json
done
