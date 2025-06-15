FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set working directory
WORKDIR /app

# Copy all files to the working directory
COPY . .

# Fix line endings and make entrypoint script executable
RUN sed -i 's/\r$//' scripts/entrypoint.sh
RUN chmod +x scripts/entrypoint.sh

# Prevent tzdata from prompting for input
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Argentina/Buenos_Aires

# Install Python, pip, etc.
RUN apt-get update && apt-get install -y python3-pip build-essential nano
RUN apt-get install -y python3-dev espeak-ng megatools curl openssl wget


RUN apt-get install -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# # Install tzdata with preset timezone
RUN apt-get update && apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get install -y \
    libssl-dev libffi-dev zlib1g-dev


RUN apt-get update && apt-get install -y libbz2-dev

# # Install and setup pyenv
RUN curl https://pyenv.run | bash
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

# Setup pyenv in shell configuration files
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

# Source bashrc to reload configuration and install Python
RUN bash -c 'source ~/.bashrc && eval "$(pyenv init -)" && pyenv install 3.10.0 && pyenv global 3.10.0'

# Setup Python environment
RUN cd src/python && \
    bash -c 'source ~/.bashrc && eval "$(pyenv init -)" && pyenv local 3.10.0 && python -m venv .venv' && \
    bash -c 'source ~/.bashrc && eval "$(pyenv init -)" && pyenv local 3.10.0 && . .venv/bin/activate && pip install --upgrade "pip<24"' && \
    bash -c 'source ~/.bashrc && eval "$(pyenv init -)" && pyenv local 3.10.0 && . .venv/bin/activate && pip install --upgrade wheel setuptools' && \
    bash -c 'source ~/.bashrc && eval "$(pyenv init -)" && pyenv local 3.10.0 && . .venv/bin/activate && pip install -e .'

# ENTRYPOINT ["scripts/entrypoint.sh"]

CMD ["/bin/bash"]
