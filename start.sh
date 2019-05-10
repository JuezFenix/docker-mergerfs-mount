#!/bin/bash

function term_handler {
  kill -SIGTERM ${!}
  echo "sending SIGTERM to child pid"
  fuse_unmount
  echo "exiting now"
  exit $?
}

function fuse_unmount {
  fusermount -u -z "$OUT"
}

if [ -z "${FILESYSTEMS}" ]; then
  echo "No filesystems specified!"
fi

trap term_handler SIGINT SIGTERM

while true
do
  /usr/bin/mergerfs -f -o $OPTIONS "$FILESYSTEMS" "$OUT" & wait ${!}
  echo "mergerfs crashed at: $(date +%Y.%m.%d-%T)"
  fuse_unmount
done

exit 144
