LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE       := anxfilecheck
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_EXECUTABLES)
LOCAL_SRC_FILES    := anxfilecheck.sh
LOCAL_INIT_RC      := anxfilecheck.rc
include $(BUILD_PREBUILT)
