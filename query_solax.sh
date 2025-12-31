#!/bin/bash

# Solax Cloud API Query Script to test the API connection
# Usage: ./query_solax.sh <token> <serial_number>
#   or: TOKEN=your_token SERIAL=your_serial ./query_solax.sh

set -e

# Get token and serial from arguments or environment variables
TOKEN="${1:-${TOKEN}}"
SERIAL="${2:-${SERIAL}}"

# Check if token and serial are provided
if [ -z "$TOKEN" ] || [ -z "$SERIAL" ]; then
    echo "Error: Token and serial number are required" >&2
    echo "Usage: $0 <token> <serial_number>" >&2
    echo "   or: TOKEN=your_token SERIAL=your_serial $0" >&2
    exit 1
fi

# Solax Cloud API endpoint
API_URL="https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do"

# Query the API
echo "Querying Solax Cloud API..." >&2
echo "Token: ${TOKEN:0:10}..." >&2
echo "Serial: $SERIAL" >&2
echo "" >&2

# Use curl to fetch the data and format JSON output
curl -s "${API_URL}?tokenId=${TOKEN}&sn=${SERIAL}" | \
    python3 -m json.tool 2>/dev/null || \
    jq '.' 2>/dev/null || \
    cat

