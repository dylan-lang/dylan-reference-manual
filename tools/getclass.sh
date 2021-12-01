#!/bin/sh
section="$1"
if [ -z "${section}" ]; then
  echo "Usage: $0 section"
  exit 1
fi
exec awk -v section="${section}" -f tools/getclass.awk source/rewrite-map.txt
