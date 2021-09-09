FROM ubuntu:latest

ENV DEBIAN_FRONTEND "noninteractive"
RUN apt-get update \
    && apt-get install -y \
        git \
        vim \
        curl \
        build-essential \
        gcc \
        gfortran \
        gnuplot \
        openmpi-doc \
        openmpi-bin \
        libopenmpi-dev \
        openssl \
        libssl-dev \
        libreadline-dev \
        ncurses-dev \
        bzip2 \
        zlib1g-dev \
        libbz2-dev \
        libffi-dev \
        libopenblas-dev \
        liblapack-dev \
        libsqlite3-dev \
        liblzma-dev \
        libpng-dev \
        libfreetype6-dev

ENV OMPI_MCA_btl_vader_single_copy_mechanism "none"
ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1

WORKDIR /usr/local/src

## Python installation
RUN curl https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz -O -L \
    && tar zxf Python-3.9.4.tgz \
    && rm -rf Python-3.9.4.tgz \
    && cd Python-3.9.4 \
    && ./configure \
    && make \
    && make altinstall \
    && ln -s /usr/local/bin/python3.9 /usr/local/bin/python \
    && ln -s /usr/local/bin/pip3.9 /usr/local/bin/pip
ENV PYTHONIOENCODING "utf-8"
RUN pip install pip -U \
    && pip install \
        numpy \
        scipy \
        matplotlib \
        sympy \
        pandas \
        tqdm \
        Pillow \
        ase \
        joblib \
        Cython \
        fire

## Quantum espresso installation
RUN curl https://github.com/QEF/q-e/releases/download/qe-6.8/qe-6.8-ReleasePack.tgz -O -L
RUN tar xvf qe-6.8-ReleasePack.tgz \
    && rm -rf qe-6.8-ReleasePack.tgz
RUN cd qe-6.8 \
    && ./configure \
    && make all \
    && make install
COPY res/environment_variables ./qe-6.8


WORKDIR /root

## Pseudo-potential preparation
COPY res/pslibrary.1.0.0.tar.bz2 ./
RUN tar jxvf pslibrary.1.0.0.tar.bz2 \
    && rm -rf pslibrary.1.0.0.tar.bz2

RUN curl http://www.quantum-simulation.org/potentials/sg15_oncv/sg15_oncv_upf_2020-02-06.tar.gz -O -L
RUN mkdir sg15_oncv_upf \
    && tar xvf sg15_oncv_upf_2020-02-06.tar.gz -C sg15_oncv_upf \
    && rm -rf sg15_oncv_upf_2020-02-06.tar.gz

