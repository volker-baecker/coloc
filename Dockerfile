FROM debian:jessie

RUN apt-get update
RUN apt-get install -y curl
# Install Xvfb (X virtual frame buffer) 
RUN apt-get install -y xvfb
RUN apt-get install -y libx11-dev libxtst-dev libXrender-dev

# add webupd8 repository
RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    \
    \
    echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
    \
    \
    echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
rm -rf /var/lib/apt/lists/*

# Define maintainer.
MAINTAINER Mark Hiner <hinerm@gmail.com>

# Define working directory.
WORKDIR /fiji

# Install Fiji.
RUN \
      curl -O http://update.imagej.net/bootstrap.js && \
      jrunscript bootstrap.js update-force-pristine

# Add fiji to the PATH
ENV PATH $PATH:/fiji

RUN cd plugins && wget -O jacop_.jar http://imagejdocu.tudor.lu/lib/exe/fetch.php?media=plugin:analysis:jacop_2.0:just_another_colocalization_plugin:jacop_.jar

RUN mkdir /fiji/data

RUN cd /fiji/macros && wget -O coloc.ijm https://gist.githubusercontent.com/volker-baecker/6de91df9af79fd252436e8016f282adb/raw/92cc251927f6e76011f9ebfbeb2f8af3844bf489/coloc.ijm
RUN cd /fiji && wget -O run-coloc.sh https://gist.githubusercontent.com/volker-baecker/42e720f3174b52b583f32299867d4c6b/raw/57a843e81086e6313e865786cc94de91993a4d32/run-coloc.sh && chmod a+x run-coloc.sh

RUN cd /fiji/macros && wget -O metrics.ijm https://gist.githubusercontent.com/volker-baecker/f298621247e62011ba3913d70af9ffed/raw/0a9803e955ba3adfae608adf78b09de1e1f540c3/metrics.ijm
RUN cd /fiji && wget -O run-metrics.sh https://gist.githubusercontent.com/volker-baecker/1a273b28c62d010ab5c266d71b89ba64/raw/8b161bf719559bbac12dfd3620f4dd4542a0a99d/run-metrics.sh && chmod a+x run-metrics.sh

# Define default command.
CMD ["fiji-linux64"]
