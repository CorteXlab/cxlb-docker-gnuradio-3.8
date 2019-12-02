cxlb-docker-gnuradio-3.8
========================

Docker image with a GNURadio-3.8 toolchain

quick howto
-----------

- build the docker image:

    docker build --network=host -t cxlb-gnuradio-3.8 .

- create and start a container:

    docker run -dti --net=host cxlb-gnuradio-3.8

- then connect to this container with ssh:

    ssh -Xp 2222 root@localhost
