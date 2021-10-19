#!/usr/bin/env bash

declare -A InstanceVolumeArray

for line in $(cat volumes.list | awk '{print $2}')
do
   echo $line

  # assArray1[fruit]=Mango
  # assArray1[bird]=Cockatail
  # assArray1[flower]=Rose
  # assArray1[animal]=Tiger

done
