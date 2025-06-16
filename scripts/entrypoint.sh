#!/bin/bash

# Install and setup pyenv
curl https://pyenv.run | bash
export PYENV_ROOT="/root/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Setup pyenv in shell configuration files
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

# Source bashrc to reload configuration and install Python
source ~/.bashrc
pyenv install 3.10.0
pyenv local 3.10.0

# Setup Python environment
cd src/python
python -m venv .venv
source .venv/bin/activate
pip install --upgrade "pip<24"
pip install --upgrade wheel setuptools
pip install -e .
echo "Environment is ready!"
