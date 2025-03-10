FROM        --platform=linux/amd64 ubuntu:22.04

LABEL       author="Evil Factory" maintainer="https://github.com/evilfactory"

LABEL       org.opencontainers.image.source="https://github.com/evilfactory/BTPterodactylDockerImage"
LABEL       org.opencontainers.image.licenses=LGPL

ENV         DEBIAN_FRONTEND=noninteractive 

RUN         dpkg --add-architecture i386 \
			&& apt update \
			&& apt upgrade -y \
			&& apt -y install gpg tar curl git wget unzip software-properties-common python3 python3-pip gcc g++ lib32gcc-s1 libgcc1 libcurl4-gnutls-dev:i386 libssl-dev:i386 libssl-dev libcurl4:i386 lib32tinfo6 libtinfo6:i386 lib32z1 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 iproute2 gdb libsdl1.2debian libfontconfig1 telnet net-tools netcat tzdata  libtinfo6:i386 libtbb2:i386 libtinfo5:i386 libcurl4-gnutls-dev:i386 libcurl4:i386 libncurses5:i386 libcurl3-gnutls:i386 faketime:i386 libtbb2:i386 \
			&& apt -y install lib32tinfo6 lib32stdc++6 lib32z1 libtbb2 libtinfo5 libstdc++6 readline-common libncursesw5 libfontconfig1 libnss-wrapper gettext-base libc++-dev libc6-i386 libcurl4 libc6 libc6:i386 libssl3 libssl3:i386 libc6 libc6:i386 xvfb libxml2-utils \
			&& add-apt-repository ppa:dotnet/backports \
			&& mkdir -pm755 /etc/apt/keyrings \
			&& wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key - \
			&& wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
			&& apt update \
			&& apt install -y --install-recommends winehq-staging \
			&& apt install -y dotnet-sdk-8.0

RUN			apt-get install -y locales locales-all
ENV			LC_ALL en_US.UTF-8
ENV			LANG en_US.UTF-8
ENV			LANGUAGE en_US.UTF-8

RUN 		useradd -d /home/container -m container

## install rcon
RUN 		cd /tmp/ \
			&& curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.2/rcon-0.10.2-amd64_linux.tar.gz > rcon.tar.gz \
			&& tar xvf rcon.tar.gz \
			&& mv rcon-0.10.2-amd64_linux/rcon /usr/local/bin/

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
