#!/usr/bin/env bash

set -u

show_help() {
    cat <<HELP
DevOps CI/CD Diagnostic CLI

Usage:
  app.sh help
  app.sh system-info
  app.sh check-port <host> <port>

Commands:
  help                       Display this help message
  system-info               Display system information
  check-port <host> <port>  Check TCP connectivity to a host and port
HELP
}

invalid_input() {
    echo "ERROR: Invalid command or input."
    echo
    show_help
    exit 2
}

system_info() {
    echo "======================================"
    echo "        SYSTEM INFORMATION"
    echo "======================================"
    echo "Hostname         : $(hostname)"
    echo "User             : $(whoami)"
    echo "Kernel           : $(uname -r)"
    echo "Operating System : $(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
    echo "Uptime           : $(uptime -p 2>/dev/null || echo "Unavailable")"
    echo "CPU              : $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ *//')"

    echo
    echo "Memory:"
    free -h

    echo
    echo "Disk:"
    df -h /
}

check_port() {
    local host="$1"
    local port="$2"

    if [[ ! "$port" =~ ^[0-9]+$ ]]; then
        echo "ERROR: Port must be numeric."
        exit 2
    fi

    if (( port < 1 || port > 65535 )); then
        echo "ERROR: Port must be between 1 and 65535."
        exit 2
    fi

    echo "Checking TCP connectivity to $host:$port..."

    if command -v nc >/dev/null 2>&1; then
        if nc -z -w 3 "$host" "$port" >/dev/null 2>&1; then
            echo "Port $port on $host is OPEN."
            return 0
        else
            echo "Port $port on $host is CLOSED or unreachable."
            return 1
        fi
    fi

    if timeout 3 bash -c "</dev/tcp/$host/$port" >/dev/null 2>&1; then
        echo "Port $port on $host is OPEN."
        return 0
    else
        echo "Port $port on $host is CLOSED or unreachable."
        return 1
    fi
}

command="${1:-}"

case "$command" in
    help)
        [[ $# -eq 1 ]] || invalid_input
        show_help
        ;;

    system-info)
        [[ $# -eq 1 ]] || invalid_input
        system_info
        ;;

    check-port)
        [[ $# -eq 3 ]] || invalid_input
        check_port "$2" "$3"
        ;;

    "")
        invalid_input
        ;;

    *)
        invalid_input
        ;;
esac
