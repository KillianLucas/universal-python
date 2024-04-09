#!/bin/bash
set -e

echo "Starting Open Interpreter installation..."
sleep 2
echo "This will take approximately 5 minutes..."
sleep 2

# Define pyenv location
pyenv_root="$HOME/.pyenv/bin/pyenv"

#!/bin/bash

echo "Starting installation of pyenv..."

INSTALL_URL="https://pyenv.run"

# Check if pyenv is already installed
if command -v pyenv &> /dev/null; then
    echo "pyenv is already installed."
else
    # Try to download and install pyenv using available commands
    if command -v curl &> /dev/null; then
        echo "Using curl to download pyenv..."
        curl -L "$INSTALL_URL" | sh
    elif command -v wget &> /dev/null; then
        echo "Using wget to download pyenv..."
        wget -O- "$INSTALL_URL" | sh
    elif command -v python &> /dev/null; then
        echo "Using Python to download pyenv..."
        python -c "import urllib.request; exec(urllib.request.urlopen('$INSTALL_URL').read())"
    elif command -v perl &> /dev/null; then
        echo "Using Perl to download pyenv..."
        perl -e "use LWP::Simple; exec(get('$INSTALL_URL'))"
    else
        echo "Neither curl nor wget is available."
        if [ "$(uname -s)" = "Linux" ]; then
            echo "Linux detected. Attempting to install sudo and curl..."

            # Check and install sudo if not present
            if ! command -v sudo &> /dev/null; then
                apt-get update && apt-get install -y sudo
            fi

            # Install curl using sudo
            if command -v sudo &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y curl
                if command -v curl &> /dev/null; then
                    echo "Using curl to download pyenv..."
                    curl -L "$INSTALL_URL" | sh
                else
                    echo "Failed to install curl. Installation of pyenv cannot proceed."
                fi
            else
                echo "Unable to install sudo. Manual installation required."
            fi
        else
            echo "Failed to install curl. Installation of pyenv cannot proceed."
        fi
    fi
fi

# Install Python and remember the version
python_version=3.11.9
$pyenv_root install $python_version --skip-existing
$pyenv_root shell $python_version

# Explicitly use the installed Python version for commands
installed_version=$($pyenv_root exec python --version)
echo "Installed Python version: $installed_version"
if [[ $installed_version != *"$python_version"* ]]; then
    echo "Python $python_version was not installed correctly. Please open an issue at https://github.com/openinterpreter/universal-python/."
    exit 1
fi

# Use the specific Python version to install open-interpreter
$pyenv_root exec python -m pip install open-interpreter

echo "Open Interpreter has been installed. Run the following command to use it:"
echo "interpreter"
