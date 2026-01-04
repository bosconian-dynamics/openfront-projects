#!/bin/bash
# Bootstrap script for OpenFront Projects Monorepo
# This script installs PowerShell if needed, then delegates to setup.ps1

set -e

FORCE_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-f|--force]"
            echo "  -f, --force    Run non-interactively without confirmation"
            exit 1
            ;;
    esac
done

echo "======================================"
echo "OpenFront Projects - Bootstrap"
echo "======================================"
echo ""

# Check if PowerShell is already installed
if command -v pwsh &> /dev/null; then
    PWSH_VERSION=$(pwsh --version)
    echo "✓ PowerShell is already installed: $PWSH_VERSION"
    echo ""
    echo "Delegating to setup.ps1..."
    echo ""
    exec pwsh -File ./setup.ps1
fi

echo "PowerShell (pwsh) is not installed."
echo ""
echo "This repository uses PowerShell for setup scripts."
echo "PowerShell Core is cross-platform and works on Linux, macOS, and Windows."
echo ""

# Ask for confirmation unless in force mode
if [ "$FORCE_MODE" = false ]; then
    read -p "Would you like to install PowerShell now? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "PowerShell installation declined."
        echo ""
        echo "To install PowerShell manually, visit:"
        echo "  https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell"
        echo ""
        echo "After installing PowerShell, run this script again or execute:"
        echo "  pwsh -File ./setup.ps1"
        exit 0
    fi
fi

echo ""
echo "Installing PowerShell..."
echo ""

# Detect OS and package manager
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID="$ID"
    OS_VERSION_ID="$VERSION_ID"
else
    echo "❌ Cannot detect OS distribution"
    echo "Please install PowerShell manually from:"
    echo "  https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell"
    exit 1
fi

install_powershell_alpine() {
    echo "Detected Alpine Linux - using apk..."
    apk add --no-cache \
        ca-certificates \
        less \
        ncurses-terminfo-base \
        krb5-libs \
        libgcc \
        libintl \
        libssl1.1 \
        libstdc++ \
        tzdata \
        userspace-rcu \
        zlib \
        icu-libs \
        curl
    
    apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust
    
    # Download and install PowerShell
    curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/powershell-7.4.0-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz
    mkdir -p /opt/microsoft/powershell/7
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
    chmod +x /opt/microsoft/powershell/7/pwsh
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
    rm /tmp/powershell.tar.gz
}

install_powershell_debian_ubuntu() {
    echo "Detected Debian/Ubuntu-based system - using apt..."
    
    # Install prerequisites
    apt-get update
    apt-get install -y wget apt-transport-https software-properties-common
    
    # Download and register Microsoft repository
    UBUNTU_CODENAME=""
    case "$OS_VERSION_ID" in
        20.04)
            UBUNTU_CODENAME="focal"
            ;;
        22.04)
            UBUNTU_CODENAME="jammy"
            ;;
        24.04)
            UBUNTU_CODENAME="noble"
            ;;
        *)
            # For Debian or other versions, try to detect
            if [ "$OS_ID" = "debian" ]; then
                case "$OS_VERSION_ID" in
                    11)
                        UBUNTU_CODENAME="bullseye"
                        ;;
                    12)
                        UBUNTU_CODENAME="bookworm"
                        ;;
                esac
            fi
            ;;
    esac
    
    if [ -n "$UBUNTU_CODENAME" ]; then
        wget -q "https://packages.microsoft.com/config/$OS_ID/$OS_VERSION_ID/packages-microsoft-prod.deb"
        dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb
        apt-get update
        apt-get install -y powershell
    else
        echo "Warning: Could not detect specific version, attempting generic install..."
        apt-get install -y powershell || {
            echo "❌ Failed to install PowerShell via apt"
            echo "Please install PowerShell manually from:"
            echo "  https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
            exit 1
        }
    fi
}

# Try to install based on available package managers
if command -v apk &> /dev/null; then
    install_powershell_alpine
elif command -v apt-get &> /dev/null; then
    install_powershell_debian_ubuntu
elif command -v apt &> /dev/null; then
    # Fallback to apt if apt-get is not available
    apt update
    apt install -y wget apt-transport-https software-properties-common
    wget -q "https://packages.microsoft.com/config/$OS_ID/$OS_VERSION_ID/packages-microsoft-prod.deb"
    dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    apt update
    apt install -y powershell
elif command -v dpkg &> /dev/null; then
    # Last resort: try dpkg directly
    echo "Using dpkg to install PowerShell..."
    wget -q "https://packages.microsoft.com/config/$OS_ID/$OS_VERSION_ID/packages-microsoft-prod.deb"
    dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    echo "❌ dpkg alone cannot resolve dependencies."
    echo "Please use apt-get or apt to complete the installation:"
    echo "  apt-get update && apt-get install -y powershell"
    exit 1
else
    echo "❌ No supported package manager found (apk, apt-get, apt, dpkg)"
    echo "Please install PowerShell manually from:"
    echo "  https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell"
    exit 1
fi

# Verify PowerShell installation
if command -v pwsh &> /dev/null; then
    PWSH_VERSION=$(pwsh --version)
    echo ""
    echo "✓ PowerShell installed successfully: $PWSH_VERSION"
    echo ""
    echo "Delegating to setup.ps1..."
    echo ""
    exec pwsh -File ./setup.ps1
else
    echo ""
    echo "❌ PowerShell installation completed but pwsh command not found"
    echo "Please check your installation or install manually from:"
    echo "  https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell"
    exit 1
fi
