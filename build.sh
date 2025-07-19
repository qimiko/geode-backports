#!/bin/bash

shopt -s nullglob

current=$(pwd)
outdir="$current/out/"

rm -rf "$outdir"
mkdir "$outdir"

build_windows () {
  cmake -B build-windows -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_CXX_FLAGS=-m32 -DCMAKE_C_FLAGS=-m32 -G Ninja -DGEODE_DONT_INSTALL_MODS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
  cmake --build build-windows

  return $?
}

for d in */
do
  if [ ! -d "$d/clone/" ]
  then
    continue
  fi

  pushd "$d/clone/"
  build_windows || {
    echo "failed to build windows :("
    exit 1
  }
  geode build -p android32 || {
    echo "failed to build android :("
    exit 1
  }

  files=$(find build-android32 -name "*.geode" -type f)
  for file in $files
  do
    filename=$(basename "$file")
    geode package merge "build-android32/$filename" "build-windows/$filename"
  done
  cp ./build-android32/*.geode "$outdir"    
  popd
done

