FROM kubeflownotebooks/jupyter:v0.3.83

USER root

ENV WORK_DIR=/opt
ENV ERL_TOP=$WORK_DIR/otp
ENV ELIXIR_TOP=$WORK_DIR/elixir
ENV IELIXIR_DIR=/ielixir
ENV PATH="${ERL_TOP}/target/bin:${ELIXIR_TOP}/bin:${PATH}"

# args - software versions
 # renovate: datasource=github-tags depName=erlang/otp versioning=loose
ARG ERL_VERSION=23.1.2
 # renovate: datasource=github-tags depName=elixir-lang/elixir versioning=semver
ARG ELIXIR_VERSION=v1.12.2
 # renovate: datasource=github-tags depName=pprzetacznik/IElixir versioning=semver
ARG IELIXIR_VERSION=v0.9.21

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq upgrade \
 && apt install -yq --no-install-recommends \
    autoconf \
    g++ \
    gcc \
    gcc-mingw-w64 \
    libncurses5-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    libssl-dev \
    libwxbase3.0-dev \
    libxslt-dev \
    libzmq3-dev \
    make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $WORK_DIR \
 && cd $WORK_DIR \
 && wget https://github.com/erlang/otp/archive/OTP-$ERL_VERSION.zip -O otp.zip \
 && unzip otp.zip -d $WORK_DIR \
 && mv $WORK_DIR/otp-OTP-$ERL_VERSION $ERL_TOP \
 && rm otp.zip

RUN cd $ERL_TOP \
 && ./otp_build autoconf \
 && ./configure --prefix=$ERL_TOP/target \
 && make \
 && make install \
 && cd $WORK_DIR \
 && wget https://github.com/elixir-lang/elixir/releases/download/$ELIXIR_VERSION/Precompiled.zip -O elixir.zip \
 && unzip elixir.zip -d $ELIXIR_TOP \
 && rm elixir.zip

RUN curl -fSL https://github.com/pprzetacznik/IElixir/archive/refs/tags/${IELIXIR_VERSION}.tar.gz -o /tmp/ielixir.tar.gz \
 && mkdir ${IELIXIR_DIR} \
 && tar -zxvf /tmp/ielixir.tar.gz -C ${IELIXIR_DIR} --strip-components=1 \
 && rm /tmp/ielixir.tar.gz \
 && cd ${IELIXIR_DIR} \
 && ls -alh \
 && mix local.hex --force \
 && mix local.rebar --force \
 && mix deps.get \
 && mix deps.compile \
 && ./install_script.sh \
 && chown -R ${NB_USER}:users ${ERL_TOP} \
 && chown -R ${NB_USER}:users ${ELIXIR_TOP} \
 && chown -R ${NB_USER}:users ${IELIXIR_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

USER $NB_UID
