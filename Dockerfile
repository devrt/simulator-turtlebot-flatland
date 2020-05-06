FROM ros:melodic-ros-core

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN source /opt/ros/melodic/setup.bash && \
    mkdir -p ~/catkin_ws/src && cd ~/catkin_ws/src && \
    catkin_init_workspace && \
    git clone --depth 1 https://github.com/avidbots/flatland.git && \
    git clone --depth 1 https://github.com/avidbots/turtlebot_flatland.git && \
    git clone --depth 1 -b melodic https://github.com/turtlebot/turtlebot.git && \
    git clone --depth 1 https://github.com/turtlebot/turtlebot_apps.git && \
    rm -r turtlebot_apps/turtlebot_actions && \
    rm -r turtlebot_apps/turtlebot_follower && \
    git clone --depth 1 -b melodic https://github.com/yujinrobot/kobuki.git && \
    cd .. && \
    rosdep update && apt-get update && \
    apt-get install -y supervisor && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/ros/melodic install && \
    cp -r src/turtlebot_flatland /opt/ros/melodic/share/ && \
    apt-get clean && rm -r ~/catkin_ws

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME /opt/ros/melodic/share/turtlebot_description

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
