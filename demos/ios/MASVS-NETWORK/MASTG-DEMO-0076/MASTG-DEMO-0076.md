---
platform: ios
title: Insecure ATS Configuration Allowing Cleartext Traffic
code: [xml]
id: MASTG-DEMO-0076
test: MASTG-TEST-0314
kind: fail
status: draft
note: This demo uses a standalone Info.plist file for demonstration purposes
---

### Sample

The code snippet below shows an insecure ATS configuration in an `Info.plist` file that disables App Transport Security globally by setting `NSAllowsArbitraryLoads` to `true`:

{{ Info.plist }}

### Steps

1. Extract the app (@MASTG-TECH-0058) and locate the `Info.plist` file inside the app bundle.
2. Run the following script to extract and display the `NSAppTransportSecurity` configuration:

{{ run.sh }}

### Observation

The output shows the ATS configuration found in the `Info.plist` file:

{{ output.txt }}

### Evaluation

The test fails because `NSAllowsArbitraryLoads` is set to `true`, which disables ATS globally and allows cleartext HTTP traffic to any domain.

Note that in some cases, apps may legitimately need to disable ATS (e.g., browsers). In such cases, verify that a proper justification string is provided and that the app implements appropriate compensating controls.
