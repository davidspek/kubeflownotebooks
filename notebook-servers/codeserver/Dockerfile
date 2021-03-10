FROM kubeflownotebooks/notebook-server-base:702da68

USER root

ENV CODE_VERSION 3.9.0

RUN echo "**** install node repo ****" && \
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_14.x focal main' \
    > /etc/apt/sources.list.d/nodesource.list && \
    curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb https://dl.yarnpkg.com/debian/ stable main' \
    > /etc/apt/sources.list.d/yarn.list && \
    echo "**** install build dependencies ****" && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    pkg-config && \
    echo "**** install runtime dependencies ****" && \
    apt-get install -y \
    jq \
    nano \
    net-tools \
    nodejs \
    yarn \
    python3-pip && \
    echo "**** install code-server ****" && \
    yarn config set network-timeout 600000 -g && \
    yarn --production --verbose --frozen-lockfile global add code-server@"$CODE_VERSION" && \
    yarn cache clean && \
    echo "**** clean up ****" && \
    apt-get purge --auto-remove -y \
    build-essential \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    pkg-config && \
    apt-get clean && \
    rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Create /jovyan dir and set user permissions for Jovyan to store files in home directory
# Change ownership of /etc/s6 to user jovyan
RUN mkdir -p /jovyan && \
    chown -R ${NB_USER}:users /jovyan

USER $NB_UID
WORKDIR /tmp

COPY --chown=jovyan:users requirements.txt .
RUN python3 -m pip install -r \
    requirements.txt --quiet --no-cache-dir \
    && rm -f requirements.txt

# Copy Init and service scripts into containers
# and ensure jovyan is user (so S6 doesn't need to run as root)
COPY --chown=jovyan:users root/ /

RUN cp -r $HOME/ /jovyan

WORKDIR $HOME
EXPOSE 8888

ENTRYPOINT ["/init"]
