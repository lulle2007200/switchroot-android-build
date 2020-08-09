#!/bin/bash

cd ${BUILDBASE}

if [ "$(ls -A ./android/lineage)" ]; then
    echo "Sources found. Skipping..."
else
    if [[ -z $DUMMY_BUILD ]]; then
        echo "Getting sources..."
        ./get-sources.sh
    else
        echo Dummy executed get-sources.sh
    fi
fi

if [[ -z $FLAGS || ! -z ${FLAGS##*noupdate*} ]]; then
    if [[ -z $DUMMY_BUILD ]]; then
        cd ${BUILDBASE}
        ./reset-changes-update-sources.sh
        ./repopic-and-patch.sh
    else
        echo Dummy executed reset-changes-update-source.sh and repopic-and-patch-sh
    fi
fi

if [[ -z $FLAGS || ! -z ${FLAGS##*nobuild*} ]]; then
    if [[ -z $DUMMY_BUILD ]]; then
        cd ${BUILDBASE}
        ./build.sh
        RESULT=$?
        if [[ $RESULT -ne 0 ]]; then
            exit -1
        fi
    else
        echo Dummy executed build.sh
    fi
fi

if [[ "$ROM_TYPE" == "zip" ]]; then
    if [[ -z $FLAGS || ! -z ${FLAGS##*nooutput*} ]]; then
        if [[ -z $DUMMY_BUILD ]]; then
            echo "Copying output to ./android/output..."
            cd ${BUILDBASE}
            ./copy-to-output.sh
        else
            echo Dummy executed copy-to-output.sh
        fi
    fi
fi

if [[ ! -z $FLAGS && -z ${FLAGS##*with_twrp*} ]]; then
    if [[ -z $DUMMY_BUILD ]]; then
        cd ${BUILDBASE}
        ./add-twrp-repo.sh
        cd ${BUILDBASE}
        ./build-twrp.sh
        RESULT=$?
        if [[ $RESULT -ne 0 ]]; then
            exit -1
        fi

        echo "Copying twrp output to ./android/output..."
        cd ${BUILDBASE}
        ./copy-twrp-to-output.sh

        # restore original recovery dir
        rm -rf ${BUILDBASE}/android/lineage/bootable/recovery
        mv ${BUILDBASE}/android/recovery-backup ${BUILDBASE}/android/lineage/bootable/recovery
    else
        echo Dummy built twrp
    fi
fi
