#!/vendor/bin/sh

ANX_DIR="/sdcard/.ANXCamera"
DEVICE=$(getprop ro.product.device)

if [ -d $ANX_DIR || -f /system/etc/ANXCamera/cheatcodes/feature_${DEVICE} || -f /system/etc/device_features/${DEVICE}.xml ]; then
    new_cheatcode=$(sha1sum /system/etc/ANXCamera/cheatcodes/feature_${DEVICE} | cut -d " " -f1)
    old_cheatcode=$(sha1sum ${ANX_DIR}/cheatcodes_reference/feature_${DEVICE} | cut -d " " -f1)

    new_features=$(sha1sum /system/etc/device_features/${DEVICE}.xml | cut -d " " -f1)
    old_features=$(sha1sum ${ANX_DIR}/features_reference/${DEVICE}.xml | cut -d " " -f1)

    if [ "$new_cheatcode" = "$old_cheatcode" || "$new_features" = "$old_features" ]; then
        echo "anxfilecheck: You are using the latest cheatcode and feature files."
    else
        mkdir ${ANX_DIR}/cheatcodes/
        cp /system/etc/ANXCamera/cheatcodes/feature_${DEVICE} ${ANX_DIR}/cheatcodes/

        mkdir ${ANX_DIR}/cheatcodes_reference/
        cp /system/etc/ANXCamera/cheatcodes/feature_${DEVICE} ${ANX_DIR}/cheatcodes_reference/

        mkdir ${ANX_DIR}/features/
        cp /system/etc/device_features/${DEVICE}.xml ${ANX_DIR}/features/

        mkdir ${ANX_DIR}/features_reference/
        cp /system/etc/device_features/${DEVICE}.xml ${ANX_DIR}/features_reference/
    fi
fi
