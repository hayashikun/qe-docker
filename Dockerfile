FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y \
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
                        libpng-dev \
                        libfreetype6-dev

WORKDIR /usr/local/src

## Quantum espresso installation
RUN curl https://github.com/QEF/q-e/releases/download/qe-6.5/qe-6.5-ReleasePack.tgz -O -L
# COPY res/qe-6.5-ReleasePack.tgz .
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
# COPY res/pslibrary.1.0.0.tar.gz .
RUN tar xvf pslibrary.1.0.0.tar.gz \
    && rm -rf pslibrary.1.0.0.tar.gz
COPY res/make_ps ./pslibrary.1.0.0
RUN cd pslibrary.1.0.0 \
    && sed -i -e "s#/path_to_quantum_espresso/#/usr/local/src/qe-6.5#g" ./QE_path \
    && ./make_all_ps

RUN curl http://www.quantum-simulation.org/potentials/sg15_oncv/sg15_oncv_upf_2020-02-06.tar.gz -O -L
# COPY res/sg15_oncv_upf_2020-02-06.tar.gz .
RUN mkdir sg15_oncv_upf \
    && tar xvf sg15_oncv_upf_2020-02-06.tar.gz -C sg15_oncv_upf \
    && rm -rf sg15_oncv_upf_2020-02-06.tar.gz

## Python installation
RUN curl https://pyenv.run | bash
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc
RUN pyenv install 3.8.0
RUN pyenv global 3.8.0
RUN eval "$(pyenv init -)" \
    && pip install pip -U \
    && pip install \
        numpy \
        scipy \
        matplotlib \
        sympy \
        pandas \
        tqdm \
        Pillow \
        ase \
        jupyter

COPY res/entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
