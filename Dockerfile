FROM debian:buster

ENV APT="apt-get -y"

RUN ${APT} update && ${APT} dist-upgrade

WORKDIR /root

COPY cxlb-build-toolchain.git cxlb-build-toolchain.git
# set an empty password for root
RUN sed -i -e 's%root:\*:%root:$6$fEFUE2YaNmTEH51Z$1xRO8/ytEYIo10ajp4NZSsoxhCe1oPLIyjDjqSOujaPZXFQxSSxu8LDHNwbPiLSjc.8u0Y0wEqYkBEEc5/QN5/:%' /etc/shadow

# install ssh server, listening on port 2222
RUN ${APT} install openssh-server
RUN sed -i 's/^#\?[[:space:]]*Port 22$/Port 2222/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?[[:space:]]*PermitEmptyPasswords no$/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?[[:space:]]*PermitRootLogin.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /run/sshd
RUN chmod 755 /run/sshd
CMD [ "/usr/sbin/sshd", "-D" ]

ENV BUILD="cxlb-build-toolchain.git/cxlb-build-toolchain -y /usr/bin/python3 -as"
ENV PARMS="cxlb_toolchain_build /cortexlab/toolchains/current"

# build toolchain (separate build steps to benefit from docker cache in case of build issues on a specific module)

RUN ${APT} install udev

RUN ${BUILD} uhd=master ${PARMS}
RUN ${BUILD} uhd-firmware ${PARMS}
RUN ${BUILD} gnuradio=maint-3.8 ${PARMS}
RUN ${BUILD} gr-bokehgui=master ${PARMS}
RUN ${BUILD} gr-iqbal=maint-3.8 ${PARMS}
# RUN ${BUILD} fft-web ${PARMS}

# activate toolchain configuration
RUN /cortexlab/toolchains/current/bin/cxlb-toolchain-system-conf
RUN echo source /cortexlab/toolchains/current/bin/cxlb-toolchain-user-conf >> /etc/profile

# remove toolchain sources
#RUN rm -rf cxlb_toolchain_build/
