#!/bin/bash

docker container rm -f test_multibeam

docker run -i -d \
--name test_multibeam \
--rm \
--volume /tmp/.X11-unix:/tmp/.X11-unix. \
--env DISPLAY=host.docker.internal:0.0 \
--env HTTP_PROXY=http://$hostIP:$hostPort \
--env HTTPS_PROXY=https://$hostIP:$hostPort \
--env http_proxy=http://$hostIP:$hostPort \
--env https_proxy=https://$hostIP:$hostPort \
sonar_simulation

docker cp ~/.vimrc test_multibeam:/root

docker exec -i -t test_multibeam /bin/bash -i -c \
"/etc/init.d/omniorb4-nameserver stop && rm -f /var/lib/omniorb/* && /etc/init.d/omniorb4-nameserver start &&
ruby /usr/app/sonar_simulation/simulation/examples/sonar_multibeam-run.rb; /bin/bash"
