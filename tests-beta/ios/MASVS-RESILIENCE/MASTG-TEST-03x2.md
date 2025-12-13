---
platform: ios
title: Verbose Error Logging and Debugging Messages
id: MASTG-TEST-03x2
type: [dynamic]
weakness: MASWE-0094
knowledge: [MASTG-KNOW-0064, MASTG-KNOW-0101]
profiles: [R]
---

## Overview

This test is the dynamic counterpart to MASTG-TEST-03x1.

## Steps

1. Install the app on a device using @MASTG-TECH-0056.
2. Monitor system logs with @MASTG-TECH-0060 while interacting with the app.
3. Trigger various app functionalities including error conditions (e.g., network failures, invalid inputs).

## Observation

The output should contain all log messages captured during runtime.

## Evaluation

The test fails if the app logs verbose debug messages in production builds that expose implementation details such as:

- Internal function names or code paths
- Detailed error messages with stack information
- API endpoints or internal URLs
- Internal state or configuration details
- Library or framework version information
- Debugging information intended only for developers
