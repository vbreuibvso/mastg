---
platform: ios
title: Uses of Network Framework Bypassing ATS
code: [swift]
id: MASTG-DEMO-0078
test: MASTG-TEST-0315
kind: fail
status: draft
note: This demo requires rebuilding MASTestApp with the provided MastgTest.swift code
---

### Sample

The code snippet below shows sample code that uses the `Network` framework to establish a connection that bypasses ATS:

{{ MastgTest.swift }}

### Steps

1. Unzip the app package and locate the main binary file (@MASTG-TECH-0058), which in this case is `./Payload/MASTestApp.app/MASTestApp`.
2. Run @MASTG-TOOL-0073 with the script to search for low-level networking APIs in the binary.

{{ low_level_network.r2 }}

{{ run.sh }}

### Observation

The output contains references to low-level networking APIs found in the binary:

{{ output.txt }}

### Evaluation

The test fails because the app uses `NWConnection` from the Network framework without TLS, which bypasses ATS protections and allows cleartext HTTP traffic.

To determine the security impact:

1. Review the code context to understand how the connection is configured (with or without TLS).
2. Check if the connection is used for sensitive data transmission.
3. Perform dynamic analysis to observe actual network traffic (see @MASTG-TEST-0236).
