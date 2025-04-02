#!/usr/bin/env bash
rm -rvf "./work" || exit 1
rm -vf "./FontGoogleSansOverlay/compiled_res.zip" || exit 1
if [[ $1 == "--mrproper" ]]; then
  rm -rvf "./out" || exit 1
fi
exit 0
