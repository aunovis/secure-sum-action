#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

curl https://raw.githubusercontent.com/aunovis/secure_sum/refs/heads/main/Cargo.toml -o example_cargo.toml
curl https://raw.githubusercontent.com/aunovis/secure_sum/refs/heads/main/system_tests/example_metric.toml -o example_metric.toml
