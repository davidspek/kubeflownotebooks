FROM kubeflownotebooks/jupyter:v0.1.21

# install - requirements.txt
COPY --chown=jovyan:users cpu-requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir -f https://download.pytorch.org/whl/torch_stable.html \
 && rm -f /tmp/requirements.txt
