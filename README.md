cxlb-gnuradio-docker
====================

Docker image with a GNURadio toolchain

quick howto
-----------

- build the docker image:

    docker build --network=host -t cxlb-toolchain .

- create and start a container:

    docker run -dti --privileged --net=host cxlb-toolchain

- then connect to this container with ssh:

    ssh -Xp 2222 root@localhost
