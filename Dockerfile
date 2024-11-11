FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="zhukai@apache.org"

RUN apt-get update

RUN apt-get install -y git cmake ccache python3 ninja-build nasm yasm gawk lsb-release wget
RUN apt-get install -y software-properties-common gnupg iputils-ping
RUN apt-get install -y gdb gdbserver
RUN apt-get install -y openssh-server
RUN apt-get install -y net-tools lsof
RUN apt-get install -y python3-pip libpq-dev zlib1g-dev libcrypto++-dev libssl-dev libkrb5-dev python3-dev iptables
RUN apt-get install -y \
    ca-certificates \
    curl vim\
    gnupg \
    lsb-release && \
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean


RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" 

ENV CC=clang-18
ENV CXX=clang++-18
ENV LC_ALL C.UTF-8

RUN pip3 install --no-cache-dir \
    PyMySQL \
    avro \
    cassandra-driver \
    confluent-kafka \
    dicttoxml \
    docker \
    docker-compose \
    grpcio \
    grpcio-tools \
    kafka-python \
    kazoo \
    minio \
    lz4 \
    protobuf \
    psycopg2-binary \
    pymongo \
    pytz \
    pytest \
    pytest-timeout \
    redis \
    tzlocal==2.1 \
    urllib3 \
    requests-kerberos \
    dict2xml \
    hypothesis \
    pyhdfs \
    pika \
    nats-py \
    jinja2


RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd
RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]