#!/bin/bash

shopt -s nullglob

git_setup=true
git config user.email
if [ $? -ne 0 ]
then
  git_setup=false
fi

checkout_project () {
  d=$1
  if [ ! -f "$d/metadata" ]
  then
    return 1
  fi

  clone_url=$(sed -n "1p" "$d/metadata")
  commit_hash=$(sed -n "2p" "$d/metadata")

  rm -rf "$d/clone"
  git -c advice.detachedHead=false clone --revision=$commit_hash --depth=1 $clone_url "$d/clone/"

  pushd "$d/clone/" > /dev/null
  if $git_setup
  then
    git am -3 "../patch/"*.patch --ignore-whitespace --ignore-space-change
  else
    git apply "../patch"*.patch --ignore-whitespace --ignore-space-change
  fi
  popd > /dev/null
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
