---
platform: ios
title: Uses of Low-Level Networking APIs that Bypass ATS
id: MASTG-TEST-0315
type: [static]
weakness: MASWE-0050
related-tests: [MASTG-TEST-0313, MASTG-TEST-0314, MASTG-TEST-0236]
profiles: [L1, L2]
---

## Overview

App Transport Security (ATS) only applies to connections made via the [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system) (typically `URLSession`). Lower-level networking APIs bypass ATS entirely, meaning they can establish cleartext HTTP connections regardless of the app's ATS configuration.

The following low-level APIs are not affected by ATS:

- **[`Network` framework](https://developer.apple.com/documentation/network)**: A modern low-level networking API for socket-level communication using TCP and UDP.
- **[`CFNetwork`](https://developer.apple.com/documentation/cfnetwork)**: Core Foundation-based networking APIs including `CFSocketStream`, `CFHTTPStream`, and related functions.
- **BSD Sockets**: Low-level POSIX socket APIs accessed through functions like `socket()`, `connect()`, `send()`, and `recv()`.

Apple [recommends](https://developer.apple.com/documentation/security/preventing_insecure_network_connections) preferring high-level frameworks: "ATS doesn't apply to calls your app makes to lower-level networking interfaces like the Network framework or CFNetwork. In these cases, you take responsibility for ensuring the security of the connection. You can construct a secure connection this way, but mistakes are both easy to make and costly. It's typically safest to rely on the URL Loading System instead."

For more information on when ATS applies, see @MASTG-KNOW-0071.

## Steps

1. Extract the app (@MASTG-TECH-0058).
2. Run a static analysis tool such as @MASTG-TOOL-0073 on the app binary and search for uses of low-level networking APIs (e.g., `NWConnection`, `CFSocketStream`, `CFStreamCreatePairWithSocketToHost`, or BSD socket functions).

## Observation

The output should contain a list of low-level networking API usages and their locations within the app binary.

## Evaluation

The test case fails if the app uses low-level networking APIs that could establish cleartext connections. The presence of these APIs indicates that the app may bypass ATS protections.

When evaluating the findings:

- **Review the context**: Determine if the low-level API usage involves cleartext (HTTP/unencrypted) or encrypted (TLS/HTTPS) connections.
- **Check TLS configuration**: If using `Network` framework, verify that TLS is properly configured using `.tls` parameter in `NWParameters`.
- **Cross-reference with dynamic analysis**: Perform network traffic interception (see @MASTG-TEST-0236) to confirm whether cleartext traffic is actually transmitted.
