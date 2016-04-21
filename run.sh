#!/bin/bash

cp galaxy.ini galaxy/config
cp tool_conf.xml galaxy/config
rsync -ruv tools/ galaxy/tools/

cp requirements.txt ./galaxy/lib/galaxy/dependencies/requirements.txt 

cd galaxy
./run.sh
