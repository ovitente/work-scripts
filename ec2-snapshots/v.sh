VLIST="vol-08f583eb5eb254e3b
vol-0f2fc06447ab757ea
vol-08f583eb5eb254e3b
vol-0f2fc06447ab757ea
vol-0f2fc06447ab757ea
vol-08f583eb5eb254e3b"


for i in $VLIST
do
  if [ $=$(jq '.[0].VolumeId' -r in-vol.json) ]; then
    echo "$i | $(jq '.[0].InstanceId' -r in-vol.json)"
  fi

done

# jq '.[0].InstanceId' -r in-vol.json
