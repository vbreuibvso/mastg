---
platform: ios
title: Uses of BSD Sockets Bypassing ATS
code: [swift]
id: MASTG-DEMO-0079
test: MASTG-TEST-0315
kind: fail
status: draft
note: This demo requires rebuilding MASTestApp with the provided MastgTest.swift code
---

### Sample

The code snippet below shows sample code that uses BSD sockets directly to establish a connection that bypasses ATS:

{{ MastgTest.swift }}

### Steps

1. Unzip the app package and locate the main binary file (@MASTG-TECH-0058), which in this case is `./Payload/MASTestApp.app/MASTestApp`.
2. Run @MASTG-TOOL-0073 with the script to search for BSD socket APIs in the binary.

{{ bsd_sockets.r2 }}

{{ run.sh }}

### Observation

The output contains references to BSD socket APIs found in the binary:

{{ output.txt }}

### Evaluation

The test fails because the app uses BSD sockets (`socket`, `connect`, `send`, `recv`) directly, which bypasses ATS protections entirely and allows cleartext network traffic.

To determine the security impact:

1. Review the code context to understand what data is transmitted over these sockets.
2. Check if the connection uses any encryption (TLS/SSL) implemented at the application level.
3. Perform dynamic analysis to observe actual network traffic (see @MASTG-TEST-0236).
