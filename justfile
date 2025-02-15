# vim: set tabstop=4 shiftwidth=4 expandtab:

[private]
default:
    @just --list

[private]
fmt:
    just --fmt --check --unstable
    just --version

OS := if os() == "macos" { "apple" } else { "unknown" }
OS_ALT := if os() == "macos" { "darwin" } else { "linux-gnu" }
LOCAL_PATH := home_dir() / ".local"
BIN_PATH := LOCAL_PATH / "bin"

# https://github.com/Orange-OpenSource/hurl/releases

HURL_VERSION := "6.0.0"
HURL_NAME := "hurl-" + HURL_VERSION + "-" + arch() + "-" + OS + "-" + OS_ALT
HURL := LOCAL_PATH / HURL_NAME / "bin" / "hurl"

[private]
hurl *ARGS:
    @[ -e {{ HURL }} ] \
    || (echo {{ _GREEN }}🔀 Installing hurl {{ HURL_VERSION }} ...{{ _RESET }} \
        && mkdir -p {{ BIN_PATH }} \
        && (curl -LSsf "https://github.com/Orange-OpenSource/hurl/releases/download/{{ HURL_VERSION }}/{{ HURL_NAME }}.tar.gz" | tar zxv -C {{ LOCAL_PATH }}) \
        && chmod +x {{ HURL }} && echo {{ _MAGENTA }}{{ HURL }} {{ _RESET }} && {{ HURL }} --version \
        && ln -sf {{ HURL }} {{ BIN_PATH }}/hurl && echo {{ _MAGENTA }}hurl{{ _RESET }} && hurl --version)
    {{ if ARGS != "" { HURL + " " + ARGS } else { HURL + " --help" } }}

# Run the tests
test *ARGS: (hurl "--test --color --report-html tmp --variable host=https://pipedream.changelog.com " + ARGS + " test/*.hurl")

# Open the test report
report:
    open tmp/index.html

# Open an interactive terminal in the debug container
debug:
    dagger call debug terminal --cmd=bash

# Benchmark $url as http version $http with $reqs across $conns
bench url="https://changelog.com" http="2" reqs="100000" conns="50":
    oha -n {{ reqs }} -c {{ conns }} {{ url }} --http-version={{ http }}

# Publish container image
[group('team')]
publish image="ghcr.io/thechangelog/pipely:latest":
    #!/usr/bin/env bash
    export GHCR_PASSWORD=$(op read op://Shared/CHANGELOG_GHCR_PASSWORD_2023_02_26/credential --account changelog.1password.com --cache)
    set -ex
    dagger call publish --registry-password=env:GHCR_PASSWORD

# https://linux.101hacks.com/ps1-examples/prompt-color-using-tput/

[private]
_RESET := "$(tput sgr0)"
[private]
_GREEN := "$(tput bold)$(tput setaf 2)"
[private]
_MAGENTA := "$(tput bold)$(tput setaf 5)"
