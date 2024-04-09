#!/bin/bash
set -e

echo "Starting Open Interpreter installation..."
sleep 2
echo "This will take approximately 5 minutes..."
sleep 2

# Define pyenv location
pyenv_root="$HOME/.pyenv/bin/pyenv"

# Check if pyenv is installed
if ! command -v $pyenv_root &> /dev/null
then
    echo "pyenv is not installed. Installing now..."
    curl https://pyenv.run | zsh #zsh is the default shell for mac now. Changing this may cause install to fail 
else
    echo "pyenv is already installed."
fi

# Install Python 3.12 if not already installed
$pyenv_root install 3.12 --skip-existing

# Use pyenv exec to run pip install with the installed Python version
$pyenv_root exec python3.12 -m pip install open-interpreter

echo ""
echo "Open Interpreter has been installed. Run the following command to use it: "
echo ""
echo "interpreter"