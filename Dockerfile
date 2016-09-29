From zlz0414/caffe:cuda8-cudnn5
MAINTAINER Aoxiao Zhong
RUN apt-get update -y && apt-get install build-essential -y
ADD apt-packages /tmp/apt-packages
RUN xargs -a /tmp/apt-packages apt-get install -y


ADD python-libs /tmp/python-libs
RUN pip install -r /tmp/python-libs

RUN useradd --create-home --home-dir /home/zax --shell /bin/bash zax
RUN adduser zax sudo

ADD run_jupyter.sh /home/zax
RUN chmod +x /home/zax/run_jupyter.sh
RUN chown zax /home/zax/run_jupyter.sh

RUN git clone https://github.com/openslide/openslide.git /home/zax/openslide
WORKDIR /home/zax/openslide
RUN autoreconf -i
RUN ./configure
RUN make
RUN make  install
RUN pip install --no-deps openslide-python
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/openslide.conf && ldconfig
RUN sudo ln /dev/null /dev/raw1394

EXPOSE 8888
RUN usermod -a -G sudo zax
RUN echo "zax ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER zax
RUN mkdir -p /home/zax/workspace
ENV HOME=/home/zax
ENV SHELL=/bin/bash
ENV USER=zax
VOLUME /home/zax/workspace
WORKDIR /home/zax/workspace


CMD ["/home/zax/run_jupyter.sh"]
