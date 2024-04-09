$ErrorActionPreference = 'Stop'

Write-Output "Starting Open Interpreter installation..."
Start-Sleep -Seconds 2
Write-Output "This will take approximately 5 minutes..."
Start-Sleep -Seconds 2

# Check if Git is installed
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "Git is already installed."
} else {
    # Check if Chocolatey is installed
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        # Install Chocolatey
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }

    # Install Git using Chocolatey
    choco install git.install -y
}

# Check if pyenv is installed
$pyenvRoot = "${env:USERPROFILE}\.pyenv\pyenv-win"
$pyenvBin = "$pyenvRoot\bin\pyenv.bat"
if (!(Get-Command $pyenvBin -ErrorAction SilentlyContinue)) {
    # Download and install pyenv-win
    $pyenvInstaller = "install-pyenv-win.ps1"
    $pyenvInstallUrl = "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1"
    Invoke-WebRequest -Uri $pyenvInstallUrl -OutFile $pyenvInstaller
    & powershell -ExecutionPolicy Bypass -File $pyenvInstaller
    Remove-Item -Path $pyenvInstaller
}

# Check if Rust is installed
if (!(Get-Command rustc -ErrorAction SilentlyContinue)) {
    Write-Output "Rust is not installed. Installing now..."
    $rustupUrl = "https://win.rustup.rs/x86_64"
    $rustupFile = "rustup-init.exe"
    Invoke-WebRequest -Uri $rustupUrl -OutFile $rustupFile
    Start-Process -FilePath .\$rustupFile -ArgumentList '-y', '--default-toolchain', 'stable' -Wait
    Remove-Item -Path .\$rustupFile
}

# Use the full path to pyenv to install Python
& "$pyenvBin" init
& "$pyenvBin" install 3.11.7 --skip-existing

# Turn on this Python and install OI
$env:PYENV_VERSION="3.11.7"
& pip install open-interpreter

# Get us out of this vers of Python (which was just used to setup OI, which should stay in that vers of Python...?)
Remove-Item Env:\PYENV_VERSION

Write-Output ""
Write-Output "Open Interpreter has been installed. Run the following command to use it: "
Write-Output ""
Write-Output "interpreter"