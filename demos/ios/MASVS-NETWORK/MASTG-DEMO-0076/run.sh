#!/bin/bash

# Extract and display ATS configuration from Info.plist
echo "=== NSAppTransportSecurity Configuration ==="
plutil -extract NSAppTransportSecurity xml1 -o - Info.plist 2>/dev/null || echo "No NSAppTransportSecurity key found"
