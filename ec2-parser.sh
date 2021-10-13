#!/usr/bin/env bash

# Source file for instance IDs
INSTANCES_ID_SOURCE_FILE="instances.list"

# Temp files
INSTANCES_TYPES="instances-types.list"
INSTANCE_TYPE_SOURCE_FILE="ins-type.json"

# Temp global vars
INSTANCE_PROPERTIES="instance-prop.json"
INSTANCE_TYPE=""
OUTPUT_LINE="" # Must be emtpy at start
CPU_TYPE=""      # Must be emtpy at start
CPU_USAGE=""     # Must be emtpy at start
MEMORY_AMOUNT="" # Must be emtpy at start
MEMORY_USAGE=""  # Must be emtpy at start

# Metrics request configiration parameters
START_TIME="2021-10-13T00:00:01"
END_TIME="2021-10-13T23:59:59"
PERIOD=3600

# Functions Declaration ====================================================================================

function GetInstanceType {
  INSTANCE_TYPE="$(aws ec2 describe-instances --instance-ids ${instance_id} | jq .Reservations[].Instances[].InstanceType -r)"
  OUTPUT_LINE="${instance_id} | $INSTANCE_TYPE"
}

function SaveInstanceTypeSourceJsonOutput {
  for instance_type in $(cat ${INSTANCES_TYPES}); do
    aws ec2 describe-instance-types \
      --instance-types ${instance_type} >> ${INSTANCE_PROPERTIES}
  done
}

# function GetCpuInfo {
# }

function GetCpuUsage {
  OUTPUT_LINE="${OUTPUT_LINE} | $(aws cloudwatch get-metric-statistics  \
    --namespace AWS/EC2                                                 \
    --metric-name CPUUtilization                                        \
    --dimensions Name=InstanceId,Value=${instance_id}                   \
    --statistics Maximum                                                \
    --start-time ${START_TIME}                                          \
    --end-time ${END_TIME}                                              \
    --period ${PERIOD} | jq '.Datapoints[0] .Maximum' | sed -re 's/([0-9]+\.[0-9]{2})[0-9]+/\1/g')"
}

function GetMemoryInfo {
  OUTPUT_LINE="${OUTPUT_LINE} | $(aws ec2 describe-instance-types --instance-types ${INSTANCE_TYPE} | jq .InstanceTypes[].MemoryInfo[] -r)"
}

function Clean {
  # Removes temp files
  rm ${INSTANCE_TYPE_SOURCE_FILE} ${INSTANCES_TYPES}
}

# Functions Usage ====================================================================================

# Clean
for instance_id in $(cat ${INSTANCES_ID_SOURCE_FILE}); do
  GetInstanceType
  # GetCpuInfo
  GetCpuUsage
  GetMemoryInfo
  echo $OUTPUT_LINE
done
