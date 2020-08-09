#!/bin/bash

## This script builds Andorid with an existing docker image

if [ -z $ROM_NAME ];
then
    echo "Missing ROM_NAME env variable. Expected icosa | foster | foster_tab"
    exit 1
else
    echo "ROM name: $ROM_NAME"
fi

if [ -z $ROM_TYPE ]; then
    echo "Missing ROM_TYPE env variable. Expected zip | images"
    exit 1
else
    echo "ROM type: $ROM_TYPE"
fi

if [ -n $FLAGS ]; then
    echo "Flags: $FLAGS"
fi

mkdir -p ./android/lineage
echo Building $ROM_NAME

BUILDBASE="/build"
docker run --rm -ti -e DUMMY_BUILD=${DUMMY_BUILD:-""} -e ROM_NAME=$ROM_NAME -e ROM_TYPE=$ROM_TYPE -e FLAGS=${FLAGS:-""} -v "$PWD"/android:${BUILDBASE}/android pablozaiden/switchroot-android-build
