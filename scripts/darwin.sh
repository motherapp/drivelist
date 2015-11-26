#!/bin/sh

function get_key {
  grep "$1" | awk -F "  +" '{ print $3 }'
}

function get_until_paren {
  awk 'match($0, "\\(|$"){ print substr($0, 0, RSTART - 1) }'
}

DISKS="`df -Hl | grep '^\/' | awk -F ' +' '{ print $1 }' | awk -F '/' '{ print $3 }'`"

for disk in $DISKS; do
  diskinfo="`diskutil info $disk`"

  device=`echo "$diskinfo" | get_key "Device Node"`
  description=`echo "$diskinfo" | get_key "Device / Media Name"`
  mountpoint=`echo "$diskinfo" | get_key "Mount Point"`
  size=`echo "$diskinfo" | get_key "Total Size" | get_until_paren`

  echo "device: $device"
  echo "description: $description"
  echo "size: $size"
  echo "mountpoint: $mountpoint"

  if [[ "$device" == "/dev/disk0" ]] || [[ "$mountpoint" == "/" ]]; then
    echo "system: True"
  else
    echo "system: False"
  fi

  echo ""
done
