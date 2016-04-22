#!/bin/bash

cp galaxy.ini galaxy/config
cp tool_conf.xml galaxy/config
cp datatypes_conf.xml galaxy/config
cp requirements.txt galaxy/requirements.txt
cp data_manager_conf.xml galaxy/config/data_manager_conf.xml
cp -r data galaxy/
cp tool_data_table_conf.xml galaxy/config/tool_data_table_conf.xml
rsync -ruv datatypes/ galaxy/lib/galaxy/datatypes/
rsync -ruv tools/ galaxy/tools/
rsync -ruv tool-data/ galaxy/tool-data # for future usage

cd galaxy
./run.sh
