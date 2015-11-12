#!/bin/bash

## TODO: filter for source packages
## TODO: filter for packages that are part of the next sr load / already in the devel project


source_dir="devel-image"
target_dir="suse-image"

help() {

  echo ""
  echo "  Compare the rpms in version number that are available"
  echo "  in two different directories"
  echo ""
  echo "    Still to implement: take these directories as arguments"
  echo "    and not hardcode them. Later: take two images, mount them,"
  echo "    then compare the contents"
}


# TODO: add options and help output
# Idea: take twp images as arguments - mount both of them and compare the rpm files inside
#       print rpms that are different in version 
while test $# -gt 0; do
  case $1 in
    -h | --help) help; exit 0 ;;
    *)  ;;
  esac
  shift
done

get_field_numbers(){
  field_numbers=$( echo $1 | awk -F'-' '{print NF}' )
  echo $field_numbers
}

get_build_arch(){
  build_arch=$( echo $1 | awk -F'-' '{print $NF}' )
  echo $build_arch 
}

get_arch(){
  build_arch=$( echo $1 | awk -F'-' '{print $NF}' )
  arch=$( echo $build_arch | awk -F'.' '{print $(NF-1) }' )
  echo $arch
}

get_version_number(){
  version_number=$( echo $1 | awk -F'-' '{print $(NF-1) }' )
   echo $version_number
}

get_package_name(){
  field_numbers=$( echo $1 | awk -F'-' '{print NF}' )
  package_name=$( echo $1 | cut -d '-' -f 1-$((field_numbers-2))   )
  echo $package_name
}


## Find inexistent packages in the sources
for i in `find $source_dir/ -iname "*.rpm" | awk -F'/' '{print $NF}'` ;
do
  find_res=0
  package_name=$( get_package_name $i )
  for j in ` find $target_dir -name $package_name* | awk -F'/' '{print $NF}'` ;
  do
    find_res=$((find_res+1))
  done
  if [ $find_res -eq 0 ] ; then
#    echo "package named $package_name not present in target image"
    echo "$package_name"
  fi
done
