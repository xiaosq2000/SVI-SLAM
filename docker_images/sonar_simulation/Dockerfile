# syntax=docker/dockerfile:1
FROM osrf/ros:melodic-desktop-bionic
SHELL ["/bin/bash", "-c"]
RUN set -e \ 
	&& deps='gcc-5 g++-5 git cmake vim wget unzip dbus ruby ruby-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $deps ros-melodic-desktop-full=1.4.1-0* \
	&& rm -rf /var/lib/apt/lists/*

# Git configuration
RUN git config --global http.proxy $http_proxy \
    && git config --global https.proxy $https_proxy \
	&& git config --global user.email "xiaosq2000@gmail.com" \
	&& git config --global user.name "Shuqi Xiao"

# GCC version: from 7 to 5
# OpenCV-3.2.0: download, compile and install
RUN cd /usr/bin \
    && rm -f gcc g++ \
    && ln -s gcc-5 gcc \
    && ln -s g++-5 g++ \
    && cd /usr/src \
    && wget -O opencv.zip https://github.com/opencv/opencv/archive/3.2.0.zip \
    && unzip opencv.zip && rm opencv.zip \
    && cd /usr/src/opencv-3.2.0 && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-std=c++11" -DWITH_IPP=OFF ..  \
    && make \
    && make install \
    && rm -rf /usr/src/opencv-3.2.0

# GCC version: from 5 to 7
# Sonar Simulation: auto install
RUN cd /usr/bin \
	&& rm -r gcc g++ \
	&& ln -s gcc-7 gcc \
	&& ln -s g++-7 g++ \
	&& mkdir -p /usr/app/sonar_simulation

COPY bootstrap.sh /usr/app/sonar_simulation

WORKDIR /usr/app/sonar_simulation

RUN bash bootstrap.sh \
	&& echo "source /usr/app/sonar_simulation/env.sh" >> /root/.bashrc

CMD ["/bin/bash", "-i"]
