FROM debian:buster

ENV APT="apt-get -y"

RUN ${APT} update && ${APT} dist-upgrade

WORKDIR /root

COPY cxlb-build-toolchain.git cxlb-build-toolchain.git

ENV BUILD="cxlb-build-toolchain.git/cxlb-build-toolchain -as"
ENV PARMS="cxlb_toolchain_build /cortexlab/toolchains/current"

# build toolchain (separate build steps to benefit from docker cache in case of build issues on a specific module)

RUN ${BUILD} uhd ${PARMS}
RUN ${BUILD} uhd-firmware ${PARMS}
# RUN ${BUILD} rtl-sdr ${PARMS}
# RUN ${BUILD} bladerf ${PARMS}
# RUN ${BUILD} hackrf ${PARMS}
RUN ${BUILD} gnuradio ${PARMS}
# RUN ${BUILD} pluto ${PARMS}
RUN ${BUILD} gr-bokehgui ${PARMS}
RUN ${BUILD} gr-iqbal ${PARMS}
# RUN ${BUILD} gr-ofdm ${PARMS}
# RUN ${BUILD} gr-osmosdr ${PARMS}
# RUN ${BUILD} fft-web ${PARMS}
# RUN ${BUILD} xilinx ${PARMS}
# RUN ${BUILD} xilinx-usb-driver ${PARMS}
# RUN ${BUILD} digilent ${PARMS}
# RUN ${BUILD} nutaq ${PARMS}
# RUN ${BUILD} gr-cortexlab ${PARMS}

# activate toolchain configuration
RUN /cortexlab/toolchains/current/bin/cxlb-toolchain-system-conf
RUN echo source /cortexlab/toolchains/current/bin/cxlb-toolchain-user-conf >> /etc/profile

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
