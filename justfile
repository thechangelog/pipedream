# vim: set tabstop=4 shiftwidth=4 expandtab:

[private]
default:
    @just --list

[private]
fmt:
    just --fmt --check --unstable

OS := if os() == "macos" { "apple" } else { "unknown" }
OS_ALT := if os() == "macos" { "darwin" } else { "linux-gnu" }
LOCAL_PATH := home_dir() / ".local"
BIN_PATH := LOCAL_PATH / "bin"

# https://github.com/Orange-OpenSource/hurl/releases

HURL_VERSION := "5.0.1"
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

# https://linux.101hacks.com/ps1-examples/prompt-color-using-tput/

_BOLD := "$(tput bold)"
_RESET := "$(tput sgr0)"
_BLACK := "$(tput bold)$(tput setaf 0)"
_RED := "$(tput bold)$(tput setaf 1)"
_GREEN := "$(tput bold)$(tput setaf 2)"
_YELLOW := "$(tput bold)$(tput setaf 3)"
_BLUE := "$(tput bold)$(tput setaf 4)"
_MAGENTA := "$(tput bold)$(tput setaf 5)"
_CYAN := "$(tput bold)$(tput setaf 6)"
_WHITE := "$(tput bold)$(tput setaf 7)"
_BLACKB := "$(tput bold)$(tput setab 0)"
_REDB := "$(tput setab 1)$(tput setaf 0)"
_GREENB := "$(tput setab 2)$(tput setaf 0)"
_YELLOWB := "$(tput setab 3)$(tput setaf 0)"
_BLUEB := "$(tput setab 4)$(tput setaf 0)"
_MAGENTAB := "$(tput setab 5)$(tput setaf 0)"
_CYANB := "$(tput setab 6)$(tput setaf 0)"
_WHITEB := "$(tput setab 7)$(tput setaf 0)"
