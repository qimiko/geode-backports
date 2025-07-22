#!/bin/bash

shopt -s nullglob

checkout_project () {
  d=$1
  if [ ! -f "$d/metadata" ]
  then
    continue
  fi

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
}

if [ $# -eq 0 ]
then
  for d in */
  do
    checkout_project $d
  done
else
  checkout_project $1
fi
