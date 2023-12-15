FROM docker.io/library/ubuntu
RUN apt update -y && apt upgrade -y
RUN apt install -y qt5dxcb-plugin
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:mozillateam/ppa
RUN printf "\
Package: firefox*\n\
Pin: release o=LP-PPA-mozillateam\n\
Pin-Priority: 1001\n\
" | tee /etc/apt/preferences.d/Mozilla
RUN apt install -y firefox
