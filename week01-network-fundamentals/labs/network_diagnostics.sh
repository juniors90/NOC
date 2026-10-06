#!/usr/bin/env bash

# Set target host from first positional argument or default to google.com
TARGET="${1:-google.com}"

# Asegurar que la carpeta de resultados exista
mkdir -p results

# Guardar en archivo y mostrar en pantalla simultáneamente
LOG_FILE="results/example.txt"
exec &> >(tee "$LOG_FILE")

# Function to print structured section headers
section() {
    echo
    echo "$1"
    echo "-----------------"
}

# Function to test general internet connectivity (pinging Google Public DNS)
check_internet() {
    ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1
}

# Function to check DNS resolution for the target host
check_dns() {
    getent hosts "$TARGET" > /dev/null 2>&1 || host "$TARGET" > /dev/null 2>&1
}

# Main Report Header
echo "================================="
echo "NETWORK DIAGNOSTICS REPORT"
echo "================================="

# 1. Hostname
section "HOSTNAME"
hostname

# 2. IP Configuration
section "IP CONFIGURATION"
ip addr

# 3. Routing Table
section "ROUTING TABLE"
ip route

# 4. Neighbor Table (ARP)
section "NEIGHBOR TABLE"
ip neigh

# 5. Internet Connectivity Check
section "INTERNET CONNECTIVITY"
if check_internet; then
    echo "[OK] Internet connectivity"
else
    echo "[FAIL] Internet connectivity"
fi

# 6. DNS Resolution & Target Diagnostics (Bonus included)
section "DNS & TARGET DIAGNOSTICS ($TARGET)"
if check_dns; then
    echo "[OK] DNS resolution"

    # Extract target IP address
    TARGET_IP=$(getent hosts "$TARGET" | awk '{print $1}' | head -n 1)
    if [ -z "$TARGET_IP" ]; then
        TARGET_IP=$(host "$TARGET" 2>/dev/null | awk '/has address/ {print $4}' | head -n 1)
    fi
    echo "Resolved IP: ${TARGET_IP:-Unknown}"

    # Target Ping Diagnostics (4 packets)
    PING_OUTPUT=$(ping -c 4 -W 2 "$TARGET" 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "[OK] Ping to $TARGET"

        # Extract packet loss percentage
        LOSS=$(echo "$PING_OUTPUT" | grep -oP '\d+(?=% packet loss)')
        echo "Packet Loss: ${LOSS:-0}%"

        # Extract average latency
        AVG_LATENCY=$(echo "$PING_OUTPUT" | awk -F'/' '/rtt|round-trip/ {print $5}')
        if [ -n "$AVG_LATENCY" ]; then
            echo "Avg Latency: ${AVG_LATENCY} ms"
        fi
    else
        echo "[FAIL] Ping to $TARGET"
    fi
else
    echo "[FAIL] DNS resolution"
fi

# 7. Listening Ports
section "LISTENING PORTS"
ss -tuln