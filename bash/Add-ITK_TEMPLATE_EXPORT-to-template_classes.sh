#!bin/sh

# file should be at ITK root

# "files_to_modify.txt" will contain all paths to files which should be modified
# Those are:
# * Files contained inside Modules except ThrirdParty
# * .h files with same name as a .hxx
h_file="h_file.txt"
hxx_file="hxx_file.txt"
exclude="-not -path '*ThirdParty*'"
# find doesn't work with var
#find Modules/ $exclude -name '*.h' > "$h_file"
find Modules/ -not -path "*ThirdParty*" -name '*.h' > "$h_file"
find Modules/ -not -path "*ThirdParty*" -name '*.hxx' > "$hxx_file"

# create an empty file which stores files to modify
files_to_modify="files_to_modify.txt"
echo " " > "$files_to_modify"
# compare if a .h name file have the same name as a .hxx file
for h_name in `cat $h_file`; do
  if grep -q "$h_name" "$hxx_file"; then
    echo "$h_name" >> "$files_to_modify"
  fi
done

# Among these files, add:
# * ITK_TEMPLATE_EXPORT to each not forward declaration class
# * #include ITKCommonExport.h

# Check inside each path file inside files_to_modify.txt:
# * for each 'class'; do
#   * if it's not in a comment; then
#     * if it's followed by '{' instead of ';'; then #which means it's not a forward dec.
#       * if the following word is not 'ITK_TEMPLATE_EXPORT'; then
#         * replace 'class' by 'class ITK_TEMPLATE_EXPORT'
#       * fi
#     * fi
#   * fi
# * done

# script to replace class by class ITK_TEMPLATE_EXPORT
for h_name in `cat $files_to_modify`; do

  # Replace class ITK_TEMPLATE_EXPORT ITK_TEMPLATE_EXPORT by class ITK_TEMPLATE_EXPORT
  sed -i 's/^\(\s*\)\(class ITK_TEMPLATE_EXPORT ITK_TEMPLATE_EXPORT\)/\1class ITK_TEMPLATE_EXPORT/g' "$h_name"

  # Replace all class (which have nothing except space in front of it) by class ITK_TEMPLATE_EXPORT
  sed -i 's/^\(\s*\)\(class\)/\1class ITK_TEMPLATE_EXPORT/g' "$h_name"

  # Replace class ITK_TEMPLATE_EXPORT ITK_TEMPLATE_EXPORT by class ITK_TEMPLATE_EXPORT
  sed -i 's/^\(\s*\)\(class ITK_TEMPLATE_EXPORT ITK_TEMPLATE_EXPORT\)/\1class ITK_TEMPLATE_EXPORT/g' "$h_name"

done



# Check for #include ITKCommonExport.h
# * for each 'class ITK_TEMPLATE_EXPORT' inside files_to_modify; do
#   * if '#include "ITKCommonExport.h"' not already here; then
#     * if it contains a #inlcude; then
#       * replace '#include' by '#include "ITKCommonExport.h"'
#     * else
#       * add #include somewhere
#     * fi
#   * fi
# * done


#for ftm in `cat "$files_to_modify"`; do


#  if ! grep -q '#include "ITKCommonExport.h"' "$ftm"; then
#    sed '0,/#include/s//#include "ITKCommonExport.h"\n#include/' "$ftm" > "$ftm"
#  fi
#done



# Function to know if a word is in a comment or not

