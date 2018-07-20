FROM ubuntu:18.10

RUN apt-get update

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y tzdata \
  && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
  && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y git build-essential cmake libwxgtk3.0-dev wx3.0-headers libglew-dev \
  libglm-dev apt-utils libcurl4-openssl-dev libcairo2-dev libboost-all-dev autoconf automake \
  bison flex gcc git libtool make oce-draw liboce-foundation-dev liboce-ocaf-dev swig \
  libwxbase3.0-dev libssl-dev

RUN mkdir -p /opt \
  && cd /opt \
  && git clone --depth 1 -b master https://git.launchpad.net/kicad

RUN cd /opt/kicad/scripts \
  && chmod +x get_libngspice_so.sh \
  && ./get_libngspice_so.sh \
  && ./get_libngspice_so.sh install

RUN mkdir -p /opt/kicad/build/release \
  && cd /opt/kicad/build/release \
  && cmake -DCMAKE_BUILD_TYPE=Release -DKICAD_SCRIPTING_WXPYTHON=OFF ../../

RUN cd /opt/kicad/build/release \
  && make -j8

RUN cd /opt/kicad/build/release \
  && make install

CMD /usr/local/bin/kicad
