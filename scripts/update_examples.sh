#!/bin/bash

set -e

git_root="$(git rev-parse --show-toplevel)"
exmaple_dir="$git_root/examples"

cd $git_root

if [ ! -d "$exmaple_dir" ]; then
    mkdir "$exmaple_dir"
fi

curl https://raw.githubusercontent.com/aunovis/secure_sum/refs/heads/main/Cargo.toml -o "$exmaple_dir/example_cargo.toml"
curl https://raw.githubusercontent.com/Weichwerke-Heidrich-Software/setup-bomnipotent-action/refs/heads/main/package.json -o "$exmaple_dir/example_package.json"
curl https://raw.githubusercontent.com/aunovis/secure_sum/refs/heads/main/system_tests/example_metric.toml -o "$exmaple_dir/example_metric.toml"
