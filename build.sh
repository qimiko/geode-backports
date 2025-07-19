#!/bin/bash

shopt -s nullglob

current=$(pwd)
outdir="$current/out/"

rm -rf "$outdir"
mkdir "$outdir"

for d in */
do
  if [ ! -d "$d/clone/" ]
  then
    continue
  fi

  pushd "$d/clone/"
  geode build -p windows
  geode build -p android32
    
  files=$(find build-android32 -name "*.geode" -type f -exec basename {} \;)
  for file in $files
  do
    geode package merge "build-android32/$file" "build-windows/$file"
  done
  cp ./build-android32/*.geode "$outdir"    
  popd
done

