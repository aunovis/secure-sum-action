#!/bin/bash

set -eou pipefail

# This is a tiny wrapper script that ensures that secure_sum is installed, and passes any arguments on.
# You can thus call it just as you would secure_sum.

args=("$@")

function get_latest_tag() {
    local repo=aunovis/secure_sum
    curl -s "https://api.github.com/repos/${repo}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'
}

if ! command -v secure_sum > /dev/null; then
    version=get_latest_tag
    echo "Installing AUNOVIS Secure Sum..."
    curl --proto '=https' --tlsv1.2 -LsSf "https://github.com/aunovis/secure_sum/releases/download/${version}/secure_sum-installer.sh" | sh
fi

secure_sum "${args[@]}"
