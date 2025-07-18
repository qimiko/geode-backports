#!/bin/bash

shopt -s nullglob

for d in */
do
  clone_url=$(sed -n "1p" "$d/metadata")
  commit_hash=$(sed -n "2p" "$d/metadata")

  rm -rf "$d/clone"
  git -c advice.detachedHead=false clone --revision=$commit_hash --depth=1 $clone_url "$d/clone/"

  pushd "$d/clone/"
  for p in ../patch/*.patch
  do
    filename=$(basename "$p")
    echo "Apply patch $filename"
    git apply $p    
  done

  popd
done

