---
platform: ios
title: Testing Enforced Updating
id: MASTG-TEST-0x80-2
type: [dynamic]
weakness: MASWE-0075
profiles: [L2]
---

## Overview

This test verifies whether the app enforces an update when directed by the backend. On iOS, apps typically read `CFBundleShortVersionString`/`CFBundleVersion` (for example, via `Bundle.main.infoDictionary`), send the version to a backend using [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession "URLSession"), and enforce a minimum supported version returned by the backend. Some apps also query the App Store using the iTunes Search API lookup endpoint (for example, `https://itunes.apple.com/lookup?bundleId=<bundleId>` or `https://itunes.apple.com/lookup?id=<appId>`) to retrieve the latest published version from the App Store response (for example, `results[0].version`). If an update is required, the app should block usage and optionally redirect you to the App Store using [`UIApplication.open`](https://developer.apple.com/documentation/uikit/uiapplication/open(_:options:completionhandler:) "UIApplication.open") or present a StoreKit view (for example, [`SKStoreProductViewController`](https://developer.apple.com/documentation/storekit/skstoreproductviewcontroller "SKStoreProductViewController")).

## Steps

1. Apply @MASTG-TECH-0063 (MITM) to capture launch traffic and initial API calls. Filter for headers, parameters, or body fields carrying version information (for example, `X-App-Version`, `version`, `build`, `minVersion`). Additionally, look for requests to `https://itunes.apple.com/lookup` with `bundleId` or `id` (and optional `country`) parameters and note fields like `resultCount`, `results[0].version`, and `results[0].trackViewUrl` in the JSON response.
2. Use dynamic instrumentation to hook relevant classes or methods that retrieve the app version (for example, `Bundle.main.infoDictionary["CFBundleShortVersionString"]`/`["CFBundleVersion"]`) or that are specifically related to update flows (for example, `URLSession` request builders/`resume`, the code that evaluates `minVersion`, `UIApplication.open`, or the parsing logic that reads `results[0].version` from the iTunes lookup response). Also, hook any StoreKit presentation code (for example, `SKStoreProductViewController`).

## Observation

The output should contain:

- a network traffic trace showing version values in requests and the corresponding backend responses for different versions, including any requests to `https://itunes.apple.com/lookup` and the parsed fields (for example, `results[0].version`)
- a method trace showing which APIs were called (for example, `URLSession` request execution, version retrieval from `Bundle`, iTunes lookup parsing, and any redirection via `UIApplication.open` or StoreKit)

## Evaluation

The test case fails if the app does not implement enforced updating. For example, if it neither performs backend-gated version checks nor blocks usage when the backend (or the iTunes lookup result) requires an update or if it implements these checks incorrectly (see below).

**Additional Verification:**

Validate whether the backend indicates that an update is required but the app still allows you to continue using it (this may require manual testing):

- Try to dismiss any update prompts or navigate around them.
- Modify requests to present an older version (for example, change `version`/`build`), replay the request, and observe whether the backend response changes (for example, an error or a field indicating an update is required).
- If the app uses the iTunes lookup endpoint, stub or replay the lookup response to advertise a higher `results[0].version` and verify that the app enforces the update (for example, by blocking usage or redirecting to the App Store).
