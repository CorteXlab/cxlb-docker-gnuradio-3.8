FROM debian:stretch

RUN apt-get update && apt-get -y dist-upgrade

COPY cxlb-build-toolchain.git cxlb-build-toolchain.git

RUN apt-get -y install libfontconfig1-dev libxrender-dev libpulse-dev swig g++ automake autoconf libtool python-dev libfftw3-dev libcppunit-dev libboost-all-dev libusb-dev libusb-1.0-0-dev fort77 libsdl1.2-dev python-wxgtk3.0 libqt4-dev python-numpy ccache python-opengl libgsl0-dev python-cheetah python-lxml qt4-dev-tools libqwt5-qt4-dev libqwtplot3d-qt4-dev pyqt4-dev-tools python-qwt5-qt4 cmake git-core wget libxi-dev python-docutils gtk2-engines-pixbuf r-base-dev python-tk liborc-0.4-0 liborc-0.4-dev libasound2-dev python-gtk2 libportaudio2 portaudio19-dev ca-certificates xalan libpcap0.8-dev libmpfr4 libgmp10 expect fxload python-mako python3-mako libcomedi-dev liblog4cpp5-dev python-requests libitpp-dev libzmq5-dev python3-requests python3-numpy libgps-dev python-six python3-six python3-setuptools

RUN apt-get -y install nodejs python-jinja2 python-dateutil python-yaml python-packaging python-tornado python-futures python-pandas python-psutil python-pip
RUN pip install bokeh

RUN cxlb-build-toolchain.git/cxlb-build-toolchain -pcs "uhd rtl-sdr gnuradio gr-iqbal bladerf hackrf uhd-firmware fft-web gr-ofdm gr-bokehgui gr-osmosdr" cxlb_toolchain_build /cortexlab/toolchains/current
