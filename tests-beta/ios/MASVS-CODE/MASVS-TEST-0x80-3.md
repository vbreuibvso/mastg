---
platform: ios
title: Testing Enforced Updating
id: MASTG-TEST-0x80-3
type: [static]
weakness: MASWE-0075
profiles: [L2]
---

## Overview

This test verifies whether the app enforces an update (@MASTG-KNOW-0074) when directed by the backend. On iOS, apps typically read `CFBundleShortVersionString`/`CFBundleVersion` (for example, via `Bundle.main.infoDictionary`) and compare against a minimum supported version returned by the backend over `URLSession`. Some apps also query the App Store using the iTunes Search API lookup endpoint (for example, `https://itunes.apple.com/lookup?bundleId=<bundleId>` or `https://itunes.apple.com/lookup?id=<appId>`) to retrieve the latest published version from the response (for example, `results[0].version`). If an update is required, the app should block usage and optionally redirect to the App Store (for example, via `UIApplication.open` or a StoreKit product view).

## Steps

1. Apply @MASTG-TECH-0066 (static analysis) and examine startup code paths that run before authentication (for example, `AppDelegate.application(_:didFinishLaunchingWithOptions:)`, `SceneDelegate.scene(_:willConnectTo:)`, initial view controllers).
2. Locate version retrieval and comparison logic (for example, reads of `CFBundleShortVersionString`/`CFBundleVersion` and comparisons against a constant or a value from a backend response).
3. Identify `URLSession` calls that:
    - send the app version (for example, headers or JSON fields like `version`, `build`),
    - request the minimum supported version from the backend, or
    - query the iTunes Search API lookup endpoint (`https://itunes.apple.com/lookup`) using `bundleId` or `id` (optionally `country`) and parse fields like `results[0].version` and `results[0].trackViewUrl`.
4. Trace the code that handles an "update required" condition to verify enforced blocking (for example, non-dismissible `UIAlertController`, disabling navigation, or redirection using `UIApplication.shared.open` or a StoreKit product view).

## Observation

The output should contain a list of code locations where the app:

- retrieves its version (`CFBundleShortVersionString`/`CFBundleVersion`) and performs version comparisons,
- makes `URLSession` calls that carry or request version information or query `https://itunes.apple.com/lookup` (including parsing of `results[0].version`), and
- executes the enforced update path (for example, blocking UI or redirection).

Include a call graph snippet showing that these checks execute before authentication.

## Evaluation

The test case fails if no code paths implement an enforced update before authentication, if version checks (including handling of the iTunes lookup result) are present but do not lead to blocking behavior when required, or if the app informs you that you must update but still allows you to continue using it.
