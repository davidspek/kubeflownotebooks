FROM kubeflownotebooks/jupyter:v0.2.53

# install - requirements.txt
COPY --chown=jovyan:users cpu-requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt
