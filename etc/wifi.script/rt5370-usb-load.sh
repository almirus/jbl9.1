#!/bin/sh

RT_MOD_PATH=/lib/modules/`uname -r`/BDP

insmod ${RT_MOD_PATH}/rtutil5370sta.ko
insmod ${RT_MOD_PATH}/rt5370sta.ko
insmod ${RT_MOD_PATH}/rtnet5370sta.ko
