FROM osrf/ros:humble-desktop-full
ARG ROS_DISTRO=humble
ENV DEBIAN_FRONTEND noninteractive
ARG USER_ID
ARG GROUP_ID

ARG USER=developer
ARG GROUP=domain_users

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    groupadd -g ${GROUP_ID} $GROUP && \
    useradd -m -s /bin/bash -l -u ${USER_ID} -g $GROUP $USER \
;fi

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install -y \
    python3-pip \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-gazebo-ros-pkgs

RUN apt-get update && apt-get install -y git \
    && apt-get install -y nano \
    && apt-get install -y tmux \
    && apt-get install -y bash-completion \
    && apt-get install -y wget \
    && apt-get install -y libgstreamer-plugins-base1.0-dev

RUN sudo usermod -a -G dialout $USER \
    && apt-get remove modemmanager -y \
    && apt update \
    && apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y \
    && apt install libqt5gui5 -y \
    && apt install libfuse2 -y \
    && apt install fuse -y

ENV HOME /home/$USER
ENV SHELL /bin/bash

WORKDIR /home/$USER

# Source the ROS distro
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
RUN echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc
RUN echo "export _colcon_cd_root=/opt/ros/$ROS_DISTRO/" >> ~/.bashrc

RUN echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

# switch to user to perform actions
USER $USER

RUN mkdir -p tools
WORKDIR /home/$USER/tools
RUN wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage \
    && chmod +x ./QGroundControl.AppImage

WORKDIR /home/$USER
RUN mkdir -p px4_offboard_ws/src

RUN mkdir -p autopilot/main
WORKDIR /home/$USER/autopilot/main
RUN git clone https://github.com/PX4/PX4-Autopilot.git --recursive
RUN bash ./PX4-Autopilot/Tools/setup/ubuntu.sh --no-sim-tools --no-nuttx

