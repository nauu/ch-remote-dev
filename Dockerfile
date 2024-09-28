FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="zhukai@apache.org"

# 更新包列表
RUN apt-get update

# 安装必要的软件包
RUN apt-get install -y git cmake ccache python3 ninja-build nasm yasm gawk lsb-release wget
RUN apt-get install -y software-properties-common gnupg
RUN apt-get install -y gdb gdbserver
RUN apt-get install -y openssh-server
RUN apt-get clean

RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" 

ENV CC=clang-18
ENV CXX=clang++-18
ENV LC_ALL C.UTF-8

# 添加用户
RUN useradd -m ch-builder && \
    echo "ch-builder:ch-builder" | chpasswd && \
    echo "ch-builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN chmod 777 /tmp

# 设置 SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# 暴露 SSH 端口
EXPOSE 22

# 启动 SSHD
CMD ["/usr/sbin/sshd", "-D"]
