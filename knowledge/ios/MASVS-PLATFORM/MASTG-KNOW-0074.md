---
masvs_category: MASVS-PLATFORM
platform: ios
title: Enforced Updating
---

Enforced updating can be useful for maintaining security when critical components such as public key pins need to be rotated or when severe vulnerabilities must be patched quickly. In these cases, requiring users to install a new version can ensure that old, insecure builds are no longer in use.

On iOS, however, Apple does not provide a built-in API to enforce updates or to perform in-app update flows similar to Android's Play Core library. The App Store is the only official distribution channel, and Apple's guidelines prohibit applications from downloading or installing code outside it. Developers therefore need to implement their own logic to check for new versions and prompt users accordingly.

The typical approach is to query the [App Store Lookup API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html), for example using the endpoint:

```txt
https://itunes.apple.com/lookup?bundleId=<YourBundleId>
```

This returns metadata including the latest version number. The app can then compare that value with its current version (`CFBundleShortVersionString`) and, if necessary, prompt the user to update. Apple provides [`SKStoreProductViewController`](https://developer.apple.com/documentation/storekit/skstoreproductviewcontroller) in StoreKit, which allows developers to present the App Store product page directly within the app for a smoother update experience. Alternatively, the app can open the App Store page using its URL.

Open-source libraries such as [Siren](https://github.com/ArtSabintsev/Siren) (archived on Apr 2, 2025) or [react-native-appstore-version-checker](https://www.npmjs.com/package/react-native-appstore-version-checker) automate these lookups and comparisons. Regardless of the method, update prompts should be used carefully to avoid frustrating users when no real security or functional benefit exists.

For more details on managing builds and versions, see Apple's [App Store Connect documentation](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/). To ensure compliance, review the [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).

Keep in mind that updating the app does not resolve vulnerabilities that reside on backend systems. A secure update mechanism must be part of a broader API and service lifecycle management strategy. Likewise, if users are not forced to update, test older app versions against your backend and apply proper API versioning and deprecation policies to maintain overall platform security.
