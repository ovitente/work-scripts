# Get all snapshots
aws ec2 describe-snapshots \
  --owner-ids self \
  --query "Snapshots[*].{ID:SnapshotId,CreationTime:StartTime,Source:VolumeId,Size:VolumeSize,IsEncrypted:Encrypted, Tags:Tags[]}" \
  --output text | column -t

# Get all instances id and volumes id
aws ec2 describe-volumes --query "Volumes[*].Attachments[].{InstanceId:InstanceId,VolumeId:VolumeId}" --output table

# Encryption
# Tags
