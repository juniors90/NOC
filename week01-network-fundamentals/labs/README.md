# Network Diagnostics

A Bash script that checks the network status of a Linux machine
and prints a readable report.

## What it checks

- IP configuration, routing table and ARP/neighbor table
- Internet connectivity (ICMP)
- DNS resolution
- Listening ports

## Usage

```cmd
chmod +x network_diagnostics.sh
./network_diagnostics.sh
./network_diagnostics.sh example.com
```

## Example output
(paste a trimmed sample here)

## What I learned


- IP vs MAC, gateways and routing tables
- How to tell a DNS problem from a connectivity problem
- Basic Bash scripting for diagnostics

## Next steps

- Add subnet calculations
- Export results to a log file