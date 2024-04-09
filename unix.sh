#!/bin/bash
set -e

echo "Starting Open Interpreter installation..."
sleep 2
echo "This will take approximately 5 minutes..."
sleep 2

# Define pyenv location and ensure it's in the PATH
pyenv_root="$HOME/.pyenv"
export PYENV_ROOT="$pyenv_root"
export PATH="$PYENV_ROOT/bin:$PATH"

# Install pyenv
if ! command -v pyenv &> /dev/null; then
    echo "Installing pyenv..."
    if command -v curl &> /dev/null; then
        curl -L https://pyenv.run | sh
    elif command -v wget &> /dev/null; then
        wget -O- https://pyenv.run | sh
    else
        echo "Neither curl nor wget is available. Please install one of these to continue."
        exit 1
    fi
fi

# Initialize pyenv after installation
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Install Python and remember the version
python_version=3.11.9
pyenv install $python_version --skip-existing

# Explicitly use the installed Python version for commands
installed_version=$(pyenv exec $python_version --version)
echo "Installed Python version: $installed_version"
if [[ $installed_version != *"$python_version"* ]]; then
    echo "Python $python_version was not installed correctly. Please open an issue at https://github.com/openinterpreter/universal-python/."
    exit 1
fi

# Use the specific Python version to install open-interpreter
pyenv exec $python_version -m pip install open-interpreter

echo "Open Interpreter has been installed. Run the following command to use it:"
echo "interpreter"
