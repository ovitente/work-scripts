#!/usr/local/bin/bash
# aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].{ID:SnapshotId,CreationTime:StartTime,Source:VolumeId,Size:VolumeSize,IsEncrypted:Encrypted, Tags:Tags[]}" --output text | column -t

# Get list of all instances
read -a INSTANCES_ID_LIST <<< "$(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"
# read -a INSTANCES_ID_LIST <<< "Hello Moto Two"
echo "${INSTANCES_ID_LIST[@]} | - ARRAY"
echo "---------------------------------"

declare -A InstanceVolumeArray
# InstanceVolumeArray[key1]="OMGWHY"
# InstanceVolumeArray[key2]="124314OMGWHY"
# InstanceVolumeArray[key3]="AOSfh9asfh"
# InstanceVolumeArray[key4]="000000"
# echo "${InstanceVolumeArray[*]} | - ARRAY"

for instance_id in ${INSTANCES_ID_LIST[*]}; do
  # InstanceVolumeArray[$instance_id]="WOOOOW"
  InstanceVolumeArray[$instance_id]=$(aws ec2 describe-volumes --query "Volumes[*].Attachments[?InstanceId=='$instance_id'].{VolumeId:VolumeId}" --output text)
done


# SAMPLE - aws ec2 describe-volumes --query 'Volumes[*].Attachments[?InstanceId==`i-06203b72c61a233e4`].{VolumeId:VolumeId}' --output text


# For every key in the associative array..
echo "--------------------------------------------------"
for instance_id in "${!InstanceVolumeArray[@]}"; do
  # Print the instance_id value
  echo "Instance: $instance_id | Volume: ${InstanceVolumeArray[$instance_id]}"
done

# NOTE: The use of quotes around the array of keys ${!ARRAY[@]} in the for statement (plus the use of @ instead of *) is necessary in case any keys include spaces.




# InstanceVolumeArray[${InstanceVolumeArray}]=volume_id


# echo "${InstanceVolumeArray[instance_id]}"
# # assign
# # $(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"
# # read -a InstanceVolumeArray <<< "$(aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId}" --output text | tr '\n' ' ' )"
# # echo "${InstanceVolumeArray[@]}"

# # Надо сразу делать ассоциативный массив, для этого надо сразу получать инстанс айди и волюм, отформатировать вывод авс кли или jq получать в нужном виде.

# # for instance_id in ${InstanceVolumeArray[@]}
# # do
# #   # echo $instance_id
# #   echo ${InstanceVolumeArray[$instance_id]}
# #   # jq '.[] | select(.InstanceId=="'"$instance_id"'") .VolumeId' -r volumes.json
# # done
