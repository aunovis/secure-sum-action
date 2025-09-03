#!/bin/bash

set -eou pipefail
set -x

# This is a tiny wrapper script that ensures that secure_sum is installed, and passes any arguments on.
# You can thus call it just as you would secure_sum.

args=("$@")

function get_latest_tag() {
    curl -s "https://api.github.com/repos/aunovis/secure_sum/releases/latest" | grep '"tag_name":' | cut -d '"' -f4
}

if ! command -v secure_sum > /dev/null; then
    version=$(get_latest_tag)
    echo "Installing AUNOVIS Secure Sum ${version}..."
    installer_url="https://github.com/aunovis/secure_sum/releases/download/${version}/secure_sum-installer.sh"
    echo "Using installer from URL: ${installer_url}"
    curl --proto '=https' --tlsv1.2 -LsSf "$installer_url" | sh
fi

secure_sum "${args[@]}"
