FROM kubeflownotebooks/jupyter:v0.3.83

USER root

# args - software versions
 # renovate: datasource=github-tags depName=golang/go versioning=loose
ARG GO_VERSION=go1.16.5
 # renovate: datasource=github-tags depName=gopherdata/gophernotes versioning=semver
ARG GOPHERNOTES_VERSION=v0.7.3

ENV GO_DIR /go
ENV GOPATH ${GO_DIR}
ENV GO111MODULE=on
ENV PATH "${GO_DIR}/bin:${PATH}"

# install - Go and Gophernotes dependencies
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq upgrade \
 && apt-get -yq install --no-install-recommends \
    gcc \
    musl-dev \
    pkg-config \
    python3-zmq \
    libzmq3-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install Go
RUN curl -sL "https://golang.org/dl/${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
 && mkdir -p ${GO_DIR} \
 && tar -xzf /tmp/go.tar.gz -C ${GO_DIR} --strip-components=1 \
 && rm /tmp/go.tar.gz \
 && chown -R ${NB_USER}:users ${GO_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# install gophernotes
RUN curl -sL "https://github.com/gopherdata/gophernotes/archive/refs/tags/${GOPHERNOTES_VERSION}.tar.gz" -o /tmp/gophernotes.tar.gz \
 && mkdir -p /go/src/github.com/gopherdata/gophernotes/ \
 && tar -xzf /tmp/gophernotes.tar.gz -C ${GO_DIR}/src/github.com/gopherdata/gophernotes/ --strip-components=1 \
 && cd ${GO_DIR}/src/github.com/gopherdata/gophernotes/ \
 && go install . \
 && cp ${GO_DIR}/bin/gophernotes /usr/local/bin/ \
 && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
 && cp -r ${GO_DIR}/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes \
 && chown -R ${NB_USER}:users ${GO_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

USER $NB_UID
