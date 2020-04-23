FROM ubuntu:latest

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

WORKDIR /usr/local/src

ENV OMPI_MCA_btl_vader_single_copy_mechanism "none"

## Quantum espresso installation
RUN curl https://github.com/QEF/q-e/releases/download/qe-6.5/qe-6.5-ReleasePack.tgz -O -L
RUN tar xvf qe-6.5-ReleasePack.tgz \
    && rm -rf qe-6.5-ReleasePack.tgz
RUN cd qe-6.5 \
    && ./configure \
    && make pw \
    && make pp \
    && make ph \
    && make ld1 \
    && make upf \
    && make install
COPY res/environment_variables ./qe-6.5

WORKDIR /root

## Pseudo-potential preparation
RUN curl https://people.sissa.it/dalcorso/pslibrary/pslibrary.1.0.0.tar.gz -O -L
RUN tar xvf pslibrary.1.0.0.tar.gz \
    && rm -rf pslibrary.1.0.0.tar.gz
COPY res/make_ps ./pslibrary.1.0.0
RUN cd pslibrary.1.0.0 \
    && sed -i -e "s#/path_to_quantum_espresso/#/usr/local/src/qe-6.5#g" ./QE_path \
    && ./make_all_ps

RUN curl http://www.quantum-simulation.org/potentials/sg15_oncv/sg15_oncv_upf_2020-02-06.tar.gz -O -L
RUN mkdir sg15_oncv_upf \
    && tar xvf sg15_oncv_upf_2020-02-06.tar.gz -C sg15_oncv_upf \
    && rm -rf sg15_oncv_upf_2020-02-06.tar.gz

## Python installation
RUN curl https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz -O -L \
    && tar zxf Python-3.8.0.tgz \
    && rm -rf Python-3.8.0.tgz \
    && cd Python-3.8.0 \
    && ./configure \
    && make \
    && make altinstall \
    && ln -s /usr/local/bin/python3.8 /usr/bin/python \
    && ln -s /usr/local/bin/pip3.8 /usr/bin/pip
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
        jupyter \
        jupyterlab \
        joblib \
        Cython
RUN jupyter notebook --generate-config \
    && echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.port = 8889" >> /root/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py
