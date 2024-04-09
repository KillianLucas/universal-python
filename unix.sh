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
    echo "pyenv is not installed, proceeding with installation..."

    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo "curl is not available, checking for wget..."

        # Check for wget
        if ! command -v wget &> /dev/null; then
            echo "wget is also not available, attempting to install curl..."

            # Determine OS and install curl
            os_name="$(uname -s)"
            if [ "$os_name" = "Darwin" ]; then
                echo "Installing curl on macOS..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
                brew install curl
            elif [ "$os_name" = "Linux" ]; then
                echo "Installing curl on Linux..."
                sudo apt-get update && sudo apt-get install -y curl
            else
                echo "Unsupported OS, cannot install curl automatically."
                exit 1
            fi

            if ! command -v curl &> /dev/null; then
                echo "Failed to install curl. Please manually install curl or wget to continue."
                exit 1
            fi
        fi
    fi

    # Install pyenv using curl or wget
    if command -v curl &> /dev/null; then
        echo "Installing pyenv using curl..."
        curl -L https://pyenv.run | sh
    elif command -v wget &> /dev/null; then
        echo "Installing pyenv using wget..."
        wget -O- https://pyenv.run | sh
    fi
else
    echo "pyenv is already installed."
fi


# Initialize pyenv after installation
eval "$($pyenv_root init --path)"
eval "$($pyenv_root init -)"

# Install Python and remember the version
python_version=3.11.9
$pyenv_root install $python_version --skip-existing
$pyenv_root shell $python_version

# Explicitly use the installed Python version for commands
installed_version=$(pyenv exec python --version)
echo "Installed Python version: $installed_version"
if [[ $installed_version != *"$python_version"* ]]; then
    echo "Python $python_version was not installed correctly. Please open an issue at https://github.com/openinterpreter/universal-python/."
    exit 1
fi

# Use the specific Python version to install open-interpreter
$pyenv_root exec python -m pip install open-interpreter

echo "Open Interpreter has been installed. Run the following command to use it:"
echo "interpreter"
