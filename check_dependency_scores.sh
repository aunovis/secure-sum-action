#!/bin/bash

set -eou pipefail

# This is a tiny wrapper script that ensures that secure_sum is installed, and passes any arguments on.
# You can thus call it just as you would secure_sum.

args=("$@")

if [ -f ".env" ]; then
    source .env
fi

if [ -z "${GITHUB_TOKEN}" ]; then
    echo "For Secure Sum to work, you need to specify an environment variable named 'GITHUB_TOKEN', either in your terminal, or in a .env file."
    exit 1
fi

function install_latest_version() {
    if ! command -v curl > /dev/null; then
        echo "Please install curl first."
        exit 1
    fi

    local metadata_url="https://api.github.com/repos/aunovis/secure_sum/releases/latest"
    local repo_metadata=$(curl -s \
        -H "Accept: application/vnd.github+json" \
        -H "Agent: Secure-Sum-Installer" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$metadata_url")
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
    
    if [ -z "$version" ]; then
        echo "Still no luck parsing that version. Here's the rull repo_metadata output:"
        echo "$repo_metadata"
        exit 1
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
