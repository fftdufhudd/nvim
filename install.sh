#!/bin/bash

echo "Starting dependencies installation..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/arch-release ]; then
        echo "Detected Arch Linux"
        echo "Starting installation..."
        sudo pacman -S --needed neovim git base-devel ripgrep fd nodejs npm unzip clang llvm
    elif [ -f /etc/debian_version ]; then
        echo "Detected Debian/Ubuntu"
        echo "Starting installation..."
        sudo apt update && sudo apt install -y neovim git build-essential ripgrep findutils nodejs npm unzip clang llvm
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    if ! command -v brew &> /dev/null; then
        echo "Błąd: Zainstaluj Homebrew (https://brew.sh/)"
        exit
    fi
    echo "Starting installation..."
    brew install neovim git ripgrep fd nodejs npm unzip llvm
fi

# Tworzenie folderu na historię zmian (undodir)
mkdir -p ~/.vim/undodir

echo "Dependencies installed! Now start Neovim and wait for the installation to finish."
