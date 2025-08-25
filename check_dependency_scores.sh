#!/bin/bash

set -eou pipefail

function get_latest_tag() {
    local repo=aunovis/secure_sum
    curl -s "https://api.github.com/repos/${repo}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'
}

if ! command -v secure_sum > /dev/null; then
    version=get_latest_tag
    echo "Installing AUNOVIS Secure Sum..."
    curl --proto '=https' --tlsv1.2 -LsSf "https://github.com/aunovis/secure_sum/releases/download/${version}/secure_sum-installer.sh" | sh
fi
