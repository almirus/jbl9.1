#!/bin/sh

RT_MOD_PATH=/lib/modules/`uname -r`/BDP

insmod ${RT_MOD_PATH}/rtutil3370sta.ko
insmod ${RT_MOD_PATH}/rt3370sta.ko
insmod ${RT_MOD_PATH}/rtnet3370sta.ko
