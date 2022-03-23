#!/bin/bash

docker container rm -f test_bus

docker run -i -d \
--name test_bus \
--rm \
--mount type=bind,source=/mnt/c/datasets/SVIn2-datasets,target=/usr/app/SVIn2-datasets,readonly \
--volume /tmp/.X11-unix:/tmp/.X11-unix. \
--env DISPLAY=host.docker.internal:0.0 \
--env HTTP_PROXY=http://$hostIP:$hostPort \
--env HTTPS_PROXY=https://$hostIP:$hostPort \
--env http_proxy=http://$hostIP:$hostPort \
--env https_proxy=https://$hostIP:$hostPort \
svin2:melodic 

docker cp ~/.vimrc test_bus:/root

docker cp personal_config.sh test_bus:/root

docker exec -i test_bus /bin/bash -c ". /root/personal_config.sh"

docker exec -i -t test_bus /bin/bash -i -c "roslaunch okvis_ros svin_node_stereo_rig_water.launch;/bin/bash -i"
