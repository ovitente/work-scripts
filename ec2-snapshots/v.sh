VLIST="vol-08f583eb5eb254e3b
vol-0f2fc06447ab757ea
vol-08f583eb5eb254e3b
vol-0f2fc06447ab757ea
vol-0f2fc06447ab757ea
vol-08f583eb5eb254e3b"

JSON_SOURCE="test.json"
ARRAY_INDEX=$(grep -o -i Attachments $JSON_SOURCE | wc -l)

# for i in $VLIST
# do
#   if [ $i=$(jq '.[0].VolumeId' -r $JSON_SOURCE) ]; then
#     echo "$i | $(jq '.[0].InstanceId' -r $JSON_SOURCE)"
#   fi
# done


i=0
while [ $i -ne $ARRAY_INDEX ]
do
  # id=$(cat ${JSON_SOURCE}            | jq .[$i].ID -r)
  # creation_time=$(cat ${JSON_SOURCE} | jq .[$i].CreationTime -r | cut -b 1-19)
  # snap_source=$(cat ${JSON_SOURCE}   | jq .[$i].Source -r)
  # size=$(cat ${JSON_SOURCE}          | jq .[$i].Size -r)

  jq -r '.['"$i"'].Attachments | @tsv' $JSON_SOURCE
  # jq -r '[.['"$i"'].Attachments, .['"$i"'].InstanceId, .['"$i"'].VolumeId] | @tsv' $JSON_SOURCE
  # jq -r '[.['"$i"'].ID, .['"$i"'].CreationTime, .['"$i"'].Source, .['"$i"'].Size] | @tsv' $JSON_SOURCE

  # echo "$id | $creation_time | $snap_source | $size"

  i=$(($i+1))
done



# jq '.[0].InstanceId' -r in-vol.json
