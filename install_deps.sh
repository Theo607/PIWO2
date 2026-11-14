#!/usr/bin/env bash
set -e

echo "==> Checking for root privileges to install packages..."
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges to run pacman."
fi

echo "==> Installing STM32 bare-metal dependencies via pacman..."
sudo pacman -S --needed \
    arm-none-eabi-gcc \
    arm-none-eabi-binutils \
    make \
    libopencm3 \
    stlink

echo "==> All required dependencies are successfully installed!"
