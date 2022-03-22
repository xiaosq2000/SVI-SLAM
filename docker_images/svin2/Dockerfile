# syntax=docker/dockerfile:1
FROM osrf/ros:melodic-desktop-bionic
SHELL ["/bin/bash", "-c"]
RUN set -e \ 
	&& deps='gcc-5 g++-5 git cmake vim wget unzip dbus libgoogle-glog-dev libgflags-dev libatlas-base-dev libsuitesparse-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $deps ros-melodic-desktop-full=1.4.1-0* \
	&& rm -rf /var/lib/apt/lists/*

# GCC version: from 7 to 5 
RUN cd /usr/bin \
    && rm -f gcc g++ \
	&& ln -s gcc-5 gcc \
	&& ln -s g++-5 g++

# Eigen-3.2.10: download, compile and install 
RUN cd /usr/src \
	&& wget https://gitlab.com/libeigen/eigen/-/archive/3.2.10/eigen-3.2.10.tar.gz \
	&& tar zxf eigen-3.2.10.tar.gz \
	&& rm eigen-3.2.10.tar.gz \
	&& mkdir -p /usr/src/eigen-3.2.10/build \
	&& cd /usr/src/eigen-3.2.10/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release .. \
	&& make install \
	&& rm -rf /usr/src/eigen-3.2.10

# Ceres-1.9.0: download, compile and install 
RUN	mkdir -p /usr/src/ceres/build \
	&& cd /usr/src/ceres \
	&& wget -O ceres.tar.gz https://ceres-solver.googlesource.com/ceres-solver/+archive/451e71c6b7c127ebfd29f0eb658543d512629a4e.tar.gz \
	&& tar zxf ceres.tar.gz \
	&& rm ceres.tar.gz \
	&& cd /usr/src/ceres/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release .. \
	&& make \
	&& make install \
	&& rm -rf /usr/src/ceres

# OpenCV-3.2.0: download, compile and install 
RUN cd /usr/src \
	&& wget -O opencv.zip https://github.com/opencv/opencv/archive/3.2.0.zip \
	&& unzip opencv.zip && rm opencv.zip \
	&& cd /usr/src/opencv-3.2.0 && mkdir build && cd build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-std=c++11" -DWITH_IPP=OFF ..  \
	&& make \
	&& make install \
	&& rm -rf /usr/src/opencv-3.2.0 

# Chores
RUN git config --global http.proxy $http_proxy \
	&& git config --global https.proxy $https_proxy \
	&& apt-get update \
	&& apt-get install -y ros-melodic-tf2-sensor-msgs \
	&& rm -rf /var/lib/apt/lists/*

# BRISK-2.0.3: download and compile
RUN cd /usr/src \
	&& git clone https://github.com/gwli/brisk \
	&& mkdir -p /usr/src/brisk/build \
	&& cd /usr/src/brisk/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release ..  \
	&& make \
	&& make install \
	&& rm -rf /usr/src/brisk

# SVIn2
RUN mkdir -p /usr/app/svin2_ws \
	&& cd /usr/app/svin2_ws \
	&& git clone https://github.com/sharminrahman/SVIn2 \
	&& mv /usr/app/svin2_ws/SVIn2 /usr/app/svin2_ws/src \
	&& cd /usr/app/svin2_ws/src \
	&& git clone https://github.com/quattrinili/imagenex831l \
	# OKVIS cmake settings
	&& sed -i '13s/OFF/ON/g' /usr/app/svin2_ws/src/okvis_ros/okvis/CMakeLists.txt \
	&& sed -i '15s/OFF/ON/g' /usr/app/svin2_ws/src/okvis_ros/okvis/CMakeLists.txt \
	&& sed -i '109i \ \ set(brisk_DIR "\/usr\/local\/lib\/CMake/brisk")' /usr/app/svin2_ws/src/okvis_ros/okvis/CMakeLists.txt \
	&& sed -i '22i set(brisk_DIR "\/usr\/local\/lib\/CMake\/brisk")' /usr/app/svin2_ws/src/pose-graph/CMakeLists.txt \
	&& grep -rl '\-march=native' /usr/app/svin2_ws/src | xargs sed -i 's/\-march=native//g' 
	# PCL, OpenCV, Flann namespace conflict solution
#	&& sed -i '370s/flann/::flann/g' /usr/include/flann/algorithms/nn_index.h \
#	&& sed -i '576s/flann/::flann/g' /usr/include/flann/algorithms/nn_index.h \
#	&& sed -i '197s/flann/::flann/g' /usr/include/flann/util/allocator.h \
#	&& sed -i '116s/flann/::flann/g' /usr/include/flann/algorithms/kdtree_single_index.h \
#	&& sed -i '251s/flann/::flann/g' /usr/include/flann/algorithms/kdtree_single_index.h \
#	&& sed -i '345s/flann/::flann/g' /usr/include/flann/algorithms/kdtree_single_index.h \
#	&& sed -i '25s/flann/::flann/g' /usr/include/flann/algorithms/center_chooser.h \
#	&& sed -i '44s/flann/::flann/g' /usr/include/flann/algorithms/center_chooser.h \
#	&& sed -i '129s/flann/::flann/g' /usr/include/flann/algorithms/all_indices.h \
#	&& sed -i '136s/flann/::flann/g' /usr/include/flann/algorithms/all_indices.h
WORKDIR /usr/app/svin2_ws
RUN source "/opt/ros/$ROS_DISTRO/setup.bash" \
	&& catkin_make 
	
# Modify roslaunch files
RUN	sed -i '4s/default\=".*"/default="\/usr\/app\/SVIn2-datasets\/bus_out_loop_w_cam_info.bag"/' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereo_rig_water.launch  \
	&& sed -i '27s/image_raw\/camera_info/image_raw\/cam_info/' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereo_rig_water.launch \
	&& sed -i '28s/image_raw\/camera_info/image_raw\/cam_info/' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereo_rig_water.launch \
	&& sed -i '52i \ \ <node type="rviz" name="rviz" pkg="rviz" args="-d $(find pose_graph)/rviz/svin2.rviz" />' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereo_rig_water.launch \
	&& sed -i '4s/default\=".*"/default="\/usr\/app\/SVIn2-datasets\/cave_loop_w_cam_info.bag"/' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereoRig2_water.launch \
	&& sed -i '29s/image_raw\/camera_info/image_raw\/cam_info/' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereoRig2_water.launch \
	&& sed -i '30s/image_raw\/camera_info/image_raw\/cam_info/' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereoRig2_water.launch \
	&& sed -i '54i \ \ <node type="rviz" name="rviz" pkg="rviz" args="-d $(find pose_graph)/rviz/svin2.rviz" />' /usr/app/svin2_ws/src/okvis_ros/launch/svin_node_stereoRig2_water.launch

CMD ["/bin/bash"]
