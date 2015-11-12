#!/bin/bash

## TODO: a lot

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

for i in `find $source_dir/ -iname "*.rpm" | awk -F'/' '{print $NF}'` ;
  do
  field_numbers=$( get_field_numbers $i )
  build_arch=$( get_build_arch $i )
  arch=$( get_arch $i )
  version_number=$( get_version_number $i )
  package_name=$( get_package_name $i )
    for j in `find $target_dir -name $package_name* | awk -F'/' '{print $NF}'` ; do
      if [[ $( get_version_number $i  ) !=  $( get_version_number $j  )   ]]; then
        # NOTE: output package name with different version
        echo "$i"
      fi
    done
done
