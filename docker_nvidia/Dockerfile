ARG IMAGE="nvcr.io/nvidia/nvhpc:24.11-devel-cuda_multi-ubuntu22.04"

FROM ${IMAGE}

ARG JSON_FORTRAN_BRANCH="8.3.0"
ARG NEKO_BRANCH="develop"

# Update and Install basic Linux development tools
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libopenblas-dev \
    pkg-config \
    cmake \
    git \
    ca-certificates \
    build-essential \
  && apt-get clean

#ENV NVCOMPILERS=/opt/nvidia/hpc_sdk/Linux_x86_64/24.11/compilers/bin/
#ENV PATH=${PATH}:${NVCOMPILERS}

WORKDIR /tmp

# Install JSON-Fortran
RUN git clone --branch ${JSON_FORTRAN_BRANCH} https://github.com/jacobwilliams/json-fortran.git \
    && cd json-fortran \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/opt/json-fortran -DUSE_GNU_INSTALL_CONVENTION=ON -DCMAKE_Fortran_COMPILER=nvfortran ..\
    && make install

ENV PKG_CONFIG_PATH=/opt/json-fortran/lib/pkgconfig:$PKG_CONFIG_PATH \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/json-fortran/lib

WORKDIR /opt

RUN git clone https://github.com/Nek5000/gslib.git \
    && cd gslib \
    && make

RUN git clone -b ${NEKO_BRANCH} https://github.com/ExtremeFLOW/neko \
    && cd neko \
    && ./regen.sh \
    && ./configure \
        FCFLAGS="-O3" \
        CUDAFLAGS="-O2 -fPIE --gpu-architecture=sm_80" \
        NVCC=/opt/nvidia/hpc_sdk/Linux_x86_64/24.11/compilers/bin/nvcc \
        --prefix=/opt/neko \
        --with-cuda=/opt/nvidia/hpc_sdk/Linux_x86_64/24.11/cuda/ \
        --with-gslib=/opt/gslib/build/ \
    && make \
    && make install \
    && chmod -R 777 /opt/neko \
    && ln -s /opt/neko/examples/tgv/32768.nmsh /opt/neko/bench/tgv32/32768.nmsh

WORKDIR /opt/neko/bench

ENV PATH=$PATH:/opt/neko/bin \
    PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/neko/lib/pkgconfig \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/neko/lib  

CMD ["/bin/bash"]

