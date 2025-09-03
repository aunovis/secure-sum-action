#!/bin/bash

set -eou pipefail

# This is a tiny wrapper script that ensures that secure_sum is installed, and passes any arguments on.
# You can thus call it just as you would secure_sum.

args=("$@")

function install_latest_version() {
    if ! command -v curl > /dev/null; then
        echo "Please install curl first."
        exit 1
    fi
    local metadata_url="https://api.github.com/repos/aunovis/secure_sum/releases/latest"
    local repo_metadata=$(curl -s "$metadata_url")
    if [ -z "$repo_metadata" ]; then
        echo "URL $metadata_url did not return any metadata."
        exit 1
    fi
    local tag_line=$(echo "$repo_metadata" | grep '"tag_name":')
    echo "Detected line:"
    echo "$tag_line"
    local version=$(echo "$tag_line" | cut -d '"' -f4)
    if [ -z "$version" ]; then
        echo "Could not parse version, trying jq."
        if ! command -v jq > /dev/null; then
            echo "jq is not installed, I ran out of ideas."
            exit 1
        fi
        version=$(echo "$repo_metadata" | jq -r '.tag_name')
    fi
    echo "Installing AUNOVIS Secure Sum ${version}..."
    local installer_url="https://github.com/aunovis/secure_sum/releases/download/${version}/secure_sum-installer.sh"
    echo "Using installer from URL: ${installer_url}"
    curl --proto '=https' --tlsv1.2 -LsSf "$installer_url" | sh
}

if ! command -v secure_sum > /dev/null; then
    install_latest_version
fi

secure_sum "${args[@]}"
