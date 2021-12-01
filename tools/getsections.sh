#!/bin/sh
type="$1"
if [ -z "${type}" ]; then
  type="section"
fi
exec awk -v type="${type}" -f tools/getsections.awk source/rewrite-map.txt
