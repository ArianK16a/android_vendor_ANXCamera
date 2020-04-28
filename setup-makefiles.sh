#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

INITIAL_COPYRIGHT_YEAR=2020

ANXCAMERA_COMMON=common
VENDOR=ANXCamera

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR/../.."

HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the helper
setup_vendor "$ANXCAMERA_COMMON" "$VENDOR" "$LINEAGE_ROOT" true

# Copyright headers and guards
write_headers "xiaomi"
sed -i 's|TARGET_DEVICE|BOARD_VENDOR|g' $ANDROIDMK
sed -i 's|vendor/ANXCamera/|vendor/ANXCamera/common|g' $PRODUCTMK
sed -i 's|device/ANXCamera//setup-makefiles.sh|vendor/ANXCamera/setup-makefiles.sh|g' $ANDROIDBP $ANDROIDMK $BOARDMK $PRODUCTMK

write_makefiles "$MY_DIR"/proprietary-files.txt true

overrides=" \
    ANXCamera:Snap,Camera2"

for i in ${overrides[@]}; do
  # Split the string into var1 and var2
  IFS=: read var1 var2 <<< $i

  # Get the line number to insert the override
  line_number=$(grep -rn "name: \"$var1\"" $ANDROIDBP | awk '{print $1}' | tr -d ":")

  # Split the replacement in override1, override2 and override3
  IFS=, read override1 override2 override3 <<< $var2

  # Insert one or two replacements
  if [[ $override3 != "" ]]; then
    # Insert the override for three replacements
    sed -i "$line_number a \\\toverrides: [\"$override1\", \"$override2\", \"$override3\"]," $ANDROIDBP
  elif [[ $override2 != "" ]]; then
    # Insert the override for two replacements
    sed -i "$line_number a \\\toverrides: [\"$override1\", \"$override2\"]," $ANDROIDBP
  else
    # Insert the override for one replacement
    sed -i "$line_number a \\\toverrides: [\"$override1\"]," $ANDROIDBP
  fi

done

# Finish
write_footers
