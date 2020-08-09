#!/bin/bash

## This script creates the build image locally and builds Android.
##
## Possible parameters:
##  --rom: rom to build. Possible values: icosa | foster | foster_tab
##  --rom-type: build output. Possible values: zip | images
##  --flags: flags to pass to the build script. Possible values: string that contains:
##      - nobuild: avoids running the build process.
##      - noupdate: avoids running the sources update process.
##      - nooutput: avoids copying the build to the output directory.
##      - with_twrp: builds TWRP after a successful Android build and copies it to the output directory
##
## If the ENV variable DUMMY_BUILD has some non-empty value, the actual execution of scripts 
## will be replaced with dummy messages. Used to quickly test the other parameters.

while (($# > 0))
    do
    declare Option="$1"
    declare Value="$2"

    case $Option in
    --rom)
        if [[ "$Value" != "icosa" && "$Value" != "foster" && "$Value" != "foster_tab" ]]; then
            echo "Invalid rom name. Expecting icosa | foster | foster_tab"
            exit 1
        fi
        declare ROM_NAME="$Value"
        shift
        shift
        ;;

    --rom-type)
        if [[ "$Value" != "zip" && "$Value" != "images" ]]; then
            echo "Invalid rom type. Expecting images | zip"
            exit 1
        fi
        declare ROM_TYPE="$Value"
        shift
        shift
        ;;

    --flags)
        if [ -z ${Value##*--*} ]; then
            echo "Flags must come last and the arguments must not be empty."
            exit 1
        fi
        declare FLAGS="$Value"
        shift
        shift
        ;;

    *)
        echo "Unknown option. Ignoring $Option."
        shift
        ;;

    esac
done

./create-image.sh

DUMMY_BUILD=${DUMMY_BUILD:-""} ROM_NAME=${ROM_NAME:-icosa} ROM_TYPE=${ROM_TYPE:-zip} FLAGS=${FLAGS:-""} ./build-in-docker.sh
